import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class reported extends StatefulWidget {
  const reported({super.key});

  @override
  State<reported> createState() => _reportedState();
}

class _reportedState extends State<reported> {
  bool isListEmpty = false;
  Stream<QuerySnapshot>? exploreStream;

  removeReport(String itemId) async {
    await FirebaseFirestore.instance
        .collection("Admin")
        .doc("DlNQAe80WuMvVp9nbRAqfYsF8Ly1")
        .update({
      'Reported': FieldValue.arrayRemove([itemId])
    });
    var QAdocs = await FirebaseFirestore.instance
        .collection("Question-Answer")
        .where(FieldPath.documentId, isEqualTo: itemId)
        .get();
    for (QueryDocumentSnapshot doc in QAdocs.docs) {
      await doc.reference.update({'Report': false});
    }
    initializeExploreStream();
    extractReportedItems();
  }

  confirmReport(String itemId) async {
    var QAdocs = await FirebaseFirestore.instance
        .collection("Question-Answer")
        .where(FieldPath.documentId, isEqualTo: itemId)
        .get();
    for (QueryDocumentSnapshot doc in QAdocs.docs) {
      await doc.reference.update({'Report': true});
    }
    initializeExploreStream();
    extractReportedItems();
  }

  @override
  void initState() {
    super.initState();
    initializeExploreStream();
    extractReportedItems();
  }

  // late Stream<QuerySnapshot<Map<String, dynamic>>> exploreStream;
  Future<void> initializeExploreStream() async {
    var reportedlist = extractReportedItems();
    List<String>? list = await reportedlist;
    if (list.isEmpty) {
      setState(() {
        isListEmpty = true; // Set the flag to true if the list is empty
        exploreStream = null;
      });
    } else {
      setState(() {
        exploreStream = FirebaseFirestore.instance
            .collection('Question-Answer')
            .where(FieldPath.documentId, whereIn: list)
            .snapshots();
      });
    }
  }

  Future<List<String>> extractReportedItems() async {
    List<String> allReportedItems = [];
    var snapshot = await FirebaseFirestore.instance.collection('Admin').get();
    for (var doc in snapshot.docs) {
      List<dynamic> reportedArray = doc.get('Reported') ?? [];
      print(reportedArray);
      allReportedItems.addAll(List<String>.from(reportedArray));
    }
    print(allReportedItems.toString());
    return allReportedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: exploreStream == null
          ? isListEmpty
              ? Center(child: Text('No reported items found'))
              : const Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: exploreStream!,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                var docs = snapshot.data!.docs;

                return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final item = docs[index];
                      // bool isSaved = ;
                      // print(isSaved);
                      return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            splashColor: Colors.transparent,
                            onTap: () => {_showItemDetails(context, item.id)},
                            style: ListTileStyle.drawer,
                            leading: Icon(Icons.menu_book_sharp),
                            title: Text(docs[index]['Question'] + '?'),
                          ));
                    });
              },
            ),
    );
  }

  void _showItemDetails(BuildContext context, String itemId) async {
    final itemDoc = await FirebaseFirestore.instance
        .collection('Question-Answer')
        .doc(itemId)
        .get();
    final itemData = itemDoc.data();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemData?['Question'] + '?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                textAlign: TextAlign.justify,
                itemData?['Answer'] ?? 'No description available',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16.0),
              Wrap(
                spacing: 8.0,
                children: (itemData?['Tags'] as List<dynamic>?)!.map((tag) {
                      return Chip(
                        label: Text(tag),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                      );
                    }).toList() ??
                    [],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // Evenly space the buttons
                children: [
                  MaterialButton(
                    onPressed: () {
                      // Handle report action here
                      confirmReport(itemId);
                      Navigator.pop(context);
                    },
                    color: Colors.red,
                    // Button color
                    textColor: Colors.white,
                    // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text('Keep Reported'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      removeReport(itemId);
                      Navigator.pop(context);
                    },
                    color: Colors.green,
                    // Button color
                    textColor: Colors.white,
                    // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text('Remove Report'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

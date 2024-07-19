import 'package:apk/addmodal.dart';
import 'package:apk/previewmodal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class explore extends StatefulWidget {
  const explore({super.key});

  @override
  State<explore> createState() => _exploreState();
}

class _exploreState extends State<explore> {
  final exploreStream =
      FirebaseFirestore.instance.collection('Question-Answer').snapshots();

  void openbottmsheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => addmodal());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: openbottmsheet,
          child: const Icon(Icons.add, color: Colors.black)),
      body: StreamBuilder(
        stream: exploreStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }
          var docs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final item = docs[index];
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
                      trailing: IconButton(
                        style:
                            ButtonStyle(splashFactory: NoSplash.splashFactory),
                        icon: Icon(Icons.bookmark_border),
                        onPressed: () {

                        },
                      ),
                    ));
              });
        },
      ),
    );
  }

  void _showItemDetails(BuildContext context, String itemId) async {
    final itemDoc = await FirebaseFirestore.instance.collection('Question-Answer').doc(itemId).get();
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
                itemData?['Question'] +'?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                itemData?['Answer'] ?? 'No description available',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

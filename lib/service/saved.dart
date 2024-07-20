import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class saved extends StatefulWidget {
  const saved({super.key});

  @override
  State<saved> createState() => _savedState();
}

class _savedState extends State<saved> {
  final exploreStream = FirebaseFirestore.instance
      .collection('Question-Answer')
      .orderBy('Timestamp', descending: true)
      .snapshots();

  final savedIdsStream = FirebaseFirestore.instance
      .collection('User')
      .doc(FirebaseAuth
          .instance.currentUser?.uid) // Replace with the actual document ID
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: savedIdsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('No saved IDs available'));
              }
              List<String> documentIds =
                  List.from(snapshot.data!['Saved'] ?? []);
              return StreamBuilder(
                stream: exploreStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var docs = snapshot.data!.docs
                      .where((doc) => documentIds.contains(doc.id))
                      .toList();
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
                            onTap: () => {_showItemDetails(context, docs[index].id)},
                            style: ListTileStyle.drawer,
                            leading: Icon(Icons.menu_book_sharp),
                            title: Text(docs[index]['Question'] + '?'),
                          ),
                        );
                      });
                },
              );
            }));
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
                  );
                }).toList() ??
                    [],
              )
            ],
          ),
        );
      },
    );
  }
}

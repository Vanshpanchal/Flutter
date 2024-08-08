import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'homepage.dart';

class mypost extends StatefulWidget {
  const mypost({super.key});

  @override
  State<mypost> createState() => _mypostState();
}

class _mypostState extends State<mypost> {
  var usercredential = FirebaseAuth.instance.currentUser?.uid;

  final navigatorController = Get.find<navigatorcontroller>();
  final exploreStream = FirebaseFirestore.instance
      .collection('Question-Answer')
      .where('Uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: exploreStream,
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      );
                    }).toList() ??
                    [],
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:apk/addmodal.dart';
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
                return Card(

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      splashColor: Colors.transparent,
                      onTap: () => {openbottmsheet()},
                      style: ListTileStyle.drawer,
                      leading: Icon(Icons.menu_book_sharp),
                      title: Text(docs[index]['Question']+'?'),
                      trailing: IconButton(
                        style: ButtonStyle(splashFactory: NoSplash.splashFactory),
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
}

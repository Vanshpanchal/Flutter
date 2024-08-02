import 'package:apk/addmodal.dart';
import 'package:apk/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class explore extends StatefulWidget {
  const explore({super.key});

  @override
  State<explore> createState() => _exploreState();
}

class _exploreState extends State<explore> {
  final navigatorController = Get.find<navigatorcontroller>();
  final TextEditingController searchtxt = TextEditingController();
  final searchController = Get.put(SearchController());

  var exploreStream = FirebaseFirestore.instance
      .collection('Question-Answer')
      .orderBy('Timestamp', descending: true)
      .snapshots();

  List<dynamic> _saves = [];

  save(itemId) async {
    var usercredential = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("User")
        .doc(usercredential?.uid)
        .update({
      'Saved': FieldValue.arrayUnion([itemId])
    });

    Get.showSnackbar(GetSnackBar(
      title: "Success",
      message: "Question Saved ",
      icon: Icon(
        Icons.bookmark,
        color: Colors.green,
      ),
      mainButton: TextButton(
          onPressed: () {
            navigatorController.selectedindex.value = 1;
          },
          child: Text(
            'Show',
            style: TextStyle(color: Colors.white),
          )),
      duration: Duration(seconds: 2),
    ));
  }

  report(itemId) async {
    await FirebaseFirestore.instance
        .collection("Admin")
        .doc('EQepsPITGKxb5BcdJCWO')
        .update({
      'Reported': FieldValue.arrayUnion([itemId])
    });
  }

  getsave() async {
    var usercredential = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance
        .collection("User")
        .doc(usercredential?.uid)
        .get();
    var data = doc['Saved'];
    _saves = data;
    print(_saves);
  }

  void openbottmsheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => addmodal());
  }

  @override
  void initState() {
    super.initState();
    getsave();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String?> _fetchUserName(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('User').doc(uid).get();
      if (userDoc.exists) {
        return userDoc['Username'];
      } else {
        return 'Unknown User';
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return 'Error';
    }
  }

  onSearch(String msg) {
    if (msg.isNotEmpty) {
      setState(() {
        exploreStream = FirebaseFirestore.instance
            .collection('Question-Answer')
            .where("Tags", arrayContains: msg)
            .snapshots();
      });
    } else {
      setState(() {
        exploreStream = FirebaseFirestore.instance
            .collection('Question-Answer')
            .orderBy('Timestamp', descending: true)
            .snapshots();
      });
    }
    // print(exploreStream.toString());
  }

  Future<String?> _fetchUserProfileImage(String uid) async {
    try {
      if (uid.isNotEmpty) {
        return await FirebaseStorage.instance.ref("/Profile/${uid}.png").getDownloadURL();
      } else {
        return 'https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small_2x/default-avatar-profile-icon-of-social-media-user-vector.jpg';
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return 'https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small_2x/default-avatar-profile-icon-of-social-media-user-vector.jpg';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CupertinoSearchTextField(
          onChanged: (val) => onSearch(val),
        ),
      ),
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
            return const Center(child: CircularProgressIndicator());
          }
          getsave();
          var docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child: Text('No data found'),
            );
          }

          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final item = docs[index];
                // bool isSaved = ;
                // print(isSaved);
                return docs.isEmpty
                    ? const Center(
                        child: Text("No Data Found"),
                      )
                    : Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          splashColor: Colors.transparent,
                          onTap: () => {_showItemDetails(context, item.id)},
                          style: ListTileStyle.drawer,
                          leading: FutureBuilder<String?>(
                            future: _fetchUserProfileImage(docs[index]['Uid']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                );
                              } else if (snapshot.hasError) {
                                print(snapshot.error);
                                return const CircleAvatar(
                                  foregroundImage: NetworkImage(
                                    'https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small_2x/default-avatar-profile-icon-of-social-media-user-vector.jpg',
                                  ),
                                );
                              } else {
                                return CircleAvatar(
                                  foregroundImage: NetworkImage(snapshot.data!),
                                );
                              }
                            },
                          ),
                          title: Text(docs[index]['Question'] + '?'),
                          subtitle: FutureBuilder<String?>(
                            future: _fetchUserName(docs[index]['Uid']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text('Loading...');
                              } else if (snapshot.hasError) {
                                return Text('Error fetching user name');
                              } else {
                                String userName = "~ ${snapshot.data}";
                                return Text(userName);
                              }
                            },
                          ),
                          // trailing: IconButton(
                          //   style:
                          //       ButtonStyle(splashFactory: NoSplash.splashFactory),
                          //   icon: Icon(Icons.bookmark_border,color: Colors.black,),
                          //   onPressed: () {
                          //     save(item.id);
                          //     // print(getsave());
                          //   },
                          // ),
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
                              borderRadius: BorderRadius.circular(12.0)));
                    }).toList() ??
                    [],
              ),
              Row(
                children: [
                  IconButton.filledTonal(
                      onPressed: () => {report(itemId)},
                      icon: Icon(Icons.report, color: Colors.red)),
                  IconButton.filledTonal(
                      onPressed: () => {save(itemId)},
                      icon: Icon(Icons.save_rounded, color: Colors.green))
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class SearchController extends GetxController {
  var searchText = ''.obs;

  void updateSearchText(String text) {
    searchText.value = text;
  }
}

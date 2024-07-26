import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class addmodal extends StatefulWidget {
  const addmodal({super.key});

  @override
  State<addmodal> createState() => _addmodalState();
}

class _addmodalState extends State<addmodal> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  addQA() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      String doc_id =
          FirebaseFirestore.instance.collection('Question-Answer').doc().id;
      Map<String, dynamic> Data = {
        'Question': _questionController.text.trim().capitalizeFirst,
        'Answer': _answerController.text.trim().capitalizeFirst,
        'Uid': user?.uid,
        'Report': false,
        'Tags': _tags,
        'docId': doc_id,
        'Timestamp': FieldValue.serverTimestamp()
      };
      await FirebaseFirestore.instance
          .collection("Question-Answer")
          .doc(doc_id)
          .set(Data)
          .then((_) => {
                debugPrint("AddUser: User Added"),
                Get.showSnackbar(const GetSnackBar(
                  title: "Question-Answer Added",
                  message: "Success",
                  icon: Icon(
                    Icons.cloud_done_sharp,
                    color: Colors.white,
                  ),
                  duration: Duration(seconds: 3),
                ))
              })
          .catchError((e) {
        debugPrint("AddUser  {$e}");
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    } catch (e) {
      debugPrint("Signupcode  {$e}");
    }
  }

  final TextEditingController _tagController = TextEditingController();
  final List<String> _tags = [];

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
      });
      print(_tags);
      _tagController.clear();
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: 0.85,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 50,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  "Interview-Question",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _questionController,
                  maxLength: null,
                  maxLines: 3,
                  enabled: true,
                  minLines: 1,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.question_mark_outlined),
                    hintText: 'Question',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _answerController,
                  maxLines: 12,
                  minLines: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    hintText: 'Answer',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(Icons.question_answer_outlined),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _tagController,
                  maxLines: 12,
                  minLines: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add_box_rounded),
                      onPressed: () {
                        _addTag();
                        print(_tags);
                      },
                    ),
                    hintText: 'Tag',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(Icons.tag_rounded),
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  children: _tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      onDeleted: () => _removeTag(tag),
                      deleteIcon: const Icon(
                        Icons.cancel_outlined,
                        size: Checkbox.width,
                        color: Colors.black,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.file_upload_outlined),
                  onPressed: () {
                    print(_answerController.text.isNotEmpty);
                    if (_questionController.text.isNotEmpty &&
                        _answerController.text.isNotEmpty &&
                        _tags.isNotEmpty) {
                      addQA();
                      Navigator.pop(context);
                    } else {
                      Get.showSnackbar(const GetSnackBar(
                        title: "Error",
                        message: "Enter Proper Detail please",
                        icon: Icon(
                          Icons.error_outlined,
                          color: Colors.red,
                        ),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  },
                  label: Text('Upload'),
                  style: ElevatedButton.styleFrom(elevation: 2.0, // Border color and width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Border radius
                    )),
                ),
              ],
            ),
          ),
        ));
  }
}

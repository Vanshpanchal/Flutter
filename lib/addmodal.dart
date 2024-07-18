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
        'Question': _questionController.text,
        'Answer': _answerController.text,
        'Uid': user?.uid,
        'Report': false,
        'docId': doc_id
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
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
            "Enter Data",
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _questionController,
            maxLength: null,
            maxLines: 3,
            minLines: 1,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Question',
                prefixIcon: Icon(Icons.question_mark_outlined)),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _answerController,
            maxLines: 15,
            minLines: 1,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Answer',
                prefixIcon: Icon(Icons.question_answer_outlined)),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              addQA();
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}

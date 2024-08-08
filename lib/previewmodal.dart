import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class previewmodal extends StatefulWidget {
  const previewmodal({super.key});

  @override
  State<previewmodal> createState() => _previewmodalState();
}

class _previewmodalState extends State<previewmodal> {

  // final TextEditingController _questionController = (TextEditingController().text='Question') as TextEditingController;
  // final TextEditingController _answerController = (TextEditingController().text='Answer') as TextEditingController;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        child: Padding(
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
                "Interview-Question",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              TextField(
                maxLength: null,
                controller: TextEditingController(text: 'Hello'),
                maxLines: 3,
                enabled: false,
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
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                maxLines: 12,
                enabled: false,
                controller: TextEditingController(text: 'Hello'),
                minLines: 1,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    hintText: 'Answer',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(Icons.question_answer_outlined)),

              ),
            ],
          ),
        ));;
  }
}

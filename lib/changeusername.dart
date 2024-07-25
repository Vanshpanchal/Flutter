import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class changeusername extends StatefulWidget {
  const changeusername({super.key});

  @override
  State<changeusername> createState() => _changeusernameState();
}

class _changeusernameState extends State<changeusername> {
  TextEditingController username = TextEditingController();
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
                  "Change Username",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: username,
                  maxLength: null,
                  maxLines: 3,
                  enabled: true,
                  minLines: 1,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_3),
                    hintText: 'Enter Username',
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
                ElevatedButton.icon(
                  icon: Icon(Icons.cloud_done),
                  onPressed: () {
                    if (username.text.isNotEmpty) {
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
                  label: Text('Change Username'),
                ),
              ],
            ),
          ),
        ));
  }
}

import 'package:apk/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  signup() async {

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: "vansh.tapu@gmail.com", password: "123456789");
      Get.offAll(wrapper());
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    } catch (e) {
      debugPrint("Signupcode  {$e}");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text("SignUp"),
              onPressed: () {
                signup();
              },
            ),

          ],
        ),
      ),
    );
  }
}

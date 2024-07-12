import 'package:apk/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "vansh.tapu@gmail.com", password: "1234567890");
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    } catch (e) {
      debugPrint("Signupcode  {$e}");
    }
  }
  forget() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: "vansh.tapu@gmail.com");
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
        title: Text("Login"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                signIn();
              },
              child: Text("Login"),
            ),
            ElevatedButton(
              onPressed: (() => {Get.to(signup())}),
              child: Text("SignUp"),
            ),
            ElevatedButton(
              child: Text("Forget"),
              onPressed: () {
                forget();
              },
            ),
          ],
        ),
      ),
    );
  }
}

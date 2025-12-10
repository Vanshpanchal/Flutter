import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authservice {
  final _auth = FirebaseAuth.instance;
  Future<void> signup(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Successfull")));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.code)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.code)));
      }
    } catch (e) {
      debugPrint("Signupcode  {$e}");
    }
  }

  Future<UserCredential?> funSignInWithGoogle() async {
    // Use the v7 API: call `authenticate` on the shared instance.
    // Initialize the shared GoogleSignIn instance with the Web OAuth client ID
    // (serverClientId). On Android this must be the Web client ID from
    // the Firebase console (OAuth 2.0 client for Web).
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '205276852583-hbldo6rurb7nbdq93lfq359vikbam8gt.apps.googleusercontent.com',
    );

    late GoogleSignInAccount googleUser;
    try {
      googleUser = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      // Common transient error: reauth failed or canceled on account switch.
      // Try signing out and retrying once.
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.clientConfigurationError) {
        try {
          await GoogleSignIn.instance.signOut();
        } catch (_) {}
        try {
          googleUser = await GoogleSignIn.instance.authenticate();
        } catch (e2) {
          // Give up after retry.
          debugPrint('Google reauth retry failed: $e2');
          return null;
        }
      } else {
        debugPrint('Google sign-in exception: $e');
        return null;
      }
    }

    // googleUser is guaranteed to be assigned or we've returned above.

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final userCredential = await funSignInWithGoogle();
      if (userCredential == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in cancelled')),
        );
        return null;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed in with Google')),
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Auth error: ${e.message}')),
      );
      return null;
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google sign-in failed')),
      );
      return null;
    }
  }
}

import 'dart:io';

import 'package:apk/theme_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final user = FirebaseAuth.instance.currentUser;
  String username = '';
  Color _selectedColor = Colors.amber; // Default color
  final ThemeController themeController = Get.put(ThemeController());

// Get instance of ThemeController

  @override
  void initState() {
    super.initState();
    fetchuser();
    loadimage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchuser();
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  forget() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: user!.email.toString());
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    } catch (e) {
      debugPrint("Signupcode  {$e}");
    }
  }

  fetchuser() async {
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('User')
          .doc(user?.uid)
          .get();
      print(userData);
      if (userData.exists) {
        setState(() {
          username = userData['Username'] ?? 'No name available';
        });
      } else {
        setState(() {
          username = 'No name available';
        });
      }
    }
  }

  void _openColorPicker() async {
    final selectedColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          onColorSelected: (color) {
            // Pass the selected color back
            setState(() {
              themeController.update(
                  color as List<Object>?); // Update the theme controller
              _selectedColor = color;
            });
          },
        );
      },
    );
  }

  String? imageUrl;
  final imagepicker = ImagePicker();
  bool isLoading = false;

  pickImage() async {
    XFile? res = await imagepicker.pickImage(source: ImageSource.gallery);
    if (res != null) {
      uploadProfilePic(File(res.path));
    }
  }

  loadimage() async {
    Reference reference = FirebaseStorage.instance
        .ref('/Profile')
        .child('${FirebaseAuth.instance.currentUser?.uid}.png');

    imageUrl = await reference.getDownloadURL();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          _buildProfileDetails(context),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     signout();
      //   },
      //   child: const Icon(Icons.logout_outlined),
      // ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    var usercredential = FirebaseAuth.instance.currentUser;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          imageUrl == null
              ? CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/pimg.jpg'),
                )
              : CircleAvatar(
                  radius: 60,
                  foregroundImage: NetworkImage(imageUrl!),
                ),
          SizedBox(height: 10),
          Text(
            username,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            usercredential?.email ?? 'No User Found',
            style: TextStyle(
              color: Colors.black38,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: .0),
      child: Column(
        children: [
          _buildProfileOption(
            context,
            icon: Icons.person,
            title: 'Change Username',
            onTap: () async {
              final newUsername = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangeUsernamePage()),
              );
              if (newUsername != null && newUsername is String) {
                setState(() {
                  username = newUsername;
                });
              }
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.image,
            title: 'Change Profile Picture',
            onTap: () {
              pickImage();
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.lock,
            title: 'Reset Password',
            onTap: () {
              forget();
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              signout();
              // Handle logout logic
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context,
      {required IconData icon,
      required String title,
      required Function() onTap}) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
          onTap: onTap,
        ));
  }

  uploadProfilePic(File file) async {
    try {
      Reference reference = FirebaseStorage.instance
          .ref('/Profile')
          .child('${FirebaseAuth.instance.currentUser?.uid}.png');

      await reference.putFile(file).whenComplete(() => {
            Get.showSnackbar(GetSnackBar(
              title: "Success",
              message: "Profile Pic Changed",
              icon: Icon(
                Icons.bookmark,
                color: Colors.green,
              ),
              mainButton: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Colors.white),
                  )),
              duration: Duration(seconds: 2),
            ))
          });

      imageUrl = await reference.getDownloadURL();
      setState(() {});
    } catch (e) {
      print('Error');
    }
  }
}

class ChangeUsernamePage extends StatelessWidget {
  TextEditingController _username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Username'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _username,
                maxLength: null,
                maxLines: 3,
                enabled: true,
                minLines: 1,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.abc),
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
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.file_upload_outlined),
                onPressed: () async {
                  String newUsername = _username.text;
                  if (newUsername.isNotEmpty) {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await FirebaseFirestore.instance
                          .collection('User')
                          .doc(user.uid)
                          .update({
                        'Username': newUsername,
                      });
                      Navigator.pop(context, newUsername);
                    }
                  }
                },
                label: Text('Upload'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeEmailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Email'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'New Email'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle change email logic
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final ValueChanged<Color> onColorSelected;
  final ThemeController themeController = Get.put(ThemeController());

  CustomDialog({required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select a Color Palette'),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              onColorSelected(Colors.lightGreenAccent);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: CircleAvatar(
              backgroundColor: Colors.lightGreenAccent,
              radius: 20.0,
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              onColorSelected(Colors.amber);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: CircleAvatar(
              backgroundColor: Colors.amber,
              radius: 20.0,
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              onColorSelected(Colors.blue);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 20.0,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

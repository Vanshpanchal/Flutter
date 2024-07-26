import 'package:apk/explore.dart';
import 'package:apk/profile.dart';
import 'package:apk/saved.dart';
import 'package:apk/mypost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final user = FirebaseAuth.instance.currentUser;

  signout() async {
    await FirebaseAuth.instance.signOut();
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final controller = Get.put(navigatorcontroller());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primaryFixed,
        title: Obx(()=>Text(controller.getAppBarTitle())) ,
      ),
      body: Obx(() => controller.screen[controller.selectedindex.value]),
      bottomNavigationBar: Obx(() => NavigationBar(
            selectedIndex: controller.selectedindex.value,
            onDestinationSelected: (index) =>
                controller.selectedindex.value = index,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.looks_rounded,color: Colors.black), label: "Explore"),
              NavigationDestination(
                  icon: Icon(Icons.book_outlined,color: Colors.black), label: "Saved"),
              NavigationDestination(
                  icon: Icon(Icons.my_library_books_outlined,color: Colors.black),
                  label: "My Question"),
              NavigationDestination(
                  icon: Icon(Icons.person_outline,color: Colors.black), label: "Profile"),
            ],
          )),
    );
  }
}

class navigatorcontroller extends GetxController {
  final Rx<int> selectedindex = 0.obs;
  final screen = [
    const explore(),
    const saved(),
    const mypost(),
    const profile()
  ];
  String getAppBarTitle() {
    switch (selectedindex.value) {
      case 0:
        return 'Explore';
      case 1:
        return 'Saved';
      case 2:
        return 'My Question';
      case 3:
        return 'Profile';
      default:
        return '';
    }
  }
}

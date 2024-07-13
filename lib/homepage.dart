import 'package:apk/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final controller = Get.put(navigatorcontroller());
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Obx(()=> controller.screen[controller.selectedindex.value]),
      bottomNavigationBar: Obx(() => NavigationBar(
            selectedIndex: controller.selectedindex.value,
            onDestinationSelected: (index) =>
                controller.selectedindex.value = index,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.looks_rounded), label: "Explore"),
              NavigationDestination(
                  icon: Icon(Icons.favorite_border_outlined),
                  label: "Favourite"),
              NavigationDestination(
                  icon: Icon(Icons.person_outline), label: "Profile"),
            ],
          )),

    );
  }
}

class navigatorcontroller extends GetxController {
  final Rx<int> selectedindex = 0.obs;
  final screen = [
    Container(color: Colors.green),
    Container(color: Colors.blue),
    const profile()
  ];
}

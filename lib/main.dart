import 'package:apk/firebase_options.dart';
import 'package:apk/service/Authservice.dart';
import 'package:apk/theme_controller.dart';
import 'package:apk/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      return GetMaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
            useMaterial3: true,

            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              elevation: 8.0,
            ),
            appBarTheme: const AppBarTheme(
              // AppBar color
              elevation: 4.0, // AppBar shadow elevation
            ),
          ),
          home: wrapper());

  }
}
class Button extends StatelessWidget {
  // final auth = Authservice();
  const Button({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await Authservice()
              .signup(email: "abc@gmail.com", password: "", context: context);
        },
        child: const Text('Show SnackBar'),
      ),
    );
  }
}

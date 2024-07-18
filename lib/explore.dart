import 'package:apk/addmodal.dart';
import 'package:flutter/material.dart';

class explore extends StatefulWidget {
  const explore({super.key});

  @override
  State<explore> createState() => _exploreState();
}

class _exploreState extends State<explore> {

  void openbottmsheet(){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx)=> addmodal()
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: openbottmsheet,
          child: const Icon(Icons.add, color: Colors.black)),
    );
  }
}

import 'package:flutter/material.dart';

import '../../const/style_const.dart';

class MemoGenerator extends StatefulWidget {
  const MemoGenerator({super.key});

  @override
  State<MemoGenerator> createState() => _MemoGeneratorState();
}

class _MemoGeneratorState extends State<MemoGenerator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: homeBackgroundColor,
        title: Image.asset("assets/images/logoBlack.png", height: 60),
      ),
      body: const Text("Memorandum"),
    );
  }
}

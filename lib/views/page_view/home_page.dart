import 'dart:math';

import 'package:flutter/material.dart';

import '../../utils/constant/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _changeBackgroundColor() {
    setState(() {
      ConstColors.backgroundColor =
          Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
              .withOpacity(1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Test App'),
        ),
        body: GestureDetector(
          onTap: _changeBackgroundColor,
          child: Container(
            color: ConstColors.backgroundColor,
            child: const Center(
              child: Text(
                'Hello there',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

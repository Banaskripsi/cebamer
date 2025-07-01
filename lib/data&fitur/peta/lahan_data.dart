import 'package:flutter/material.dart';

class LahanData extends StatefulWidget {
  const LahanData({super.key});

  @override
  State<LahanData> createState() => _LahanDataState();
}

class _LahanDataState extends State<LahanData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      width: double.maxFinite,
      color: Colors.white70,
    );
  }
}
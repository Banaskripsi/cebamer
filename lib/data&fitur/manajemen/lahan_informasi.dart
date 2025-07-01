import 'package:cebamer/services/navigasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LahanInformasi extends StatelessWidget {
  const LahanInformasi({super.key});
  @override
  Widget build(BuildContext context) {
    final NavigasiService navigasi = Get.find<NavigasiService>();
    return Scaffold(
      body: ListView(
        children: [
          InkWell(
            onTap: () => navigasi.pindahHalaman('/lahanPeta'),
            child: Container(
              height: 200,
              width: 200,
              color: Colors.blue
            ),
          )
        ]
      )
    );
  }
}
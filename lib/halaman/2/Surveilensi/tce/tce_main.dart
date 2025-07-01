import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Surveilensi/tce/controller/tce_controller.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurveilensiTCE extends StatefulWidget {
  const SurveilensiTCE({super.key});

  @override
  State<SurveilensiTCE> createState() => _SurveilensiTCEState();
}

class _SurveilensiTCEState extends State<SurveilensiTCE> {

  final controller = Get.find<TCEController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: paddingLR20,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              j30,
              Header(title: 'Titik Cedera Ekonomi', description: 'Digunakan untuk mengetahui indikasi keberbahayaan yang disebabkan oleh serangan hama dan penyakit.'), j50,
              divider(context, 'Input Data'), j20,
            ],
          )
        )
      )
    );
  }
}
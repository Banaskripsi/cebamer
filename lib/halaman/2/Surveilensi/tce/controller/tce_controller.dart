import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/controller/periode_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/model/pengamatan_model.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/service/pengamatan_service.dart';
import 'package:cebamer/model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TCEController extends GetxController {
  TextEditingController biayaPengendalian = TextEditingController();
  TextEditingController hargaJual = TextEditingController();
  TextEditingController targetPanen = TextEditingController();
  TextEditingController kerugianHama = TextEditingController();
  TextEditingController koefisienKeamanan = TextEditingController();

  final pengamatanService = Get.find<PengamatanService>();
  final lahanController = Get.find<SelectedLahanController>();
  final periodeController = Get.find<SelectedPeriodeController>();

  Lahan? get lahan => lahanController.lahanTerpilih;
  PlantingPeriod? get periode => periodeController.plantingPeriod;

  List<PengamatanModel>? pengamatanList;

  Future<void> getDataPengamatan(String firestoreDocId) async {
    try {
      await pengamatanService.fetchDataAdditional(lahan!.id, periode!.id, firestoreDocId);
    } catch (e) {
      rethrow;
    }
  }
}
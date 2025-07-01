
import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/controller/periode_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/pengamatan_controller.dart';
import 'package:get/get.dart';

class Kalkulasi extends GetxController {
  final lahan = Get.find<SelectedLahanController>();
  final periode = Get.find<SelectedPeriodeController>();

  final data1 = Get.find<PengamatanController>();

  Future<void> hitungData () async {
  }
}
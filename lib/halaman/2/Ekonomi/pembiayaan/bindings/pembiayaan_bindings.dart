// pembiayaan_binding.dart
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/controller/pembiayaan_controller.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/service/pembiayaan_service.dart';
import 'package:get/get.dart';
// import controller Anda

class PembiayaanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PembiayaanController>(() => PembiayaanController(), fenix: true);
    Get.lazyPut<PembiayaanService>(() => PembiayaanService(), fenix: true);
  }
}
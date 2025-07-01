import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/pengamatan_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/tahap2_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/service/pengamatan_service.dart';
import 'package:get/get.dart';

class PengamatanBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PengamatanController());
    Get.put(Tahap2Controller());
    Get.put(PengamatanService());
  }
}


import 'package:cebamer/halaman/2/Surveilensi/controller/surveilensi_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/tce/controller/tce_controller.dart';
import 'package:get/get.dart';

class SurveilensiBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SurveilensiController>(() => SurveilensiController());
    Get.lazyPut<TCEController>(() => TCEController(), fenix: true);
  }
}
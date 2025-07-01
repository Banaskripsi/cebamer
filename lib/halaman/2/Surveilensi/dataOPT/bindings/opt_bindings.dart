import 'package:cebamer/halaman/2/Surveilensi/dataOPT/controller/opt_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/dataOPT/service/dataopt_service.dart';
import 'package:get/get.dart';

class OptBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OptController>(() => OptController(), fenix: true);
    Get.lazyPut<JenisOPTService>(() => JenisOPTService());
  }
}
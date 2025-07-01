import 'package:get/get.dart';
import 'barnavigasi_controller.dart';

class BarnavigasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BarnavigasiController>(() => BarnavigasiController());
  }
}
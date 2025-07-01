import 'package:cebamer/services/navigasi.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/services/profilLahanService/lahan_service.dart';
import 'package:get/get.dart';
import 'features_controller.dart';

class FeaturesBinding extends Bindings {
  @override
  void dependencies() {
    
    Get.lazyPut<LahanService>(() => LahanService(), fenix: true);
    Get.lazyPut<NavigasiService>(() => NavigasiService(), fenix: true);
    Get.lazyPut<Notifikasi>(() => Notifikasi(), fenix: true);

    // Daftarkan controller halaman ini
    Get.lazyPut<FeaturesController>(() => FeaturesController());
  }
}
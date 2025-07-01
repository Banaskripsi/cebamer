import 'package:cebamer/halaman/2/Manajemen/A_Pekerjaan/controller/tindakan_controller.dart';
import 'package:cebamer/halaman/2/Manajemen/A_Pekerjaan/service/tindakan_service.dart';
import 'package:cebamer/halaman/2/Manajemen/controller/manajemen_controller.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/service/produk_service.dart';
import 'package:cebamer/halaman/2/Surveilensi/dataOPT/service/dataopt_service.dart';
import 'package:get/get.dart';

class ManajemenBindsings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManajemenController>(() => ManajemenController(), fenix: true);
    Get.lazyPut(() => TindakanController(), fenix: true);
    Get.put(TindakanService());
    Get.put(JenisOPTService());
    Get.put(ProdukService());
  }
}
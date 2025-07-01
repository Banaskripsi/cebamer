import 'package:cebamer/halaman/2/Perlakuan/produk/controller/produk_controller.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/service/produk_service.dart';
import 'package:get/get.dart';

class ProdukBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProdukController(), fenix: true);
    Get.put(ProdukService());
  }
}
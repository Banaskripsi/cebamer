import 'package:get/get.dart';
// Pakai Getx
class NavigasiService {
  NavigasiService();

  Future<T?>? pindahHalaman<T>(String namaHalaman, {dynamic argumen, Map<String, String>? parameter}) {
    return Get.toNamed<T?>(
      namaHalaman,
      arguments: argumen,
      parameters: parameter,
    );
  }

  Future<T?>? gantiHalaman<T>(String namaHalaman, {dynamic argumen, Map<String, String>? parameter}) {
    return Get.offNamed<T?>(
      namaHalaman,
      arguments: argumen,
      parameters: parameter,
    );
  }

  Future<T?>? gantiSemuaHalaman<T>(String namaHalaman, {dynamic argumen, Map<String, String>? parameter}) {
    return Get.offAllNamed<T?>(
      namaHalaman,
      arguments: argumen,
      parameters: parameter,
    );
  }

  void kembali<T>({T? hasil}) {
    Get.back<T>(result: hasil);
  }

  void kembaliKeRute(String namaRute) {
    Get.until((route) => Get.currentRoute == namaRute);
  }
}
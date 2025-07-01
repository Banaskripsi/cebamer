import 'dart:async';
import 'package:cebamer/halaman/beranda/edukasi/varietas/model/varietas_model.dart';
import 'package:cebamer/halaman/beranda/edukasi/varietas/service/varietas_service.dart';
import 'package:get/get.dart';

class VarietasController extends GetxController {
  RxList<VarietasModel> daftarVarietas = <VarietasModel>[].obs;
  StreamSubscription? _varietasSub;

  final service = Get.put(VarietasService());

  void listenDataVarietas() {
    _varietasSub?.cancel();
    _varietasSub = service.getVarietas().listen((data) {
      daftarVarietas.value = data;
    });
  }

  @override
  void onReady() {
    super.onReady();
    listenDataVarietas();
  }
}
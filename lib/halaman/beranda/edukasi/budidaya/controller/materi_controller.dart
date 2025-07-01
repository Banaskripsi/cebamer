import 'dart:async';

import 'package:cebamer/halaman/beranda/edukasi/budidaya/model/materi_model.dart';
import 'package:cebamer/halaman/beranda/edukasi/budidaya/service/materi_service.dart';
import 'package:get/get.dart';

class MateriController extends GetxController {
  

  RxList<MateriModel> daftarMateri = <MateriModel>[].obs;
  StreamSubscription? _materiSub;

  final service = Get.put(MateriService());

  void listenDataMateri() {
    _materiSub?.cancel();
    _materiSub = service.getMateri().listen((data) {
      daftarMateri.value = data;
    });
  }

  @override
  void onReady() {
    super.onReady();
    listenDataMateri();
  }
}
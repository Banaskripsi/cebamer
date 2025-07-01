import 'dart:async';

import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/controller/periode_controller.dart';
import 'package:cebamer/halaman/2/Manajemen/A_Pekerjaan/model/tindakan_model.dart';
import 'package:cebamer/halaman/2/Manajemen/A_Pekerjaan/service/tindakan_service.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/model/produk_model.dart';
import 'package:cebamer/model/data_model.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TindakanController extends GetxController {

  final lahanController = Get.find<SelectedLahanController>();
  final periodeController = Get.find<SelectedPeriodeController>();

  final notifkasi = Get.find<Notifikasi>();
  final service = Get.find<TindakanService>();

  Lahan? get lahan => lahanController.lahanTerpilih;
  PlantingPeriod? get periode => periodeController.plantingPeriod;

  var produk = Rxn<ProdukModel>();

  final penyebabCtrl = TextEditingController();
  final namaProdukCtrl = TextEditingController();
  final aplikasiProdukCtrl = TextEditingController();
  final tanggalCtrl = TextEditingController();
  final deskripsiCtrl = TextEditingController();
  final tanggalAplikasiCtrl = DateTime.now().obs;

  StreamSubscription? _tindakanSub;
  final RxList<TindakanModel> daftarTindakan = <TindakanModel>[].obs;
  
  // Menambahkan variabel untuk melacak item yang sedang diperluas
  final RxSet<String> expandedItems = <String>{}.obs;

  // Method untuk toggle expand state
  void toggleExpanded(String tindakanId) {
    if (expandedItems.contains(tindakanId)) {
      expandedItems.remove(tindakanId);
    } else {
      expandedItems.add(tindakanId);
    }
  }

  // Method untuk mengecek apakah item sedang diperluas
  bool isExpanded(String tindakanId) {
    return expandedItems.contains(tindakanId);
  }

  Future<bool> uploadDataTindakan() async {
    try {
      TindakanModel tindakan = TindakanModel(
        penyebab: penyebabCtrl.text.trim(),
        namaProduk: namaProdukCtrl.text.trim(),
        aplikasiProduk: double.tryParse(aplikasiProdukCtrl.text) ?? 0,
        tanggalAplikasi: tanggalAplikasiCtrl.value,
        deskripsi: deskripsiCtrl.text.trim(),
        produk: produk.value
      );

      await service.uploadDataTindakan(tindakan, lahan!.id, periode!.id);
      notifkasi.notif(text: 'Berhasil!', subTitle: 'Data berhasil diunggah.', warna: primer1, icon: Icons.check);
      return true;
    } catch (e) {
      notifkasi.notif(text: 'Gagal', subTitle: 'Data gagal untuk disimpan, silahkan coba kembali.', warna: salahInd, icon: Icons.error);
      return false;
    }
  }

  void listenTindakan() {
    if (lahan != null && periode != null) {
      _tindakanSub?.cancel();
      _tindakanSub = service.getTindakan(lahan!.id, periode!.id).listen((data) {
        daftarTindakan.value = data;
      });
    }
  }

  void deleteTindakan(String tindakanId) {
    service.deleteTindakan(lahanId: lahan!.id, periodeId: periode!.id, documentId: tindakanId);
  }

  @override
  void onReady() {
    super.onReady();
    listenTindakan();
  }

  void clear() {
    penyebabCtrl.clear();
    namaProdukCtrl.clear();
    aplikasiProdukCtrl.clear();
    deskripsiCtrl.clear();
    tanggalCtrl.clear();
  }
}
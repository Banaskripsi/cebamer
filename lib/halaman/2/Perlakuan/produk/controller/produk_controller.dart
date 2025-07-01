import 'dart:async';

import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/controller/periode_controller.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/model/produk_model.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/service/produk_service.dart';
import 'package:cebamer/model/data_model.dart';
import 'package:cebamer/services/auth.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DaftarController extends GetxController{
  static DaftarController get instance => Get.put(DaftarController());

  final sembunyikanPassword = true.obs;
  final centang = true.obs;
  final localStorage = GetStorage();

  final email = TextEditingController();
  final password = TextEditingController();
}

  
class ProdukController extends GetxController {
  static ProdukController get instance => Get.find();

  final lahanController = Get.find<SelectedLahanController>();
  final periodeController = Get.find<SelectedPeriodeController>();
  final auth = Get.find<AuthService>();
  final notifikasi = Get.find<Notifikasi>();

  final produkService = Get.find<ProdukService>();
  final namaProdukController = TextEditingController();
  final efektivitasPengendalianController = TextEditingController();
  final volumeProdukController = TextEditingController();
  final biayaProdukController = TextEditingController();
  final tanggalExpController = TextEditingController();
  final namaManufakturProdukController = TextEditingController();
  final registrasiProdukController = TextEditingController();

  Rx<String> jenisProdukan = ''.obs;
  Rx<String> jenisSubProdukan = ''.obs;

  final tanggalKadaluwarsa = DateTime.now().obs;

  RxString pilihProduk = 'Pupuk'.obs;     // Dropdown A
  RxnString pilihSubJenis = RxnString(null);
  RxBool editable = false.obs;

  //
  RxList<ProdukModel> daftarProduk = <ProdukModel>[].obs;
  StreamSubscription? _produkSub;

  Lahan? get lahan => lahanController.lahanTerpilih;
  PlantingPeriod? get periode => periodeController.plantingPeriod;


  List<String> unitData = [
    'g/m²',
    'g/ha',
    'kg/m²',
    'kg/ha',
    't/ha',
    'l/m²',
    'l/ha'
  ];


  List<String> jenisProduk = [
    'Pestisida',
    'Pupuk',
  ];

  List<String> jenisPestisida = [
    'Insektisida',
    'Rodentisida',
    'Herbisida',
    'Fungisida',
    'Nematisida'
  ];

  List<String> jenisPupuk = [
    'Pupuk Organik',
    'Pupuk Kimia',
    'Pupuk Hayati',
    'Pupuk Cair'
  ];

  List<String> currentSubJenis(String? n) {
    if (n == 'Pestisida') {
      return jenisPestisida;
    } else if (n == 'Pupuk') {
      return jenisPupuk;
    }
    return [];
  }

  var showOptionalForm = false.obs;
  var showFunction = false.obs;

  void deactivateForm() {
    showOptionalForm.value = false;
  }

  void deactivateFunction() {
    showFunction.value = false;
  }

  // UNTUK PRODUK
  void listenProdukService(String userId) {
    if (lahan != null && periode != null) {
      _produkSub?.cancel();
      _produkSub = produkService.fetchDataProdukbyUserId(userId).listen((data) {
        daftarProduk.value = data;
      });
    }
  }

  Future<bool> updateDataProduk(String documentId) async {
    try {
      final data = ProdukModel(
        userId: auth.user!.uid,
        efektivitasPengendalian: double.tryParse(efektivitasPengendalianController.text.trim()) ?? 0,
        volumeProduk: double.tryParse(volumeProdukController.text.trim()) ?? 0,
        namaProduk: namaProdukController.text,
        biayaProduk: double.tryParse(biayaProdukController.text.trim()) ?? 0,
        jenisProduk: jenisProdukan.value, 
        jenisSubProduk: jenisSubProdukan.value,
        tanggalExp: tanggalKadaluwarsa.value
      );

      await produkService.updateProduk(docId: documentId, data: data);
      notifikasi.notif(text: 'Berhasil!', subTitle: 'Data berhasil diperbarui.', warna: primer1, icon: Icons.check);
      return true;
    } catch (e) {
      notifikasi.notif(text: 'Gagal', subTitle: 'Gagal memperbarui data produk, silahkan coba kembali.', warna: salahInd, icon: Icons.error);
      return false;
    }
  }

  Future<void> deleteDataProduk(ProdukModel map) async {
    try {
      await produkService.deleteProduk(map);
    } catch (e) {
      throw Exception('Terjadi kesalahan saat deleteDataProduk: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (auth.user?.uid != null) {
      listenProdukService(auth.user!.uid);
    }
  }
}

class ManajemenMainController extends GetxController {
  static ManajemenMainController get instance => Get.find();
  RxString pilihSatuanLuas = 'Ha'.obs;

  List<String> satuanLuas = [
    'Ha',
    'm²'
  ];
}
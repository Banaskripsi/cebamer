import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/controller/periode_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/helper/pengamatanlokal_helper.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/model/pengamatan_model.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/service/pengamatan_service.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/tahap2_controller.dart';
import 'package:cebamer/model/data_model.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PengamatanController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      isLoading.value = true;
      // Reset values
      jumlahKotak.value = null;
      namaMetodePengamatan.value = '';
      namaOPT.value = '';
      firestoreDocId.value = '';
      
      // Load data if needed
      if (lahan != null && periode != null && firestoreDocId.value!.isNotEmpty ) {
        await getDataPengamatanTahap2();
      }
    } catch (e) {
      print(e);
      throw Exception('Kesalahan pada initializeData');
    } finally {
      isLoading.value = false;
    }
  }

  // UNTUK TAHAP 1
  final TextEditingController namaOPTController = TextEditingController();
  final TextEditingController jumlahPengamatan = TextEditingController();
  final TextEditingController metodePengamatan = TextEditingController();
  final jumlahPetak = 5.obs;
  
  // UNTUK TAHAP 2
  final TextEditingController jumlahTanamanC = TextEditingController();
  final TextEditingController tanamanbergejalaC = TextEditingController();
  final TextEditingController skor1C = TextEditingController();
  final TextEditingController skor2C = TextEditingController();
  final TextEditingController skor3C = TextEditingController();
  final TextEditingController skor4C = TextEditingController();
  final TextEditingController skor5C= TextEditingController();


  final lahanController = Get.find<SelectedLahanController>();
  final periodeController = Get.find<SelectedPeriodeController>();

  final notifikasi = Get.find<Notifikasi>();

  final PengamatanService service = PengamatanService();
  final helper = PengamatanHelper.instance;

  // (FUNGSIONAL) DATA TAHAP 2
  final jumlahKotak = Rx<int?>(null);
  Rx<String?> namaMetodePengamatan = ''.obs;
  Rx<String?> namaOPT = ''.obs;
  Rx<String?> firestoreDocId = ''.obs;

  // (ANALISIS) DATA TAHAP 2

  Rx<int?> jumlahSeluruhTanaman = 0.obs;
  Rx<double?> hasilIndidensi = 0.0.obs;
  Rx<double?> hasilSkorKeparahan = 0.0.obs;
  Rx<double?> intensitas = 0.0.obs;
  Rx<double?> severity = 0.0.obs;

  // UNTUK TAHAP 3 (TAHAP 3)
  TextEditingController namaProduk = TextEditingController();
  TextEditingController hargaJual = TextEditingController();
  TextEditingController hargaProduk = TextEditingController();
  TextEditingController efektivitasproduk = TextEditingController();
  TextEditingController beratProduk = TextEditingController();
  TextEditingController jenisProduk = TextEditingController();
  

  // UMUM
  Lahan? get lahan => lahanController.lahanTerpilih;
  PlantingPeriod? get periode => periodeController.plantingPeriod;
  // RxList<PengamatanModel> pengamatanList = <PengamatanModel>[].obs;

  var pengamatanSpesifik = Rxn<PengamatanModel>();
  var isLoading = false.obs;

  // FUNGSI UNTUK TAHAP 1
  Future<String?> uploadFungsiPengamatan(int pengamatanId) async {

  int? jumlahKotakValue = int.tryParse(jumlahPengamatan.text);
    if (jumlahKotakValue == null || jumlahKotakValue <= 0) {
      notifikasi.notif(text: 'Terjadi error saat mengambil data. Silahkan coba lagi.');
      return 10.toString();
    }
  isLoading.value = true;
  jumlahPetak.value = jumlahKotakValue;
  try {
    PengamatanModel pengamatanModel = PengamatanModel(
      pengamatanId: pengamatanId,
      metodePengamatan: metodePengamatan.text,
      namaOPT: namaOPTController.text,
      jumlahKotak: jumlahKotakValue,
    );
    DocumentReference docRef = await service.uploadPengamatan(pengamatanModel, lahan!.id, periode!.id);
    return docRef.id;
  } catch (e) {
    return '';
  } finally {
    isLoading.value = false;
  }
}

  // FUNGSI UNTUK TAHAP 2
  Future<bool> uploadFungsiDataPengamatan(int indexKotak, int indexPetak, int pengamatanLokalId, bool valid) async {
    if (lahan == null) {
      notifikasi.notif(text: 'Error!', subTitle: 'Lahan belum dipilih', icon: Icons.error, warna: salahInd);
      return false;
    }
    if (periode == null) {
      notifikasi.notif(text: 'Error!', subTitle: 'Periode belum dipilih', icon: Icons.error, warna: salahInd);
      return false;
    }
    if (firestoreDocId.value == null) {
      notifikasi.notif(text: 'Error!', subTitle: 'Data pengamatan tidak lengkap', icon: Icons.error, warna: salahInd);
      return false;
    }

    final int? jumlahtanaman = int.tryParse(jumlahTanamanC.text);
    final int? tanamanbergejala = int.tryParse(tanamanbergejalaC.text);
    final int? skor1 = int.tryParse(skor1C.text);
    final int? skor2 = int.tryParse(skor2C.text);
    final int? skor3 = int.tryParse(skor3C.text);
    final int? skor4 = int.tryParse(skor4C.text);
    final int? skor5 = int.tryParse(skor5C.text);
    
    try {
      PengamatanDataModel pengamatanDataModel = PengamatanDataModel(
        indexKotak: indexKotak,
        jumlahtanaman: jumlahtanaman ?? 0,
        tanamanbergejala: tanamanbergejala ?? 0, 
        skor1: skor1 ?? 0,
        skor2: skor2 ?? 0,
        skor3: skor3 ?? 0,
        skor4: skor4 ?? 0,
        skor5: skor5 ?? 0
      );

      await service.uploadDataPengamatan(
        lahan!.id, 
        periode!.id, 
        pengamatanDataModel, 
        firestoreDocId.value!
      );
      await helper.setStatusPetak(pengamatanLokalId, indexPetak, valid);
      
      // Trigger UI update after successful upload
      final tahap2Controller = Get.find<Tahap2Controller>();
      tahap2Controller.triggerPetakUpdate();
      
      return true;
    } catch (e) {
      notifikasi.notif(text: 'Error!', subTitle: 'Gagal mengunggah data: $e', icon: Icons.error, warna: salahInd);
      return false;
    }
  }

  // FUNGSI UPLOAD DATA TAHAP 3 (TAHAP 3)
  Future<bool> uploadDataAdditionalCtrl() async {
    if (firestoreDocId.value == null) {
      isLoading.value = true;
    }
    try {
      isLoading.value = true;
      PengamatanModelAdditional pengamatanTahap3 = PengamatanModelAdditional(
        namaproduk: namaProduk.text,
        severity: hasilSkorKeparahan.value ?? 0,
        intensitas: hasilIndidensi.value ?? 0,
        hargaJual: double.tryParse(hargaJual.text) ?? 0,
        efektivitasPengendalian: double.tryParse(efektivitasproduk.text) ?? 0,
        hargaProduk: double.tryParse(hargaProduk.text) ?? 0,
        beratProduk: double.tryParse(beratProduk.text) ?? 0
      );
      await service.uploadDataAdditional(lahan!.id, periode!.id, firestoreDocId.value!, pengamatanTahap3);
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // GET UNTUK ONLINE FIRESTORE
  // Future<void> getDataPengamatan(int pengamatanId) async {
  //   try {
  //     final data = await service.fetchDataPengamatan(lahan!.id, periode!.id, pengamatanId);
  //     pengamatanList.value = data;
  //     update();
  //   } catch (e) {
  //     print(e);
  //     return;
  //   }
  // }

  Future<void> getDataPengamatanTahap2() async {
    if (firestoreDocId.value == null) {
      isLoading.value = true;
    }
    try {
      isLoading.value = true;
      List<PengamatanDataModel> hasil = await service.fetchDataPengamatanTahap2(lahan!.id, periode!.id, firestoreDocId.value!);
      int totalTanaman = hasil.fold(0, (total, data) {
        return total + (data.jumlahtanaman ?? 0);
      });
      int totalTanamanBergejala = hasil.fold(0, (total, data) {
        return total + (data.tanamanbergejala ?? 0);
      });
      int tanamanSkor1 = hasil.fold(0, (total, data) => total + (data.skor1 ?? 0));
      int tanamanSkor2 = hasil.fold(0, (total, data) => total + (data.skor2 ?? 0));
      int tanamanSkor3 = hasil.fold(0, (total, data) => total + (data.skor3 ?? 0));
      int tanamanSkor4 = hasil.fold(0, (total, data) => total + (data.skor4 ?? 0));
      int tanamanSkor5 = hasil.fold(0, (total, data) => total + (data.skor5 ?? 0));
      int sigmaTanaman = (tanamanSkor1 * 1) + (tanamanSkor2 * 2) + (tanamanSkor3 * 3) + (tanamanSkor4 * 4) + (tanamanSkor5 * 5);

      double skorKeparahan = sigmaTanaman / (totalTanaman * 5) * 100;
      double insidensi = totalTanamanBergejala / totalTanaman * 100;

      jumlahSeluruhTanaman.value = totalTanaman;
      hasilIndidensi.value = insidensi;
      hasilSkorKeparahan.value = skorKeparahan;

    } catch (e) {
      throw Exception('Kesalahan pada controller: (getDataPengamatanTahap2)');
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> getDataPengamatanSpesifik(int pengamatanId) async {
  //   try {
  //     // Skip if we already have the data
  //     if (pengamatanSpesifik.value != null && 
  //         pengamatanSpesifik.value!.idPengamatanTahap1 != null &&
  //         jumlahKotak.value != null && 
  //         namaMetodePengamatan.value!.isNotEmpty) {
  //       print("Firestore data already loaded, skipping reload");
  //       return;
  //     }

  //     PengamatanModel? pengamatanModel = await service.fetchDataPengamatanSpesifik(lahan!.id, periode!.id, pengamatanId);
  //     if (pengamatanModel != null) {
  //       pengamatanSpesifik.value = pengamatanModel;
  //       jumlahKotak.value = pengamatanModel.jumlahKotak;
  //       namaMetodePengamatan.value = pengamatanModel.metodePengamatan;
  //       firestoreDocId.value = pengamatanModel.idPengamatanTahap1;
  //     }
  //   } catch (e) {
  //     print("Error in getDataPengamatanSpesifik: $e");
  //   }
  // }

  Future<void> deleteDataPengamatanSpesifik(int pengamatanId) async {
    try {
      await service.deleteDataPengamatanSpesifik(lahan!.id, periode!.id, pengamatanId);
    } catch (e) {
      throw Exception('Terjadi kesalahan pada deleteDataPengamatanSpesifik: $e');
    }
  }

  // GET UNTUK OFFLINE SQFLITE
  Future<void> getDataLokalPengamatan(int pengamatanId) async {
    try {
      if (namaOPT.value != null && 
          jumlahKotak.value != null && 
          namaMetodePengamatan.value?.isNotEmpty == true) {
        return;
      }

      final data = await helper.getPengamatanbyId(pengamatanId);
      
      if (data != null) {
        namaOPT.value = data.namaOPT ?? '';
        jumlahKotak.value = data.jumlahKotak;
        namaMetodePengamatan.value = data.metodePengamatan;
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan pada getDataLokalPengamatan: $e');
    }
  }

  // UNTUK SURVEILENSI
  Future<void> fetchFirestoreId(int pengamatanId) async {
    try {
      final firestoreId = await service.getPengamatanDocId(lahan!.id, periode!.id, pengamatanId);
      if (firestoreId != null) {
        firestoreDocId.value = firestoreId;
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan pada fetchFirestoreId: $e');
    }
  }

  @override
  void onClose() {
    namaOPTController.clear();
    jumlahPengamatan.clear();
    jumlahSeluruhTanaman.value = 0;
    hasilIndidensi.value = 0;
    hasilSkorKeparahan.value = 0;
    super.onClose();
  }
}
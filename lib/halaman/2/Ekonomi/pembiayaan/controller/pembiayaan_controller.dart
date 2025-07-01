import 'dart:async';

import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/controller/periode_controller.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/model/pembiayaan_model.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/service/pembiayaan_service.dart';
import 'package:cebamer/model/data_model.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class PembiayaanController extends GetxController {
  // Akses controller global
  final SelectedLahanController selectedLahanCtrl = Get.find<SelectedLahanController>();
  final SelectedPeriodeController selectedPeriodeCtrl = Get.find<SelectedPeriodeController>();

  final notifikasi = GetIt.I<Notifikasi>();
  final PembiayaanService pembiayaanService = Get.find<PembiayaanService>();

  final isLoading = true.obs;

  // Biaya Tetap
  final benihCtrl = TextEditingController();
  final biayaAirCtrl = TextEditingController();
  final biayaPengendalianCtrl = TextEditingController();
  final olahTanahCtrl = TextEditingController();
  final mulsaCtrl = TextEditingController();
  final pupukCtrl = TextEditingController();
  final pestisidaCtrl = TextEditingController();
  final sewaLahanCtrl = TextEditingController();
  final transportasiCtrl = TextEditingController();
  final upahHarianCtrl = TextEditingController();
  final biayaLainCtrl = TextEditingController();

  StreamSubscription? _pembiayaanSub;
  final RxList<Pembiayaan> daftarBiaya = <Pembiayaan>[].obs;
  RxBool editableBiaya = false.obs;

  // Biaya Opsional
  final List<TextEditingController> biayaNamaCtrl = [];
  final List<TextEditingController> biayaNilaiCtrl = [];
  final TextEditingController namaBiayaOpsionalCtrl = TextEditingController();
  final TextEditingController keteranganBiayaOpsionalCtrl = TextEditingController();
  final tanggalBiayaOpsional = DateTime.now().obs;
  final RxInt biayaFieldCount = 0.obs;
  final RxList<PembiayaanOpsionalModel> daftarBiayaOpsional = <PembiayaanOpsionalModel>[].obs;
  StreamSubscription? _pembiayaanOpsionalSub;

  // UMUM
  var showOpsional = false.obs;
  RxBool editable = false.obs;
  Lahan? get lahan => selectedLahanCtrl.lahanTerpilih;
  PlantingPeriod? get periode => selectedPeriodeCtrl.plantingPeriod;

  @override
  void onInit() {
    super.onInit();
  
  }

  @override
  void onReady() {
    super.onReady();
    if (lahan == null || periode == null) {
      Get.snackbar('Error', 'Lahan atau Periode belum dipilih.');
      Get.back(); 
    } else {
      _loadDataPembiayaan();
      listenPembiayaanOpsional();
      listenPembiayaan();
    }
  }

  Future<void> _loadDataPembiayaan() async {
    // Jika ada data pembiayaan sebelumnya yang perlu di-load untuk lahan & periode ini
    // Contoh:
    // Pembiayaan? existingData = await pembiayaanService.fetchExistingPembiayaan(lahan!.id, periode!.id);
    // if (existingData != null) {
    //   benihCtrl.text = existingData.benih;
    //   // ... isi controller lain
    // }
    try {
      Stream<List<Pembiayaan>>? existingData = pembiayaanService.getPembiayaan(lahan!.id, periode!.id);
      if (existingData != null) {
        
      }
    } catch (e) {
      print(e);
      Get.snackbar('Terjadi Kesalahan', 'Gagal memuat data.');
    } finally {
      isLoading.value = false;
    }
  }

  // FUNGSI UNTUK BIAYA TETAP

  Future<void> uploadPembiayaan() async {
    if (lahan == null || periode == null) {
      notifikasi.notif(text: 'Error: Lahan atau Periode tidak valid!');
      return;
    }

    isLoading.value = true;

    String benih = benihCtrl.text;
    String biayaAir = biayaAirCtrl.text;
    String olahTanah = olahTanahCtrl.text;
    String biayaPengendalian = biayaPengendalianCtrl.text;
    String mulsa = '';
    String pestisida = '';
    String pupuk = '';
    String sewaLahan = '';
    String transportasi = '';
    String upahHarian = '';
    String biayaLain = '';

    if (showOpsional.value) {
      mulsa = mulsaCtrl.text;
      pestisida = pestisidaCtrl.text;
      pupuk = pupukCtrl.text;
      sewaLahan = sewaLahanCtrl.text;
      transportasi = transportasiCtrl.text;
      upahHarian = upahHarianCtrl.text;
      biayaLain = biayaLainCtrl.text;
    }

    try {
      Pembiayaan biaya = Pembiayaan(
        lahanId: lahan!.id,
        periodeId: periode!.id,
        benih: benih,
        biayaAir: biayaAir,
        biayaPengendalian: biayaPengendalian,
        olahTanah: olahTanah,
        mulsa: mulsa,
        pestisida: pestisida,
        pupuk: pupuk,
        sewaLahan: sewaLahan,
        transportasi: transportasi,
        upahHarian: upahHarian,
        biayaLain: biayaLain,
      );

      await pembiayaanService.uploadDataPembiayaan(biaya, lahan!.id, periode!.id);
      Get.back(); 
    } catch (e) {
      print(e);
      notifikasi.notif(text: 'Gagal upload: ${e.toString()}');
      Get.snackbar('Error', 'Gagal mengupload data: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateDataPembiayaan(String documentId) async {
    try {
      final lahanId = lahan!.id;
      final periodeId = periode!.id;

      final data = Pembiayaan(
        lahanId: lahanId,
        periodeId: periodeId,
        benih: benihCtrl.text.trim(),
        biayaAir: biayaAirCtrl.text.trim(),
        biayaPengendalian: biayaPengendalianCtrl.text.trim(),
        mulsa: mulsaCtrl.text.trim(),
        olahTanah: olahTanahCtrl.text.trim(),
        pestisida: pestisidaCtrl.text.trim(),
        pupuk: pupukCtrl.text.trim(),
        sewaLahan: sewaLahanCtrl.text.trim(),
        transportasi: transportasiCtrl.text.trim(),
        upahHarian: upahHarianCtrl.text.trim(),
        biayaLain: biayaLainCtrl.text.trim()
      );

      await pembiayaanService.updateDataPembiayaan(lahanId: lahanId, periodeId: periodeId, documentId: documentId, data: data);
      notifikasi.notif(text: 'Berhasil!', subTitle: 'Data berhasil diperbarui.', icon: Icons.check, warna: primer1);
      return true;
    } catch (e) {
      print(e);
      notifikasi.notif(text: 'Gagal', subTitle: 'Gagal untuk memperbarui data pembiayaan tetap, silahkan coba kembali.', icon: Icons.error, warna: salahInd);
      return false;
    }
  }

  void listenPembiayaan() {
    if (lahan != null && periode != null) {
      _pembiayaanSub?.cancel();
      _pembiayaanSub = pembiayaanService.getPembiayaan(lahan!.id, periode!.id).listen((data) {
        daftarBiaya.value = data;
      });
    }
  }

  // FUNGSI UNTUK BIAYA OPSIONAL

  Future<bool> uploadDataPembiayaanOpsional() async {
    Map<String, dynamic> biayaOpsionalMap = {};
    double nilaiTotal = 0;
    for (int i = 0; i < biayaNamaCtrl.length; i++) {
      String namaBiaya = biayaNamaCtrl[i].text.trim();
      String valueBiaya = biayaNilaiCtrl[i].text.trim();

      if (namaBiaya.isNotEmpty && valueBiaya.isNotEmpty) {
        double? nilai = double.tryParse(valueBiaya);
        biayaOpsionalMap[namaBiaya] = nilai ?? valueBiaya;

        if (nilai != null) {
          nilaiTotal += nilai;
        }
      }
    }

    try {
      PembiayaanOpsionalModel biayaOpsional = PembiayaanOpsionalModel(
        biayaOpsional: biayaOpsionalMap,
        namaBiayaOpsional: namaBiayaOpsionalCtrl.text,
        keteranganBiayaOpsional: keteranganBiayaOpsionalCtrl.text,
        jumlahBiayaOpsional: nilaiTotal,
        tanggalBiayaOpsional: DateTime.now()
      );
      await pembiayaanService.uploadDataPembiayaanOpsional(biayaOpsional, lahan!.id, periode!.id);
      notifikasi.notif(text: 'Berhasil!', subTitle: 'Data pembiayaan berhasil diunggah.', warna: primer1);
      return true;
    } catch (e) {
      print(e);
      notifikasi.notif(text: 'Gagal', subTitle: 'Data pembiayaan gagal diunggah, silahkan coba kembali.');
      return false;
    }
  }

  Future<bool> updateDataPembiayaanOpsional(String documentId) async {
  try {
    final lahanId = lahan!.id;
    final periodeId = periode!.id;

    Map<String, dynamic> ambilDataBiayaOpsional() {
      Map<String, dynamic> hasil = {};
      for (int i = 0; i < biayaFieldCount.value; i++) {
        final nama = biayaNamaCtrl[i].text;
        final nilai = double.tryParse(biayaNilaiCtrl[i].text) ?? 0;
        if (nama.isNotEmpty) hasil[nama] = nilai;
      }
      return hasil;
    }

    final model = PembiayaanOpsionalModel(
      pembiayaanOpsionalId: documentId,
      namaBiayaOpsional: namaBiayaOpsionalCtrl.text.trim(),
      keteranganBiayaOpsional: keteranganBiayaOpsionalCtrl.text.trim(),
      tanggalBiayaOpsional: tanggalBiayaOpsional.value,
      biayaOpsional: ambilDataBiayaOpsional(),
    );

    await pembiayaanService.updatePembiayaanOpsional(
      lahanId: lahanId,
      periode: periodeId,
      documentId: documentId,
      data: model,
    );
    notifikasi.notif(text: 'Berhasil!', subTitle: 'Data telah berhasil diperbarui.', icon: Icons.check, warna: primer1);
    return true;
  } catch (e) {
    print('Gagal update: $e');
    notifikasi.notif(text: 'Gagal', subTitle: 'Data gagal diperbarui, silahkan coba kembali.', icon: Icons.error, warna: salahInd);
    return false;
  }
}

  void listenPembiayaanOpsional() {
    if (lahan != null && periode != null) {
      _pembiayaanOpsionalSub?.cancel();
      _pembiayaanOpsionalSub = pembiayaanService.getPembiayaanOpsional(lahan!.id, periode!.id).listen((data) {
        daftarBiayaOpsional.value = data;
      });
    }
  }

  void deletePembiayaanOpsional(String biayaOpsionalId) {
    pembiayaanService.deletePembiayaanOpsional(lahanId: lahan!.id, periode: periode!.id, documentId: biayaOpsionalId);
  }

  void inisialisasiFormEdit(Map<String, dynamic> biayaOpsional) {
    biayaNamaCtrl.clear();
    biayaNilaiCtrl.clear();

    biayaOpsional.forEach((nama, nilai) {
      biayaNamaCtrl.add(TextEditingController(text: nama));
      biayaNilaiCtrl.add(TextEditingController(text: nilai.toString()));
    });

    biayaFieldCount.value = biayaNamaCtrl.length;
  }

  void tambahFieldBiayaLainnya() {
    biayaNamaCtrl.add(TextEditingController());
    biayaNilaiCtrl.add(TextEditingController());
    biayaFieldCount.value++;
  }

  void hapusFieldBiayaLainnya(int index) {
    biayaNamaCtrl.removeAt(index);
    biayaNilaiCtrl.removeAt(index);
    biayaFieldCount.value--;
  }

  void resetFormBiayaOpsional() {
    for (var ctrl in biayaNamaCtrl) {
      ctrl.dispose();
    }
    for (var ctrl in biayaNilaiCtrl) {
      ctrl.dispose();
    }
    biayaNamaCtrl.clear();
    biayaNilaiCtrl.clear();

    biayaFieldCount.value = 0;

    biayaNamaCtrl.add(TextEditingController());
    biayaNilaiCtrl.add(TextEditingController());

    biayaFieldCount.refresh();
  }

  @override
  void onClose() {
    benihCtrl.dispose();
    biayaAirCtrl.dispose();
    biayaPengendalianCtrl.dispose();
    mulsaCtrl.dispose();
    olahTanahCtrl.dispose();
    pupukCtrl.dispose();
    pestisidaCtrl.dispose();
    sewaLahanCtrl.dispose();
    transportasiCtrl.dispose();
    upahHarianCtrl.dispose();
    _pembiayaanOpsionalSub?.cancel();
    namaBiayaOpsionalCtrl.dispose();
    keteranganBiayaOpsionalCtrl.dispose();
    super.onClose();
  }

  
}
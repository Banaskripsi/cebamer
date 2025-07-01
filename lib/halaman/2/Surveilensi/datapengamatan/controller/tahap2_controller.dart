import 'dart:math';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/helper/pengamatanlokal_helper.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/model/pengamatan_helper_model.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tahap2Controller extends GetxController {

  final PengamatanHelper dbHelper = PengamatanHelper.instance;
  final notifikasi = Get.find<Notifikasi>();

  final _petakUpdateTrigger = 0.obs;
  int get petakUpdateTrigger => _petakUpdateTrigger.value;

  final Map<int, List<int>> _activeIndexesCache = {};

  void triggerPetakUpdate() {
    _petakUpdateTrigger.value++;
  }

  List<int> generateActiveIndexesForPengamatan(PengamatanLokal pengamatan) {
    if (pengamatan.id == null) {
      return [];
    }
    if (_activeIndexesCache.containsKey(pengamatan.id)) {
      return _activeIndexesCache[pengamatan.id]!;
    }

    final jumlahGrid = pengamatan.jumlahKotak;
    final mode = pengamatan.metodePengamatan;

    if (jumlahGrid == null || jumlahGrid <= 0) {
      return [];
    }

    if (mode == null || mode.isEmpty) {
      return [];
    }
    
    List<int> activeIndexes = [];
    int jumlahKotakTotal = jumlahGrid * jumlahGrid;

    if (jumlahKotakTotal == 0) return [];

    final random = Random(pengamatan.id!);
    
    switch (mode) {
      case 'Simple Random Sampling':
        while (activeIndexes.length < jumlahGrid) {
          int randomIndex = random.nextInt(jumlahKotakTotal);
          if (!activeIndexes.contains(randomIndex)) {
            activeIndexes.add(randomIndex);
          }
        }
        break;
        
      case 'Systematic Sampling: Papan Catur':
        for (int i = 0; i < jumlahKotakTotal; i++) {
          int row = i ~/ jumlahGrid;
          int col = i % jumlahGrid;
          if ((row + col) % 2 == 0) {
            activeIndexes.add(i);
          }
        }
        break;
        
      case 'Systematic Sampling: Diagonal':
        for (int i = 0; i < jumlahGrid; i++) {
          // Diagonal utama
          activeIndexes.add(i * jumlahGrid + i);
          // Diagonal sekunder
          if (i != jumlahGrid - 1 - i) {
            activeIndexes.add(i * jumlahGrid + (jumlahGrid - 1 - i));
          }
        }
        activeIndexes.sort();
        break;
        
      case 'Systematic Sampling: Zig-zag':
        for (int row = 0; row < jumlahGrid; row++) {
          for (int col = 0; col < jumlahGrid; col++) {
            if (row == 0 || row == jumlahGrid - 1 || row + col == jumlahGrid - 1) {
              activeIndexes.add(row * jumlahGrid + col);
            }
          }
        }
        activeIndexes.sort();
        break;
        
      default:
        activeIndexes = List.generate(jumlahKotakTotal, (index) => index);
    }

    _activeIndexesCache[pengamatan.id!] = activeIndexes;
    return activeIndexes;
  }

  /// Validasi kelengkapan data untuk PENGAMATAN SPESIFIK menggunakan SQFlite.
  Future<bool> validasiKelengkapanDataPetak(PengamatanLokal pengamatan) async {
    if (pengamatan.id == null) {
      Get.snackbar("Error Validasi", "ID Pengamatan Lokal (SQFlite) tidak ditemukan.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    int idPengamatanLokalSqflite = pengamatan.id!;

    List<int> indexAktifLokal = generateActiveIndexesForPengamatan(pengamatan);

    if (indexAktifLokal.isEmpty) {
      final jumlahGrid = pengamatan.jumlahKotak;
      if (jumlahGrid == null || jumlahGrid == 0) {
        return true; 
      } else {
        return true;
      }
    }

    // Ambil Set<int> dari petak yang sudah diisi dari SQFlite
    Set<int> indeksSudahTerisi;
    try {
      indeksSudahTerisi = await dbHelper.getIndeksPetakTerisi(idPengamatanLokalSqflite);
    } catch (e) {
      Get.snackbar("Error Database", "Gagal mengambil status petak dari database lokal.",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return false;
    }
    

    List<String> petakBelumLengkapUi = []; // Untuk menampilkan nomor petak 1-based
    for (int indexLokalWajibIsi in indexAktifLokal) {
      if (!indeksSudahTerisi.contains(indexLokalWajibIsi)) {
        petakBelumLengkapUi.add((indexLokalWajibIsi + 1).toString()); // Konversi ke 1-based
      }
    }

    if (petakBelumLengkapUi.isNotEmpty) {
      String daftarPetak = petakBelumLengkapUi.join(', ');
      notifikasi.notif(text: 'Belum Lengkap!', subTitle: 'Silahkan lengkapi data seluruh petak, yakni $daftarPetak agar bisa melanjutkan', warna: salahInd);
      return false;
    }
    notifikasi.notif(text: 'Berhasil!', subTitle: 'Semua data petak telah lengkap.');
    return true;
  }

  @override
  void onClose() {
    _activeIndexesCache.clear();
    super.onClose();
  }
}
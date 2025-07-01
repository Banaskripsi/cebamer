import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/helper/pengamatanlokal_helper.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/model/tahapan_model.dart';
import 'package:get/get.dart';

class TahapanController extends GetxController {
  var tahapanist = <TahapanModel>[].obs;
  var tahapanMap = <int, List<TahapanModel>>{}.obs;
  var isLoading = false.obs;
  int? _currentId;

  final PengamatanHelper _helper = PengamatanHelper.instance;
  final List<Map<String, dynamic>> defaultTahapan = [
    {'nama': 'Tahap 1', 'urutan': 0},
    {'nama': 'Tahap 2', 'urutan': 1},
    {'nama': 'Tahap 3', 'urutan': 2}
  ];

  // TAHAP PADA ID PENGAMATAN YANG SPESIFIK
  Future<void> loadTahapan(int idPengamatan) async {
    _currentId = idPengamatan;
    isLoading.value = true;

    try {
      final data = await _helper.getTahapanByPengamatanId(idPengamatan);
      if (data.isEmpty) {
        await _createInitialTahapan(idPengamatan);
        final newData = await _helper.getTahapanByPengamatanId(idPengamatan);
        tahapanMap[idPengamatan] = newData;
      } else {
        tahapanMap[idPengamatan] = data;
      }
      tahapanMap.refresh();
    } catch (e) {
      throw Exception('Terjadi kesalahan pada getTahapanByPengamatanId: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // UNTUK INDIKATOR SETIAP LIST PENGAMATAN
  bool semuaTahapSelesai(int idPengamatan) {
    final list = tahapanMap[idPengamatan];
    if (list == null || list.isEmpty) return false;
    return list.every((tahap) => tahap.status == "Selesai");
  }

  //BUAT TAHAP PADA DAFTAR (LIST) ID PENGAMATAN
  // Future<void> loadSemuaTahapan(List<int?> semuaIdPengamatan) async {
  //   isLoading.value = true;
  //   try {
  //     for (final id in semuaIdPengamatan) {
  //       final data = await _helper.getTahapanByPengamatanId(id!);
  //       if (data.isEmpty) {
  //         await _createInitialTahapan(id);
  //         final newData = await _helper.getTahapanByPengamatanId(id);
  //         tahapanMap[id] = newData;
  //       } else {
  //         tahapanMap[id] = data;
  //       }
  //     }
  //     tahapanMap.refresh();
  //   } catch (e) {
  //     print('Error loadSemuaTahapan: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> loadSemuaTahapan(List<int?> semuaIdPengamatanMentah) async {
    isLoading.value = true;
    // Filter ID yang null
    final semuaIdPengamatan = semuaIdPengamatanMentah.whereType<int>().toList();

    try {
      for (final id in semuaIdPengamatan) {
        final data = await _helper.getTahapanByPengamatanId(id);
        if (data.isEmpty) {
          await _createInitialTahapan(id);
          final newData = await _helper.getTahapanByPengamatanId(id);
          tahapanMap[id] = newData;
        } else {
          tahapanMap[id] = data;
        }
      }
      tahapanMap.refresh();
    } catch (e) {
      throw Exception('Error loadSemuaTahapan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to get tahapan by urutan
  TahapanModel? getTahapanByUrutan(int idPengamatan, int urutan) {
    final tahapan = tahapanMap[idPengamatan];
    if (tahapan == null) return null;
    return tahapan.firstWhereOrNull((t) => t.urutan == urutan);
  }

  // Helper method to check if tahapan is complete
  bool isTahapanComplete(int idPengamatan, int urutan) {
    final tahapan = getTahapanByUrutan(idPengamatan, urutan);
    return tahapan?.status == "Selesai";
  }

  Future<void> _createInitialTahapan(int idPengamatan) async {
    try {
      for (var config in defaultTahapan) {
        final tahapanBaru = TahapanModel(
          idPengamatan: idPengamatan,
          namaTahapan: config['nama'],
          urutan: config['urutan'],
          status: "Belum Selesai",
        );
        await _helper.insertTahapan(tahapanBaru);
      }
    } catch (e) {
      throw Exception('Error pada createInitialTahapan: $e');
    }
  }

  Future<void> tambahTahapanDefault(int idPengamatanBaru) async {
    _currentId = idPengamatanBaru;
    await _createInitialTahapan(idPengamatanBaru);
    final data = await _helper.getTahapanByPengamatanId(idPengamatanBaru);
    tahapanMap[idPengamatanBaru] = data;
    tahapanMap.refresh();
  }

  Future<void> updateStatusTahapan(int idPengamatan, int idTahapan, String newStatus) async {
    isLoading.value = true;
    try {
      final list = tahapanMap[idPengamatan];
      if (list == null) return;
      int index = list.indexWhere((t) => t.id == idTahapan);
      if (index != -1) {
        TahapanModel tahapanUpdate = list[index];
        tahapanUpdate.status = newStatus;
        await _helper.updateTahapan(tahapanUpdate);
        list[index] = tahapanUpdate;
        tahapanMap[idPengamatan] = List.from(list);
        tahapanMap.refresh();
      }
    } catch (e) {
      throw Exception('Error bagian update: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> hapusSemuaTahapanPengamatan(int idPengamatan) async {
    isLoading.value = true;
    try {
      await _helper.deleteSemuaTahapan(idPengamatan);
      if (_currentId == idPengamatan) {
        tahapanMap.remove(idPengamatan);
        tahapanMap.refresh();
      }
    } catch (e) {
      throw Exception('Error saat hapus semua data tahapan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> hapusSatuTahapan(int idPengamatan, int idTahapan) async {
    if (_currentId == null) return;
    isLoading.value = true;
    try {
      await _helper.deleteTahapan(idTahapan);
      final list = tahapanMap[idPengamatan];
      if (list != null) {
        list.removeWhere((t) => t.id == idTahapan);
        tahapanMap[idPengamatan] = List.from(list);
        tahapanMap.refresh();
      }
    } catch (e) {
      throw Exception('Errpr saat hapus satu data tahanapan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // JIKA INGIN RESET
  void resetController() {
    _currentId = null;
    isLoading.value = false;
  }
}
import 'package:cebamer/model/data_model.dart';
import 'package:cebamer/services/navigasi.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/services/profilLahanService/lahan_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/controller/periode_controller.dart';
import 'package:get_it/get_it.dart';

class FeaturesController extends GetxController {
  // Akses controller global dan service (akan di-inject)
  final LahanService lahanService = Get.find<LahanService>();
  final NavigasiService navigasi = Get.find<NavigasiService>();
  final Notifikasi notifikasi = GetIt.I<Notifikasi>();
  final SelectedLahanController selectedLahanCtrl = Get.find<SelectedLahanController>();
  final SelectedPeriodeController selectedPeriodeCtrl = Get.find<SelectedPeriodeController>();

  // State yang reaktif
  final RxBool isLoadingLahan = true.obs;
  final RxBool isLoadingPeriode = false.obs;

  // Worker untuk listen perubahan pada lahan terpilih
  late Worker _lahanSelectionWorker;

  @override
  void onInit() {
    super.onInit();
    initializeLahan();
    // final Rx<Lahan?> _lahanTerpilih = Rx<Lahan?>(null);
    // Lahan? get lahanTerpilih => _lahanTerpilih.value; // getter biasa
    // Rx<Lahan?> get lahanTerpilihRx => _lahanTerpilih; // getter untuk Rx object jika perlu expose
    _lahanSelectionWorker = ever(selectedLahanCtrl.lahanTerpilihRx, (Lahan? selectedLahan) {
      // Callback ini akan dipanggil setiap kali selectedLahanCtrl.lahanTerpilihRx.value berubah
      if (selectedLahan != null) {
        loadPlantingPeriods(selectedLahan.id);
      } else {
        selectedPeriodeCtrl.clearAll();
      }
    });
  }

  @override
  void onClose() {
    _lahanSelectionWorker.dispose(); // Hentikan worker saat controller ditutup
    super.onClose();
  }

  Future<void> initializeLahan() async {
    isLoadingLahan.value = true;
    selectedPeriodeCtrl.clearAll(); // Pastikan ini aman dipanggil dari sini

    try {
      final allLahan = await lahanService.getLahanPengguna();
      selectedLahanCtrl.setDaftarLahan(allLahan, selectFirstAsDefault: true);
      // Jika ada lahan terpilih setelah setDaftarLahan, worker 'ever' akan otomatis trigger loadPlantingPeriods
    } catch (e) {
      notifikasi.notif(text: 'Gagal memuat lahan Anda.', icon: Icons.error);
    } finally {
      isLoadingLahan.value = false;
    }
  }

  Future<void> loadPlantingPeriods(String lahanId) async {
    isLoadingPeriode.value = true;
    try {
      final periode = await lahanService.getPlantPeriods(lahanId);
      selectedPeriodeCtrl.setDaftarPeriode(periode, selectFirstAsDefault: true);
    } catch (e) {
      notifikasi.notif(text: 'Gagal memuat periode lahan Anda.', icon: Icons.error);
      selectedPeriodeCtrl.clearAll();
    } finally {
      isLoadingPeriode.value = false;
    }
  }

  void onLahanPilih(Lahan? lahan) {
    if (lahan != null) {
      selectedLahanCtrl.setPilihLahan(lahan); // Ini akan memicu worker 'ever'
      notifikasi.notif(text: "Lahan '${lahan.namaLahan}' dipilih", icon: Icons.check_circle);
    }
  }

  void navigasiKeTambahLahan() async {
    navigasi.pindahHalaman('/lahanPeta');
    initializeLahan();
  }

  void navigasiFitur(String routeName) {
    if (selectedLahanCtrl.lahanTerpilih == null) {
      notifikasi.notif(text: 'Belum ada lahan yang dipilih', icon: Icons.warning);
      return;
    }
    // Jika periode juga wajib dipilih untuk beberapa fitur:
    if (selectedPeriodeCtrl.plantingPeriod == null) {
      notifikasi.notif(text: 'Belum ada periode tanam yang dipilih untuk lahan ini', icon: Icons.warning);
      return;
    }
    navigasi.pindahHalaman(routeName);
  }
}

import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/controller/periode_controller.dart';
import 'package:cebamer/model/data_model.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/services/profilLahanService/lahan_service.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ManajemenController extends GetxController {
  final lahanController = Get.find<SelectedLahanController>();
  final periodeController = Get.find<SelectedPeriodeController>();
  final lahanService = Get.find<LahanService>();

  final notifikasi = Get.find<Notifikasi>();

  

  TextEditingController namaLahanCtrl = TextEditingController();
  TextEditingController lokasiLahanCtrl = TextEditingController();
  TextEditingController varietasCtrl = TextEditingController();
  TextEditingController namaPeriodeCtrl = TextEditingController();
  TextEditingController targetPanenCtrl = TextEditingController();
  TextEditingController deskripsiCtrl = TextEditingController();

  final db = FirebaseFirestore.instance;

  Lahan? get lahan => lahanController.lahanTerpilih;
  PlantingPeriod? get periode => periodeController.plantingPeriod;

  List<LatLng>? titikKoordinat;

  RxBool editable = false.obs;
  RxBool editLahan = false.obs;
  Rx<bool> isLoading = false.obs;

  Future<List<LatLng>> getKoordinatLahan() async {
    try {
      Lahan? dataLahan = await lahanService.getLahanId(lahan!.id);
      if (dataLahan != null) {
        List<LatLng> koordinatLahan = dataLahan.coordinates;
        return koordinatLahan;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> editKoordinatLahan(List<LatLng> newKoordinat) async {
    try {
      List<Map<String, double>> koordinatList = newKoordinat
        .map((latLng) => {'lat': latLng.latitude, 'lng': latLng.longitude})
        .toList();
      await db.collection('lands').doc(lahan!.id).update({'coordinates': koordinatList});

      notifikasi.notif(text: 'Berhasil!', subTitle: 'Koordinat lahan berhasil diperbarui!', warna: primer1, icon: Icons.check);
      return true;
    } catch (e) {
      notifikasi.notif(text: 'Gagal', subTitle: 'Gagal memperbarui koordinat lahan.', warna: salahInd, icon: Icons.error);
      return false;
    }
  }

  Future<bool> editDataLahan() async {
  try {
    var doc = await db.collection('lands').doc(lahan!.id).get();
    var dataLama = Lahan.fromFirestore(doc);

    var dataBaru = dataLama.copyWith(
      namaLahan: namaLahanCtrl.text,
      varietas: varietasCtrl.text,
      detailLokasi: lokasiLahanCtrl.text,
      deskripsi: deskripsiCtrl.text
    );
    await db.collection('lands').doc(lahan!.id).update(dataBaru.toFirestore());
    lahanController.lahanTerpilihRx.value = dataBaru;
    notifikasi.notif(text: 'Berhasil!', subTitle: 'Data telah berhasil diedit dan disimpan!', warna: primer1, icon: Icons.check);
    return true;
  } catch (e) {
    notifikasi.notif(text: 'Gagal', subTitle: 'Data gagal disimpan, silahkan coba kembali.', warna: salahInd, icon: Icons.error);
    return false;
  }
}

  Future<bool> editDataPeriode() async {
    try {
      var doc = await db
        .collection('lands')
        .doc(lahan!.id)
        .collection('plantingPeriods')
        .doc(periode!.id)
        .get();

      var dataLama = PlantingPeriod.fromFirestore(doc);
      var dataBaru = dataLama.copyWith(
        periodName: namaPeriodeCtrl.text,
        targetPanen: double.tryParse(targetPanenCtrl.text)
      );
    await db
      .collection('lands')
      .doc(lahan!.id)
      .collection('plantingPeriods')
      .doc(periode!.id)
      .update(dataBaru.toFirestore());
      periodeController.plantingPeriodRx.value = dataBaru;
      return true;
    } catch (e) {
      return false;
    }
  }

  void refreshData() {
    update();
  }
}
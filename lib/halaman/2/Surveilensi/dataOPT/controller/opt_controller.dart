import 'dart:io';

import 'package:cebamer/halaman/2/Surveilensi/dataOPT/model/opt_model.dart';
import 'package:cebamer/halaman/2/Surveilensi/dataOPT/service/dataopt_service.dart';
import 'package:cebamer/services/auth.dart';
import 'package:cebamer/services/navigasi.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/services/storage.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class OptController extends GetxController {
  final JenisOPTService optService = Get.find<JenisOPTService>();
  final navigasi = Get.find<NavigasiService>();
  final notifikasi = Get.find<Notifikasi>();
  final storage = Get.find<StorageOPT>();
  final auth = Get.find<AuthService>();

  final optKey = GlobalKey<FormState>();
  
  final RxBool isLoading = false.obs;
  final namaOptController = TextEditingController();
  final deskripsiController = TextEditingController();
  File? selectedImageFile;
  final JenisOPTService _optService = JenisOPTService();
  final AuthService _auth = AuthService();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    namaOptController.dispose();
    super.dispose();
  }

  Future<bool> _isAndroid13OrAbove() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt >= 33;
  }
  
  Future<bool> mintaIzinKameraDanGaleri() async {
    final kamera = await Permission.camera.request();

    PermissionStatus galeri;

    if (Platform.isAndroid) {
      if (await _isAndroid13OrAbove()) {
        galeri = await Permission.photos.request();
      } else {
        galeri = await Permission.storage.request(); 
      }
    } else {
      galeri = await Permission.photos.request();
    }
    return kamera.isGranted && galeri.isGranted;
  }

  
  Future<void> pickImage(ImageSource source) async {
    bool perizinanDiberikan = await mintaIzinKameraDanGaleri();
    if (perizinanDiberikan) {
      try {
        final XFile? pilihFile = await _picker.pickImage(source: source);
        if (pilihFile != null) {
          selectedImageFile = File(pilihFile.path);
          update();
        }
      } catch (e) {
        notifikasi.notif(text: 'Terjadi kesalahan', subTitle: 'Mohon untuk ulangi memilih gambar');
      }
    } else {
      openAppSettings();
    }
  }

  Future<void> uploadAndSave() async {
    final validasi = optKey.currentState?.validate() ?? false;
    if (selectedImageFile == null) {
      return;
    }

    isLoading.value = true;
    update();
    if (!validasi) return;
    try {
      final String? imageUrl = await storage.uploadGambarOPT(
        file: selectedImageFile!,
        uid: auth.user!.uid
      );

      if (imageUrl != null) {
        JenisOPT dokumentasi = JenisOPT(
          userId: _auth.user!.uid,
          namaOPT: namaOptController.text.trim(),
          deskripsi: deskripsiController.text.trim(),
          dokURL: imageUrl,
          faktorKoreksi: 1
        );
        await _optService.tambahFoto(dokumentasi);
        notifikasi.notif(text: 'Berhasil!', subTitle: 'Berhasil mengunggah data gambar.',icon: Icons.check, warna: primer1);
        navigasi.kembali();
      } else {
        notifikasi.notif(text: 'Gagal!', subTitle: 'Tidak dapat mengunggah data gambar, silahkan coba lagi.',icon: Icons.error, warna: salahInd);
      }
    } catch (e) {
      notifikasi.notif(text: 'Gagal!', subTitle: 'Tidak dapat mengunggah data gambar, silahkan coba lagi.',icon: Icons.error, warna: salahInd);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onClose() {
    namaOptController.dispose();
    deskripsiController.dispose();
    selectedImageFile = null;
    super.onClose();
  }
}
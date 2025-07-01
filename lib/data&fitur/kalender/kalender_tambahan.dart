import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

class KalenderCatatan extends StatefulWidget {
  final DateTime selectedDay;
  const KalenderCatatan({super.key, required this.selectedDay});

  @override
  State<KalenderCatatan> createState() => _KalenderCatatanState();
}

class _KalenderCatatanState extends State<KalenderCatatan> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final GetIt getIt = GetIt.instance;
  late DateTime _selectedDay;

  late Notifikasi _notifikasi;

  Future<void> tambahAcara () async {
    final user = FirebaseAuth.instance.currentUser!;
    final username = user.displayName;
    if (_judulController.text.isEmpty || _deskripsiController.text.isEmpty) {
      _notifikasi.notif(text: 'Harap isi bagian Judul dan Deskripsi pada catatan');
      return;
    }

    String formatTanggal = DateFormat('yyyy-MM-dd').format(_selectedDay);
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    await FirebaseFirestore.instance
      .collection('informasiPengguna')
      .doc(username)
      .collection('kalender_catatan')
      .add({
        'userId': userId,
        'date': formatTanggal,
        'type': 'catatan',
        'judul': _judulController.text,
        'deskripsi': _deskripsiController.text,
        'timestamp': DateTime.now(),
        'tanggalTambah': Timestamp.now()
      });

      _judulController.clear();
      _deskripsiController.clear();

      Get.back();
  }

  @override
  void initState() {
    super.initState();
    _notifikasi = getIt.get<Notifikasi>();
    _selectedDay = widget.selectedDay;
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.5,
      child: ListView(
        children: [
          Padding(
            padding: paddingLR20,
            child: Column(
              children: [
                j20,
                Text(
                  'Tambahkan Catatan',
                  style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3)
                ), j20,
                Formnya(controller: _judulController, hintText: 'Judul Catatan', inputType: TextInputType.text),
                j20,
                Formnya(controller: _deskripsiController, hintText: 'Deskripsi Catatan', inputType: TextInputType.text,),
                j20,
                ElevatedButton.icon(
                  onPressed: tambahAcara,
                  icon: Icon(Remix.save_2_fill),
                  label: Text('Simpan')
                ),

              ],
            )
          )
        ],
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    _judulController.dispose();
    _deskripsiController.dispose();
  }
}
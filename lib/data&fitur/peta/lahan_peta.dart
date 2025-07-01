import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/data&fitur/peta/lahan_hitung.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/services/navigasi.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/services/profilLahanService/lahan_service.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

class LahanPeta extends StatefulWidget {
  const LahanPeta({super.key});

  @override
  State<LahanPeta> createState() => _LahanPetaState();
}

class _LahanPetaState extends State<LahanPeta> {
  GoogleMapController? _mapController; 
  late Notifikasi _notifikasi;
  late PageController _pageController;
  final NavigasiService _navigasi = Get.find<NavigasiService>();

  // Untuk form periode tanam utama
  DateTime? _periodeTanamAwal;
  DateTime? _periodeTanamAkhir; 

  final GetIt getIt = GetIt.instance;
  final _formLah = GlobalKey<FormState>();
  final LatLng _defaultLocation =
      const LatLng(-7.906311351150421, 110.16435928815766);
  
  Uint8List? _screenshotBytes;
  double luasArea = 0.0;

  List<LatLng> titikLahan = [];
  bool _locationError = false;
  bool _isLoadingLocation = true;
  bool _otomasiLuasLahan = true;


  LatLng? _posisiTengahPetaSaatIni;

  LatLng? _posisiSekarang;

  // Informasi Lahan
  String namaLahan = '';
  String lokasiLahan = '';
  // String luasLahan = ''; 
  String jenisTanaman = ''; 

  String? lahanDocIdSetelahSimpan;

  // Controller untuk TextFields
  final TextEditingController _namaLahanController = TextEditingController();
  final TextEditingController _lokasiLahanController = TextEditingController();
  final TextEditingController _luasLahanController = TextEditingController();
  final TextEditingController _namaPeriodeController = TextEditingController();
  final TextEditingController _tanggalTanamAwalController = TextEditingController();
  final TextEditingController _tanggalTanamAkhirController = TextEditingController();
  final TextEditingController _varietasController = TextEditingController();
  final TextEditingController _targetPanen = TextEditingController();

  final SelectedLahanController selectedLahan = Get.find<SelectedLahanController>();

  Future<void> _pilihTanggal(
      {required bool isTanggalAwal}) async {
    if (!mounted) return;
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (isTanggalAwal ? _periodeTanamAwal : _periodeTanamAkhir) ?? DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        locale: const Locale('id', 'ID'));

    if (picked != null) {
      setState(() {
        if (isTanggalAwal) {
          _periodeTanamAwal = picked;
          _tanggalTanamAwalController.text =
              DateFormat.yMMMMd('id_ID').format(picked);
        } else {
          _periodeTanamAkhir = picked;
           _tanggalTanamAkhirController.text =
              DateFormat.yMMMMd('id_ID').format(picked);
        }
      });
    }
  }


  // Fungsi untuk menyimpan periode tanam tunggal
  Future<void> _simpanPeriodeTanam({
    required String idLahan,
    required DateTime awal,
    required DateTime akhir,
    required String namaPeriode,
    required double targetPanen,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null ) {
      _notifikasi.notif(text: 'Pengguna tidak ditemukan', icon: Icons.error);
      return;
    }
    final fr = FirebaseFirestore.instance;
    final DocumentReference periodeTanamDocRef;
    periodeTanamDocRef = fr
        .collection('lands') // KOLEKSI BARU: 'lands'
        .doc(idLahan)
        .collection('plantingPeriods')
        .doc(); 

    /* // Neg meh nggo struktur lama
    final username = user.displayName!;
    periodeTanamDocRef = fr
        .collection('informasiPengguna')
        .doc(username)
        .collection('datalahan')
        .doc(idLahan)
        .collection('plantingPeriods') // Ganti nama dari 'bulan'
        .doc();
    */

    await periodeTanamDocRef.set({
      'periodName': namaPeriode,
      'startDate': Timestamp.fromDate(awal),
      'endDate': Timestamp.fromDate(akhir),
      'status': 'active',
      'targetPanen': targetPanen
    });
  }


  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    if (_posisiSekarang != null) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(_posisiSekarang!, 17));
    }
  }

  void _kalkulasiLuasLahan() {
    if (titikLahan.length < 3) {
      setState(() {
        luasArea = 0.0;
        if (_otomasiLuasLahan) {
          _luasLahanController.text = "${luasArea.toStringAsFixed(2)} m²";
        }
      });
      return;
    }
    setState(() {
      luasArea = hitungLuasLahan(titikLahan);
      if (_otomasiLuasLahan) {
        _luasLahanController.text = "${luasArea.toStringAsFixed(2)} m²";
      }
    });
  }

  void _tambahTitikDariTengah() {
    // Baca _posisiTengahPetaSaatIni yang diupdate oleh onCameraMove tanpa setState
    if (_posisiTengahPetaSaatIni != null) {
      setState(() {
        titikLahan.add(_posisiTengahPetaSaatIni!);
      });
      _kalkulasiLuasLahan();
    } else if (_mapController != null) {
      // Fallback jika _posisiTengahPetaSaatIni belum ada, ambil dari controller langsung
      // Ini memerlukan _mapController untuk diinisialisasi
      // Seharusnya _posisiTengahPetaSaatIni sudah di-set jika peta pernah digerakkan.
       // Untuk penggunaan pertama kali sebelum peta digeser, inisialisasi _posisiTengahPetaSaatIni
      // di _getInitialLocation atau setelah _mapController siap.
      _mapController!.getVisibleRegion().then((bounds) {
        LatLng center = LatLng(
          (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
          (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
        );
        setState(() {
          titikLahan.add(center);
        });
        _kalkulasiLuasLahan();
      });

    } else {
      _notifikasi.notif(text: 'Geser peta terlebih dahulu atau tunggu peta siap.', icon: Icons.info);
    }
  }

  void _undo() {
    if (titikLahan.isNotEmpty) {
      setState(() {
        titikLahan.removeLast();
      });
      _kalkulasiLuasLahan();
    }
  }

  Future<void> _simpanDataLahanDanPeriode() async {
    if (!_formLah.currentState!.validate()) {
      _notifikasi.notif(
          text: 'Mohon lengkapi semua data yang diperlukan', icon: Icons.warning);
      return;
    }
    if (titikLahan.length < 3) {
      _notifikasi.notif(text: 'Tambahkan minimal 3 titik untuk lahan', icon: Icons.warning);
      return;
    }
    if (_periodeTanamAwal == null || _periodeTanamAkhir == null) {
        _notifikasi.notif(text: 'Mohon isi tanggal awal dan akhir periode tanam.', icon: Icons.warning);
        return;
    }
    if (_periodeTanamAkhir!.isBefore(_periodeTanamAwal!)) {
        _notifikasi.notif(text: 'Tanggal akhir tidak boleh sebelum tanggal awal.', icon: Icons.warning);
        return;
    }

    _formLah.currentState!.save(); // Untuk mengisi variabel dari onSaved

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _notifikasi.notif(text: 'Pengguna tidak terautentikasi.', icon: Icons.error);
      return;
    }

    // Jika tidak otomasi, parse manual luas lahan
    double luasLahanFinal = luasArea;
    if (!_otomasiLuasLahan) {
        try {
            final parsedLuas = double.tryParse(_luasLahanController.text.replaceAll(RegExp(r'[^0-9.]'),''));
            if (parsedLuas != null) {
                luasLahanFinal = parsedLuas;
            } else {
                 _notifikasi.notif(text: 'Format luas lahan manual tidak valid.', icon: Icons.error);
                 return;
            }
        } catch (e) {
            _notifikasi.notif(text: 'Gagal memproses luas lahan manual.', icon: Icons.error);
            return;
        }
    }


    try {
      List<Map<String, dynamic>> koordinat = titikLahan
          .map((titik) => {'lat': titik.latitude, 'lng': titik.longitude})
          .toList();


      final lahanDocRef =
          await FirebaseFirestore.instance.collection('lands').add({
        'ownerUserId': user.uid,
        'landName': _namaLahanController.text,
        'varietas': _varietasController.text,
        'locationDetail': _lokasiLahanController.text,
        'coordinates': koordinat,
        'area': luasLahanFinal,
        'createdAt': Timestamp.now(),
      });

      lahanDocIdSetelahSimpan = lahanDocRef.id;
      _notifikasi.notif(text: 'Data lahan berhasil disimpan.', icon: Icons.check_circle, warna: Colors.green);
      

      final lahanService = getIt.get<LahanService>();
      final updatedLahanList = await lahanService.getLahanPengguna();
      selectedLahan.setDaftarLahan(updatedLahanList);


      await _simpanPeriodeTanam(
        idLahan: lahanDocIdSetelahSimpan!,
        awal: _periodeTanamAwal!,
        akhir: _periodeTanamAkhir!,
        namaPeriode: _namaPeriodeController.text,
        targetPanen: double.tryParse(_targetPanen.text) ?? 0,
      );
       _notifikasi.notif(text: 'Periode tanam juga berhasil disimpan.', icon: Icons.check_circle, warna: Colors.green);


      setState(() {
        titikLahan.clear();
        luasArea = 0.0;
        _luasLahanController.text = "0.00 m²";
        _namaLahanController.clear();
        _lokasiLahanController.clear();
        _namaPeriodeController.clear();
        _tanggalTanamAwalController.clear();
        _tanggalTanamAkhirController.clear();
        _periodeTanamAwal = null;
        _periodeTanamAkhir = null;
        lahanDocIdSetelahSimpan = null;
      });
      _pageController.jumpToPage(0);
      _navigasi.gantiHalaman('/lahanInformasi'); 

    } catch (e) {
      _notifikasi.notif(
          text: 'Gagal menyimpan data: ${e.toString()}', icon: Icons.error);
    }
  }


  Future<void> _getInitialLocation() async {
    setState(() {
      _isLoadingLocation = true; 
      _locationError = false;
    });
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _posisiSekarang = _defaultLocation;
              _posisiTengahPetaSaatIni = _defaultLocation; // Inisialisasi juga
              _isLoadingLocation = false;
            });
          }
          _notifikasi.notif(
              text: 'Izin lokasi ditolak. Lokasi default digunakan.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _posisiSekarang = _defaultLocation;
            _posisiTengahPetaSaatIni = _defaultLocation;
            _locationError = true;
            _isLoadingLocation = false;
          });
        }
        _notifikasi.notif(
            text: 'Izin lokasi permanen ditolak. Lokasi default digunakan.',
            icon: Icons.warning);
        return;
      }

      Position posisi = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      if (mounted) {
        setState(() {
          _posisiSekarang = LatLng(posisi.latitude, posisi.longitude);
          _posisiTengahPetaSaatIni = _posisiSekarang; 
          _isLoadingLocation = false;

          _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_posisiSekarang!, 17));
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _posisiSekarang = _defaultLocation;
          _posisiTengahPetaSaatIni = _defaultLocation;
          _isLoadingLocation = false;
          _locationError = true; // Anggap error jika gagal mendapatkan lokasi
        });
      }
      _notifikasi.notif(
          text: 'Error mendapatkan lokasi: ${e.toString()}. Menggunakan lokasi default.',
          icon: Icons.error);
    }
  }

  // // AMBIL SCREENSHOT LAHAN
  // Future<void> _ambilScreenshot() async {
  //   if (titikLahan.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Tidak ada screenshot untuk disimpan.')),
  //     );
  //   }
  //   try {
  //     await Future.delayed(Duration(milliseconds: 500));
  //     RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
  //       .findRenderObject() as RenderRepaintBoundary;
  //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //     if (byteData != null) {
  //       setState(() {
  //         _screenshotBytes = byteData.buffer.asUint8List();
  //       });
  //       print(e);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Screenshot lahan berhasil!'))
  //       );
  //     }
  //   } catch (e) {
  //     print(e);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Screenshot lahan gagal, silahkan coba lagi.'))
  //     );
  //   }
  // }

  // // SAVE HASIL SCREENSHOT KE GALERI
  // Future<void> _saveScreenshot() async {
  //   if (_screenshotBytes == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Tidak ada screenshot untuk disimpan.')),
  //     );
  //     return;
  //   }

  //   bool permissionGranted = await _requestStoragePermission();
  //   if (permissionGranted) {
  //     try {
  //       final result = await ImageGallerySaver.saveImage(
  //         _screenshotBytes!,
  //         quality: 100,
  //         name: "map_point_${DateTime.now().millisecondsSinceEpoch}",
  //       );
  //       if (result != null && result['isSuccess'] == true) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Screenshot disimpan ke galeri: ${result['filePath']}')),
  //         );
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Gagal menyimpan screenshot: ${result?['errorMessage'] ?? 'Alasan tidak diketahui'}')),
  //         );
  //       }
  //     } catch (e, s) {
  //       print("Error saving to gallery: $e\n$s");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Gagal menyimpan screenshot (exception): $e')),
  //       );
  //     }
  //   } else {
  //      ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Izin penyimpanan ditolak. Tidak dapat menyimpan.')),
  //     );
  //   }
  // }

  // // PERIZINAN LOKAL
  //   Future<bool> _requestStoragePermission() async {
  //   PermissionStatus status;
  //   if (Platform.isAndroid) {
  //     final androidInfo = await DeviceInfoPlugin().androidInfo;
  //     if (androidInfo.version.sdkInt >= 33) { // Android 13+
  //       status = await Permission.photos.request();
  //     } else {
  //       status = await Permission.storage.request();
  //     }
  //   } else {
  //     status = await Permission.photos.request(); // Untuk iOS
  //   }

  //   if (status.isGranted) {
  //     return true;
  //   } else if (status.isPermanentlyDenied) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Izin penyimpanan ditolak permanen. Aktifkan dari pengaturan aplikasi.'),
  //         action: SnackBarAction(label: 'Pengaturan', onPressed: openAppSettings),
  //       ),
  //     );
  //     return false;
  //   } else {
  //     return false;
  //   }
  // }


  @override
  void initState() {
    super.initState();
    _notifikasi = getIt.get<Notifikasi>();
    _pageController = PageController();
    selectedLahan;
    initializeDateFormatting('id_ID', null); // Cukup sekali
    _getInitialLocation(); // Panggil fungsi untuk mendapatkan lokasi
    _luasLahanController.text = "${luasArea.toStringAsFixed(2)} m²";
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _pageController.dispose();
    _namaLahanController.dispose();
    _lokasiLahanController.dispose();
    _luasLahanController.dispose();
    _namaPeriodeController.dispose();
    _tanggalTanamAwalController.dispose();
    _tanggalTanamAkhirController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildMapPage(),
          _buildFormPage(),
        ],
      ),
    );
  }

  Widget _buildMapPage() {
    return Stack(
      children: [
        if (_isLoadingLocation)
          const Center(child: CircularProgressIndicator())
        else
          GoogleMap(
            mapType: MapType.hybrid,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _posisiSekarang ?? _defaultLocation,
              zoom: 17,
            ),
            onCameraMove: (CameraPosition position) {
              // HANYA UPDATE VARIABEL, TANPA setState() agar tidak berat
              _posisiTengahPetaSaatIni = position.target;
            },
            markers: titikLahan
                .asMap()
                .entries
                .map((e) =>
                    Marker(markerId: MarkerId(e.key.toString()), position: e.value))
                .toSet(),
            polygons: {
              if (titikLahan.length >= 3)
                Polygon(
                    polygonId: const PolygonId("lahan"),
                    points: titikLahan,
                    fillColor: Colors.green.withOpacity(0.3),
                    strokeColor: Colors.green,
                    strokeWidth: 2)
            },
            myLocationEnabled: !_locationError,
            myLocationButtonEnabled: !_locationError,
            compassEnabled: true,
            mapToolbarEnabled: false,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
          ),
        if (!_isLoadingLocation)
          const Center(
            child: Icon(
              Icons.gps_fixed,
              color: Colors.red,
              size: 30,
            ),
          ),
        Positioned(
          bottom: 220,
          right: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'undo_button',
                onPressed: _undo,
                backgroundColor: primer2,
                child: const Icon(Icons.rotate_left, size: 24, color: Colors.white),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                heroTag: 'add_point_button',
                onPressed: _tambahTitikDariTengah,
                backgroundColor: primer2,
                child: const Icon(Icons.add_location_alt, size: 30, color: Colors.white),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: _isLoadingLocation ? 0 : 220,
            left: 20,
            child: Visibility(
              visible: titikLahan.isNotEmpty && !_isLoadingLocation,
              child: Chip(
                label: Text('${titikLahan.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)),
                backgroundColor: primer1,
                padding: const EdgeInsets.all(4),
              ),
            )),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.22,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: primer1,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                const Text(
                    'Tandai batas lahan Anda dengan menempatkan titik-titik di peta.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)),
                j20,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primer2,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  onPressed: () {
                    if (titikLahan.length < 3 && !_isLoadingLocation) {
                      _notifikasi.notif(text: 'Minimal 3 titik diperlukan untuk membentuk lahan.', icon: Icons.warning);
                      return;
                    }
                    if (!_isLoadingLocation) {
                       _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut
                      );
                    }
                    if (_screenshotBytes != null) {
                    }
                  },
                  child: const Text('Lanjutkan',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold)),
                )
              ]),
            ))
      ],
    );
  }

  Widget _buildFormPage() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primer1,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
        ),
        title: Text('Identitas Lahan'),
        titleTextStyle: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: paddingLR20.copyWith(bottom: 20),
          child: Form(
            key: _formLah,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                j20,
                
                Text('Detail Lahan',
                    style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3)),
                j10,
                Formnya(icon: Icons.terrain,controller: _namaLahanController, hintText: 'Nama Lahan', inputType: TextInputType.text,),
                j20,
                Formnya(icon: Icons.spa, controller: _varietasController, hintText: 'Varietas Tanaman', inputType: TextInputType.text),
                j20,
                 Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                          controller: _luasLahanController,
                          readOnly: _otomasiLuasLahan,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                             if (value == null || value.isEmpty) return 'Luas lahan tidak boleh kosong';
                             if (!_otomasiLuasLahan) {
                               final numCheck = double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'),''));
                               if (numCheck == null || numCheck <= 0) return 'Masukkan angka valid > 0';
                             }
                             return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Luas Lahan (m²)',
                              hintText: 'Otomatis / Input Manual',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.square_foot, color: primer1),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(2),
                                child: IconButton(
                                  tooltip: _otomasiLuasLahan ? "Ubah ke Manual" : "Gunakan Otomatis",
                                  onPressed: () {
                                    setState(() {
                                      _otomasiLuasLahan = !_otomasiLuasLahan;
                                      if (_otomasiLuasLahan) {
                                        _luasLahanController.text = "${luasArea.toStringAsFixed(2)} m²";
                                      } else {
                                
                                         _luasLahanController.text = luasArea > 0 ? luasArea.toStringAsFixed(2) : "";
                                      }
                                    });
                                  },
                                  icon: Icon(_otomasiLuasLahan ? Icons.draw : Icons.calculate_outlined, color: Colors.black),
                                ),
                              )
                            )),
                    ),
                  ],
                ),
                j20,
                Formnya(icon: Icons.map, controller: _lokasiLahanController, hintText: 'Lokasi Lahan', inputType: TextInputType.text,),
                j30,
                divider(context, 'Data Musim Tanam'), j10,
                Text('Musim Tanam',
                    style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3)),
                j10,
                Formnya(icon: Remix.time_zone_fill,controller: _namaPeriodeController, hintText: 'Nama Periode Tanam', inputType: TextInputType.text), j20,
                Formnya(icon: Remix.bar_chart_2_line, suffix: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('Kg', style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer1)),
                ) ,controller: _targetPanen, hintText: 'Target Panen pada 1 Lahan', inputType: TextInputType.numberWithOptions(decimal: true)),
                j20,
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                          controller: _tanggalTanamAwalController,
                          onTap: () => _pilihTanggal(isTanggalAwal: true),
                          readOnly: true,
                          validator: (value) =>
                              _periodeTanamAwal == null ? 'Pilih tanggal awal' : null,
                          decoration: const InputDecoration(
                              labelText: 'Tanggal Mulai Tanam',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today, color: primer1))),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                          controller: _tanggalTanamAkhirController,
                          onTap: () => _pilihTanggal(isTanggalAwal: false),
                          readOnly: true,
                          validator: (value) =>
                              _periodeTanamAkhir == null ? 'Pilih tanggal akhir' : null,
                          decoration: const InputDecoration(
                              labelText: 'Perkiraan Panen',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.event_available, color: primer1))),
                    ),
                  ],
                ),
                j30,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Remix.save_3_fill, size: 30, color: Colors.white,),
                    label: const Text('SIMPAN DATA LAHAN', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                    onPressed: _simpanDataLahanDanPeriode,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primer2,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                j30,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
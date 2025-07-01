import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/pengamatan_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/tahapan_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/helper/pengamatanlokal_helper.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/model/pengamatan_helper_model.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/widget/tahap_1.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/widget/tahap_2.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/widget/tahap_3.dart';
import 'package:cebamer/model/data_model.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class PengamatanMain extends StatefulWidget {
  const PengamatanMain({super.key});

  @override
  State<PengamatanMain> createState() => _PengamatanMainState();
}

class _PengamatanMainState extends State<PengamatanMain> {
  final dbHelper = PengamatanHelper.instance;
  final GlobalKey<FormState> _dataPengamatanKey = GlobalKey<FormState>();
  final GetIt getIt = GetIt.instance;
  late final Notifikasi notifikasi;


  final SelectedLahanController _selectedLahanNotifier = Get.find<SelectedLahanController>();
  final TahapanController controller = Get.find<TahapanController>();
  final PengamatanController pengamatanController = Get.find<PengamatanController>();

  List<PengamatanLokal> pengamatanList = [];

  Lahan? get _lahan => _selectedLahanNotifier.lahanTerpilih;
  String? documentId;
  bool _isInitiateLoading = true;

  final TextEditingController namaPengamatan = TextEditingController();
  int angka = 1;

  String _formatTanggal(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  @override
  void initState() {
    super.initState();
    notifikasi = getIt.get<Notifikasi>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadDataLahan();
      if (_lahan != null) {
        await _loadDataAwal();
      }
      if (mounted) {
        setState(() {
          _isInitiateLoading = false;
        });
      }
    });
  }

  // AMBIL DATA LAHAN (INISIALISASI)

  Future<void> _loadDataLahan() async {
    // await dbHelper.deleteDatabaseForTesting();
    if (_selectedLahanNotifier.lahanTerpilih == null) {
      if (mounted) {
        notifikasi.notif(text: 'Tidak Ada Lahan.', subTitle: 'Anda belum memilih lahan, silahkan pilih lahan terlebih dahulu.');
      } return;
    }

    documentId = _selectedLahanNotifier.idLahanTerpilih;
  }

  // INISIALISASI DATA (INISIALISASI)

  Future<void> _loadDataAwal() async {
    if (_lahan == null) return;

    try {
      final dataPengamatan = await dbHelper.getPengamatanByLahanId(_lahan!.id);
      List<int> listId = [];

      if (dataPengamatan.isNotEmpty) {
        listId = dataPengamatan
            .map((e) => e.id)
            .whereType<int>()
            .toList();
        
        // Load all tahapan data at once
        await controller.loadSemuaTahapan(listId);
        
        // Pre-load pengamatan data for each pengamatan
        for (var pengamatan in dataPengamatan) {
          if (pengamatan.id != null) {
            final localData = await dbHelper.getPengamatanbyId(pengamatan.id!);
            if (localData != null) {
              pengamatanController.namaOPT.value = localData.namaOPT ?? '';
              pengamatanController.jumlahKotak.value = localData.jumlahKotak;
              pengamatanController.namaMetodePengamatan.value = localData.metodePengamatan;
            }
          }
        }
      }
      
      if (mounted) {
        setState(() {
          pengamatanList = dataPengamatan;
          angka = dataPengamatan.length + 1;
        });
      }
    } catch (e) {
      if (mounted) {
         notifikasi.notif(text: 'Gagal memuat data awal.', icon: Icons.error);
      }
      throw Exception('Error load data awal: $e');
    }
  }


  // ADD DATA (FUNGSI)

  // Future<void> _tambahPengamatan() async {
  //   if (_dataPengamatanKey.currentState!.validate()) {
  //     final pengamatanBaru = 
  //     PengamatanLokal(
  //       lahanId: _lahan!.id,
  //       judul: namaPengamatan.text,
  //       docId: documentId,
  //       tanggal: DateTime.now(),
  //     );

  //   final id = await dbHelper.tambahPengamatan(pengamatanBaru);
  //   await controller.tambahTahapanDefault(id);

  //   if(mounted) {
  //     Navigator.of(context).pop();
  //   } else {
  //     return;
  //   }
  //   _loadDataAwal();
  //   namaPengamatan.clear();
  //   }
  //   _loadDataAwal();
  // }
  Future<void> _tambahPengamatan() async {
  if (_dataPengamatanKey.currentState!.validate()) {

    final pengamatanBaruSebelumSimpan = PengamatanLokal(
      lahanId: _lahan!.id,
      judul: namaPengamatan.text,
      docId: documentId,
      tanggal: DateTime.now(),
    );

    try {
      final idBaru = await dbHelper.tambahPengamatan(pengamatanBaruSebelumSimpan);
      final pengamatanTersimpan = pengamatanBaruSebelumSimpan.copyWith(id: idBaru);

      await controller.tambahTahapanDefault(idBaru);

      if (mounted) {
        setState(() {
          pengamatanList.add(pengamatanTersimpan);
          angka = pengamatanList.length + 1;
        });
        Navigator.of(context).pop();
        namaPengamatan.clear();
        notifikasi.notif(text: 'Berhasil!', subTitle: 'Daftar pengamatan berhasil ditambahkan.', icon: Icons.check_circle, warna: primer1);
      }
    } catch (e) {
      if(mounted) {
        notifikasi.notif(text: 'Gagal!', subTitle: 'Penambahan data pengamatan gagal, silahkan coba lagi.', icon: Icons.error, warna: salahInd);
      }
      throw Exception("Error tambah pengamatan: $e");
    }
  }
}

  // ADD DATA (VISUALISASI)

  void _uiTambahPengamatan() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) { 
        return Padding(
          padding: paddingLR20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              j20,
              Text('Tambah Daftar Pengamatan', style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3)),
              j20,
              Form(
                key: _dataPengamatanKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: namaPengamatan,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silahkan diisi';
                        } return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Contoh: Pengamatan 1',
                        labelText: 'Nama Pengamatan',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                        )              
                      ),
                    ), j10,
                    ElevatedButton.icon(
                      onPressed: _tambahPengamatan,
                      icon: Icon(Icons.add),
                      label: Text('Tambah Pengamatan')
                    )
                  ],
                )
              )
            ],
          ),
        );
      }
    );
  }

  // EDIT DATA (FUNGSI)

  void _tampilkanFormEdit(PengamatanLokal pengamatan) {
    final editController = TextEditingController(text: pengamatan.judul);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Pengamatan'),
        content: TextFormField(
          controller: editController,
          decoration: InputDecoration(labelText: 'Judul Baru'),
        ),
        actions: [
          TextButton(
            child: Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Simpan'),
            onPressed: () async {
              final judulBaru = editController.text.trim();
              if (judulBaru.isNotEmpty) {
                final pengamatanUpdate = pengamatan.copyWith(
                  judul: judulBaru
                );
                try {
                  await dbHelper.updatePengamatan(pengamatanUpdate);
                  if (mounted) {
                    setState(() {
                      final index = pengamatanList.indexWhere((p) => p.id == pengamatanUpdate.id);
                      if (index != -1) {
                        pengamatanList[index] = pengamatanUpdate;
                      }
                    });
                    Get.back();
                    notifikasi.notif(text: 'Berhasil!', subTitle: 'Data berhasil diperbaharui.', icon: Icons.check_circle, warna: primer1);
                  }
                } catch (e) {
                  if(mounted) {
                    notifikasi.notif(text: 'Gagal memperbarui data.', icon: Icons.error);
                  }
                  throw Exception("Error update pengamatan: $e");
                }
              }
            },
          ),
        ],
      ),
    );
  }

  // DELETE DATA (FUNGSI & VISUALISASI)

  void _konfirmasiHapus(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Data'),
        content: Text('Apakah kamu yakin ingin menghapus data ini?'),
        actions: [
          TextButton(child: Text('Batal'), onPressed: () => pop()),
          TextButton(
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              try {
                await dbHelper.deletePengamatan(id);
                await dbHelper.deleteStatusPetakUntukPengamatan(id);
                await controller.hapusSemuaTahapanPengamatan(id);
                await pengamatanController.deleteDataPengamatanSpesifik(id);

                if (mounted) {
                  setState(() {
                    pengamatanList.removeWhere((p) => p.id == id);
                    angka = pengamatanList.length + 1;
                  });
                  Get.back();
                  notifikasi.notif(text: 'Berhasil!', subTitle: 'Data berhasil dihapus dari database.', icon: Icons.check_circle, warna: primer1);
                }
              } catch (e) {
                if(mounted) {
                  Get.back();
                  notifikasi.notif(text: 'Gagal menghapus data.', icon: Icons.error);
                }
                throw Exception("Error hapus pengamatan: $e");
              }
            },
          ),
        ],
      ),
    );
  }

  
  void pop() {
    if (!mounted) return;
    Navigator.pop(context);
  }

  // INDIKASI (VISUALISASI)


  // INDIKASI (FUNGSI)
  @override
  Widget build(BuildContext context) {
    if (_lahan == null && !_isInitiateLoading) {
      return Scaffold(
        body: Center(child: Text('Tidak ada lahan yang terpilih, silahkan kembali.'))
      );
    }

    if (_isInitiateLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator())
      );
    }

    if (pengamatanList.isEmpty) {
      return Scaffold(
        body: Padding(
          padding: paddingLR20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Daftar Pengamatan Kosong, silahkan tambahkan daftar di bawah.',
                style: BanaTemaTeks.temaCerah.displayMedium!.copyWith(color: primer3),
                textAlign: TextAlign.center,
              ),
              ElevatedButton.icon(
                onPressed: _uiTambahPengamatan,
                label: Text('Tambahkan Pengamatan'),
                icon: Icon(Icons.add)
              )
            ],
          )
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pengamatan'),
        titleTextStyle: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3),
      ),
      body: RefreshIndicator(
        onRefresh: _loadDataAwal,
        child: ListView.builder(
          itemCount: pengamatanList.length,
          itemBuilder: (context, index) {
            final pengamatan = pengamatanList[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: controller.semuaTahapSelesai(pengamatan.id!) ? primer1 : aksenOranye, width: 3)
                ),
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Iki Judul Pengamatan
                    ListTile(
                      title: Text(pengamatan.judul!, style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3)),
                      subtitle: Text(_formatTanggal(pengamatan.tanggal!)),
                      trailing: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: primer3,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                _tampilkanFormEdit(pengamatan);
                                _loadDataAwal();
                              },
                              icon: Icon(Icons.edit, color: warnaCerah1, )
                            ),
                            IconButton(
                              onPressed: () {
                                _konfirmasiHapus(context, pengamatan.id!);
                                _loadDataAwal();
                              },
                              icon: Icon(Icons.delete, color: salahInd)
                            ),
                          ],
                        ),
                      ),
                    ),
                    /// TAHAPAN DALAM TAMBAH DATA
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: sekunder1, width: 3)),                      
                      ),
                      child: Padding(
                        padding: paddingLR20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TAHAP 1', style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: sekunder1)), j5,
                              ],
                            ),
                            Obx(() {
                              final pengamatanId = pengamatan.id;
                              if (pengamatanId == null) {
                                return Text('Id Pengamatan Tidak Ditemukan.');
                              }
                                final tahapan = controller.tahapanMap[pengamatan.id];
                                if (tahapan == null) {
                                  return SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator()
                                  );
                                }
                              final tahap1 = tahapan.firstWhereOrNull((t) => t.urutan == 0);
                              final tahap1Selesai = tahap1?.status == "Selesai";
                              return IconButton(
                                onPressed: tahap1Selesai
                                ? () {
                                  notifikasi.notif(text: 'Tahap Selesai 1', subTitle: 'Anda telah menyelesaikan tahap ini.', icon: Icons.close, warna: salahInd);
                                }
                                : () => Get.to(() => TahapSatu(idPengamatan: pengamatan.id!)),
                                icon: Icon(Icons.chevron_right_outlined,),
                              );
                            })
                          ],
                        ),
                      )
                    ), j10,
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: sekunder2, width: 3)),                      
                      ),
                      child: Padding(
                        padding: paddingLR20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TAHAP 2', style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: sekunder2)), j5,
                              ],
                            ),
                            Obx(() {
                              final tahapan = controller.tahapanMap[pengamatan.id];
                              if (tahapan == null) {
                                  return SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator()
                                  );
                                }
                              final tahap1 = tahapan.firstWhereOrNull((t) => t.urutan == 0);
                              final tahap1Selesai = tahap1?.status == "Selesai";
                              final tahap2 = tahapan.firstWhereOrNull((t) => t.urutan == 1);
                              final tahap2Selesai = tahap2?.status == "Selesai";
                              return IconButton(
                                onPressed: tahap1Selesai
                                  ? () {
                                      if (!tahap2Selesai) {
                                        Get.to(() => TahapDua(idPengamatan: pengamatan.id!, judulPengamatan: pengamatan.judul!, pengamatanLokal: pengamatan));
                                      } else {
                                        notifikasi.notif(text: 'Tahap Selesai 2', subTitle: 'Anda telah menyelesaikan tahap ini.', icon: Icons.close, warna: salahInd);
                                      }
                                    } 
                                  : null,
                                icon: Icon(Icons.chevron_right_outlined),
                                color: tahap1Selesai ? null : Colors.grey,
                              );
                            })
                          ],
                        ),
                      )
                    ), j10,
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: sekunder3, width: 3)),                      
                      ),
                      child: Padding(
                        padding: paddingLR20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TAHAP 3', style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: sekunder3)), j5,
                              ],
                            ),
                            Obx(() {
                              final tahapan = controller.tahapanMap[pengamatan.id] ?? [];
                              final tahap1 = tahapan.firstWhereOrNull((t) => t.urutan == 0);
                              final tahap2 = tahapan.firstWhereOrNull((t) => t.urutan == 1);
                              final tahap3 = tahapan.firstWhereOrNull((t) => t.urutan == 2);
                              final tahap1Selesai = tahap1?.status == "Selesai";
                              final tahap2Selesai = tahap2?.status == "Selesai";
                              final tahap3Selesai = tahap3?.status == "Selesai";
                              return IconButton(
                                onPressed: tahap1Selesai && tahap2Selesai
                                  ? () {
                                    if (!tahap3Selesai) {
                                      Get.to(() => TahapKetiga(idPengamatan: pengamatan.id!, judulPengamatan: pengamatan.judul!, pengamatan: pengamatan));
                                    } else {
                                      notifikasi.notif(text: 'Tahap Selesai 3', subTitle: 'Anda telah menyelesaikan tahap ini.', icon: Icons.close, warna: salahInd);
                                    }
                                  }
                                  : null,
                                icon: Icon(Icons.chevron_right_outlined),
                                color: tahap1Selesai ? null : Colors.grey,
                              );
                            })
                          ],
                        ),
                      )
                    ), j10,
                    // INDIKASI
                    Container(
                      margin: paddingLR20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: controller.semuaTahapSelesai(pengamatan.id!)
                          ? primer1
                          : aksenOranye
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: controller.semuaTahapSelesai(pengamatan.id!)
                          ? Row(
                            children: [
                              Icon(Icons.check, color: Colors.white), l10,
                              Text(
                                'Sudah Selesai',
                                style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: Colors.white)
                                ),
                            ],
                          )
                          : Row(
                            children: [
                              Icon(Icons.timelapse_outlined, color: Colors.white), l10,
                              Text(
                                'Belum Selesai',
                                style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: Colors.white)
                              ),
                            ],
                          ),
                      )
                    ), j20,
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uiTambahPengamatan,
        tooltip: 'Tambahkan Pengamatan',
        backgroundColor: primer2,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
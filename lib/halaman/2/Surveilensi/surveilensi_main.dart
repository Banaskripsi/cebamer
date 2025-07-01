import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/controller/surveilensi_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/pengamatan_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/helper/pengamatanlokal_helper.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/model/pengamatan_helper_model.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/services/navigasi.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

class SurveilensiMain extends StatefulWidget {
  const SurveilensiMain({super.key});

  @override
  State<SurveilensiMain> createState() => _SurveilensiMainState();
}

class _SurveilensiMainState extends State<SurveilensiMain> {
  final SelectedLahanController _selectedLahanNotifier = Get.find<SelectedLahanController>();
  final NavigasiService navigasi = Get.find<NavigasiService>();

  final pengamatanController = Get.find<PengamatanController>();
  final surveilensiController = Get.find<SurveilensiController>();
  final pengamatanHelper = PengamatanHelper.instance;
  late Future<List<PengamatanLokal>> _pengamatanFuture;

  String? pilihNamaOPT = 'Semua';
  List<String> _namaOPTList = [];

  @override
  void initState() {
    super.initState();
    _pengamatanFuture = fetchPengamatan();
  }

  Future<List<PengamatanLokal>> fetchPengamatan() async {
    final list = await pengamatanHelper.getPengamatanByLahanId(surveilensiController.lahan!.id);

    final namaOPTSet = <String>{};
    for (var item in list) {
      if (item.namaOPT != null) {
        namaOPTSet.add(item.namaOPT!);
      }
    }
    final listOPT = namaOPTSet.toList();
    listOPT.sort();
    setState(() {
      _namaOPTList = ['Semua', ...listOPT];
    });
    return list;
  }

  Future<void> _refreshPengamatan() async {
    setState(() {
      _pengamatanFuture = fetchPengamatan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lahan = _selectedLahanNotifier.lahanTerpilih;
    if (lahan == null) {
      return Center(child: Text('Data lahan tidak ada, silahkan kembali.'));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Surveilensi Organisme Pengganggu Tumbuhan',
                maxLines: 2,
                style: BanaTemaTeks.temaCerah.titleMedium!.copyWith(color: primer3)
              )
            ],
          )
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: paddingLR20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                j20,
                Text(
                  'Fitur Surveilensi Hama dan Penyakit Tumbuhan',
                  style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3),
                ),
                j10,
                Text(
                  'Anda dapat melakukan pengelolaan data surveilensi dengan menambahkan data pengamatan.',
                ),
                j20,
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/surveilensiPengamatan'),
                  icon: Icon(Remix.search_2_fill),
                  label: Text('Pengamatan',),      
                ), j20,
                divider(context, 'Daftar Surveilensi OPT'),
                DropdownButton<String>(
                  value: pilihNamaOPT,
                  hint: Text('Sort'),
                  items: _namaOPTList.map((opt) {
                    return DropdownMenuItem(
                      value: opt,
                      child: Text(opt),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      pilihNamaOPT = value;
                    });
                  }
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: FutureBuilder(
                    future: _pengamatanFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Terdapat kesalahan, silahkan coba kembali.'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('Belum ada data pengamatan, silahkan tambahkan data pengamatan terlebih dahulu.'));
                      } else {
                        final pengamatanList = snapshot.data!;
                        final filterList = (pilihNamaOPT == null || pilihNamaOPT == 'Semua')
                          ? pengamatanList
                          : pengamatanList.where((t) => t.namaOPT == pilihNamaOPT).toList();
                        return RefreshIndicator(
                          onRefresh: _refreshPengamatan,
                          child: ListView.builder(
                            itemCount: filterList.length,
                            itemBuilder: (context, index) {
                              final pengamatan = filterList[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Container(
                                  color: primer1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child:  pengamatan.dokURL != null && pengamatan.dokURL!.isNotEmpty
                                                ? Image.network(pengamatan.dokURL!, fit: BoxFit.cover, width: 100, height: 70)
                                                : Container(
                                                    width: 100,
                                                    height: 70,
                                                    color: Colors.grey,
                                                    child: Icon(Icons.image_not_supported),
                                                  )
                                            ),j10,
                                            // Text(
                                            //   pengamatan.judul!,
                                            //   style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: Colors.white)
                                            // )
                                          ],
                                        ), l10,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                pengamatan.namaOPT!,
                                                style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(DateFormat.yMMMMd('id_ID').format(pengamatan.tanggal!)), j5,
                                              Text(
                                                pengamatan.judul!,
                                                style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ],
                                          ),
                                        ), l20,
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: warnaPrimer3,
                                              radius: 40,
                                              child: RichText(
                                                text: TextSpan(
                                                  text: pengamatan.severity?.toStringAsFixed(1) ?? '0.0',
                                                  style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: Colors.white),
                                                  children: [
                                                    TextSpan(
                                                      text: ' %',
                                                      style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: Colors.white),
                                                    )
                                                  ]
                                                )
                                              )
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              );
                            },
                          ),
                        );
                      }
                    },
                  )
                )
              ],
            ),
          ),
        )
      );
    }
  }
}
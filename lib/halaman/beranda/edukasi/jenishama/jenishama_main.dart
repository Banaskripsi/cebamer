import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/services/storage.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';

class JenishamaMain extends StatelessWidget {
  const JenishamaMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: paddingLR20,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              j50,
              header(context, judul: 'Beberapa Jenis OPT', deskripsi: 'Berikut merupakan daftar beberapa hama yang dapat menghambat pertumbuhan bawang merah.'),
              j20,
              Text(
                '1. Spodoptera exigua',
                style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3),
              ), j10,
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GambarOPT(fileName: 'ulat.jpg'),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          j5,
                          Text(
                            'Morfologi',
                            style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3),
                          ), j5,
                          Text(
                            'Ulat yang baru menetas berwarna hijau, dan memiliki corak yang menyerupai bulan sabit pada ruas perut keempat dan kesepuluh, dan garis terang di bagian belakang. Pada usia 2 minggu, ulat kurang lebih berukuran 5 cm.',
                            style: BanaTemaTeks.temaCerah.displaySmall!.copyWith(color: primer3),
                          ), j30,
                          j5,
                          Text(
                            'Siklus Hidup',
                            style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3),
                          ), j5,
                          Text(
                            'Spodoptera exigua pada umumnya memiliki siklus hidup sepanjang 30 hingga 60 hari, dengan stadium telur berkisar 2-4 hari, stadium larva instar 6 20-46 hari, dan stadium pupa 8-11 hari.',
                            style: BanaTemaTeks.temaCerah.displaySmall!.copyWith(color: primer3),
                          ), j30,
                          Text(
                            'Gejala Serangan',
                            style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3),
                          ), j5,
                          Text(
                            'Gejala yang disebabkan oleh ulat grayak adalah daun yang hanya tersisa tulang daun atau urat daun, serta epidermis daun atas yang transparan',
                            style: BanaTemaTeks.temaCerah.displaySmall!.copyWith(color: primer3),
                          ), j30,
                          Text(
                            'Pengendalian',
                            style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3),
                          ), j5,
                          Text(
                            'Bacillus thuringiensis merupakan mikroorganisme yang sejak tahun 1950 digunakan sebagai agen pengendali hayati untuk mengendalikan hama ulat grayak.',
                            style: BanaTemaTeks.temaCerah.displaySmall!.copyWith(color: primer3),
                          ), j30,
                          divider(context, 'Sumber Pustaka'), j20,
                          Text('Sumber gambar: John C. French Sr.'), j5,
                          Text('Sumber pustaka: Dr. Ir. Yenny Muliani, M.P. Rafika Ratik Srimurni, S.TP., M.Si. Prof. Dr. Tien Turmuktini, Dra., M.P. 2025. Hama pada Tanaman Sayuran : Ilmu Hama. Sukabumi, Jejak Publisher'), j10,
                        ],
                      ))
                  ],
                ),
              ),
              
            ],
          ),
        )
      )
    );
  }
}

class GambarOPT extends StatefulWidget {
  final String fileName;
  const GambarOPT({super.key, required this.fileName});

  @override
  State<GambarOPT> createState() => _GambarOPTState();
}

class _GambarOPTState extends State<GambarOPT> {

   late Future<String?> _futureUrl;

  @override
  void initState() {
    super.initState();
    _futureUrl = FirebaseStorageService().getDownloadUrlFromOptFolder(widget.fileName);
  }
   @override
    Widget build(BuildContext context) {
      return FutureBuilder<String?>(
        future: _futureUrl,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Gagal memuat gambar'));
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: Image.network(
              snapshot.data!,
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }
}
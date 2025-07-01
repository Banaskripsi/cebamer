import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/bindings/pengamatan_bindings.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/pengamatan_main.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurveilensiPengamatan extends StatelessWidget {
  const SurveilensiPengamatan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: paddingLR20,
        child: ListView(
          children: [
              // H E A D E R
              j20,
              Header(title: 'PENGAMATAN OPT', description: 'Fitur untuk pendokumentasian kegiatan surveilensi dan monitoring lahan.'),
              // I N F O R M A S I
              j30,
              Text('Apa yang harus dilakukan?', style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3)),
              j20,
              info(),
              Divider(),
              // F U N G S I
              j50,
              ElevatedButton(
                onPressed: () => Get.to(() => PengamatanMain(), binding: PengamatanBindings()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tambah Data Pengamatan'),
                    Icon(Icons.add_circle, size: 30)
                  ],
                )
              ),
            ],
        ),
      )
    );
  }

  Widget info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepBox(step: 'TAHAP 1', color: sekunder1, text: 'Pilih jenis data pengamatan. Ini dapat membantu kami mengklasifikasikan data yang akan diinput. Anda dapat memilih jenis Organisme Pengganggu Tumbuhan apa yang akan diamati dan bagaimana pengambilan sampel dilakukan.'),
        j10,
        _StepBox(step: 'TAHAP 2', color: sekunder2, text: 'Pada tahap ini, Anda dapat melakukan pengamatan dan pengambilan sampel. Hasil data yang didapat adalah tingkat keparahan serangan dalam bentuk persentase.'),
        j10,
        _StepBox(step: 'TAHAP 3', color: sekunder3, text: 'Penentuan Titik Cedera Ekonomi dan Ambang Ekonomi. Tahap ini merupakan bagian final dari pengamatan, dimana dibutuhkan data tambahan, seperti biaya pengendalian dan perlakuan lahan, sehingga potensi kerugian dapat dikalkulasikan.')
      ],
    );
  }
}

class _StepBox extends StatelessWidget {
  final String step;
  final Color color;
  final String text;
  const _StepBox({required this.step, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.fromLTRB(12, 12, 15, 12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 5)),
        color: warnaCerah1,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(step, style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: color)),
          SizedBox(height: 4),
          Text(text, textAlign: TextAlign.justify, style: BanaTemaTeks.temaCerah.labelMedium!.copyWith(color: primer3)),
        ],
      ),
    );
  }
}
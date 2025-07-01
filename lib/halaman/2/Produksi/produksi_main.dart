import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';

class ProduksiMain extends StatefulWidget {
  const ProduksiMain({super.key});

  @override
  State<ProduksiMain> createState() => _ProduksiMainState();
}

class _ProduksiMainState extends State<ProduksiMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Produksi dan Panen',
          style: BanaTemaTeks.temaCerah.titleMedium!.copyWith(color: primer3)
        ),
      ),
      body: Padding(
        padding: paddingLR20,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              j30,
              Text(
                'Input Data Produksi',
                style: BanaTemaTeks.temaCerah.titleMedium!.copyWith(color: primer3
                )
              ), j10,
              Text(
                'Fitur untuk mengelola pencatanan panen atau produktivitas lahan Anda.'
              ), j10,
              
            ],
          ),
        ),
      )
    );
  }
}
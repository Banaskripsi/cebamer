import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/model/produk_model.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/produk_add.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/service/produk_service.dart';
import 'package:cebamer/halaman/2/Perlakuan/widget/produk_view.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/services/auth.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class PerlakuanMain extends StatelessWidget {
  const PerlakuanMain({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ProdukService();
    final auth = Get.find<AuthService>();
    final currentUserId = auth.user?.uid;

    if (currentUserId == null || currentUserId.isEmpty) {
      return Center(child: Text('Anda belum login ke akun, silahkan login terlebih dahulu.'));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perlakuan dan Produk',
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
                'Input Data Produk',
                style: BanaTemaTeks.temaCerah.titleMedium!.copyWith(color: primer3
                )
              ), j10,
              Text(
                'Fitur untuk mengelola data produk dan perlakuan lahan. Anda dapat menambahkan data pengelolaan perlakuan lahan beserta produk yang digunakan.'
              ), j10,
              ElevatedButton.icon(
                onPressed: () => tambahDataProduk(context),
                icon: Icon(Icons.add),
                label: Text('Produk')
              ), j20,
              divider(context, 'Daftar Produk'),
              j20,
              StreamBuilder(
                stream: service.fetchDataProdukbyUserId(currentUserId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Terjadi kesalahan saat mengambil daftar produk, silahkan coba kembali.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Anda belum memiliki daftar produk untuk ditampilkan, silahkan tambahkan untuk melihat.'));
                  }
                  final List<ProdukModel> daftarProduk = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: daftarProduk.length,
                    itemBuilder: (context, index) {
                      final produk = daftarProduk[index];
                      return Card(
                        color: primer1,
                        child: ListTile(
                          title: Text(
                            produk.namaProduk,
                            style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3)
                          ),
                          subtitle: Text(
                            '${produk.jenisProduk} (${produk.jenisSubProduk})',
                            style: BanaTemaTeks.temaCerah.displayMedium!.copyWith(color: primer3)
                          ),
                          trailing: IconButton(
                            onPressed: () => Get.to(() => ProdukView(), arguments: produk),
                            icon: Icon(Remix.list_check_2, color: warnaCerah3),
                            style: IconButton.styleFrom(
                              backgroundColor: primer3
                            )
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ]
          )
        )
      )
    );
  }
}
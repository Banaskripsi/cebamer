import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/model/produk_model.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/produk_add.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/service/produk_service.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/services/auth.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';


Future<void> pilihProduk(BuildContext context, void Function(ProdukModel) produkPilih) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20))
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: () => tambahDataProduk(context),
                  label: Text('Tambahkan Data Produk'),
                  icon: Icon(Icons.add)
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close)
                )
              ],
            ), j20,
            Text('Pilih Produk Pengendalian', style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3)), j10,
            divider(context, 'Daftar Produk'),
            j20,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: DaftarProduk(produkPilih: produkPilih)
            )
          ],
        )
      );
    }
  );
}

class DaftarProduk extends StatefulWidget {
  final void Function(ProdukModel produk) produkPilih;
  const DaftarProduk({super.key, required this.produkPilih});

  @override
  State<DaftarProduk> createState() => _DaftarProdukState();
}

class _DaftarProdukState extends State<DaftarProduk> {
  final ProdukService produkService = ProdukService();

  void deleteProduk(ProdukModel produk) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await produkService.deleteProduk(produk);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = GetIt.I<AuthService>();
    final currentUserId = auth.user?.uid;
    if (currentUserId == null || currentUserId.isEmpty) {
      return Center(child: Text('Anda belum login ke akun'));
    } else {
      return StreamBuilder(
        stream: produkService.fetchDataProdukbyUserId(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Terdapat kesalahan dalam pengambilan data.'));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Belum ada daftar produk, silahkan tambahkan terlebih dahulu.'));
          }
          final List<ProdukModel> daftarProduk = snapshot.data!;
          return ListView.builder(
            itemCount: daftarProduk.length,
            itemBuilder: (context, index) {
              final produk = daftarProduk[index];
// USER INTERFACE
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                color: primer1,
                child: ListTile(
                  onTap: () {
                    widget.produkPilih(produk);
                    Navigator.pop(context);
                  },
                  title: Text(produk.namaProduk),
                  subtitle: Text('Efektivitas Pengendalian: ${produk.efektivitasPengendalian}'),
                  trailing: IconButton(
                    onPressed: () => deleteProduk(produk),
                    icon: Icon(Icons.delete, color: Colors.red,)
                  ),
                )
              );
            },
          );
        },
      );
    }
  }
}
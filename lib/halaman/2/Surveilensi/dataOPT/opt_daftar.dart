import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Surveilensi/dataOPT/model/opt_model.dart';
import 'package:cebamer/halaman/2/Surveilensi/dataOPT/opt_add.dart';
import 'package:cebamer/halaman/2/Surveilensi/dataOPT/service/dataopt_service.dart';
import 'package:cebamer/services/auth.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';


Future<JenisOPT?> daftarOPT(BuildContext context) async {
  JenisOPT? result;
  await showModalBottomSheet<JenisOPT>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close)
                ),
                ElevatedButton.icon(
                  onPressed: () => addDataOPT(context),
                  label: Text('Tambahkan Data OPT'),
                  icon: Icon(Icons.add)
                )
              ],
            ),
            j20,
            RichText(
              text: TextSpan(
                text: '•  ',
                style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Daftar ',
                    style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: primer3)
                  ),
                  TextSpan(
                    text: 'Organisme Pengganggu Tumbuhan',
                    style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3)
                  )
                ]
              )
            ),
            j20,
            Row(
              children: [
                Flexible(child: Divider(indent: 0, endIndent: 7,),),
                Text('Pilih OPT'),
                Flexible(child: Divider(indent: 7, endIndent: 0,),)
                ],
              ),
            j10,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: DaftarOPT(
                pilih: (opt) {
                  result = opt;
                  Navigator.pop(context);
                },
              ),
            ),            
          ],
        ),
      );
    },
  );
  return result;
}

class DaftarOPT extends StatelessWidget {
  final void Function(JenisOPT) pilih;
  const DaftarOPT({super.key, required this.pilih});

  @override
  Widget build(BuildContext context) {
    final authService = GetIt.I<AuthService>();
    final String? currentUserId = authService.user?.uid;

    final jenisOPTService = Get.find<JenisOPTService>();

    if (currentUserId == null || currentUserId.isEmpty) {
      return Center(child: Text('Anda belum login ke akun.'));
    } else {
      return StreamBuilder(
        stream: jenisOPTService.getJenisOPTByUserIdStream(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terdapat kesalahan saat pengambilan data.'),);
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data OPT, silahkan tambahkan terlebih dahulu.', style: BanaTemaTeks.temaCerah.displayMedium!.copyWith(color: primer3), textAlign: TextAlign.center,));
          }
          final List<JenisOPT> daftarOPT = snapshot.data!;
          return ListView.builder(
            itemCount: daftarOPT.length,
            itemBuilder: (context, index) {
              final opt = daftarOPT[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                color: primer1,
                child: ListTile(
                  onTap: () {
                    pilih(opt);
                  },
                  titleTextStyle: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: Colors.white),
                  leading: opt.dokURL.isNotEmpty
                    ? SizedBox(
                      height: 80,
                      width: 80,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(                            
                            opt.dokURL,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 40),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: SizedBox(height: 50, width: 50,));
                            },
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                    width: 100,
                    height: 100,
                    child: Icon(Icons.image_not_supported)
                    ),
                  title: Text(opt.namaOPT, style: BanaTemaTeks.temaCerah.titleMedium!.copyWith(color: Colors.white)),
                  subtitle: Text(opt.deskripsi, style: BanaTemaTeks.temaCerah.labelMedium!.copyWith(color: primer3)),
                  trailing: IconButton(
                    onPressed: () => jenisOPTService.deleteJenisOPT(opt),
                    icon: Icon(Icons.delete),
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }
}
import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/services/auth.dart';
import 'package:cebamer/services/navigasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class Pengaturan extends StatefulWidget {
  const Pengaturan({super.key});

  @override
  State<Pengaturan> createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  final GetIt getIt = GetIt.instance;
  final navigasi = Get.find<NavigasiService>();

  late final AuthService auth;

  @override
  void initState() {
    super.initState();
    auth = getIt.get<AuthService>();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: paddingLR20,
        child: ListView(
          children: [
            j50,
            IconButton(
              onPressed: () async {
                final hasil = await auth.logout();
                if (hasil) {
                  Get.offAllNamed('/daftarPage');
                }
              },
              icon: Icon(Icons.logout)
            )
          ]
        ),
      )
    );
  }
}
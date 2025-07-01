import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Manajemen/controller/manajemen_controller.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ManajemenPeta extends StatefulWidget {
  const ManajemenPeta({super.key});

  @override
  State<ManajemenPeta> createState() => _ManajemenPetaState();
}

class _ManajemenPetaState extends State<ManajemenPeta> {
  final controller = Get.find<ManajemenController>();
  final notifikasi = Get.find<Notifikasi>();


  List<LatLng>? titikKoordinat;
  bool? editDataLahan = false;

  Future<void> getKoordinatLahan() async {
    try {
      List<LatLng>? koordinat = await controller.getKoordinatLahan();
      if (koordinat.isNotEmpty) {
        setState(() {
          titikKoordinat = koordinat;
        });
        notifikasi.notif(text: 'Berhasil!', subTitle: 'Data berhasil didapatkan.');
      } else {
        notifikasi.notif(text: 'Gagal', subTitle: 'Gagal dalam mendapatkan data, silahkan coba kembali.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan pada getKoordinatLahan: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getKoordinatLahan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: paddingLR20,
        child: Column(
          children: [
            j50,
            header(context, judul: 'Pengaturan Peta', deskripsi: 'Anda dapat mengubah atau menyesuaikan koordinat peta lahan.'),
            j30,
            divider(context, 'Peta Lahan'), j10,
            if (titikKoordinat == null)
            SizedBox(
              height: 350,
              width: double.maxFinite,
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text('Sedang memuat lahan...')
                ],
              )
            ),
            if (titikKoordinat != null)
            Expanded(
              child: SizedBox(
                height: 700,
                width: double.maxFinite,
                child: GoogleMap(
                  mapType: MapType.satellite,
                  initialCameraPosition: CameraPosition(
                    target: titikKoordinat!.isNotEmpty ? titikKoordinat![0] : LatLng(0, 0),
                    zoom: 15,
                  ),
                  polygons: {
                    Polygon(
                      polygonId: PolygonId('lahan'),
                      points: titikKoordinat!,
                      fillColor: primer1.withValues(alpha: 210, red: 255, blue: 255, green: 81),
                      strokeColor: Colors.green,
                      strokeWidth: 2,
                    ),
                  },
                  markers: titikKoordinat!
                    .asMap()
                    .entries
                    .map((e) => Marker(
                      markerId: MarkerId(e.key.toString()),
                      position: e.value,
                      draggable: true,
                      onDragEnd: (newTitik) {
                        setState(() {
                          titikKoordinat![e.key] = newTitik;
                        });
                      }
                    )).toSet(),
                )
              ),
            ), j30,
            ElevatedButton.icon(
              onPressed: () async {
                if (titikKoordinat != null) {
                  bool hasil = await controller.editKoordinatLahan(titikKoordinat!);
                  if (hasil) {
                    controller.update();
                  } else {
                    
                  }
                }
              },
              label: Text('Simpan Data'),
              icon: Icon(Icons.save)
            ),
            j20,
          ],
        )
      )
    );
  }
}
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/tahap2_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/model/pengamatan_helper_model.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PetaGrid extends StatelessWidget {
  final PengamatanLokal pengamatan;
  final void Function(int index)? onTap;
  const PetaGrid({super.key, this.onTap, required this.pengamatan});
  
  @override
  Widget build(BuildContext context) {
    final tahap2Controller = Get.find<Tahap2Controller>();
    final jumlahGrid = pengamatan.jumlahKotak;

    if (jumlahGrid == null || jumlahGrid <= 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: salahInd),
            SizedBox(height: 16),
            Text(
              'Data konfigurasi pengamatan tidak lengkap',
              style: TextStyle(color: salahInd),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Silahkan lengkapi data di Tahap 1 terlebih dahulu',
              style: TextStyle(color: primer3),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    int jumlahkotak = jumlahGrid * jumlahGrid;
    final indeksAktif = tahap2Controller.generateActiveIndexesForPengamatan(pengamatan);
    
    return Obx(() {
      // This will cause the FutureBuilder to recreate when the trigger changes
      final _ = tahap2Controller.petakUpdateTrigger;
      
      return FutureBuilder<Set<int>>(
        future: tahap2Controller.dbHelper.getIndeksPetakTerisi(pengamatan.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final indeksTerisi = snapshot.data ?? {};
          
          return GridView.builder(
            
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: jumlahGrid,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: jumlahkotak,
            itemBuilder: (context, index) {
              bool aktif = indeksAktif.contains(index);
              bool sudahDiisi = indeksTerisi.contains(index);
              
              return GestureDetector(
                onTap: aktif ? () => onTap?.call(index) : null,
                child: Container(
                  height: 200,
                  width: 200,
                  color: aktif 
                    ? (sudahDiisi ? primer1 : sekunder1)
                    : salahInd,
                  child: Center(
                    child: Text('${index + 1}'),
                  )
                ),
              );
            },
          );
        }
      );
    });
  }
}
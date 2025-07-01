import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/model/pembiayaan_model.dart';
import 'package:intl/intl.dart';

class PieChartPembiayaanOpsional extends StatelessWidget {
  final PembiayaanOpsionalModel model;

  const PieChartPembiayaanOpsional({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final List<PieChartSectionData> sections = [];
    final total = model.biayaOpsional.values.fold<double>(0, (sum, item) {
      if (item is num) return sum + item.toDouble();
      if (item is String) {
        final parsed = double.tryParse(item);
        return sum + (parsed ?? 0);
      }
      return sum;
    });
    if (total == 0) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Tidak ada data untuk ditampilkan',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    int index = 0;
    final colors = [
      Colors.blue[400]!,
      Colors.red[400]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.purple[400]!,
      Colors.teal[400]!,
      Colors.brown[400]!,
      Colors.pink[400]!,
      Colors.indigo[400]!,
      Colors.amber[400]!,
    ];

    model.biayaOpsional.forEach((nama, nilai) {
      double value = 0;
      if (nilai is num) {
        value = nilai.toDouble();
      } else if (nilai is String) {
        value = double.tryParse(nilai) ?? 0;
      }
      
      if (value <= 0) return;

      final percentage = (value / total) * 100;
      sections.add(PieChartSectionData(
        color: colors[index % colors.length],
        value: value,
        title: "${percentage.toStringAsFixed(1)}%",
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold, 
          color: Colors.white
        ),
      ));
      index++;
    });

    if (sections.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Data tidak valid untuk chart',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 50,
              sectionsSpace: 2,
              startDegreeOffset: -90,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: model.biayaOpsional.entries.mapIndexed((i, entry) {
            final value = entry.value;
            double numValue = 0;
            if (value is num) {
              numValue = value.toDouble();
            } else if (value is String) {
              numValue = double.tryParse(value) ?? 0;
            }
            
            if (numValue <= 0) return SizedBox.shrink();
            
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16, 
                  height: 16, 
                  decoration: BoxDecoration(
                    color: colors[i % colors.length],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "${entry.key}: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(numValue)}",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        
        const SizedBox(height: 12),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(total),
              style: BanaTemaTeks.temaCerah.displaySmall!.copyWith(color: aksenMerah, fontWeight: FontWeight.bold)
            ),
          ],
        ),
      ],
    );
  }
}

// Widget baru untuk pie chart yang menampilkan data dari semua document
class PieChartSemuaPembiayaanOpsional extends StatelessWidget {
  final List<PembiayaanOpsionalModel> daftarPembiayaan;

  const PieChartSemuaPembiayaanOpsional({super.key, required this.daftarPembiayaan});

  @override
  Widget build(BuildContext context) {
    // Filter data yang memiliki jumlahBiaya > 0
    final validData = daftarPembiayaan.where((item) => 
      item.jumlahBiayaOpsional != null && item.jumlahBiayaOpsional! > 0
    ).toList();
    
    if (validData.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'Tidak ada data biaya yang valid',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Pastikan data memiliki jumlah biaya yang valid',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    
    // Hitung total
    final total = validData.fold<double>(0, (sum, item) => sum + (item.jumlahBiayaOpsional ?? 0));
    
    // Buat sections untuk pie chart
    final List<PieChartSectionData> sections = [];
    final colors = [
      Colors.blue[400]!,
      Colors.red[400]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.purple[400]!,
      Colors.teal[400]!,
      Colors.brown[400]!,
      Colors.pink[400]!,
      Colors.indigo[400]!,
      Colors.amber[400]!,
    ];
    
    for (int i = 0; i < validData.length; i++) {
      final item = validData[i];
      final value = item.jumlahBiayaOpsional ?? 0;
      final percentage = (value / total) * 100;
      
      sections.add(PieChartSectionData(
        color: colors[i % colors.length],
        value: value,
        title: "${percentage.toStringAsFixed(1)}%",
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold, 
          color: Colors.white
        ),
      ));
    }
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: aksenOranye, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Pengeluaran ',
              style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3, fontStyle: FontStyle.italic,),
              children: [
                TextSpan(
                  text: 'Berkala',
                  style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: aksenOranye, fontStyle: FontStyle.italic,),
                )
              ]
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 50,
                sectionsSpace: 2,
                startDegreeOffset: -90,
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: validData.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final value = item.jumlahBiayaOpsional ?? 0;
              
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16, 
                    height: 16, 
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "${item.namaBiayaOpsional}: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(value)}",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          
          SizedBox(height: 12),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(total),
                style: BanaTemaTeks.temaCerah.displaySmall!.copyWith(color: aksenMerah, fontWeight: FontWeight.bold)
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension MapIndexed<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int i, E e) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}

// Widget untuk pie chart biaya tetap
class PieChartPembiayaanTetap extends StatelessWidget {
  final Pembiayaan model;

  const PieChartPembiayaanTetap({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    // Konversi data string ke Map untuk memudahkan pemrosesan
    final Map<String, String> biayaTetap = {
      'Benih': model.benih,
      'Air/Irigasi': model.biayaAir,
      'Pengendalian': model.biayaPengendalian,
      'Mulsa': model.mulsa,
      'Olah Tanah': model.olahTanah,
      'Pestisida': model.pestisida,
      'Pupuk': model.pupuk,
      'Sewa Lahan': model.sewaLahan,
      'Transportasi': model.transportasi,
      'Upah Harian': model.upahHarian,
      'Biaya Lain': model.biayaLain,
    };

    final List<PieChartSectionData> sections = [];
    final total = biayaTetap.values.fold<double>(0, (sum, item) {
      if (item.isEmpty) return sum;
      final parsed = double.tryParse(item);
      return sum + (parsed ?? 0);
    });

    if (total == 0) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'Tidak ada data biaya tetap',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Pastikan data memiliki nilai biaya yang valid',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    int index = 0;
    final colors = [
      Colors.blue[400]!,
      Colors.red[400]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.purple[400]!,
      Colors.teal[400]!,
      Colors.brown[400]!,
      Colors.pink[400]!,
      Colors.indigo[400]!,
      Colors.amber[400]!,
      Colors.cyan[400]!,
    ];

    biayaTetap.forEach((nama, nilai) {
      if (nilai.isEmpty) return;
      
      final value = double.tryParse(nilai) ?? 0;
      if (value <= 0) return;

      final percentage = (value / total) * 100;
      sections.add(PieChartSectionData(
        color: colors[index % colors.length],
        value: value,
        title: "${percentage.toStringAsFixed(1)}%",
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold, 
          color: Colors.white
        ),
      ));
      index++;
    });

    if (sections.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'Data tidak valid untuk chart',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Pastikan data memiliki nilai biaya yang valid',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: aksenOranye, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Pengeluaran ',
              style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3, fontStyle: FontStyle.italic,),
              children: [
                TextSpan(
                  text: 'Tetap',
                  style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: aksenOranye, fontStyle: FontStyle.italic,),
                )
              ]
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 50,
                sectionsSpace: 2,
                startDegreeOffset: -90,
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: biayaTetap.entries.mapIndexed((i, entry) {
              if (entry.value.isEmpty) return SizedBox.shrink();
              
              final value = double.tryParse(entry.value) ?? 0;
              if (value <= 0) return SizedBox.shrink();
              
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16, 
                    height: 16, 
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "${entry.key}: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(value)}",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          
          SizedBox(height: 12),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(total),
                style: BanaTemaTeks.temaCerah.displaySmall!.copyWith(color: aksenMerah, fontWeight: FontWeight.bold)
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget untuk pie chart yang menampilkan data dari semua document biaya tetap
class PieChartSemuaPembiayaanTetap extends StatelessWidget {
  final List<Pembiayaan> daftarPembiayaan;

  const PieChartSemuaPembiayaanTetap({super.key, required this.daftarPembiayaan});

  @override
  Widget build(BuildContext context) {
    if (daftarPembiayaan.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'Tidak ada data biaya tetap',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Tambahkan data biaya tetap terlebih dahulu',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Ambil data dari document pertama (karena biaya tetap biasanya satu document per periode)
    final data = daftarPembiayaan.first;
    
    // Konversi data string ke Map
    final Map<String, String> biayaTetap = {
      'Benih': data.benih,
      'Air/Irigasi': data.biayaAir,
      'Pengendalian': data.biayaPengendalian,
      'Mulsa': data.mulsa,
      'Olah Tanah': data.olahTanah,
      'Pestisida': data.pestisida,
      'Pupuk': data.pupuk,
      'Sewa Lahan': data.sewaLahan,
      'Transportasi': data.transportasi,
      'Upah Harian': data.upahHarian,
      'Biaya Lain': data.biayaLain,
    };

    // Hitung total
    final total = biayaTetap.values.fold<double>(0, (sum, item) {
      if (item.isEmpty) return sum;
      final parsed = double.tryParse(item);
      return sum + (parsed ?? 0);
    });

    if (total == 0) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'Tidak ada data biaya yang valid',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Pastikan data memiliki nilai biaya yang valid',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Buat sections untuk pie chart
    final List<PieChartSectionData> sections = [];
    final colors = [
      Colors.blue[400]!,
      Colors.red[400]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.purple[400]!,
      Colors.teal[400]!,
      Colors.brown[400]!,
      Colors.pink[400]!,
      Colors.indigo[400]!,
      Colors.amber[400]!,
      Colors.cyan[400]!,
    ];
    
    int index = 0;
    biayaTetap.forEach((nama, nilai) {
      if (nilai.isEmpty) return;
      
      final value = double.tryParse(nilai) ?? 0;
      if (value <= 0) return;
      
      final percentage = (value / total) * 100;
      sections.add(PieChartSectionData(
        color: colors[index % colors.length],
        value: value,
        title: "${percentage.toStringAsFixed(1)}%",
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold, 
          color: Colors.white
        ),
      ));
      index++;
    });
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: aksenMerah, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Pengeluaran ',
              style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3, fontStyle: FontStyle.italic,),
              children: [
                TextSpan(
                  text: 'Tetap',
                  style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: aksenMerah, fontStyle: FontStyle.italic,),
                )
              ]
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 50,
                sectionsSpace: 2,
                startDegreeOffset: -90,
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: biayaTetap.entries.mapIndexed((i, entry) {
              if (entry.value.isEmpty) return SizedBox.shrink();
              
              final value = double.tryParse(entry.value) ?? 0;
              if (value <= 0) return SizedBox.shrink();
              
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16, 
                    height: 16, 
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "${entry.key}: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(value)}",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          
          SizedBox(height: 12),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(total),
                style: BanaTemaTeks.temaCerah.displaySmall!.copyWith(color: aksenMerah, fontWeight: FontWeight.bold)
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/*
CARA PENGGUNAAN WIDGET PIE CHART BIAYA TETAP:

1. Untuk menampilkan pie chart dari satu data pembiayaan tetap:
   PieChartPembiayaanTetap(model: pembiayaanData)

2. Untuk menampilkan pie chart dari daftar pembiayaan tetap:
   PieChartSemuaPembiayaanTetap(daftarPembiayaan: daftarPembiayaan)

CONTOH PENGGUNAAN LENGKAP:

// Import widget
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/widget/chart_opsional_pembiayaan.dart';

// Di dalam widget build dengan GetX controller
Obx(() {
  if (controller.daftarBiaya.isNotEmpty) {
    final data = controller.daftarBiaya.first;
    return Column(
      children: [
        // Pie chart untuk satu data
        PieChartPembiayaanTetap(model: data),
        
        // Atau pie chart untuk daftar data
        PieChartSemuaPembiayaanTetap(daftarPembiayaan: controller.daftarBiaya),
      ],
    );
  } else {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text('Tidak ada data biaya tetap'),
    );
  }
})

// Contoh penggunaan di halaman terpisah
class HalamanPieChartBiayaTetap extends StatelessWidget {
  final PembiayaanController controller = Get.find<PembiayaanController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pie Chart Biaya Tetap')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Obx(() {
          if (controller.daftarBiaya.isEmpty) {
            return Center(
              child: Text('Belum ada data biaya tetap'),
            );
          }
          return PieChartPembiayaanTetap(model: controller.daftarBiaya.first);
        }),
      ),
    );
  }
}

FITUR WIDGET:
- Menampilkan persentase di setiap bagian pie chart
- Legend dengan nama kategori dan nilai biaya
- Format currency Indonesia (Rp)
- Handling untuk data kosong atau tidak valid
- Desain yang konsisten dengan tema aplikasi
- Responsive layout dengan Wrap untuk legend
- Warna yang berbeda untuk setiap kategori biaya
- Total biaya ditampilkan di bagian bawah

KATEGORI BIAYA YANG DITAMPILKAN:
- Benih
- Air/Irigasi
- Pengendalian
- Mulsa
- Olah Tanah
- Pestisida
- Pupuk
- Sewa Lahan
- Transportasi
- Upah Harian
- Biaya Lain
*/
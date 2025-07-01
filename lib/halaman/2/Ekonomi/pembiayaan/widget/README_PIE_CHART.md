# Widget Pie Chart Pembiayaan

File ini berisi widget untuk menampilkan data pembiayaan dalam bentuk pie chart.

## Widget yang Tersedia

### 1. PieChartPembiayaanTetap
Widget untuk menampilkan pie chart dari satu data pembiayaan tetap.

**Parameter:**
- `model`: Model `Pembiayaan` yang berisi data biaya tetap

**Contoh Penggunaan:**
```dart
PieChartPembiayaanTetap(model: pembiayaanData)
```

### 2. PieChartSemuaPembiayaanTetap
Widget untuk menampilkan pie chart dari daftar pembiayaan tetap.

**Parameter:**
- `daftarPembiayaan`: List dari model `Pembiayaan`

**Contoh Penggunaan:**
```dart
PieChartSemuaPembiayaanTetap(daftarPembiayaan: controller.daftarBiaya)
```

### 3. PieChartPembiayaanOpsional
Widget untuk menampilkan pie chart dari satu data pembiayaan opsional.

**Parameter:**
- `model`: Model `PembiayaanOpsionalModel` yang berisi data biaya opsional

**Contoh Penggunaan:**
```dart
PieChartPembiayaanOpsional(model: pembiayaanOpsionalData)
```

### 4. PieChartSemuaPembiayaanOpsional
Widget untuk menampilkan pie chart dari daftar pembiayaan opsional.

**Parameter:**
- `daftarPembiayaan`: List dari model `PembiayaanOpsionalModel`

**Contoh Penggunaan:**
```dart
PieChartSemuaPembiayaanOpsional(daftarPembiayaan: controller.daftarBiayaOpsional)
```

## Fitur Widget

- **Persentase**: Menampilkan persentase di setiap bagian pie chart
- **Legend**: Menampilkan nama kategori dan nilai biaya dengan format currency Indonesia
- **Responsive**: Layout yang responsif dengan Wrap untuk legend
- **Error Handling**: Menangani data kosong atau tidak valid
- **Tema Konsisten**: Desain yang konsisten dengan tema aplikasi
- **Warna Berbeda**: Setiap kategori biaya memiliki warna yang berbeda

## Kategori Biaya Tetap

Widget pie chart biaya tetap menampilkan kategori berikut:
1. Benih
2. Air/Irigasi
3. Pengendalian
4. Mulsa
5. Olah Tanah
6. Pestisida
7. Pupuk
8. Sewa Lahan
9. Transportasi
10. Upah Harian
11. Biaya Lain

## Kategori Biaya Opsional

Widget pie chart biaya opsional menampilkan kategori yang dinamis sesuai dengan data yang diinput oleh pengguna.

## Contoh Implementasi Lengkap

```dart
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/widget/chart_opsional_pembiayaan.dart';

class HalamanPembiayaan extends StatelessWidget {
  final PembiayaanController controller = Get.find<PembiayaanController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pembiayaan')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Obx(() {
          return Column(
            children: [
              // Pie chart biaya tetap
              if (controller.daftarBiaya.isNotEmpty)
                PieChartPembiayaanTetap(model: controller.daftarBiaya.first),
              
              SizedBox(height: 20),
              
              // Pie chart biaya opsional
              if (controller.daftarBiayaOpsional.isNotEmpty)
                PieChartSemuaPembiayaanOpsional(
                  daftarPembiayaan: controller.daftarBiayaOpsional
                ),
            ],
          );
        }),
      ),
    );
  }
}
```

## Dependencies

Widget ini memerlukan package berikut:
- `fl_chart`: Untuk membuat pie chart
- `intl`: Untuk format currency Indonesia

## Catatan

- Widget akan menampilkan pesan "Tidak ada data" jika tidak ada data yang valid
- Data dengan nilai 0 atau kosong tidak akan ditampilkan dalam pie chart
- Format currency menggunakan locale 'id_ID' dengan simbol 'Rp'
- Warna pie chart menggunakan palet warna yang sudah ditentukan 
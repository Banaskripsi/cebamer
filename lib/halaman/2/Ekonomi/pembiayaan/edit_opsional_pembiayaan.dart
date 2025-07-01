import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/controller/pembiayaan_controller.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/model/pembiayaan_model.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/widget/chart_opsional_pembiayaan.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

class EditOpsionalPembiayaan extends StatefulWidget {
  const EditOpsionalPembiayaan({super.key});

  @override
  State<EditOpsionalPembiayaan> createState() => _EditOpsionalPembiayaanState();
}

class _EditOpsionalPembiayaanState extends State<EditOpsionalPembiayaan> {

  late PembiayaanOpsionalModel data;
  PembiayaanOpsionalModel? selectedItem;
  final controller = Get.find<PembiayaanController>();
  
  @override
  void initState() {
    super.initState();
    data = Get.arguments as PembiayaanOpsionalModel;
    // Inisialisasi form dengan data yang diterima
    controller.namaBiayaOpsionalCtrl.text = data.namaBiayaOpsional;
    controller.keteranganBiayaOpsionalCtrl.text = data.keteranganBiayaOpsional;
    controller.tanggalBiayaOpsional.value = data.tanggalBiayaOpsional;
    controller.inisialisasiFormEdit(data.biayaOpsional);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: paddingLR20,
        child: SingleChildScrollView(
          child: Obx(()
            => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                j50,
                header(context, judul: 'Detail Biaya', deskripsi: 'Anda dapat melihat dan memperbarui data pembiayaan.'),
                j20,
                Obx(() {
                final daftar = controller.daftarBiayaOpsional;
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (daftar.isEmpty) {
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
                            'Belum ada data pengeluaran',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tambahkan pengeluaran berkala untuk melihat diagram',
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                // Cari item yang sedang diedit berdasarkan documentId
                selectedItem = daftar.where((item) => item.pembiayaanOpsionalId == data.pembiayaanOpsionalId).firstOrNull;
                
                if (selectedItem == null) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Text(
                        'Data tidak ditemukan',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                  );
                }
                
                // Update form dengan data terbaru dari selectedItem
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (selectedItem != null) {
                    if (controller.namaBiayaOpsionalCtrl.text != selectedItem!.namaBiayaOpsional) {
                      controller.namaBiayaOpsionalCtrl.text = selectedItem!.namaBiayaOpsional;
                    }
                    if (controller.keteranganBiayaOpsionalCtrl.text != selectedItem!.keteranganBiayaOpsional) {
                      controller.keteranganBiayaOpsionalCtrl.text = selectedItem!.keteranganBiayaOpsional;
                    }
                    if (controller.tanggalBiayaOpsional.value != selectedItem!.tanggalBiayaOpsional) {
                      controller.tanggalBiayaOpsional.value = selectedItem!.tanggalBiayaOpsional;
                    }
                  }
                });
                
                // Tampilkan hanya item yang sedang diedit
                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
                      Text(
                        selectedItem!.namaBiayaOpsional,
                        style: BanaTemaTeks.temaCerah.titleMedium!.copyWith(
                          color: primer3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        DateFormat('dd MMM yyyy').format(selectedItem!.tanggalBiayaOpsional),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      if (selectedItem!.keteranganBiayaOpsional.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          selectedItem!.keteranganBiayaOpsional,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                      SizedBox(height: 16),
                      PieChartPembiayaanOpsional(model: selectedItem!),
                    ],
                  ),
                );
              }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.editable.value = !controller.editable.value;
                      },
                      child: controller.editable.value
                      ? Row(
                        children: [
                          Icon(
                            Icons.toggle_off,
                            color: primer3,
                            size: 44,
                            ),
                          l10,
                          Text(
                            'Edit Data (Non-aktif)',
                            style: BanaTemaTeks.temaCerah.bodyMedium!.copyWith(color: primer3, fontStyle: FontStyle.italic),
                          )
                        ],
                      )
                      : Row(
                        children: [
                          Icon(
                            Icons.toggle_on,
                            color: primer1,
                            size: 44,
                            ),
                          l10,
                          Text(
                            'Edit Data (Aktif)',
                            style: BanaTemaTeks.temaCerah.bodyMedium!.copyWith(color: primer3, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !controller.editable.value,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (selectedItem?.pembiayaanOpsionalId != null) {
                            final hasil = await controller.updateDataPembiayaanOpsional(selectedItem!.pembiayaanOpsionalId!);
                            if (hasil) {
                              debugPrint('Berhasil');
                            }
                          } else {
                            debugPrint('DocumentId tidak ditemukan');
                          }
                        },
                        icon: Icon(Remix.save_2_fill),
                        label: Text('Perbarui')
                      )
                    ),
                  ],
                ), j30,
                divider(context, 'Kelompok Biaya'), j20,              
                Formnya(
                  controller: controller.namaBiayaOpsionalCtrl,
                  hintText: 'Nama Kelompok Biaya',
                  labelText: 'Nama Kelompok Biaya',
                  inputType: TextInputType.text,
                  readOnly: controller.editable.value,
                ),j20,
                Formnya(
                  controller: controller.keteranganBiayaOpsionalCtrl,
                  hintText: 'Keterangan Biaya',
                  labelText: 'Keterangan Biaya',
                  inputType: TextInputType.text,
                  readOnly: controller.editable.value,
                ), j20,
                Obx(()
                  => Formnya(
                    controller: TextEditingController(
                      text: DateFormat.yMMMMd('id_ID').format(controller.tanggalBiayaOpsional.value)
                    ),
                    readOnly: true,
                    hintText: 'Tanggal',
                    labelText: 'Tanggal Input',
                    inputType: TextInputType.datetime,
                    fungsi: () async {
                      final tanggal = await showDatePicker(
                        context: context,
                        initialDate: controller.tanggalBiayaOpsional.value,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030)
                      );
                  
                      if (tanggal != null) {
                        controller.tanggalBiayaOpsional.value = tanggal;
                      }
                    },
                  ),
                ), j40,
                divider(context, 'Daftar Biaya Opsional'), j20,
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(3)
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'No.',
                            style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer1)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Nama Biaya',
                            style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer1)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Jumlah Biaya',
                            style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer1)
                          ),
                        ),
                      ],
                    ),
                    ...listbiaya(),
                  ],
                ), j10,
                Visibility(
                  visible: !controller.editable.value,
                  child: ElevatedButton.icon(
                    onPressed: controller.tambahFieldBiayaLainnya,
                    icon: Icon(Remix.folder_add_fill),
                    label: Text('Tambahkan Data Baru')
                  )
                ),
                j30,
              ]
            ),
          ),
        ),
      )
    );
  }

  List<TableRow> listbiaya() {
    return List.generate(controller.biayaFieldCount.value, (index) {
      return TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: primer1,
              child: Text(
                '${index + 1}',
                style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: primer3)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller.biayaNamaCtrl[index],
              readOnly: controller.editable.value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller.biayaNilaiCtrl[index],
              readOnly: controller.editable.value,
            ),
          )
        ],
      );
    });
  }
}
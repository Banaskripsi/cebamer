import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/controller/produk_controller.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/model/produk_model.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

class ProdukView extends StatefulWidget {
  const ProdukView({super.key});

  @override
  State<ProdukView> createState() => _ProdukViewState();
}

class _ProdukViewState extends State<ProdukView> {
  final controller = Get.find<ProdukController>();

  late ProdukModel data;
  ProdukModel? item;

  @override
  void initState() {
    super.initState();
    data = Get.arguments as ProdukModel;
    controller.namaProdukController.text = data.namaProduk;
    controller.efektivitasPengendalianController.text = data.efektivitasPengendalian.toString();
    controller.volumeProdukController.text = data.volumeProduk.toString();
    controller.biayaProdukController.text = NumberFormat.decimalPattern('id_Id').format(data.biayaProduk);
    controller.tanggalExpController.text = DateFormat.yMMMMd().format(data.tanggalExp ?? DateTime.now());
    controller.tanggalKadaluwarsa.value = data.tanggalExp ?? DateTime.now();
    controller.namaManufakturProdukController.text = data.namaManufakturProduk;
    controller.registrasiProdukController.text = data.registrasiProduk.toString();
    controller.jenisProdukan.value = data.jenisProduk;
    controller.jenisSubProdukan.value = data.jenisSubProduk;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: paddingLR20,
        child: SingleChildScrollView(
          child: Obx(() {
            if (controller.daftarProduk.isEmpty) {
              return Center(child: Text('Belum ada data yang telah ditambahkan.'));
            }
            return Column(
                children: [
                  j50,
                  header(context, judul: 'Detail Produk', deskripsi: 'Anda dapat melihat detail produk disini.'),
                  j20,
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
                        child: ElevatedButton.icon(
                          onPressed: () {
                            controller.updateDataProduk(data.id!);
                          },
                          icon: Icon(Remix.save_2_fill),
                          label: Text('Perbarui')
                        ),
                      )
                    ],
                  ), 
                  j30,
                  Formnya(
                    controller: controller.namaProdukController,
                    hintText: 'Nama Produk',
                    labelText: 'Nama Produk',
                    inputType: TextInputType.text,
                    readOnly: controller.editable.value,
                  ), j10,
                  Formnya(
                    controller: controller.efektivitasPengendalianController,
                    hintText: 'Efektivitas Pengendalian',
                    labelText: 'Efektivitas Pengendalian',
                    inputType: TextInputType.text,
                    readOnly: controller.editable.value,
                    prefixText: '% ',
                  ), j10,
                  Formnya(
                    controller: controller.biayaProdukController,
                    hintText: 'Biaya Produk',
                    labelText: 'Biaya Produk',
                    inputType: TextInputType.number,
                    readOnly: controller.editable.value,
                    prefixText: 'Rp. ',
                  ), j10,
                  Formnya(
                    controller: controller.volumeProdukController,
                    hintText: 'Volume Produk',
                    labelText: 'Volume Produk',
                    inputType: TextInputType.number,
                    readOnly: controller.editable.value,
                  ), j10,
                  Formnya(
                    controller: controller.namaManufakturProdukController,
                    hintText: 'Nama Manufaktur Produk',
                    labelText: 'Manufaktur',
                    inputType: TextInputType.text,
                    readOnly: controller.editable.value,
                  ), j10,
                  Formnya(
                    controller: controller.registrasiProdukController,
                    hintText: 'Nomor Registrasi Produk',
                    inputType: TextInputType.text,
                    readOnly: controller.editable.value,
                  ), j10,
                  Obx(()
                  => Formnya(
                      icon: Remix.calendar_2_fill,
                      fungsi: () async {
                        final tanggal = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2040),
                          initialDate: DateTime.now()
                        );
                        if (tanggal != null) {
                          controller.tanggalKadaluwarsa.value = tanggal;
                        }
                      },
                      controller: TextEditingController(
                        text: DateFormat.yMMMMd().format(controller.tanggalKadaluwarsa.value)
                      ),
                      hintText: 'Tanggal Kadaluwarsa Produk',
                      inputType: TextInputType.text,
                      readOnly: true,
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: salahInd,
        onPressed: () {
          DialogGlobal().tampilkan(
            title: 'Konfirmasi Hapus',
            message: 'Apakah Anda yakin ingin menghapus data produk ini? Tekan OK jika ingin menghapus',
            onConfirm: () {
              controller.deleteDataProduk(data);
              Get.back();
            },
            cancelText: 'Batal',
            onCancel: () => Get.back,
          );
        },
        child: Icon(Icons.delete, color: warnaCerah3),
      ),
    );
  }
}
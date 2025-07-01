import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Surveilensi/dataOPT/controller/opt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

Future<void> addDataOPT(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (b) {
      return GetBuilder<OptController>(
        builder: (controller) {
          return AlertDialog(
            title: Text('Tambah Data OPT'),
            content: OPTTambah(),
          );
        },
      );
    }
  );
}

class OPTTambah extends GetView<OptController> {
  const OPTTambah({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: controller.optKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.namaOptController,
                decoration: const InputDecoration(labelText: 'Nama OPT'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama OPT tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi OPT'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    value = '';
                  }
                  return null;
                },
              ),
              j20,
              controller.selectedImageFile == null
                  ? const Text('Belum ada gambar dipilih.')
                  : Container(
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: Image.file(controller.selectedImageFile!, fit: BoxFit.contain),
                    ),
              j10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.photo_library),
                    label: Text('Galeri'),
                    onPressed: controller.isLoading.value ? null : () => controller.pickImage(ImageSource.gallery),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text('Kamera'),
                    onPressed: controller.isLoading.value ? null : () => controller.pickImage(ImageSource.camera),
                  ),
                ],
              ),
              j20,
              Obx(() {
                return controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                  onPressed: controller.uploadAndSave,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40)
                  ),
                  child: Text('Unggah dan Simpan'),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
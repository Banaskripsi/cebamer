import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/controller/produk_controller.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/model/produk_model.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/service/produk_service.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/services/auth.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

Future<void> tambahDataProduk(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    top: 35,
                    left: 1,
                    child: SingleChildScrollView(
                      child: UpTambahDataProduk(),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, size: 30)
                    )
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class UpTambahDataProduk extends StatefulWidget {
  const UpTambahDataProduk({super.key});

  @override
  State<UpTambahDataProduk> createState() => _UpTambahDataProdukState();
}

class _UpTambahDataProdukState extends State<UpTambahDataProduk> {

  final controller = Get.put(ProdukController());

  final _produkKey = GlobalKey<FormState>();
  final _namaProdukController = TextEditingController();
  final _efektivitasPengendalianController = TextEditingController();
  final _volumeProdukController = TextEditingController();
  final _biayaProdukController = TextEditingController();
  final _tanggalExpController = TextEditingController();
  final _namaManufakturProdukController = TextEditingController();
  final _registrasiProdukController = TextEditingController();

  final ProdukService _produkService = ProdukService();
  final GetIt getIt = GetIt.instance;
  late final AuthService _auth;
  late final Notifikasi _notifikasi;

  String? _selectedJenisProduk;
  String? _selectedSubJenisProduk;
  DateTime? _tanggalExp;

  List<String> _subJenisItems = [];
  final List<String> _satuanBerat = [
    'g',
    'Kg',
    'l'
  ];
  String? _selectedBerat;

  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? pilih = await showDatePicker(
      context: context,
      initialDate: _tanggalExp ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      locale: Locale('id', 'ID')
    );

    if (pilih != null) {
      setState(() {
        _tanggalExp = pilih;
        _tanggalExpController.text = DateFormat.yMMMMd('id_ID').format(pilih);
      });
    }
  }

  void _updateSubJenis(String? n) {
    setState(() {
      _subJenisItems = controller.currentSubJenis(n);
      if (_subJenisItems.isNotEmpty) {
        if (!_subJenisItems.contains(_selectedSubJenisProduk)) {
          _selectedSubJenisProduk = _subJenisItems.first;
        }
      } else {
        _selectedSubJenisProduk = null;
      }
    });
  }

  Future<void> _uploadDataProduk() async {
    final navigator = Navigator.of(context);

    if (!_produkKey.currentState!.validate()) {
      _notifikasi.notif(text: 'Harap isi semua field yang wajib diisi.', icon: Icons.error_outline);
      return;
    }

    // Pastikan jenis dan subjenis produk terpilih (jika subjenis ada)
    if (_selectedJenisProduk == null) {
       _notifikasi.notif(text: 'Jenis produk harus dipilih.', icon: Icons.error_outline);
      return;
    }
    if (_subJenisItems.isNotEmpty && _selectedSubJenisProduk == null) {
       _notifikasi.notif(text: 'Sub jenis produk harus dipilih.', icon: Icons.error_outline);
      return;
    }


    try {
      final String namaProduk = _namaProdukController.text;
      final double efektivitas = double.tryParse(_efektivitasPengendalianController.text) ?? 0.0;
      final double volume = double.tryParse(_volumeProdukController.text) ?? 0.0;
      final double biaya = double.tryParse(_biayaProdukController.text) ?? 0.0;

      String namaManufaktur = "";
      double registrasi = 0.0;
      DateTime? tanggalKadaluwarsa;

      if (controller.showOptionalForm.value) {
        namaManufaktur = _namaManufakturProdukController.text;
        registrasi = double.tryParse(_registrasiProdukController.text) ?? 0.0;
        tanggalKadaluwarsa = _tanggalExp;
      }

      ProdukModel produk = ProdukModel(
        userId: _auth.user!.uid,
        namaProduk: namaProduk,
        jenisProduk: _selectedJenisProduk!,
        jenisSubProduk: _selectedSubJenisProduk ?? "",
        efektivitasPengendalian: efektivitas,
        volumeProduk: volume,
        namaManufakturProduk: namaManufaktur,
        biayaProduk: biaya,
        registrasiProduk: registrasi,
        tanggalExp: tanggalKadaluwarsa,
      );

      await _produkService.tambahProduk(produk);
      _notifikasi.notif(text: 'Data Produk Berhasil Diunggah!', icon: Icons.check);
      if (navigator.canPop()) {
        navigator.pop(true);
      }
    } catch (e) {      
      _notifikasi.notif(text: 'Gagal mengunggah data: ${e.toString()}', icon: Icons.error,);
      throw Exception('Error mengunggah data produk: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (!GetIt.I.isRegistered<AuthService>()) {
      GetIt.I.registerSingleton<AuthService>(AuthService());
    }
    if (!GetIt.I.isRegistered<Notifikasi>()) {
      GetIt.I.registerSingleton<Notifikasi>(Notifikasi()); // Dummy notif
    }

    _auth = getIt.get<AuthService>();
    _notifikasi = getIt.get<Notifikasi>();

    if (controller.jenisProduk.isNotEmpty) {
      _selectedJenisProduk = controller.jenisProduk.first;
      _updateSubJenis(_selectedJenisProduk);
    }
    if (_satuanBerat.isNotEmpty) {
      _selectedBerat = _satuanBerat.first;
    }
  }

  @override
  void dispose() {
    _namaProdukController.dispose();
    _efektivitasPengendalianController.dispose();
    _volumeProdukController.dispose();
    _namaManufakturProdukController.dispose();
    _biayaProdukController.dispose();
    _tanggalExpController.dispose();
    _registrasiProdukController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextInputType textString = TextInputType.text;
    final TextInputType textDouble = TextInputType.numberWithOptions(decimal: true); // Lebih baik untuk double
    
    return SingleChildScrollView(
      child: Obx( 
        () => Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _produkKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(), j10,
                Divider(),
                //Dropdown Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>( 
                        hint: Text('Pilih Jenis Produk'),
                        value: _selectedJenisProduk,
                        items: controller.jenisProduk.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value)
                          );
                        }).toList(),
                        onChanged: (String? n) {
                          if (n != null && n != _selectedJenisProduk) {
                            _selectedJenisProduk = n;
                            _updateSubJenis(n);
                          }
                        },
                        validator: (value) => value == null ? 'Jenis produk wajib dipilih' : null,
                      ),
                    ),
                    l10,
                    if (_selectedJenisProduk != null && _subJenisItems.isNotEmpty)
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          hint: Text('Pilih Sub Jenis'),
                          value: _selectedSubJenisProduk,
                          items: _subJenisItems.map((String value) {
                            return DropdownMenuItem(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (String? n) {
                            if (n != null) {
                              setState(() {
                                _selectedSubJenisProduk = n;
                              });
                            }
                          },
                          validator: (value) => _subJenisItems.isNotEmpty && value == null ? 'Sub jenis wajib dipilih' : null,
                        ),
                      )
                    else if (_selectedJenisProduk != null && _subJenisItems.isEmpty)
                      Expanded(child: Padding(padding: EdgeInsets.all(10), child: Text('Tidak ada sub jenis', style: TextStyle(color: Colors.grey))))
                    else
                      Expanded(child: SizedBox.shrink())
                  ],
                ), j20,
                Formnya(
                  controller: _namaProdukController,
                  inputType: textString,
                  hintText: 'Nama Produk',
                ), j20,
                Formnya(
                  controller: _efektivitasPengendalianController,
                  inputType: textDouble,
                  suffix: Padding(
                    padding: EdgeInsets.all(5),
                    child: IconButton(
                      onPressed: () {
                        DialogGlobal().tampilkan(title: 'Efektivitas Pengendalian', message: 'Jika tidak diisi, akan dianggap 80%. Produk yang telah teregistrasi dan didistribusikan pada umumnya memiliki keterangan mengenai efektivitas pengendalian atau koefisien keamanan dalam bentuk persentase. Silahkan kosongi jika pada produk tidak memberikan keterangan tersebut.');
                      },
                      icon: Icon(Icons.info_rounded),
                    ),
                  ),
                  hintText: 'Efektivitas Pengendalian (%)',
                ), j20,
                Row(
                  children: [
                    Expanded(
                      child: Formnya(
                        controller: _biayaProdukController,
                        inputType: textDouble,
                        hintText: 'Harga Produk (Rp)',
                      ),
                    ), l10,
                    Expanded(
                      child: Formnya(
                        controller: _volumeProdukController,
                        inputType: textDouble,
                        hintText: 'Berat/Volume',
                      ),
                    ),
                    l10,
                    // Dropdown untuk satuan berat
                    DropdownButton<String>(
                      value: _selectedBerat,
                      items: _satuanBerat.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value)
                        );
                      }).toList(),
                      onChanged: (String? nValue) {
                        setState(() {
                          _selectedBerat = nValue;
                        });
                      },
                    ),
                  ],
                ), j20,
                InkWell(
                  onTap: () => controller.showOptionalForm.value = !controller.showOptionalForm.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          controller.showOptionalForm.value ? Icons.toggle_on : Icons.toggle_off,
                          color: controller.showOptionalForm.value ? primer3 : Colors.grey,
                          size: 30,
                        ), l10,
                        Text(controller.showOptionalForm.value ? 'Sembunyikan Data Opsional' : 'Tambahkan Data Opsional')
                      ],
                    ),
                  ),
                ), j20,
                Visibility(
                  visible: controller.showOptionalForm.value,
                  maintainState: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Data Opsional:", style: BanaTemaTeks.temaCerah.titleMedium), j10,
                      Formnya(
                        controller: _namaManufakturProdukController,
                        inputType: textString,
                        hintText: 'Nama Manufaktur Produk',
                        isOptional: true,
                      ), j20,
                      Formnya(
                        controller: _registrasiProdukController,
                        inputType: textDouble,
                        hintText: 'Nomor Registrasi Produk',
                        isOptional: true,
                      ), j20,
                      Formnya(
                        controller: _tanggalExpController,
                        inputType: textString,
                        readOnly: true,
                        fungsi: () => _pilihTanggal(context),
                        hintText: 'Tanggal Kadaluwarsa Produk',
                        isOptional: true,
                      ), j20,
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primer3,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: TextStyle(fontSize: 16)
                  ),
                  onPressed: () => _uploadDataProduk(),
                  icon: Icon(Icons.save),
                  label: Text('Simpan Data Produk')
                ),
                j20,
              ],
            )
          )
        ),
      )
    );
  }

  Widget _header () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tambahkan Data Produk', style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3)), j10,
        Text('Data ini digunakan untuk beberapa fitur aplikasi, seperti catatan perlakuan, surveilensi, dan ekonomi.', style: BanaTemaTeks.temaCerah.displayMedium!.copyWith(color: primer3))
      ],
    );
  }
}
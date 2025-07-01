import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/controller/produk_controller.dart';
import 'package:cebamer/data&fitur/user_profile.dart';
import 'package:cebamer/helper/banahelper.dart';
import 'package:cebamer/helper/validator.dart';
import 'package:cebamer/services/auth.dart';
import 'package:cebamer/services/navigasi.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remixicon/remixicon.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class MasukPage extends StatefulWidget {
  const MasukPage({super.key});

  @override
  State<MasukPage> createState() => _MasukPageState();
}

class _MasukPageState extends State<MasukPage> {
  late AuthService _authService;
  late Notifikasi _notifikasi;

  final GetIt getIt = GetIt.instance;
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  final NavigasiService _navigasi = Get.find<NavigasiService>();

  final emailc = TextEditingController();
  final passwordc = TextEditingController();

  final localStorage = GetStorage();
  String? email, password;

  @override
  void initState() {
    super.initState();
    _authService = getIt.get<AuthService>();
    _notifikasi = getIt.get<Notifikasi>();
  }
  @override
  Widget build(BuildContext context) {
    final controller = DaftarController.instance;
    final dark = Banahelper.modeGelap(context);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _loginKey,
          child: Padding(
            padding: paddingLR20,
            child: ListView(
              children: [
                j50,
                _header(),
                j50,
                Text(
                  'LOGIN',
                  style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3),
                ),
                Text('Untuk tujuan pengelolaan data, Anda harus memiliki akun dan terhubung dengan internet dalam mengakses aplikasi.'), j20,
                Column(
                  children: [
                    TextFormField(
                      onSaved: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      validator: (value) => BanaValidator.validasiEmail(value, email),
                      decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: dark? const BorderSide(color: warnaPrimer1, width: 2) : const BorderSide(color: primer3, width: 2),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: dark? const BorderSide(width: 2, color: warnaPrimer1) : const BorderSide(width: 2, color: primer3)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: dark? const BorderSide(width: 2, color: warnaPrimer1) : const BorderSide(width: 2, color: primer3)
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: dark? const BorderSide(width: 3, color: Colors.red) : const BorderSide(width: 1, color: Colors.red)
                            ),
                            prefixIcon: Icon(Remix.user_fill, color: dark? warnaCerah1 : primer3, size: 27),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: dark? warnaCerah1 : warnaGelap1,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                            )
                          ),
                    ), j20,
                    Obx(
                      () => TextFormField(
                      onSaved: (p2) {
                        setState(() {
                          password = p2;
                        });
                      },
                      validator: (value) => BanaValidator.validasiPassword(value, password),
                      obscureText: controller.sembunyikanPassword.value,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: dark? const BorderSide(color: warnaPrimer1, width: 2) : const BorderSide(color: warnaPrimer2, width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: dark? const BorderSide(width: 2, color: warnaPrimer1) : const BorderSide(width: 2, color: primer3)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: dark? const BorderSide(width: 2, color: warnaPrimer1) : const BorderSide(width: 2, color: primer3)
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: dark? const BorderSide(width: 3, color: Colors.red) : const BorderSide(width: 1, color: Colors.red)
                        ),
                        prefixIcon: Icon(Icons.lock, color: dark? warnaCerah1 : primer3, size: 27),
                        suffixIcon: IconButton(
                          onPressed: () => controller.sembunyikanPassword.value = !controller.sembunyikanPassword.value,
                          icon: controller.sembunyikanPassword.value ? Icon(Remix.eye_line, color: dark? warnaCerah1 : warnaGelap1, size: 25) : Icon(Remix.eye_close_line, color: dark? warnaCerah1 : warnaGelap1),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent
                          ),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: dark? warnaCerah1 : warnaGelap1,
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    )), j20,
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            activeColor: dark? warnaCerah1 : warnaGelap1,
                            value: controller.centang.value,
                            onChanged: (value) => controller.centang.value = !controller.centang.value,
                          )
                        ),
                        Text(
                          'Selalu ingat',
                          style: TextStyle(
                            color: dark? warnaCerah1 : warnaGelap2,
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w500
                          ),
                        )
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent
                      ),
                      child: Text(
                        'Lupa Password?',
                        style: TextStyle(
                          color: dark? warnaCerah1 : warnaGelap2,
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w500
                        )
                      )
                    )
                  ],
                ), j20,
                InkWell(
                  onTap: () async {
                    if (_loginKey.currentState!.validate()) {
                      _loginKey.currentState?.save();
                      bool hasil = await _authService.login(email!, password!);
                      if (hasil) {
                        _notifikasi.notif(text: 'Berhasil Masuk, Selamat Datang!', icon: Icons.check);
                        _navigasi.gantiHalaman('/pageController');
                      } else {
                        _notifikasi.notif(text: 'Gagal untuk masuk akun, silahkan coba kembali', icon: Icons.error);
                      }
                    }
                    if (controller.centang.value) {
                      localStorage.write('Ingat Email', emailc.text.trim());
                      localStorage.write('Ingat Password', passwordc.text.trim());
                    }
                  },
                  child: Container(
                    width: double.maxFinite,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          warnaPrimer1,
                          warnaBiru1
                        ]
                      ),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                          child: Text(
                                'DAFTAR',
                                  style: TextStyle(
                                    letterSpacing: 2,
                                    color: dark? warnaGelap2 : warnaCerah3,
                                    fontFamily: 'Poppins',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                  ),
                ), j20,
                Row(
                  children: [
                    Flexible(child: Divider(color: dark? warnaCerah1 : warnaGelap2, indent: 0, endIndent: 7,),),
                    const Text('Atau login dengan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                    Flexible(child: Divider(color: dark? warnaCerah1 : warnaGelap2, indent: 7, endIndent: 0,),)
                  ],
                    ), j20,
                InkWell(
                  onTap: () async {
                    final terdaftar = await _authService.daftarGoogle();
                      if (terdaftar.user!.uid.isNotEmpty) {
                        await _authService.simpanDataPengguna(
                          UserProfile(
                            uid: _authService.user!.uid,
                            username: _authService.user!.displayName ?? 'User',
                            role: 'pengguna'
                            )
                          );
                          _notifikasi.notif(text: 'Daftar dengan Akun Google Berhasil!', icon: Icons.check);
                          _navigasi.pindahHalaman('/pageController');
                        } else {
                          _notifikasi.notif(text: 'Daftar dengan Google gagal! Silahkan coba kembali', icon: Icons.error);
                        }
                      }, child: Padding(
                          padding: paddingLR20,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: dark? warnaCerah3 : warnaGelap1, width: 2),
                              borderRadius: BorderRadius.circular(20)
                          ), 
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Image(
                                  width: MediaQuery.of(context).size.width * 0.18,
                                  height: MediaQuery.of(context).size.height * 0.08,
                                  image: AssetImage('assets/image/googlelogo.png'),
                            ),
                          ),
                        ),
                      ),
                    ), j20,
                    Center(
                      child: TextButton(
                        onPressed: () {
                          _navigasi.gantiHalaman('/daftarPage');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'Belum punya akun? Silahkan  ',
                            style: TextStyle(
                              color: dark? warnaCerah3 : warnaGelap2,
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w500
                            ),
                            children: [
                              TextSpan(
                                text: 'dengan klik disini',
                                  style: TextStyle(
                                    color: dark? warnaCerah3 : warnaGelap2,
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline
                                  ),
                              )
                            ]
                          ),
                        ),
                      )
                    )
                  ],
                ), 
              ],
            )
          )
        )
      ),
    );
  }

  Widget _header() {
    final dark = Banahelper.modeGelap(context);
    return Padding(
      padding: paddingLR20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/image/logoutama.png'),
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.1,
          ),j10,
          Text(
            'Cerdas Bertani Bawang Merah',
            textAlign: TextAlign.center,
            style: BanaTemaTeks.temaCerah.displayMedium
          ),
          Divider(
            thickness: 1,
          ),                    
        ],
      ),
    );
  }
}
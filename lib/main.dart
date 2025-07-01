import 'package:cebamer/data&fitur/cuaca/cuaca_page.dart';
import 'package:cebamer/data&fitur/kalender/kalender.dart';
import 'package:cebamer/data&fitur/manajemen/lahan_informasi.dart';
import 'package:cebamer/data&fitur/peta/lahan_peta.dart';
import 'package:cebamer/halaman/2/Ekonomi/ekonomi_main.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/bindings/pembiayaan_bindings.dart';
import 'package:cebamer/halaman/2/Manajemen/bindings/manajemen_bindsings.dart';
import 'package:cebamer/halaman/2/Manajemen/manajemen_main.dart';
import 'package:cebamer/halaman/2/Perlakuan/perlakuan_main.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/bindings/produk_bindings.dart';
import 'package:cebamer/halaman/2/Produksi/produksi_main.dart';
import 'package:cebamer/halaman/2/Surveilensi/bindings/surveilensi_bindings.dart';
import 'package:cebamer/halaman/2/Surveilensi/dataOPT/bindings/opt_bindings.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/bindings/pengamatan_bindings.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/pengamatan_main.dart';
import 'package:cebamer/halaman/2/Surveilensi/surveilensi_main.dart';
import 'package:cebamer/halaman/2/Surveilensi/surveilensi_pengamatan.dart';
import 'package:cebamer/halaman/2/features_binding.dart';
import 'package:cebamer/halaman/auth/daftar_page.dart';
import 'package:cebamer/halaman/auth/masuk_page.dart';
import 'package:cebamer/halaman/beranda/beranda.dart';
import 'package:cebamer/halaman/beranda/pengantar.dart';
import 'package:cebamer/routes/barnavigasi.dart';
import 'package:cebamer/routes/barnavigasi_bindings.dart';
import 'package:cebamer/registry.dart';
import 'package:cebamer/services/auth.dart';
import 'package:cebamer/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await setup();
  setupLocator();
  runApp(Cebamer());
}

Future<void> setup() async {
  await setupFirebase();
  untukGetx();
  await daftarService();
}

class Cebamer extends StatefulWidget {
  late final AuthService _authService;
  final GetIt _getIt = GetIt.instance;
  Cebamer({super.key}) {
    _authService = _getIt.get<AuthService>();
  }

  @override
  State<Cebamer> createState() => _CebamerState();
}

class _CebamerState extends State<Cebamer> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  
      locale: const Locale('id', 'ID'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('id', 'ID')
      ],
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: BanaTema.temaCerah,
      darkTheme: BanaTema.temaGelap,
      initialRoute: widget._authService.user != null ? "/pageController" : "/daftarPage",
      getPages: [
        GetPage(
          name: "/pageController",
          page: () => Barnavigasi(),
          bindings: [
            BarnavigasiBinding(),
            FeaturesBinding()
          ]
        ),
        GetPage(
          name: "/daftarPage",
          page: () => DaftarPage(),
        ),
        GetPage(
          name: "/masukPage",
          page: () => MasukPage(),
        ),
        GetPage(
          name: "/beranda",
          page: () => Beranda(),
        ),
        GetPage(name: "/cuacaPage", page: () => const CuacaPage(), /* binding: CuacaBinding(), */),
        GetPage(name: "/pengantar", page: () => const PengantarAplikasi(), /* binding: PengantarBinding(), */),
        GetPage(name: "/kalenderPage", page: () => const KalenderPage(), /* binding: KalenderBinding(), */),
        GetPage(name: "/lahanPeta", page: () => const LahanPeta(), /* binding: LahanPetaBinding(), */),
        GetPage(name: "/lahanInformasi", page: () => const LahanInformasi(), /* binding: LahanInformasiBinding(), */),

        // Fitur-fitur
        GetPage(name: "/surveilensiMain", page: () => const SurveilensiMain(), bindings: [OptBindings(), PengamatanBindings(), SurveilensiBindings()]),
        GetPage(name: "/surveilensiPengamatan", page: () => const SurveilensiPengamatan()),
        GetPage(name: "/pengamatanMain", page: () => const PengamatanMain()),
        
        GetPage(name: "/manajemenMain", page: () => const ManajemenMain(), binding: ManajemenBindsings()),
        GetPage(name: "/perlakuanMain", page: () => const PerlakuanMain(), binding: ProdukBindings()),
        GetPage(name: "/produksiMain", page: () => const ProduksiMain()),
        GetPage(name: "/ekonomiMain", page: () => const EkonomiMain(), binding: PembiayaanBinding()),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/controller/periode_controller.dart';
import 'package:cebamer/firebase_options.dart';
import 'package:cebamer/halaman/2/Surveilensi/dataOPT/service/dataopt_service.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/tahapan_controller.dart';
import 'package:cebamer/routes/barnavigasi_controller.dart';
import 'package:cebamer/services/auth.dart';
import 'package:cebamer/services/database.dart';
import 'package:cebamer/services/profilLahanService/lahan_service.dart';
import 'package:cebamer/services/navigasi.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
}

Future<void> daftarService() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(
    AuthService()
  );
  getIt.registerSingleton<JenisOPTService>(
    JenisOPTService()
  );
  getIt.registerLazySingleton<Notifikasi>(
    () => Notifikasi()
  );
  getIt.registerSingleton<DatabaseService>(
    DatabaseService()
  );
  getIt.registerSingleton<LahanService>(
    LahanService()
  );
}

final GetIt getIt = GetIt.instance;
void setupLocator() {
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
}

void untukGetx() {
  Get.put(SelectedLahanController());
  Get.put(SelectedPeriodeController());
  Get.put(BarnavigasiController());
  Get.put(TahapanController());

  //Fungsionalitas
  Get.put(Notifikasi());
  // Service
  Get.put(AuthService());
  Get.put(LahanService());
  Get.put(StorageUser());
  Get.put(StorageOPT());
  Get.lazyPut<NavigasiService>(() => NavigasiService(), fenix: true);
}
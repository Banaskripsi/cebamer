import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/controller/periode_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/dataOPT/model/opt_model.dart';
import 'package:cebamer/halaman/2/Surveilensi/dataOPT/service/dataopt_service.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/helper/pengamatanlokal_helper.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/model/pengamatan_helper_model.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/service/pengamatan_service.dart';
import 'package:cebamer/model/data_model.dart';
import 'package:get/get.dart';

class SurveilensiController extends GetxController {
  var pengamatanList = <PengamatanLokal>[].obs;
  var jenisOPTList = <JenisOPT>[].obs;

  final pengamatan = PengamatanHelper.instance;
  final pengamatanService = Get.find<PengamatanService>();
  final optService = Get.find<JenisOPTService>();

  final lahanController = Get.find<SelectedLahanController>();
  final periodeController = Get.find<SelectedPeriodeController>();

  Lahan? get lahan => lahanController.lahanTerpilih;
  PlantingPeriod? get periode => periodeController.plantingPeriod;

  Future<void> fetchDataSurveilensi(String userId, String lahanId) async {
    pengamatanList.value = await pengamatan.getPengamatanByLahanId(lahanId);
    jenisOPTList.value = await optService.getJenisOPTByUserIdStream(userId).first;
  }
}
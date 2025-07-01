import 'dart:collection';

import 'package:cebamer/model/data_model.dart';
import 'package:get/get.dart';

class SelectedPeriodeController extends GetxController {
  final RxList<PlantingPeriod> _daftarPeriodeInternal = <PlantingPeriod>[].obs;
  final Rx<PlantingPeriod?> _plantingPeriod = Rx<PlantingPeriod?>(null);

  UnmodifiableListView<PlantingPeriod> get daftarPeriode => UnmodifiableListView(_daftarPeriodeInternal);

  PlantingPeriod? get plantingPeriod => _plantingPeriod.value;
  String? get idPlantingPeriod => _plantingPeriod.value?.id;
  Rx<PlantingPeriod?> get plantingPeriodRx => _plantingPeriod;

  void setPilihPeriode(PlantingPeriod? periode) {
    if (_plantingPeriod.value != periode) {
      _plantingPeriod.value = periode;
      // Tidak perlu notifyListeners()
    }
  }

  void setDaftarPeriode(List<PlantingPeriod> daftarPeriodeBaru, {bool selectFirstAsDefault = true}) {

    final newList = List<PlantingPeriod>.from(daftarPeriodeBaru);
    _daftarPeriodeInternal.assignAll(newList);

    PlantingPeriod? periodeTerpilihBaru;

    if (_plantingPeriod.value != null) {
      periodeTerpilihBaru = _daftarPeriodeInternal.firstWhereOrNull(
        (periodeDiDaftarBaru) => periodeDiDaftarBaru.id == _plantingPeriod.value!.id,
      );
    }

    if (periodeTerpilihBaru == null && selectFirstAsDefault && _daftarPeriodeInternal.isNotEmpty) {
      periodeTerpilihBaru = _daftarPeriodeInternal.first;
    }

    _plantingPeriod.value = periodeTerpilihBaru;

  }

  void clearPilihan() {
    if (_plantingPeriod.value != null) {
      _plantingPeriod.value = null;
    }
  }

  void clearAll() {
    _plantingPeriod.value = null;
    _daftarPeriodeInternal.clear();
  }

}
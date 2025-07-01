import 'dart:collection';

import 'package:cebamer/model/data_model.dart';
import 'package:get/get.dart';

class SelectedLahanController extends GetxController {
  final RxList<Lahan> _daftarLahanInternal = <Lahan>[].obs;
  final Rx<Lahan?> _lahanTerpilih = Rx<Lahan?>(null);

  UnmodifiableListView<Lahan> get daftarLahan => UnmodifiableListView(_daftarLahanInternal);

  Lahan? get lahanTerpilih => _lahanTerpilih.value;
  String? get idLahanTerpilih => _lahanTerpilih.value?.id;
  Rx<Lahan?> get lahanTerpilihRx => _lahanTerpilih;

  void setPilihLahan(Lahan? lahan) {
    
    if (_lahanTerpilih.value != lahan) {
      _lahanTerpilih.value = lahan;
    }
  }

  void setDaftarLahan(List<Lahan> daftar, {bool selectFirstAsDefault = true}) {
    
    final newList = List<Lahan>.from(daftar);
    _daftarLahanInternal.assignAll(newList);

    Lahan? newSelection;
    if (_lahanTerpilih.value != null) {
      newSelection = _daftarLahanInternal.firstWhereOrNull(
        (l) => l.id == _lahanTerpilih.value!.id,
      );
    }

    if (newSelection == null && selectFirstAsDefault && _daftarLahanInternal.isNotEmpty) {
      newSelection = _daftarLahanInternal.first;
    }
    _lahanTerpilih.value = newSelection;
  }

  void clearPilihan() {
    if (_lahanTerpilih.value != null) {
      _lahanTerpilih.value = null;
      
    }
  }

  void clearAll() {
    _lahanTerpilih.value = null;
    _daftarLahanInternal.clear();
    
  }
}
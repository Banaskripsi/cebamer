import 'dart:convert';
import 'package:cebamer/data&fitur/cuaca/cuaca_model.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CuacaService {
  static const baseurl = 'https://api.openweathermap.org/data/2.5/weather';

  final String apiKey;

  CuacaService(this.apiKey);

  Future<Cuaca> getDataCuaca(String namaKota) async {
    try {
      final response = await http
          .get(Uri.parse('$baseurl?q=$namaKota&appid=$apiKey&units=metric&lang=id'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Cuaca.fromJson(jsonData);
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception('Gagal memuat data cuaca: ${errorBody['message'] ?? 'Unknown error'} (Status: ${response.statusCode})');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Gagal memparse response dari API');
      }
      rethrow;
    }
  }

  Future<String?> getNamaKota() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          return null;
        }
      }
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        )
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isEmpty) {
        return null;
      }

      String? kota = placemarks[0].locality;
      if (kota == null || kota.isEmpty) {
        kota = placemarks[0].subAdministrativeArea;
      }
      if (kota == null || kota.isEmpty) {
        kota = placemarks[0].administrativeArea;
      }
      if (kota == null || kota.isEmpty) {
        return null;
      }
      kota = kota.replaceAll(RegExp(r'^(Kabupaten|Kota|Kecamatan)\s+', caseSensitive: false), '');
      return kota;
    } catch (e) {
      return null;
    }
  }
}
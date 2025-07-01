import 'dart:math' show sin, pi;
import 'package:google_maps_flutter/google_maps_flutter.dart';

double hitungLuasLahan(List<LatLng> titik) {
  if (titik.length < 3) {
    return 0.0;
  }

  const double radiusBumi = 6371009.0;
  double area = 0.0;

  for (int i = 0; i < titik.length; i++) {
    LatLng t1 = titik[i];
    LatLng t2 = titik[(i + 1) % titik.length];

    double lat1Rad = t1.latitude * pi / 180.0; 
    double lon1Rad = t1.longitude * pi / 180.0;
    double lat2Rad = t2.latitude * pi / 180.0;
    double lon2Rad = t2.longitude * pi / 180.0;

    area += (lon2Rad - lon1Rad) * (2 + sin(lat1Rad) + sin(lat2Rad));
  }

  area = (area * radiusBumi * radiusBumi / 2.0).abs();
  return area;
}
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';

class BanaTema {
  BanaTema._();

  static ThemeData temaCerah = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Color.fromARGB(255, 245, 245, 245),
    scaffoldBackgroundColor: scaffoldBG1,
    textTheme: BanaTemaTeks.temaCerah,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primer2,
        iconColor: Colors.white,
        foregroundColor: Colors.white,
        textStyle: BanaTemaTeks.temaCerah.displayLarge
      )
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: primer2,
        iconColor: Colors.white,
        foregroundColor: Colors.white,
        textStyle: BanaTemaTeks.temaCerah.displayLarge
      )
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        backgroundColor: primer2,
        foregroundColor: Colors.white,
      )
    ),
    iconTheme: IconThemeData(
      color: primer1,
    )
  );

  static ThemeData temaGelap = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Color.fromARGB(255, 24, 24, 24),
    scaffoldBackgroundColor: Color.fromARGB(255, 24, 24, 24),
    textTheme: BanaTemaTeks.temaCerah
  );
}
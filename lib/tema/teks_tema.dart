import 'package:flutter/material.dart';

class BanaTemaTeks {
  BanaTemaTeks._();

  static TextTheme temaCerah = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 28, fontWeight: FontWeight.bold),
    headlineSmall: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold,),

    titleLarge: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold),
    titleMedium: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),  
    titleSmall: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold),

    bodyLarge: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.normal), 
    bodySmall: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.normal), 

    labelLarge: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold,),
    labelMedium: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w300,),  
    labelSmall: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w300,),

    displayLarge: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700),
    displayMedium: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),
    displaySmall: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w300),
  );

  static TextTheme temaGelap = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    headlineSmall: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),

    titleLarge: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    titleMedium: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),  
    titleSmall: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),

    bodyLarge: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
    bodyMedium: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white), 
    bodySmall: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white), 

    labelLarge: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white),
    labelMedium: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white),  
    labelSmall: const TextStyle().copyWith(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white),
  );
}
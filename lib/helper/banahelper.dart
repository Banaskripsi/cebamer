import 'package:flutter/material.dart';

class Banahelper {
  Banahelper._();
  static bool modeGelap(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
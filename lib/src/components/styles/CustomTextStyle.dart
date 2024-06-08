import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle h1(dynamic context) {
  return GoogleFonts.mavenPro(
    fontSize: 30,
    color: Theme.of(context).primaryColor,
    fontWeight: FontWeight.w600,
  );
}

TextStyle inputPlaceHolder(dynamic context) {
  return GoogleFonts.mavenPro(
    fontSize: 18,
    color: Colors.black38,
    fontWeight: FontWeight.w500,
  );
}

TextStyle body(dynamic context) {
  return GoogleFonts.mavenPro(
    fontSize: 16,
    color: Colors.black54,
    fontWeight: FontWeight.w400,
  );
}

import "package:flutter/material.dart";

const colorList = <Color>[
  Color(0xFF424c6b),
  Color(0xFF007a50),
  Color(0xFF7b4998),
  Color(0xFFdf008e),
  ];

class AppTheme {
  final int selectedColor;

  AppTheme({
    this.selectedColor = 0
  }) : assert( selectedColor >= 0 && selectedColor <= colorList.length-1, 'Selected color must be greater than 0');

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorSchemeSeed: colorList[selectedColor],
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
  );

} 
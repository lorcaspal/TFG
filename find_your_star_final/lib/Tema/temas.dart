import 'package:flutter/material.dart';

enum MisTemasKeys { CLARO, OSCURO }

getMiTema(MisTemasKeys themeKey) {
  switch (themeKey) {
    case MisTemasKeys.CLARO:
      return temaClaro;
    case MisTemasKeys.OSCURO:
      return temaOscuro;
    default:
      return temaClaro;
  }
}

ThemeData temaOscuro = ThemeData(
  primaryColor: Colors.blue,
  buttonColor: Colors.blue,
  brightness: Brightness.dark,
);

ThemeData temaClaro = ThemeData(
    primarySwatch: Colors.deepPurple,
    // accentColor: Colors.deepPurple,
    buttonColor: Colors.deepPurple,
    brightness: Brightness.light,
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold), //H1
      headline2: TextStyle(fontSize: 16.0), //H2
      headline3: TextStyle(fontSize: 14.0), //H3
      headline4: TextStyle(fontSize: 12.0), //H4
      headline5: TextStyle(fontSize: 16.0), //select
      bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ));

import 'package:flutter/material.dart';

enum getFormato { H1, H2, H3, H4, SELECT }

double getPadding() {
  return 15;
}

Text getTexto(context, texto, formato) {
  TextStyle style;

  switch (formato) {
    case getFormato.H1:
      style = Theme.of(context).textTheme.headline1;
      break;

    case getFormato.H2:
      style = Theme.of(context).textTheme.headline2;
      break;

    case getFormato.H3:
      style = Theme.of(context).textTheme.headline3;
      break;

    case getFormato.H4:
      style = Theme.of(context).textTheme.headline4;
      break;

    case getFormato.SELECT:
      style = Theme.of(context).textTheme.headline5;
      break;
  }
  return Text(texto, style: style);
}

TextStyle getStyle(tamanio, Color color, bool negrita) {
  return TextStyle(
      fontSize: tamanio,
      color: color,
      fontWeight: (negrita) ? FontWeight.bold : FontWeight.normal);
}

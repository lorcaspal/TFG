import 'package:find_your_star_final/Camara/vista_camara.dart';
import 'package:find_your_star_final/Comunicacion/vista_comunication.dart';
import 'package:flutter/material.dart';
import 'Busqueda/vista_busqueda.dart';
import 'Opciones/vista_opciones.dart';
import 'Tema/temas.dart';
import 'Home/vista_home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find your Star',
      theme: getMiTema(MisTemasKeys.CLARO),
      home: MyHomePage(title: 'Find your Star'),
      initialRoute: '/',
      routes: {
        '/config': (context) {
          Map argumento = ModalRoute.of(context).settings.arguments;
          return ViewOptions(name: argumento['name']);
        },
        '/busqueda': (context) => ViewBusqueda(),
        '/camara': (context) => ViewCamera(),
        '/comunication': (context) {
          Map argumento = ModalRoute.of(context).settings.arguments;
          return ViewComunication(name: argumento['name']);
        },
      },
    );
  }
}

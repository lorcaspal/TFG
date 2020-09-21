import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'dart:ui';

import 'package:find_your_star_final/Busqueda/controller_busqueda.dart';
import 'package:find_your_star_final/Tema/formatos.dart';
import 'package:flutter/material.dart';
//Variable global para saber si estamos ejecutando la aplicación en web o no (devuelve true o false).
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:loading/indicator/ball_pulse_indicator.dart';
//Libreria para Platform

import 'package:loading/loading.dart';

class ViewBusqueda extends StatefulWidget {
  ViewBusqueda({Key key}) : super(key: key);

  _BusquedaState createState() => _BusquedaState();
}

class _BusquedaState extends State<ViewBusqueda> {
  bool empezar = false;
  TiempoReal socket;
  String tipo;
  bool estadoConexion;
  //Variables de la cámara
  String path;
  File fileImg;
  bool camera = false;
  //Variables entre la API y el cliente
  Uint8List pathSocket;
  String titleImage;
  String message;
  bool load = true;
  String tiempo;
  String uuid;

  //Variables para coger las coodernadas de la API
  String ascencionAPI;
  String declinacionAPI;
  String orientacionAPI;

  //Variables para coger las coodernadas de la estrella que se quiere encontrar

  String ascencion;
  String declinacion;
  String gradosOrient;

  String orient1;
  String orient2;

  @override
  void initState() {
    super.initState();
    estadoConexion = false;
    if (kIsWeb) {
      tipo = 'web';
    } else {
      tipo = 'mobile';
    }
    cargar();
    loadParametrosCoord(
        (ascencion, declinacion, gradosOrient, orient1, orient2) {
      setState(() {
        this.ascencion = ascencion;
        this.declinacion = declinacion;
        this.gradosOrient = gradosOrient;
        this.orient1 = orient1;
        this.orient2 = orient2;
      });
    });
  }

  void cargar() {
    loadIpPort(socket, tipo, (result, socket, conected) {
      this.socket = socket;
      print('conexion: ' + conected.toString());
      print(result);
      if (conected) {
        if (result != null) {
          setState(() {
            empezar = true;
            estadoConexion = conected;
            if (kIsWeb)
              pathSocket = base64Decode(result['image']);
            else
              fileImg = new File.fromRawPath(base64Decode(result['image']));

            titleImage = result['title'];
            message = result['message'];
            load = result['load'];
            tiempo = result['time'];
            if (result['coordenadas'] != null) {
              ascencionAPI = result['coordenadas']['ra'];
              declinacionAPI = result['coordenadas']['dec'];
              orientacionAPI = result['coordenadas']['gradosOri'] +
                  ' grados al ' +
                  result['coordenadas']['ori1'] +
                  ' del ' +
                  result['coordenadas']['ori2'];
            }
          });
        } else {
          setState(() {
            estadoConexion = conected;
          });
        }
      } else {
        setState(() {
          estadoConexion = conected;
        });
      }
    });
  }

  @override
  void dispose() {
    if (socket != null && !camera && !kIsWeb) {
      socket.cerrar();
    }
    if (socket != null && kIsWeb) {
      socket.cerrar();
    }
    // Asegúrate de deshacerte del controlador cuando se deshaga del Widget.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Find your Star'),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.language),
                tooltip: 'Comunicación',
                onPressed: () async {
                  final cambio = await Navigator.pushNamed(
                      context, '/comunication',
                      arguments: {'name': '/busqueda'});
                  if (cambio) {
                    print(this.socket);
                    this.socket.cerrar();
                    this.cargar();
                  }
                }),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Configuración',
              onPressed: () async {
                final cambio = await Navigator.pushNamed(context, '/config',
                    arguments: {'name': '/busqueda'});
                if (cambio == 2) {
                  socket.sendParams(true);
                } else if (cambio == 1) {
                  socket.sendParams(false);
                }
              },
            ),
          ],
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (!empezar)
                ? (!kIsWeb)
                    ? (!estadoConexion)
                        ? Text(
                            "Intentado conectar.... Compruebe IP y Puerto",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.2),
                                fontSize: 20),
                          )
                        : Text(
                            "Haz una foto para encontrar tu estrella",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.2),
                                fontSize: 20),
                          )
                    : (!estadoConexion)
                        ? Text(
                            "Intentado conectar.... Compruebe IP y Puerto",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.2),
                                fontSize: 20),
                          )
                        : Text(
                            "Esperando cambios en galería",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.2),
                                fontSize: 20),
                          )
                : Flexible(
                    fit: FlexFit.tight,
                    child: (!kIsWeb)
                        ? Container(
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: new FileImage(fileImg),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Opacity(
                              opacity: 0.5,
                              child: Card(
                                  elevation: 5,
                                  color: Colors.black,
                                  child: Column(children: <Widget>[
                                    Text(
                                      titleImage,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(child: coordenadasAplicacion()),
                                    (message == null)
                                        ? Expanded(child: coordenadasAPI())
                                        : Expanded(
                                            child: Center(
                                            child: Text(
                                              message,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )),
                                    (load)
                                        ? Loading(
                                            indicator: BallPulseIndicator(),
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 50.0)
                                        : Text("Tiempo esperado: " + tiempo),
                                  ])),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          )
                        : Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 2,
                                    child: Image.memory(
                                      pathSocket,
                                      filterQuality: FilterQuality.high,
                                      fit: BoxFit.fill,
                                      // width: MediaQuery.of(context).size.width,
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: <Widget>[
                                        Text(titleImage),
                                        Expanded(
                                            child: coordenadasAplicacion()),
                                        (message == null)
                                            ? Expanded(child: coordenadasAPI())
                                            : Expanded(
                                                child: Text(
                                                message,
                                                textAlign: TextAlign.center,
                                              )),
                                        (load)
                                            ? Loading(
                                                indicator: BallPulseIndicator(),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 50.0)
                                            : Text(
                                                "Tiempo esperado: " + tiempo),
                                      ],
                                    ))
                              ],
                            ))
                    //width: MediaQuery.of(context).size.width,
                    )
          ],
        )),
        floatingActionButton: (!kIsWeb)
            ? (estadoConexion)
                ? Builder(
                    builder: (context) {
                      var floatingActionButton2 = FloatingActionButton(
                        onPressed: () async {
                          camera = true;
                          final result =
                              await Navigator.pushNamed(context, '/camara');
                          camera = false;
                          if (result != null) {
                            path = result;
                            fileImg = new File(path);
                            var array = path.split('/');
                            socket.sendImage(path);
                            setState(() {
                              titleImage = array[array.length - 1];
                              message =
                                  'Esperando a obtener las coordenadas de la Imagen';
                              load = true;
                              empezar = true;
                            });
                          }
                        },
                        tooltip: 'Tomar/encontrar foto',
                        child: Icon(Icons.camera),
                      );
                      return floatingActionButton2;
                    },
                  )
                : null
            : null);
  }

  Column coordenadasAplicacion() {
    double tamTitulo = 18;
    double tamSubtitulo = 16;
    double tamValor = 14;
    Color colorValor = (kIsWeb) ? Colors.black : Colors.white;
    Color colorSubtitulo = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            "Coordenadas estrella buscada",
            textAlign: TextAlign.center,
            style: getStyle(tamTitulo, colorValor, true),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text("Ascensión Recta",
                          textAlign: TextAlign.center,
                          style:
                              getStyle(tamSubtitulo, colorSubtitulo, false))),
                  Expanded(
                    child: Text("Declinación Recta",
                        textAlign: TextAlign.center,
                        style: getStyle(tamSubtitulo, colorSubtitulo, false)),
                  ),
                ])),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Text(this.ascencion + " (HH:MM:SS) ",
                      textAlign: TextAlign.center,
                      style: getStyle(tamValor, colorValor, false))),
              Expanded(
                  child: Text(this.declinacion + " (GG:MM:SS) ",
                      textAlign: TextAlign.center,
                      style: getStyle(tamValor, colorValor, false))),
            ]),
        Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: Text("Orientación",
                style: getStyle(tamSubtitulo, colorSubtitulo, false))),
        Text(
            this.gradosOrient +
                " grados al " +
                this.orient1 +
                " del " +
                this.orient2,
            style: getStyle(tamValor, colorValor, false))
      ],
    );
  }

  Column coordenadasAPI() {
    int tamTitulo = 18;
    int tamSubtitulo = 16;
    int tamValor = 14;
    Color colorValor = (kIsWeb) ? Colors.black : Colors.white;
    Color colorSubtitulo = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text("Coordenadas imagen",
              textAlign: TextAlign.center,
              style: getStyle(tamTitulo, colorValor, true)),
        ),
        Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text("Ascensión Recta",
                          textAlign: TextAlign.center,
                          style:
                              getStyle(tamSubtitulo, colorSubtitulo, false))),
                  Expanded(
                    child: Text("Declinación Recta",
                        textAlign: TextAlign.center,
                        style: getStyle(tamSubtitulo, colorSubtitulo, false)),
                  ),
                ])),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(ascencionAPI + " (HH:MM:SS) ",
                    textAlign: TextAlign.center,
                    style: getStyle(tamValor, colorValor, false)),
              ),
              Expanded(
                child: Text(declinacionAPI + " (GG:MM:SS) ",
                    textAlign: TextAlign.center,
                    style: getStyle(tamValor, colorValor, false)),
              )
            ]),
        Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: Text("Orientación",
                style: getStyle(tamSubtitulo, colorSubtitulo, false))),
        Text(orientacionAPI, style: getStyle(tamValor, colorValor, false))
      ],
    );
  }
}

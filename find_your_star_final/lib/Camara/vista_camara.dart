import 'package:camera/camera.dart';
import 'package:find_your_star_final/Camara/controller_camara.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class ViewCamera extends StatefulWidget {
  ViewCamera({Key key}) : super(key: key);

  _CameraState createState() => _CameraState();
}

class _CameraState extends State<ViewCamera> {
  // Obtén una lista de las cámaras disponibles en el dispositivo.
  var cameras;
// Obtén una cámara específica de la lista de cámaras disponibles
  var firstCamera;
  // Añade dos variables a la clase de estado para almacenar el CameraController
  // y el Future
  CameraController controller;
  Future<void> initializeControllerFuture;
  bool isCamera = false;
  CameraImage imagen;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    loadCamera(this.cameras, this.firstCamera, this.controller,
            this.initializeControllerFuture)
        .then((value) {
      setState(() {
        firstCamera = value['camara'];
        controller = value['controller'];
        initializeControllerFuture = value['iniciar'];
        isCamera = true;
      });
    });
  }

  @override
  void dispose() {
    // Asegúrate de deshacerte del controlador cuando se deshaga del Widget.
    controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<void>(
          future: initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return CameraPreview(controller);
            } else {
              // Otherwise, display a loading indicator.
              return Center(
                  child: Loading(
                      indicator: BallPulseIndicator(),
                      color: Theme.of(context).primaryColor,
                      size: 50.0));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String path = await hacerFoto(initializeControllerFuture, controller);
          Navigator.pop(context, path);
        },
        tooltip: 'Capturar',
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

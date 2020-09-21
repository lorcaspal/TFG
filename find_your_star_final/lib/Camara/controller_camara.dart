import 'dart:async';

import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

Future<Map> loadCamera(var cameras, var firstCamera,
    CameraController controller, initializeControllerFuture) async {
  // Obtén una lista de las cámaras disponibles en el dispositivo.
  cameras = await availableCameras();

  // Obtén una cámara específica de la lista de cámaras disponibles
  firstCamera = cameras.first;

  controller = CameraController(firstCamera, ResolutionPreset.ultraHigh);

  // A continuación, debes inicializar el controlador. Esto devuelve un Future!
  initializeControllerFuture = controller.initialize();
  Map result = new Map();
  result['camara'] = firstCamera;
  result['controller'] = controller;
  result['iniciar'] = initializeControllerFuture;
  return result;
}

Future<String> hacerFoto(iniciar, CameraController controller) async {
  await iniciar;

  // Construye la ruta donde la imagen debe ser guardada usando
  // el paquete path.
  final path = join(
    // (await getApplicationDocumentsDirectory()).path,
    (await getTemporaryDirectory()).path,
    '${DateTime.now()}.png',
  );

  //Esperamos a que haga una foto y la guardamos en la ruta creada anteriormente
  await controller.takePicture(path);

  return path;
}

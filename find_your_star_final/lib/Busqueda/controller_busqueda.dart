import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TiempoReal {
  IO.Socket _socket;
  SharedPreferences _pref;
  TiempoReal(pref, tipo) {
    _pref = pref;
    var ip = pref.getString('ip');
    String uuid = pref.getString('uuid');
    var puerto = pref.getInt('portSocket').toString();

    _socket = IO.io('http://' + ip + ':' + puerto, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'tipo': tipo, 'uuid': uuid} // optional
    });
    _socket.connect();
  }

  void loadImage(callback) {
    _socket.on('galeria', (image) {
      callback(image);
    });
  }

  void cerrar() {
    if (_socket.connected) {
      _socket.disconnect();
      _socket.dispose();
    }
  }

  void getParams() {
    _socket.on('send_params', (params) {
      savedParams(params);
    });
  }

  void savedParams(Map<String, dynamic> params) {
    _pref.setString('scale', params['scale']);
    _pref.setDouble('max', params['max']);
    _pref.setDouble('min', params['min']);
  }

  void sendParams(bool change) {
    Map<String, dynamic> params = new Map();
    if (change) {
      params['scale'] = _pref.getString('scale');
      if (params['scale'] != null) {
        params['max'] = _pref.getDouble('max');
        params['min'] = _pref.getDouble('min');
        _socket.emit('received_params', params);
      }
    } else {
      _socket.emit('received_params', null);
    }
  }

  void sendImage(String path) {
    File file = new File(path);
    List<int> image = file.readAsBytesSync();
    var split = path.split('/');
    String base64Image = base64Encode(image);
    Map<String, dynamic> result = new Map();
    result['image'] = base64Image;
    result['title'] = split[split.length - 1];

    if (pref.containsKey('scale')) {
      Map<String, dynamic> params = new Map();
      params['scale'] = pref.getString('scale');
      params['max'] = pref.getDouble('max');
      params['min'] = pref.getDouble('min');
      result['params'] = params;
    }
    _socket.emit('received_image', result);
  }

  bool isConnected() {
    return _socket.connected;
  }

  void getConnect(callback) {
    _socket.on('connect', (data) {
      callback(true);
    });
    callback(false);
  }
}

SharedPreferences pref;

void loadIpPort(TiempoReal socket, tipo, callback) async {
  pref = await SharedPreferences.getInstance();

  socket = new TiempoReal(pref, tipo);
  socket.getConnect((ok) {
    if (ok) {
      socket.loadImage((Map<String, dynamic> result) {
        callback(result, socket, true);
      });

      callback(null, socket, true);

      socket.getParams();
      socket.sendParams(true);
    } else {
      callback(null, socket, false);
    }
  });
}

void loadParametrosCoord(callback) async {
  pref = await SharedPreferences.getInstance();
  //Coordenadas aplicación ( metidas manualmente)
  String ascencion = pref.getInt('horas').toString() +
      ":" +
      pref.getInt('min1').toString() +
      ":" +
      pref.getDouble('sec1').toString();

  String declinacion = pref.getDouble('grad1').toString() +
      ":" +
      pref.getInt('min2').toString() +
      ":" +
      pref.getDouble('sec2').toString();

  String gradosOrient = pref.getDouble('grad2').toString();
  String orient1 = pref.getString('orient1');
  String orient2 = pref.getString('orient2');
  callback(ascencion, declinacion, gradosOrient, orient1, orient2);
}

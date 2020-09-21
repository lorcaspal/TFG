import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

var controllerIp;
var controllerPortSocket;

void loadComunication() async {
  controllerIp = TextEditingController();
  controllerPortSocket = TextEditingController();

  SharedPreferences _prefs = await SharedPreferences.getInstance();

  controllerIp.text = _prefs.getString('ip');
  controllerPortSocket.text = _prefs.getInt('portSocket').toString();
}

void guardar() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setString('ip', controllerIp.text);
  _prefs.setInt('portSocket', int.parse(controllerPortSocket.text));
}

void reset() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setString('ip', 'localhost');
  _prefs.setInt('portSocket', 3000);
  _prefs.setInt('portAPI', 8080);
  controllerIp.text = _prefs.getString('ip');
  controllerPortSocket.text = _prefs.getInt('portSocket').toString();
}

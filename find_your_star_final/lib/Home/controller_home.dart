import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final controllerAscension = TextEditingController();
final controllerDeclinacion = TextEditingController();
final controllerHoras = TextEditingController();
final controllerMin1 = TextEditingController();
final controllerSec1 = TextEditingController();
final controllerGrad1 = TextEditingController();
final controllerMin2 = TextEditingController();
final controllerSec2 = TextEditingController();
final controllerGrad2 = TextEditingController();
String upDown = 'Arriba';
String orient1 = 'N';
String orient2 = 'E';
SharedPreferences _prefs;
var uuid = Uuid();

void load() async {
  _prefs = await SharedPreferences.getInstance();

  if (!_prefs.containsKey('ip')) {
    _prefs.setString('ip', 'localhost');
    _prefs.setInt('portSocket', 3000);
    //_prefs.setInt('portAPI', 8080);
  }

  if (!_prefs.containsKey('uuid')) {
    String value = uuid.v4();
    _prefs.setString('uuid', value);
  }
}

void guardar(_formKey, context) {
  // devolverá true si el formulario es válido, o falso si
  // el formulario no es válido.
  if (_formKey.currentState.validate()) {
    //Cambiamos el valor de las variables al tipo que le corresponde
    double ascension = double.parse(controllerAscension.text);
    double declinacion = double.parse(controllerDeclinacion.text);
    int horas = int.parse(controllerHoras.text);
    int min1 = int.parse(controllerMin1.text);
    double sec1 = double.parse(controllerSec1.text);
    double grad1 = double.parse(controllerGrad1.text);
    int min2 = int.parse(controllerMin2.text);
    double sec2 = double.parse(controllerSec2.text);
    double grad2 = double.parse(controllerGrad2.text);

    _prefs.setDouble('ascension', ascension);
    _prefs.setDouble('declinacion', declinacion);
    _prefs.setInt('horas', horas);
    _prefs.setInt('min1', min1);
    _prefs.setDouble('sec1', sec1);
    _prefs.setDouble('grad1', grad1);
    _prefs.setInt('min2', min2);
    _prefs.setDouble('sec2', sec2);
    _prefs.setDouble('grad2', grad2);
    _prefs.setString('upDown', upDown);
    _prefs.setString('orient1', orient1);
    _prefs.setString('orient2', orient2);

    // Si el formulario es válido, queremos mostrar un Snackbar
    //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Guardando')));
    // Si todo está correcto cuando le damos al botón de guardar nos lleva a la siguiente página
    // donde vamos a recoger las imágenes.
    Navigator.pushNamed(context, '/busqueda');
  }
}

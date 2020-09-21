import 'package:find_your_star_final/Opciones/vista_opciones.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

var controllerMin;
var controllerMax;

final elements = [
  "Grados",
  "Arcominutos",
];

int selectedIndex = 0;

List<Widget> buildItems() {
  return elements
      .map((val) => MySelectionItem(
            title: val,
          ))
      .toList();
}

void loadOpciones(callback) async {
  controllerMin = TextEditingController();
  controllerMax = TextEditingController();
  String escala;
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.containsKey('scale')) {
    escala = pref.getString('scale');
    if (escala == "degwidth") {
      selectedIndex = 0;
    } else {
      selectedIndex = 1;
    }
    controllerMin.text = pref.getDouble('min').toString();
    controllerMax.text = pref.getDouble('max').toString();
  }
  callback(selectedIndex);
}

Future<bool> guardar(_formKey) async {
  if (_formKey.currentState.validate()) {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String escala;
    double minimo = double.parse(controllerMin.text);
    double maximo = double.parse(controllerMax.text);

    if (selectedIndex == 0) {
      escala = "degwidth";
      pref.setString('scale', escala);
    } else {
      escala = "arcminwidth";
      pref.setString('scale', escala);
    }

    pref.setDouble('min', minimo);
    pref.setDouble('max', maximo);
    return true;
  } else {
    return false;
  }
}

void reset(callback) async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  pref.remove("scale");
  pref.remove("min");
  pref.remove("max");

  selectedIndex = 0;
  controllerMax.text = "";
  controllerMin.text = "";

  callback(selectedIndex);
}

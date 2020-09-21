import 'package:flutter/material.dart';
import '../Tema/formatos.dart';
import 'controller_home.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final focusDeclinacion = FocusNode();
  final focusHoras = FocusNode();
  final focusMin1 = FocusNode();
  final focusSec1 = FocusNode();
  final focusGrad1 = FocusNode();
  final focusMin2 = FocusNode();
  final focusSec2 = FocusNode();
  final focusSelect1 = FocusNode();
  final focusGrad2 = FocusNode();
  final focusSelect2 = FocusNode();
  final focusSelect3 = FocusNode();

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    controllerAscension.dispose();
    controllerDeclinacion.dispose();
    controllerHoras.dispose();
    controllerMin1.dispose();
    controllerSec1.dispose();
    controllerGrad1.dispose();
    controllerMin2.dispose();
    controllerSec2.dispose();
    controllerGrad2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.language),
                tooltip: 'Comunicación',
                onPressed: () {
                  Navigator.pushNamed(context, '/comunication',
                      arguments: {'name': '/'});
                }),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Configuración',
              onPressed: () {
                Navigator.pushNamed(context, '/config',
                    arguments: {'name': '/'});
              },
            ),
          ],
          title: Text(widget.title),
        ),
        body: Center(
            child: Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.all(getPadding()),
                    child: SingleChildScrollView(
                        child: Column(
                      verticalDirection: VerticalDirection.down,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        getTexto(context, "Center(RA,Dec)", getFormato.H1),
                        declinacionYascencion(),
                        getTexto(context, "Center(RA,hms)", getFormato.H1),
                        ascencionYhoras(),
                        getTexto(context, "Center(Dec,dms)", getFormato.H1),
                        declinacionYgrados(),
                        getTexto(context, "Orientación", getFormato.H1),
                        orientacion()
                      ],
                    ))))),
        floatingActionButton: Builder(
          builder: (context) {
            var floatingActionButton2 = FloatingActionButton(
              onPressed: () {
                guardar(_formKey, context);
              },
              tooltip: 'Encontrar',
              child: Icon(Icons.search),
            );
            return floatingActionButton2;
          },
        ));
  }

  Row declinacionYascencion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(getPadding()),
          child: TextFormField(
            controller: controllerAscension,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            autofocus: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Introduzca valor numérico';
              }
              return null;
            },
            decoration: const InputDecoration(
              // icon: Icon(Icons.panorama_vertical),
              hintText: 'Longitud Terrestre',
              labelText: 'Ascención recta',
            ),
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusDeclinacion);
            },
          ),
        )),
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(getPadding()),
          child: TextFormField(
            controller: controllerDeclinacion,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.isEmpty) {
                return 'Introduzca valor numérico';
              }
              return null;
            },
            focusNode: focusDeclinacion,
            decoration: const InputDecoration(
              // icon: Icon(Icons.panorama_vertical),
              hintText: 'Latitud Terrestre',
              labelText: 'Declinación',
            ),
            autofocus: true,
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusHoras);
            },
          ),
        )),
      ],
    );
  }

  Row ascencionYhoras() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(getPadding()),
          child: TextFormField(
            controller: controllerHoras,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.isEmpty) {
                return 'Introduzca valor numérico';
              }
              var valor = int.parse(value);
              if (valor > 23 || valor < 0) {
                return 'Valor entre 0 y 23';
              }
              return null;
            },
            focusNode: focusHoras,
            decoration: const InputDecoration(
              // icon: Icon(Icons.panorama_vertical),
              hintText: '',
              labelText: 'Horas',
            ),
            autofocus: true,
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusMin1);
            },
          ),
        )),
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(getPadding()),
          child: TextFormField(
            controller: controllerMin1,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.isEmpty) {
                return 'Introduzca valor numérico';
              }
              var valor = int.parse(value);
              if (valor > 59 || valor < 0) {
                return 'Valor entre 0 y 59';
              }
              return null;
            },
            focusNode: focusMin1,
            decoration: const InputDecoration(
              // icon: Icon(Icons.panorama_vertical),
              hintText: '',
              labelText: 'Minutos',
            ),
            autofocus: true,
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusSec1);
            },
          ),
        )),
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(getPadding()),
          child: TextFormField(
            controller: controllerSec1,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.isEmpty) {
                return 'Introduzca valor numérico';
              }
              var valor = double.parse(value);
              if (valor > 59 || valor < 0) {
                return 'Valor entre 0 y 59';
              }
              return null;
            },
            focusNode: focusSec1,
            decoration: const InputDecoration(
              // icon: Icon(Icons.panorama_vertical),
              hintText: '',
              labelText: 'Segundos',
            ),
            autofocus: true,
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusGrad1);
            },
          ),
        )),
      ],
    );
  }

  Row declinacionYgrados() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(getPadding()),
          child: TextFormField(
            controller: controllerGrad1,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.isEmpty) {
                return 'Introduzca valor numérico';
              }
              var valor = double.parse(value);
              if (valor > 361 || valor < -361) {
                return 'Valor entre -360 y 360';
              }
              return null;
            },
            focusNode: focusGrad1,
            decoration: const InputDecoration(
              // icon: Icon(Icons.panorama_vertical),
              hintText: '',
              labelText: 'Grados',
            ),
            autofocus: true,
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusMin2);
            },
          ),
        )),
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(getPadding()),
          child: TextFormField(
            controller: controllerMin2,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.isEmpty) {
                return 'Introduzca valor numérico';
              }
              var valor = int.parse(value);
              if (valor > 59 || valor < 0) {
                return 'Valor entre 0 y 59';
              }
              return null;
            },
            focusNode: focusMin2,
            decoration: const InputDecoration(
              // icon: Icon(Icons.panorama_vertical),
              hintText: '',
              labelText: 'Minutos',
            ),
            autofocus: true,
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusSec2);
            },
          ),
        )),
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(getPadding()),
          child: TextFormField(
            controller: controllerSec2,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.isEmpty) {
                return 'Introduzca valor numérico';
              }
              var valor = double.parse(value);
              if (valor > 59 || valor < 0) {
                return 'Valor entre 0 y 59';
              }
              return null;
            },
            focusNode: focusSec2,
            decoration: const InputDecoration(
              // icon: Icon(Icons.panorama_vertical),
              hintText: '',
              labelText: 'Segundos',
            ),
            autofocus: true,
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusSelect1);
            },
          ),
        )),
      ],
    );
  }

  Column orientacion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
                child: Padding(
                    padding: EdgeInsets.all(getPadding()),
                    child: DropdownButton<String>(
                      value: upDown,
                      icon: Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      elevation: 10,
                      style: TextStyle(color: Colors.deepPurple),
                      focusNode: focusSelect1,
                      onChanged: (String newValue) {
                        setState(() {
                          upDown = newValue;
                        });
                      },
                      items: <String>['Arriba', 'Abajo']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: getTexto(context, value, getFormato.SELECT),
                        );
                      }).toList(),
                    ))),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(getPadding()),
                child: TextFormField(
                  controller: controllerGrad2,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Introduzca valor numérico';
                    }
                    var valor = double.parse(value);
                    if (valor > 361 || valor < -361) {
                      return 'Valor entre -360 y 360';
                    }
                    return null;
                  },
                  focusNode: focusGrad2,
                  decoration: const InputDecoration(
                    // icon: Icon(Icons.panorama_vertical),
                    hintText: '',
                    labelText: 'Grados',
                  ),
                  autofocus: true,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focusSelect2);
                  },
                ),
              ),
            ),
          ],
        ),
        Row(children: <Widget>[
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(getPadding()),
                  child: DropdownButton<String>(
                    value: orient1,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple),
                    focusNode: focusSelect2,
                    onChanged: (String newValue) {
                      setState(() {
                        orient1 = newValue;
                      });
                    },
                    items: <String>['N', 'E', 'O', 'S']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: getTexto(context, value, getFormato.SELECT),
                      );
                    }).toList(),
                  ))),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(getPadding()),
                  child: getTexto(context, 'a', getFormato.H3))),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(getPadding()),
                  child: DropdownButton<String>(
                    value: orient2,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple),
                    focusNode: focusSelect3,
                    onChanged: (String newValue) {
                      setState(() {
                        orient2 = newValue;
                      });
                    },
                    items: <String>['N', 'E', 'O', 'S']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: getTexto(context, value, getFormato.SELECT),
                      );
                    }).toList(),
                  ))),
        ])
      ],
    );
  }
}

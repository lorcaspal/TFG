import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:direct_select/direct_select.dart';

import 'controller_opciones.dart';

class ViewOptions extends StatefulWidget {
  ViewOptions({Key key, this.name}) : super(key: key);
  final String name;
  @override
  _OptionsState createState() => _OptionsState();
}

/*
 * Calcular la escala de la pantalla de tu dispositivo(x,y)
 */
class _OptionsState extends State<ViewOptions> {
  //Cambio puede ser:
  // 0: Sin cambio
  // 1: Reset
  // 2: nuevos valores
  int cambio = 0;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    loadOpciones((index) {
      setState(() {
        selectedIndex = index;
      });
    });
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    controllerMin.dispose();
    controllerMax.dispose();
    selectedIndex = 0;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (widget.name == '/') {
            //variable de la clase principal
            Navigator.pop(context);
          } else {
            Navigator.pop(context, cambio);
          }
        },
        child: Scaffold(
            floatingActionButton: Builder(
                builder: (context) => FloatingActionButton(
                      onPressed: () async {
                        var controlGuardado = await guardar(_formKey);
                        if (controlGuardado) {
                          cambio = 2;
                          final snackBar = SnackBar(
                              content: Text(
                                  'Los datos se han guardado correctamente'));
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                      },
                      tooltip: 'Guardar',
                      child: Icon(Icons.save),
                    )),
            appBar: AppBar(
              title: Text('Opciones de configuración'),
            ),
            body: Center(
                child: Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        Text(
                          "Unidad de medida",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 18.0),
                            child: DirectSelect(
                              itemExtent: 70.0,
                              selectedIndex: selectedIndex,
                              child: MySelectionItem(
                                isForList: false,
                                title: elements[selectedIndex],
                              ),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              items: buildItems(),
                            )),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.only(top: 28.0),
                            child: Column(children: <Widget>[
                              Text(
                                "Dimensiones",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextFormField(
                                controller: controllerMin,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Introduzca valor numérico';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.panorama_vertical),
                                  hintText:
                                      '¿Cuál es la escala mínima de tu dispositivo?',
                                  labelText: 'Mínimo',
                                ),
                              ),
                              TextFormField(
                                controller: controllerMax,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Introduzca valor numérico';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.panorama_horizontal),
                                  hintText:
                                      '¿Cuál es la escala máxima de tu dispositivo?',
                                  labelText: 'Máximo',
                                ),
                              ),
                            ]),
                          ),
                        ),
                        Column(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Builder(
                                builder: (context) => RaisedButton(
                                      textColor: Colors.white,
                                      onPressed: () {
                                        reset((index) {
                                          setState(() {
                                            selectedIndex = index;
                                          });
                                          final snackBar = SnackBar(
                                              content: Text(
                                                  'Los datos se han eliminado correctamente'));
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                        });
                                        cambio = 1;
                                      },
                                      child: Text("Eliminar valores"),
                                    )),
                          )
                        ])
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                      verticalDirection: VerticalDirection.down,
                    ))))));
  }
}

class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({Key key, this.title, this.isForList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: isForList
          ? Padding(
              child: _buildItem(context),
              padding: EdgeInsets.all(10.0),
            )
          : Card(
              color: Colors.deepPurple[100],
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: <Widget>[
                  _buildItem(context),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: FittedBox(
          child: Text(
        title,
        textScaleFactor: 1.2,
      )),
    );
  }
}

import 'package:find_your_star_final/Comunicacion/controller_conmunication.dart';
import 'package:flutter/material.dart';

class ViewComunication extends StatefulWidget {
  ViewComunication({Key key, this.name}) : super(key: key);
  final String name;
  _ComunicationState createState() => _ComunicationState();
}

class _ComunicationState extends State<ViewComunication> {
  bool cambio = false;

  @override
  void initState() {
    super.initState();
    loadComunication();
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte

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
                    onPressed: () {
                      guardar();
                      cambio = true;
                      final snackBar = SnackBar(
                          content:
                              Text('Los datos se han guardado correctamente'));
                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                    tooltip: 'Guardar',
                    child: Icon(Icons.save),
                  )),
          appBar: AppBar(
            title: Text('Opciones de comunicación'),
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      "IP",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: controllerIp,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.location_on),
                          labelText: 'dirección IP'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 28.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Puertos",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            controller: controllerPortSocket,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.insert_link),
                              labelText: 'Puerto Socket',
                            ),
                          ),
                          // TextFormField(
                          //   controller: controllerPortAPI,
                          //   keyboardType: TextInputType.number,
                          //   decoration: const InputDecoration(
                          //     icon: Icon(Icons.api),
                          //     labelText: 'Puerto API',
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Builder(
                            builder: (context) => RaisedButton(
                                  textColor: Colors.white,
                                  onPressed: () {
                                    reset();
                                    cambio = true;
                                    final snackBar = SnackBar(
                                        content: Text(
                                            'Se ha vuelto a los valores por defecto'));
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  },
                                  child: Text("Valores predeterminados"),
                                )),
                      )
                    ])
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

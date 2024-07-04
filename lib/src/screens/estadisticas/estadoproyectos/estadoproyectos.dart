import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/estadisticas/estadoproyectos/grafica.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EstadoProyectosPage extends StatefulWidget {
  EstadoProyectosPage({Key key}) : super(key: key);

  @override
  _EstadoProyectosPageState createState() => _EstadoProyectosPageState();
}

class _EstadoProyectosPageState extends State<EstadoProyectosPage> {
  List secretarias;
  SharedPreferences spreferences;
  List secretaria;
  String bd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Estado de los proyectos"),
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]))),
              child: ListTile(
                onTap: () {
                  ir("0", "TODAS LAS SECRETARÍAS");
                },
                title: Text('TODAS LAS SECRETARÍAS'),
              ),
            ),
            ListView.builder(
                itemCount: secretarias == null ? 0 : secretarias.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[300]))),
                    child: ListTile(
                        onTap: () {
                          ir(secretarias[index]["idsecretarias"].toString(),
                              secretarias[index]["des_secretarias"]);
                        },
                        title: Text(secretarias[index]["des_secretarias"])),
                  );
                }),
          ],
        )));
  }

  @override
  void initState() {
    super.initState();
    secretarias = new List();
    instanciar_sesion();
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    buscar_secretarias();
  }

  Future<String> buscar_secretarias() async {
    var response = await http.get(
        Uri.parse('${URL_SERVER}secretarias?bd=${bd}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    this.setState(() {
      this.secretarias = reponsebody['secretarias'];
    });

    return "Success!";
  }

  ir(String id, String nombre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GraficaEstadoProyectosPage(idSecretaria: id,nombreSecretiaria: nombre,)
      ),
    );
  }
}

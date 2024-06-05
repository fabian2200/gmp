import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/estadisticas/disponibilidad_presupuestal/grafica.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DisponibilidadPresupuestalPage extends StatefulWidget {
  DisponibilidadPresupuestalPage({Key key}) : super(key: key);

  @override
  _DisponibilidadPresupuestalPageState createState() => _DisponibilidadPresupuestalPageState();
}

class _DisponibilidadPresupuestalPageState extends State<DisponibilidadPresupuestalPage> {
  List secretarias;
  SharedPreferences spreferences;
  List secretaria;
  String bd;
  
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(
           title: Text("Disponibilidad presupuestal")
         ),
         body: new ListView.builder(
          itemCount: secretarias == null ? 0 : secretarias.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: InkWell(
                onTap: () {
                  ir(secretarias[index]['idsecretarias'].toString(),
                      secretarias[index]['des_secretarias'].toString());
                },
                child: Image.network(
                    '${RUTA_IMAGEN}${secretarias[index]['ico_secretarias']}'),
              ),
            );
          },
        ),
       ),
    );
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
          builder: (context) =>
              GraficaDisponibilidadPage(idSecretaria: id)),
    );
  }
}
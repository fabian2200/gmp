import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/proyectos/proyectos.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SecretariaPage extends StatefulWidget {
  SecretariaPage({Key key}) : super(key: key);

  @override
  _SecretariaPageState createState() => _SecretariaPageState();
}

class _SecretariaPageState extends State<SecretariaPage> {
  List secretarias;
  SharedPreferences spreferences;
  String bd;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Secretarías"),
          ),
          body: ListView.builder(
            itemCount: secretarias == null ? 0 : secretarias.length,
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                children: <Widget>[
                  companias_carga(),
                  Card(
                    child: InkWell(
                      onTap: () {
                        ir(secretarias[index]['idsecretarias'].toString(),
                            secretarias[index]['des_secretarias'].toString());
                      },
                      child: Image.network(
                          '${RUTA_IMAGEN}${secretarias[index]['ico_secretarias']}'),
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    buscar_secretarias();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    secretarias = new List();
    instanciar_sesion();
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
    //Timer(Duration(milliseconds: 1000), () {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ProyectosPage(id: id, nombreSecretaria: nombre)),
    );
    // });
  }

  Widget companias_carga() {
    return SkeletonAnimation(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.0),
              color: Colors.grey[300]),
        ),
      ),
    );
  }
}

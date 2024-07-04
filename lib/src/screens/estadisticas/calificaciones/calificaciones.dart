import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/estadisticas/estadoproyectos/grafica.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CalificacionesPage extends StatefulWidget {
  CalificacionesPage({Key key}) : super(key: key);

  @override
  _CalificacionesPageState createState() => _CalificacionesPageState();
}

class _CalificacionesPageState extends State<CalificacionesPage> {
  List secretarias;
  SharedPreferences spreferences;
  String bd;
  String combosecre = "0";
  String combocal = 'Todas las calificaciones';
  int total = 0;
  List proyectos;
  String empresa;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    SizeConfig _sc = SizeConfig();
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text("Calificaciones de los proyectos")),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultpadding),
                  child: Text(
                    "Secretarías",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: _sc.getProportionateScreenHeight(14)),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.05,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(defaultpadding - 15),
                      border: Border.all(color: Colors.grey[400])),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    underline: SizedBox(),
                    value: combosecre,
                    items: secretarias.length != 0
                        ? secretarias.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value['idsecretarias'].toString(),
                              child: Text(value['des_secretarias'].toString()),
                            );
                          }).toList()
                        : [
                            DropdownMenuItem(
                              child: Text("TODAS"),
                              value: "0",
                            ),
                          ],
                    onChanged: (value) {
                      setState(() {
                        combosecre = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultpadding),
                  child: Text(
                    "Calificaciones",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: _sc.getProportionateScreenHeight(14)),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.05,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultpadding - 15),
                    border: Border.all(color: Colors.grey[400]),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    underline: SizedBox(),
                    value: combocal,
                    onChanged: (String valor) {
                      setState(() {
                        combocal = valor;
                      });
                    },
                    items: <String>[
                      'Todas las calificaciones',
                      'Excelente',
                      'Bueno',
                      'Regular',
                      'Bajo'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
                child: GestureDetector(
                  onTap: () {
                    buscarcalificaciones();
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(defaultpadding - 15),
                      color: Colors.green),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: defaultpadding - 5
                      ),
                      child: Center(
                        child: Text(
                        "Realizar busqueda",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _sc.getProportionateScreenHeight(15),
                          fontWeight: FontWeight.w500
                        ),
                      )),
                    ),
                  ),
                ),
              ),
              SizedBox(height: defaultpadding),
              Container(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Resultado de la busqueda (${total})",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: defaultpadding - 3),
                    ),
                  )),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: proyectos == null ? 0 : proyectos.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: size.width * 0.18,
                            child: CircleAvatar(
                              radius: defaultpadding + 10,
                              backgroundImage: NetworkImage(
                                  '${URL_PROYECTOS}${empresa}/${proyectos[index]['num_proyect_galeria']}/${proyectos[index]['img_galeria']}'),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: defaultpadding),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      proyectos[index]["nombre_proyect"]
                                                  .length >
                                              90
                                          ? "${proyectos[index]["nombre_proyect"].substring(0, 1).toUpperCase()}${proyectos[index]["nombre_proyect"].substring(1, 90).toLowerCase()}"
                                          : "${proyectos[index]["nombre_proyect"].substring(0, 1).toUpperCase()}${proyectos[index]["nombre_proyect"].substring(1, proyectos[index]["nombre_proyect"].length).toLowerCase()}",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        proyectos[index]["des_secretarias"],
                                      ),
                                    ),
                                    dibujarestrellas(double.parse(proyectos[index]["cal"]))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    secretarias = new List();
    proyectos = new List();
    instanciar_sesion();
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");
    buscar_secretarias();
  }

  Future<String> buscar_secretarias() async {
    var response = await http.get(
        Uri.parse('${URL_SERVER}secretariasl?bd=${bd}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    this.setState(() {
      this.secretarias = reponsebody['secretarias'];
    });

    return "Success!";
  }

  Future<String> buscarcalificaciones() async {
    var response = await http.get(
        Uri.parse(
            '${URL_SERVER}proyectos_calificaciones?bd=${bd}&cal=${combocal}&sec=${combosecre}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    this.setState(() {
      proyectos = reponsebody['proyectos'];
      total = proyectos.length;
    });

    return "Success!";
  }

  Widget dibujarestrellas(double numero) {
    Widget rating=Row();
    int estrellas;
    estrellas = numero.floor();
    if (estrellas == 1) {
      rating = Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star_border_outlined,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star_border_outlined,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star_border_outlined,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star_border_outlined,
            color: Colors.yellow[600],
          )
        ],
      );
    } else if (estrellas == 2) {
      rating = Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star_border_outlined,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star_border_outlined,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star_border_outlined,
            color: Colors.yellow[600],
          )
        ],
      );
    } else if (estrellas == 3) {
      rating = Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star_border_outlined,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star_border_outlined,
            color: Colors.yellow[600],
          )
        ],
      );
    } else if (estrellas == 4) {
      rating = Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star_border_outlined,
            color: Colors.yellow[600],
          )
        ],
      );
    } else if (estrellas == 5) {
      rating = Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star,
            color: Colors.yellow[600],
          )
        ],
      );
    }
    return rating;
  }

  ir(String id, String nombre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GraficaEstadoProyectosPage(
          idSecretaria: id,
          nombreSecretiaria: nombre,
        )
      ),
    );
  }
}

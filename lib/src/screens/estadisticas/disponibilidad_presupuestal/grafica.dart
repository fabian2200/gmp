import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
//import 'package:graphic/graphic.dart' as graphic;
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';

class GraficaDisponibilidadPage extends StatefulWidget {
  final String idSecretaria;
  GraficaDisponibilidadPage({Key key, this.idSecretaria}) : super(key: key);

  @override
  _GraficaDisponibilidadPageState createState() =>
      _GraficaDisponibilidadPageState();
}

class _GraficaDisponibilidadPageState extends State<GraficaDisponibilidadPage> {
  SizeConfig _sc = SizeConfig();
  SharedPreferences spreferences;
  String bd;
  String secretaria;
  Map<String, double> dataMap = new Map();
  List<Color> colores = new List();
  double total;
  double asignado;
  double disponible;
  double ejecutado;
  List fuentes;
  final oCcy = new NumberFormat("#,##0", "es_CO");

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    SizeConfig _sc = SizeConfig();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("Disponibilidad presupuestal")),
        body: secretaria == null ? 
        Container(
          decoration: BoxDecoration(
        color: Colors.white
      ),
          child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: defaultpadding + defaultpadding + defaultpadding,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(defaultpadding),
                        child: Text("No se encontró información asocidada a la busqueda",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,               
                        ),),
                      ),
                      Image.asset("assets/images/nofound.jpg")
                  ]
                   ),
                ),
        )
              :
              SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        secretaria == null ? "" : secretaria,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: _sc.getProportionateScreenHeight(15)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                      width: double.infinity,
                      height: 300,
                      child: dataMap.isNotEmpty
                          ? PieChart(
                              dataMap: dataMap,
                              colorList: colores,
                            )
                          : Text("No existen datos")),
                ),
                SizedBox(
                  height: _sc.getProportionateScreenHeight(0),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        "Detalles presupuestales",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: _sc.getProportionateScreenHeight(18)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                                          child: Card(
                        child: Container(
                          width: size.width * 0.48,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Presupuesto total",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          _sc.getProportionateScreenHeight(13)),
                                ),
                                SizedBox(
                                  height: _sc.getProportionateScreenHeight(5),
                                ),
                                Text(
                                  total != null
                                      ? "\$ ${oCcy.format(total).replaceAll(",00", "")}"
                                      : "",
                                  style: TextStyle(
                                      fontSize:
                                          _sc.getProportionateScreenHeight(14),
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Icon(Icons.analytics_outlined,
                                        color: Colors.purple[700]),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                                          child: Card(
                        child: Container(
                          width: size.width * 0.48,
                          alignment: Alignment.center,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Presupuesto disponible",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: _sc
                                            .getProportionateScreenHeight(13)),
                                  ),
                                  SizedBox(
                                    height: _sc.getProportionateScreenHeight(5),
                                  ),
                                  Text(
                                    total != null
                                        ? "\$ ${oCcy.format(disponible).replaceAll(",00", "")}"
                                        : "",
                                    style: TextStyle(
                                        fontSize: _sc
                                            .getProportionateScreenHeight(14),
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Icon(Icons.gesture_outlined,
                                          color: Colors.orangeAccent),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    )
                    /*Text(
                      "Presupuesto total: ",
                      style: TextStyle(
                          fontSize: _sc.getProportionateScreenHeight(16),
                          fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    Text(
                      total != null
                          ? "\$ ${oCcy.format(total).replaceAll(",00", "")}"
                          : "",
                      style: TextStyle(
                          fontSize: _sc.getProportionateScreenHeight(16),
                          color: Colors.green),
                    )*/
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                                          child: Card(
                        child: Container(
                          width: size.width * 0.48,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Presupuesto asignado",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          _sc.getProportionateScreenHeight(13)),
                                ),
                                SizedBox(
                                  height: _sc.getProportionateScreenHeight(5),
                                ),
                                Text(
                                  total != null
                                      ? "\$ ${oCcy.format(asignado).replaceAll(",00", "")}"
                                      : "",
                                  style: TextStyle(
                                      fontSize:
                                          _sc.getProportionateScreenHeight(14),
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Icon(Icons.attach_money_sharp,
                                        color: Colors.green),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                                          child: Card(
                        child: Container(
                          width: size.width * 0.48,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Presupuesto ejecutado",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          _sc.getProportionateScreenHeight(13)),
                                ),
                                SizedBox(
                                  height: _sc.getProportionateScreenHeight(5),
                                ),
                                Text(
                                  total != null
                                      ? "\$ ${oCcy.format(ejecutado).replaceAll(",00", "")}"
                                      : "",
                                  style: TextStyle(
                                      fontSize:
                                          _sc.getProportionateScreenHeight(14),
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Icon(Icons.equalizer_rounded,
                                        color: Colors.brown),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    /*Text(
                      "Presupuesto total: ",
                      style: TextStyle(
                          fontSize: _sc.getProportionateScreenHeight(16),
                          fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    Text(
                      total != null
                          ? "\$ ${oCcy.format(total).replaceAll(",00", "")}"
                          : "",
                      style: TextStyle(
                          fontSize: _sc.getProportionateScreenHeight(16),
                          color: Colors.green),
                    )*/
                  ],
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        "Fuentes de financiación",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: _sc.getProportionateScreenHeight(18)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListView.builder(
                        itemCount: fuentes == null ? 0 : fuentes.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  fuentes[index]["nombre"],
                                  style: TextStyle(
                                      fontSize:
                                          _sc.getProportionateScreenHeight(15),
                                      fontWeight: FontWeight.w600),
                                ),
                                Spacer(),
                                Text(
                                  "\$ ${oCcy.format(fuentes[index]["valor"]).replaceAll(",00", "")}",
                                  style: TextStyle(
                                      fontSize:
                                          _sc.getProportionateScreenHeight(15),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[800]),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    instanciar_sesion();
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    fuentes = new List();
    buscar_secretarias();
  }

  Future<String> buscar_secretarias() async {
    double porDisponible = 0;
    double porAsignado = 0;
    var response = await http.get(
        Uri.parse(
            '${URL_SERVER}presupuestosecretaria?bd=${bd}&id=${widget.idSecretaria}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);
    // print(reponsebody);
    this.setState(() {
      try {
        secretaria = reponsebody['secretaria'][0]['des_secretarias'].toString();
        //print(reponsebody['datos_secretaria']["total"]);
        total =
            double.parse(reponsebody['datos_secretaria']["total"].toString());
        asignado = double.parse(
            reponsebody['secretaria'][0]['TOTAL_PROYECTOS'].toString());
        ejecutado = double.parse(reponsebody['secretaria'][0]
                ['TOTAL_EJECUCION_PROYECTOS']
            .toString());
        disponible = total - asignado;

        fuentes = reponsebody['fuentes'];

        //print(fuentes);

        porDisponible = disponible * 100 / total;
        porAsignado = asignado * 100 / total;

        dataMap.putIfAbsent("Disponible", () => porDisponible);
        dataMap.putIfAbsent("Asignado", () => porAsignado);
        colores.add(Colors.green);
        colores.add(Colors.red);
        colores.toList();
      } catch (e) {}
    });

    return "Success!";
  }
}

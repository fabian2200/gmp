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

class GraficaPresupuestoAsignadoPage extends StatefulWidget {
  final String idSecretaria;
  final String nombreSecretaria;
  GraficaPresupuestoAsignadoPage(
      {Key key, this.idSecretaria, this.nombreSecretaria})
      : super(key: key);

  @override
  _GraficaPresupuestoAsignadoPageState createState() =>
      _GraficaPresupuestoAsignadoPageState();
}

class _GraficaPresupuestoAsignadoPageState
    extends State<GraficaPresupuestoAsignadoPage> {
  SizeConfig _sc = SizeConfig();
  SharedPreferences spreferences;
  String bd;
  List contratos;
  Map<String, double> dataMap = new Map();
  List<Color> colores = new List();
  int total;
  List<Color> color;

  final oCcy = new NumberFormat("#,##0", "es_CO");
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    SizeConfig _sc = SizeConfig();
    return Scaffold(
        appBar: AppBar(title: Text("Presupuesto asignado")),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: _sc.getProportionateScreenHeight(0),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      widget.nombreSecretaria,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
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
                      : Text(""),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      "Detalles de la gráfica",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: _sc.getProportionateScreenHeight(15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Card(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: contratos == null ? 0 : contratos.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: RichText(
                                text: TextSpan(
                                  text: contratos[index]['num_contrato'],style: TextStyle(color: color[index], fontWeight: FontWeight.w600),
                                  children: [
                                    TextSpan(text: " - ", style: TextStyle()),
                                    TextSpan(
                                      text: contratos[index]['obj_contrato'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400)
                                    )
                                  ]
                                )
                              ),
                              subtitle: Text("Valor del contrato: \$${oCcy.format(contratos[index]['vcontr_contrato']).replaceAll(",00", "")}",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black

                              ),),
                            );
                          }),),),
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    instanciar_sesion();
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    contratos = new List();
    color = new List();
    color.add(Colors.green);
    color.add(Colors.blue);
    color.add(Colors.yellow);
    color.add(Colors.orange);
    color.add(Colors.pink);
    color.add(Colors.purple);
    color.add(Colors.red);
    color.add(Colors.black);
    color.add(Colors.brown);
    color.add(Colors.blue[900]);
    color.add(Colors.green[900]);
    color.add(Colors.brown[900]);
    color.add(Colors.orange[900]);
    color.add(Colors.grey);
    buscar_secretarias();
  }

  Future<String> buscar_secretarias() async {
    double porDisponible = 0;
    var response = await http.get(
        Uri.parse(
            '${URL_SERVER}graficadetalles?bd=${bd}&id_con=${widget.idSecretaria}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);
    // print(reponsebody);
    this.setState(() {
      try {
        contratos = reponsebody["contratos"];
        //print(contratos);
        //print(reponsebody['datos_secretaria']["total"]);
        var cantidad = contratos.length;
        for (int i = 0; i < cantidad; i++) {
          //print("Entrando");
          //print(contratos[i]["vcontr_contrato"].toString());
          total = contratos[i]["vcontr_contrato"];
        }

        //print(total.toString());

        for (int j = 0; j < cantidad; j++) {
          porDisponible = contratos[j]["vcontr_contrato"] * 100 / total;
          dataMap.putIfAbsent(
              contratos[j]["num_contrato"], () => porDisponible);
          colores.add(color[j]);
        }

        //print(fuentes);

        //porDisponible = disponible * 100 / total;
        //porAsignado = asignado * 100 / total;

        colores.toList();
      } catch (e) {}
    });

    return "Success!";
  }
}

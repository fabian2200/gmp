import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/estadisticas/estadoproyectos/InterfazGrafica.dart';
import 'package:gmp/src/screens/estadisticas/estadoproyectos/listado.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
//import 'package:graphic/graphic.dart' as graphic;
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';

class GraficaEstadoProyectosPage extends StatefulWidget {
  final String idSecretaria;
  final String nombreSecretiaria;
  GraficaEstadoProyectosPage(
      {Key key, this.idSecretaria, this.nombreSecretiaria})
      : super(key: key);

  @override
  _GraficaEstadoProyectosPageState createState() =>
      _GraficaEstadoProyectosPageState();
}

class _GraficaEstadoProyectosPageState
    extends State<GraficaEstadoProyectosPage> {
  SizeConfig _sc = SizeConfig();
  SharedPreferences spreferences;
  String bd;
  String secretaria;
  Map<String, double> dataMap = new Map();
  List<Color> colores = new List();
  List fuentes;
  int ejecucion;
  int ejecutados;
  int radicados;
  int priorizados;
  int registrados;
  int no_viabilizados;
  int total = 0;

  final oCcy = new NumberFormat("#,##0", "es_CO");

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    SizeConfig _sc = SizeConfig();
    return Scaffold(
        appBar: AppBar(title: Text("Estado de los proyectos")),
        body: ejecucion == null
            ? Center(
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
              )
            : InterfazGrafica(
                sc: _sc,
                dataMap: dataMap,
                total: total,
                idSecretaria: widget.idSecretaria,
                nombreSecretaria: widget.nombreSecretiaria,
                ejecucion: ejecucion,
                ejecutados: ejecutados,
                radicados: radicados,
                priorizados: priorizados,
                registrados: registrados,
                no_viabilizados: no_viabilizados,
                colores: colores,
                context: context));
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
    double porEjecucion = 0;
    double porViabilizado = 0;
    double porPriorizado = 0;
    double porRadicado = 0;
    double porRegistrado = 0;
    double porEjecutado = 0;

    var response = await http.get(
        Uri.parse(
            '${URL_SERVER}secretariaestado?bd=${bd}&id=${widget.idSecretaria}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);
    this.setState(() {
      try {
        ejecucion = reponsebody['proyectos_ejecucion'];
        ejecutados = reponsebody['proyectos_ejecutados'];
        radicados = reponsebody['proyectos_radicados'];
        priorizados = reponsebody['proyectos_priorizados'];
        registrados = reponsebody['proyectos_registrados'];
        no_viabilizados = reponsebody['proyectos_no'];

        total = ejecucion +
            ejecutados +
            radicados +
            priorizados +
            registrados +
            no_viabilizados;

        porEjecucion = ejecucion * 100 / total;
        porEjecutado = ejecutados * 100 / total;
        porRadicado = radicados * 100 / total;
        porPriorizado = priorizados * 100 / total;
        porRegistrado = registrados * 100 / total;
        porViabilizado = no_viabilizados * 100 / total;

        dataMap.putIfAbsent("En Ejecución", () => porEjecucion);
        dataMap.putIfAbsent("No Viabilizado", () => porViabilizado);
        dataMap.putIfAbsent("Priorizado", () => porPriorizado);
        dataMap.putIfAbsent("Radicado", () => porRadicado);
        dataMap.putIfAbsent("Registrado", () => porRegistrado);
        dataMap.putIfAbsent("Ejecutado", () => porEjecutado);

        colores.add(Colors.green);
        colores.add(Colors.red);
        colores.add(Colors.orange);
        colores.add(Colors.yellow);
        colores.add(Colors.grey);
        colores.add(Colors.blue);
        colores.toList();
      } catch (e) {}
    });

    return "Success!";
  }

  _ir(String estado, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListadoEstado(idSecretaria: id, estado: estado)
      ),
    );
  }
}

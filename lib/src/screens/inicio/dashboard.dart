import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gmp/src/screens/proyectos/proyectos.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  SizeConfig _sc = SizeConfig();
  SharedPreferences spreferences;
  String imagen = "";
  List<Ejecutados> _chartdata;
  List _secretarias;
  List _stats = [];
  Random random = new Random();
  double _presupuesto = 0;
  double _ejecutado = 0;
  double _presGastado = 0;
  double _angulopendiente = 0;
  double _anguloejecutado = 0;
  double _anguloEjecucion = 0;
  double _angulogastado= 0;
  String _mpendiente = "0";
  String _mejecutado = "0";
  String _mejecucion = "0";
  String _mgastado = "0";
  final oCcy = new NumberFormat("#,##0", "es_CO");

  String nombreEntidad = "";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kgrayfondo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: kazuloscuro,
                      ),
                    ),
                    SizedBox(
                      width: _sc.getProportionateScreenWidth(30),
                    ),
                    Text(nombreEntidad,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: kazuloscuro),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "\$${oCcy.format(_presupuesto)}",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800]),
                  ),
                ),
                Center(
                  child: Text(
                    "Presupuesto",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600]),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          //color: krojoclaro,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: _sc.getProportionateScreenWidth(50),
                              child: CircularPercentIndicator(
                                radius: 55.0,
                                lineWidth: 4.0,
                                percent: _anguloejecutado,
                                center: new Text(_anguloejecutado.toStringAsFixed(4)+"%", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                                progressColor: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Ejecutado",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600]),
                                ),
                                Text(
                                  "\$${_mejecutado} ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          //color: krojoclaro,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: _sc.getProportionateScreenWidth(50),
                              child: CircularPercentIndicator(
                                radius: 55.0,
                                lineWidth: 4.0,
                                percent: _anguloEjecucion,
                                center: new Text(_anguloEjecucion.toStringAsFixed(4)+"%", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                                progressColor: Colors.orange,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "En ejecución",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600]),
                                ),
                                Text(
                                  "\$${_mejecucion} ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                 SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          //color: krojoclaro,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: _sc.getProportionateScreenWidth(50),
                              child:  CircularPercentIndicator(
                                radius: 55.0,
                                lineWidth: 4.0,
                                percent: _angulogastado,
                                center: Text(_angulogastado.toStringAsFixed(4)+"%", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                                progressColor: Colors.red,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Gastado",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600]),
                                ),
                                Text(
                                  "\$${_mgastado} ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          //color: krojoclaro,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: _sc.getProportionateScreenWidth(50),
                              child: CircularPercentIndicator(
                                radius: 55.0,
                                lineWidth: 4.0,
                                percent: _angulopendiente,
                                center:  Text(_angulopendiente.toStringAsFixed(4)+"%", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                                progressColor: Colors.blue,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Pendiente",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600]),
                                ),
                                Text(
                                  "\$${_mpendiente} ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: defaultpadding + defaultpadding,
                ),
                Text(
                  "Tendencia",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                Text(
                  "Últimos meses",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600]),
                ),
                SizedBox(
                  height: defaultpadding,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  height: _sc.getProportionateScreenHeight(200),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: SfCartesianChart(
                    series: <ChartSeries>[
                      SplineSeries<Ejecutados, String>(
                        dataSource: _chartdata,
                        xValueMapper: (Ejecutados _ejecutado, _) =>
                            _ejecutado.mes,
                        yValueMapper: (Ejecutados _ejecutado, _) =>
                            _ejecutado.dinero,
                        color: Colors.green,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                      ),
                    ],
                    primaryXAxis: CategoryAxis(
                      majorGridLines: MajorGridLines(),
                      // Axis labels will be rotated to 90 degree
                      labelRotation: 350,
                      axisLine: AxisLine(width: 1),
                    ),
                    primaryYAxis: NumericAxis(
                      labelFormat: '{value}%',
                      axisLine: AxisLine(width: 1),
                    ),
                    plotAreaBorderWidth: 0,
                  ),
                ),
                SizedBox(
                  height: defaultpadding,
                ),
                Text(
                  "Secretarías ",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                SizedBox(
                  height: defaultpadding,
                ),
                Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _secretarias == null ? 0 : _secretarias.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            _ir(
                                _secretarias[index]['idsecretarias'].toString(),
                                _secretarias[index]['des_secretarias']
                                    .toString());
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: _sc.getProportionateScreenHeight(50),
                                  height: _sc.getProportionateScreenHeight(50),
                                  decoration: BoxDecoration(
                                    color: Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(10000),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.account_balance, color: Colors.white, size: 27),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${_secretarias[index]['des_secretarias']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Proyectos: ${_secretarias[index]['cp']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[600]),
                                    ),
                                    Text(
                                      "Presupuesto: \$${oCcy.format(_secretarias[index]['presupuesto'])}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green[800]),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ),
                  SizedBox(height: 40)
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
    var bd = spreferences.getString("bd");
    nombreEntidad = spreferences.getString("nombre_entidad");
    _secretarias = [];
    setState(() {
      imagen = spreferences.getString("imagen");
      _getDataInfo(bd);
      _getPresupuesto(bd);
      _getDataStats(bd);
    });
  }

  List<Ejecutados> getChartData(List data) {
    final List<Ejecutados> chartData = [];
    for (var i = 0; i < data.length; i++) {
      chartData.add(
          Ejecutados(data[i]["mes"], int.parse(data[i]["valor"].toString())));
    }
    print(chartData);
    return chartData;
  }

  _getDataInfo(String bd) async {
    print('${URL_SERVER}listadosecretarias?bd=${bd}');
    var response = await http.get(
        Uri.parse('${URL_SERVER}listadosecretarias?bd=${bd}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);
    setState(() {
      _secretarias = reponsebody['secretarias'];
    });

    return true;
  }

  _getPresupuesto(String bd) async {
    var response = await http.get(
        Uri.parse('${URL_SERVER}presupuesto_general?bd=${bd}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);
    setState(() {
      _presupuesto = double.parse(reponsebody['presupuesto']);
      _ejecutado =  double.parse(reponsebody['presupuesto_general']["TOTAL_EJECUCION_PROYECTOS"]);
      double _enEjecucion = double.parse(reponsebody['presupuesto_general']["TOTAL_GASTADO_EN_EJECUCION"]);
      if (_ejecutado > 10000000) {
        _mejecutado = oCcy.format(_ejecutado / 1000000) + "M";
      } else {
        _mejecutado = oCcy.format(_ejecutado);
      }

      if (_enEjecucion > 10000000) {
        _mejecucion = oCcy.format(_enEjecucion / 1000000) + "M";
      } else {
        _mejecucion = oCcy.format(_enEjecucion);
      }

      _presGastado = _ejecutado + _enEjecucion;

       if (_presGastado > 10000000) {
        _mgastado = oCcy.format(_presGastado / 1000000) + "M";
      } else {
        _mgastado = oCcy.format(_presGastado);
      }

      double _pendiente = _presupuesto - (_ejecutado + _enEjecucion);
      if (_pendiente > 10000000) {
        _mpendiente = oCcy.format(_pendiente / 1000000) + "M";
      } else {
        _mpendiente = oCcy.format(_pendiente);
      }

      _anguloEjecucion = _enEjecucion / _presupuesto;
      _anguloejecutado = _ejecutado / _presupuesto;
      _angulogastado = _presGastado / _presupuesto;
      _angulopendiente =  _pendiente / _presupuesto;
      
    });

    return true;
  }

  _getDataStats(String bd) async {
    var response = await http.get(
        Uri.parse('${URL_SERVER}graficainicial?bd=${bd}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);
    setState(() {
      _stats = reponsebody['lista'];
      _chartdata = getChartData(_stats);
    });

    return true;
  }

  _ir(String id, String nombre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProyectosPage(id: id, nombreSecretaria: nombre)
      ),
    );
  }
}

class Ejecutados {
  String mes;
  int dinero;
  Ejecutados(this.mes, this.dinero);
}

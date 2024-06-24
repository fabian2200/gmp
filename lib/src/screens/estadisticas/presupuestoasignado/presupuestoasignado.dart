import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/estadisticas/presupuestoasignado/grafica.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PresupuestoAsignadoPage extends StatefulWidget {
  PresupuestoAsignadoPage({Key key}) : super(key: key);

  @override
  _PresupuestoAsignadoPageState createState() =>
      _PresupuestoAsignadoPageState();
}

class _PresupuestoAsignadoPageState extends State<PresupuestoAsignadoPage> {
  SizeConfig _sc = SizeConfig();
  List secretarias;
  SharedPreferences spreferences;
  List secretaria;
  String bd;
  final oCcy = new NumberFormat("#,##0", "es_CO");
  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Presupuesto asignado"),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: secretarias == null ? 0 : secretarias.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                _ir(secretarias[index]['idsecretarias'].toString(),
                    secretarias[index]['des_secretarias']);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: _sc.getProportionateScreenHeight(50),
                        height: _sc.getProportionateScreenHeight(50),
                        decoration: BoxDecoration(
                          color: Color((random.nextDouble() * 0xFFFFFF).toInt())
                              .withOpacity(0.4),
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
                            "${secretarias[index]['des_secretarias']}",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Proyectos: ${secretarias[index]['cp']}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600]),
                          ),
                          Text(
                            "Presupuesto: \$${oCcy.format(secretarias[index]['presupuesto'])}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green[800]),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
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
        Uri.parse('${URL_SERVER}listadosecretarias?bd=${bd}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    this.setState(() {
      this.secretarias = reponsebody['secretarias'];
    });

    return "Success!";
  }

  _ir(String id, String nombre) {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => GraficaPresupuestoAsignadoPage(
              idSecretaria: id, nombreSecretaria: nombre)),
    );
  }
}

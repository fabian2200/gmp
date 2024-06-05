import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmp/src/screens/geo/localizacion.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




class GeolocalizacionFiltro extends StatefulWidget {
  GeolocalizacionFiltro({Key key}) : super(key: key);

  @override
  GeolocalizacionFiltroPageState createState() => GeolocalizacionFiltroPageState();
}

class GeolocalizacionFiltroPageState extends State<GeolocalizacionFiltro> {
  
  SharedPreferences spreferences;
  String combosec;
  String comboval = "0";
  String combosecre = "0";
  String comboentidad = "0";
  List _corre;
  List _dptos;
  List _muni;
  List secretarias;
  String combomuni = "0";
  String combocorre = "0";
  String bd;
  String empresa;
  String id_user;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Location location;

  List companias;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    SizeConfig _sc = SizeConfig();
    return Container(
      height: 530,
      child:  Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultpadding, vertical: defaultpadding),
            child: Card(
              elevation: 1,
              child: Column(
                children: <Widget>[
                  Container(
                    height: _sc.getProportionateScreenHeight(40),
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.blue[800]),
                    child: Center(
                      child: Text(
                        "Filtrar Proyectos",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: _sc.getProportionateScreenHeight(15)),
                      ),
                    ),
                  ),
                 SizedBox(height: 15),
                 Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultpadding),
                      child: Text(
                        "Secretarías",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: _sc.getProportionateScreenHeight(14)),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultpadding),
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.05,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(defaultpadding - 15),
                          border: Border.all(color: Colors.grey[400])),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(),
                        value: combosecre,
                        items: secretarias.length != 0
                            ? secretarias
                                .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value['idsecretarias'].toString(),
                                  child:
                                      Text(value['des_secretarias'].toString()),
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
                  SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultpadding),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Departamento:",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15)),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultpadding),
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.05,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(defaultpadding - 15),
                          border: Border.all(color: Colors.grey[400])),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(),
                        value: comboval,
                        hint: Text("Todos"),
                        items: _dptos.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value['COD_DPTO'].toString(),
                            child: Text(value['NOM_DPTO'].toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            comboval = value;
                            combomuni = null;
                            
                          });
                        },
                      ),
                    ),
                  ),
                  ///////////MUNICIPIO
                  SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultpadding),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Municipio:",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15)),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultpadding),
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.05,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(defaultpadding - 15),
                          border: Border.all(color: Colors.grey[400])),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(),
                        value: combomuni,
                        items: _muni.length > 0
                            ? _muni.map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value['COD_MUNI'].toString(),
                                  child: Text(value['NOM_MUNI'].toString()),
                                );
                              }).toList()
                            : [
                                DropdownMenuItem(
                                  child: Text("TODOS"),
                                  value: "0",
                                ),
                              ],
                        onChanged: (value) {
                          setState(() {
                            combomuni = value;
                            combocorre = "0";
                            
                          });
                        },
                      ),
                    ),
                  ),

                  ///////////Corregimientos
                  SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultpadding),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Corregimiento",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15)),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultpadding),
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.05,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(defaultpadding - 15),
                          border: Border.all(color: Colors.grey[400])),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(),
                        value: combocorre,
                        items: _corre.length > 0
                            ? _corre.map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value['ID_CORREGI'].toString(),
                                  child: Text(value['NOM_CORREGI'].toString()),
                                );
                              }).toList()
                            : [
                                DropdownMenuItem(
                                  child: Text("Todos"),
                                  value: "0",
                                ),
                              ],
                        onChanged: (value) {
                          setState(() {
                            combocorre = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: defaultpadding,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultpadding),
                    child: GestureDetector(
                      onTap: () {
                        filtrar();
                      },
                      child: Container(
                        height: _sc.getProportionateScreenHeight(40),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Realizar busqueda",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: _sc.getProportionateScreenHeight(14)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: defaultpadding,
                  ),
                ],
              ),
            ),
      )
    );
  }

  void initState() {
    super.initState();
    _corre = new List();
    _dptos = new List();
    _muni = new List();
    secretarias = new List();
    companias = new List();
    _instanciarSesion();
  }

  _instanciarSesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");
    id_user = spreferences.getString("id");
    this.listarsecretarias();
  }

  listarsecretarias() async {
    var response = await http.get(
        Uri.parse('${URL_SERVER}secretariasl?bd=${bd}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    this.setState(() {
      secretarias = reponsebody['secretarias'];
    });
  }

  filtrar() {
    
  }

}


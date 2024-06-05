import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmp/src/screens/geo/localizacion.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeoPage extends StatefulWidget {
  GeoPage({Key key}) : super(key: key);

  @override
  _GeoPageState createState() => _GeoPageState();
}

class _GeoPageState extends State<GeoPage> {
  SharedPreferences spreferences;
  String combosec;
  String comboval = "0";
  String combosecre = "0";
  List _corre;
  List _dptos;
  List _muni;
  List secretarias;
  String combomuni = "0";
  String combocorre = "0";
  String bd;
  String empresa;
  String id_user;
  LocationData _currentPosition;
  String _currentAddress;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Location location;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    SizeConfig _sc = SizeConfig();
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Geolocalización"),
          ),
          body: SingleChildScrollView(
              child: Padding(
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
                        "Geolocalización",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: _sc.getProportionateScreenHeight(15)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultpadding, vertical: defaultpadding),
                    child: Row(
                      children: <Widget>[
                        Text("Buscar por posición actual",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    _sc.getProportionateScreenHeight(14))),
                        Spacer(),
                        GestureDetector(
                            onTap: () {
                              //_getCurrentLocation();
                              obtenerposicion();
                            },
                            child: Icon(Icons.my_location, color: Colors.red)),
                      ],
                    ),
                  ),
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
                            listarmunicipios(comboval);
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
                            listarcorregimientos(value);
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
                        localizar();
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
          ))),
    );
  }

  @override
  void initState() {
    super.initState();
    _corre = new List();
    _dptos = new List();
    _muni = new List();
    secretarias = new List();
    instanciar_sesion();
  }

  Future<String> listarsecretarias() async {
    var response = await http.get(
        Uri.parse('${URL_SERVER}secretariasl?bd=${bd}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    this.setState(() {
      secretarias = reponsebody['secretarias'];
      //print(secretarias);
      //secretarias.insert(0,[{"idsecretarias": "0", "des_secretarias": "SECRETARIA DE SALUD"}]);

      //valur = (int.parse(reponsebody['rating']["total"]) / int.parse(reponsebody['rating']["todos"]));
    });
    return "Success!";
  }

  Future<String> listardepartamentos() async {
    var response = await http.get(
        Uri.parse('${URL_SERVER}departamentos?bd=${bd}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    this.setState(() {
      _dptos = reponsebody['dptos'];
      //print(_dptos);
      //valur = (int.parse(reponsebody['rating']["total"]) / int.parse(reponsebody['rating']["todos"]));
    });
    return "Success!";
  }

  Future<String> listarmunicipios(String id) async {
    var response = await http.get(
        Uri.parse('${URL_SERVER}municipios?bd=${bd}&id=${id}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    this.setState(() {
      _muni = reponsebody['muni'];
      //print(_muni);
      //valur = (int.parse(reponsebody['rating']["total"]) / int.parse(reponsebody['rating']["todos"]));
    });
    return "Success!";
  }

  Future<String> listarcorregimientos(String id) async {
    var response = await http.get(
        Uri.parse('${URL_SERVER}corregimientos?bd=${bd}&id=${id}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    this.setState(() {
      _corre = reponsebody['corregimientos'];
      //print(reponsebody['corregimientos']);
      //valur = (int.parse(reponsebody['rating']["total"]) / int.parse(reponsebody['rating']["todos"]));
    });
    return "Success!";
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");
    id_user = spreferences.getString("id");
    listarsecretarias();
    listardepartamentos();
    location = new Location();

    //_getCurrentLocation();
    //obtenerposicion();
  }

  obtenerposicion() async {
    //print("Obteniendo permisos");
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    var _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.DENIED) {
        return;
      }
    }

    print(_permissionGranted);

    await location.getLocation().then((onValue) {
      _currentPosition = onValue;
      //print(onValue.latitude.toString() + "," + onValue.longitude.toString());
      print(onValue);
      _getAddressFromLatLng();
    });
    //print(currentLocation);
  }

  /*_getCurrentLocation() {
    print("Obteniendo direccion");
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }*/

  _getAddressFromLatLng() async {
    print("Se que no voy a llorar no voy a reir");
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress = "${place.locality}, ${place.administrativeArea}";
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => LocalizacionPage(
                    tipo: "Geo",
                    dpto: place.administrativeArea,
                    muni: place.locality,
                    corre: combocorre,
                    secre: combosecre,
                  )),
        );
        //print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  localizar() {
    //print("Secretaria actual: ${combosecre}");
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => LocalizacionPage(
                tipo: "Busqueda",
                dpto: comboval,
                muni: combomuni,
                corre: combocorre,
                secre: combosecre,
              )),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/principal/principal.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as direccion;
import 'package:geolocator/geolocator.dart';

class CompaniasPage extends StatefulWidget {
  CompaniasPage({Key key}) : super(key: key);

  @override
  _CompaniasPageState createState() => _CompaniasPageState();
}

class _CompaniasPageState extends State<CompaniasPage> {
  SizeConfig _sc = SizeConfig();
  List companias;
  SharedPreferences spreferences;
  String email = "";
  String nombre = "";
  String imagen = "";
  LocationData _currentPosition;
  String _currentAddress;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Location location;
  String pais;
  String departamento;
  String ciudad;
  String address = "";
  double alto = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: size.height,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultpadding),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Entidades",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: _sc.getProportionateScreenHeight(
                                defaultpadding + 5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: defaultpadding,
                    ),
                    Container(
                      width: double.infinity,
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: companias == null ? 0 : companias.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(children: <Widget>[
                            //companias_carga(),
                            InkWell(
                              onTap: () {
                                ir(
                                    companias[index]['companias_id'].toString(),
                                    companias[index]['companias_login'],
                                    companias[index]['lat_ubic'],
                                    companias[index]['long_ubi'], 
                                    companias[index]['companias_descripcion']);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultpadding - 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      //                   <--- left side
                                      color: Colors.grey[300],
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Color.fromARGB(255, 165, 210, 247),
                                      radius: defaultpadding + 10,
                                      backgroundImage: NetworkImage(
                                        '${RUTA_IMAGEN}ImgEmpresa/${companias[index]['companias_img']}',
                                      ),
                                    ),
                                    title: Text(
                                      companias[index]['companias_descripcion']
                                                  .length >=
                                              79
                                          ? '${companias[index]['companias_descripcion'].substring(0, 1).toUpperCase()}${companias[index]['companias_descripcion'].substring(1, 79).toLowerCase()} '
                                          : '${companias[index]['companias_descripcion'].substring(0, 1).toUpperCase()}${companias[index]['companias_descripcion'].substring(1).toLowerCase()} ',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: _sc
                                            .getProportionateScreenHeight(16),
                                      ),
                                    ),
                                    subtitle: RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                        text:
                                            '${companias[index]['companias_dep']}',
                                        style: TextStyle(color: Colors.black54),
                                        /*children: [
                                          TextSpan(
                                              text:
                                                  '\n${companias[index]['fec_crea_proyect']}',
                                              style:
                                                  TextStyle(color: Colors.black54))
                                        ],*/
                                      ),
                                    )
                                    //Text('${proy[index1]['dtipol_proyec']}'),
                                    ),
                              ),
                            ),
                            /*Card(
                              child: InkWell(
                                onTap: () {
                                  ir(
                                      companias[index]['companias_id'].toString(),
                                      companias[index]['companias_login'],
                                      companias[index]['lat_ubic'],
                                      companias[index]['long_ubi']);
                                },
                                child: Image.network(
                                    '${RUTA_IMAGEN}ImgEmpresa/${companias[index]['companias_img']}'),
                              ),
                            ),*/
                          ]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              bottom: alto,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: size.width * 0.96,
                  height: _sc.getProportionateScreenHeight(200),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultpadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: defaultpadding,
                        ),
                        Text(
                          "Mi ubicación",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: defaultpadding - 5,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on, color: Colors.red[600]),
                            SizedBox(
                              width: defaultpadding - 5,
                            ),
                            Text(
                              "${ciudad}, ${departamento}",
                              style: TextStyle(fontSize: 17),
                            )
                          ],
                        ),
                        /*Text(
                          "Actualmente te encuentras en el municipio de ${ciudad} ¿Deseas usar la ubicación actual?",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 17),
                        ),*/
                        SizedBox(
                          height: defaultpadding - 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                validarexistencia();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultpadding,
                                    vertical: defaultpadding - 5),
                                decoration: BoxDecoration(
                                  color: kazulg,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "Usar ubicación",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                cerrarmodal();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultpadding,
                                    vertical: defaultpadding - 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "Escoger otra",
                                  style: TextStyle(color: kazulg, fontSize: 18),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: alto != 0
          ? FloatingActionButton(
              onPressed: () {
                abrirmodal();
              },
              child: const Icon(Icons.navigation),
              backgroundColor: Colors.green,
            )
          : Container(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    companias = [];
    instanciar_sesion();
    //print(300);
    alto = -600;
    getData();
  }

  Future<String> getData() async {
    var response = await http.get(
      Uri.parse('${URL_SERVER}companias'),
      headers: {"Accept": "application/json"}
    );

    final reponsebody = json.decode(response.body);
    this.setState(() {
      this.companias = reponsebody['companias'];
    });

    return "Success!";
  }

  ir(String id, String bd, String lat, String lng, String nombre) {
    spreferences.setString("bd", "gmp_" + bd);
    spreferences.setString("empresa", bd);
    spreferences.setString("lat", lat ?? '');
    spreferences.setString("lng", lng ?? '');
    spreferences.setString("id_emp", id);
    spreferences.setString("nombre_entidad", nombre);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrincipalPage(),
      ),
    );
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    location = new Location();
    setState(() {
      email = spreferences.getString("email");
      imagen = spreferences.getString("imagen");
      nombre = spreferences.getString("nombre");
    });
    obtenerposicion();
  }

  Widget companias_carga() {
    return SkeletonAnimation(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.14,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.0),
              color: Colors.grey[300]),
        ),
      ),
    );
  }

  obtenerposicion() async {
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

    await location.getLocation().then((onValue) {
      _currentPosition = onValue;
      obtenerdireccion(onValue);
    });
  }

  obtenerdireccion(onValue) async {
    List<dynamic> placemarks = await direccion.placemarkFromCoordinates(
        onValue.latitude, onValue.longitude);
    setState(() {
      pais = placemarks.first.country;
      departamento = placemarks.first.administrativeArea;
      ciudad = placemarks.first.locality;
      address = placemarks.first.name;
      alto = 0;
    });
  }

  cerrarmodal() {
    setState(() {
      alto = -1 * _sc.getProportionateScreenHeight(200);
    });
  }

  abrirmodal() {
    setState(() {
      alto = 0;
    });
  }

  validarexistencia() async {
    print("'${URL_SERVER}validarnombrecompania?nombre=${ciudad}'");
    var response = await http.get(
        Uri.parse('${URL_SERVER}validarnombrecompania?nombre=${ciudad}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    ir(
        reponsebody["companias"]['companias_id'].toString(),
        reponsebody["companias"]['companias_login'],
        reponsebody["companias"]['lat_ubic'],
        reponsebody["companias"]['long_ubi'],
        reponsebody["companias"]['companias_descripcion']);

    return "Success!";
  }
}

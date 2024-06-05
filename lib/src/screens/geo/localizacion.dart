import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/detalle_proyectos/detalleproyectos.dart';
import 'package:gmp/src/screens/geo/listadoproyectos.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LocalizacionPage extends StatefulWidget {
  final String dpto;
  final String muni;
  final String corre;
  final String secre;
  final String tipo;
  LocalizacionPage(
      {Key key, this.dpto, this.muni, this.corre, this.secre, this.tipo})
      : super(key: key);

  @override
  _LocalizacionPageState createState() => _LocalizacionPageState();
}

class _LocalizacionPageState extends State<LocalizacionPage> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  SharedPreferences spreferences;
  String secretaria = "Todos";
  String departamento = "Todos";
  String municipio = "Todos";
  String corregimiento = "Todos";
  String bd;
  String empresa;
  String id_user;
  List proyectos;
  int resultado = 0;
  String idActual;
  String descripcionActual = "";
  String fechaCreacion = "";
  String secretariaActual = "";
  String longActual = "";
  String latActual = "";
  double pinPillPosition = -400;

  Completer<GoogleMapController> _controller = Completer();
  var mapController;
  static final CameraPosition valledupar = CameraPosition(
    target: LatLng(4.570868, -74.297333),
    zoom: 12.4746,
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    SizeConfig _sc = SizeConfig();
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            "Geolocalización",
            style: TextStyle(color: kazuloscuro),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios, color: kazuloscuro),
          ),
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: valledupar,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  mapController = controller;
                  marcadores();
                },
                markers: Set<Marker>.of(markers.values),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: size.width,
                      child: Text(
                        "Criterios de la busqueda",
                        style: TextStyle(
                            fontSize: defaultpadding - 3,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: _sc.getProportionateScreenHeight(20),
                    ),
                    Container(
                      width: size.width,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Secretarías: ",
                            style: TextStyle(
                                fontSize: defaultpadding - 5,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            secretaria,
                            style: TextStyle(
                                fontSize: defaultpadding - 5,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _sc.getProportionateScreenHeight(3),
                    ),
                    Container(
                      width: size.width,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Departamento: ",
                            style: TextStyle(
                                fontSize: defaultpadding - 5,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            departamento,
                            style: TextStyle(
                                fontSize: defaultpadding - 5,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _sc.getProportionateScreenHeight(3),
                    ),
                    Container(
                      width: size.width,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Municipio: ",
                            style: TextStyle(
                                fontSize: defaultpadding - 5,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            municipio,
                            style: TextStyle(
                                fontSize: defaultpadding - 5,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _sc.getProportionateScreenHeight(3),
                    ),
                    Container(
                      width: size.width,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Corregimiento: ",
                            style: TextStyle(
                                fontSize: defaultpadding - 5,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            corregimiento,
                            style: TextStyle(
                                fontSize: defaultpadding - 5,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _sc.getProportionateScreenHeight(20),
                    ),
                    GestureDetector(
                      onTap: () {
                        _listado_proyectos();
                      },
                      child: Container(
                        child: Text(
                          "VER BUSQUEDA PROYECTOS EN LISTADO",
                          style: TextStyle(
                              fontSize: _sc.getProportionateScreenHeight(14),
                              fontWeight: FontWeight.w500,
                              color: Colors.blue[400]),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _sc.getProportionateScreenHeight(20),
                    ),
                    Container(
                      child: Text(
                          "Resultado de la busqueda (${resultado.toString()})",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: _sc.getProportionateScreenHeight(14),
                          )),
                    ),
                    SizedBox(
                      height: _sc.getProportionateScreenHeight(25),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: pinPillPosition,
              right: 0,
              left: 0,
              duration: Duration(milliseconds: 200),
              child: Container(
                margin: EdgeInsets.all(20),
                height: size.height * 0.3,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          blurRadius: 20,
                          offset: Offset.zero,
                          color: Colors.grey.withOpacity(0.5))
                    ]),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(10),
                      ),
                      GestureDetector(
                        onTap: () {
                          _cerrar();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Spacer(),
                              Text("X",
                                  style: TextStyle(fontWeight: FontWeight.w600))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(10),
                      ),
                      Text(
                        "Descripción del proyecto",
                        style: TextStyle(
                            fontSize: _sc.getProportionateScreenHeight(14),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(10),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          descripcionActual,
                          textAlign: TextAlign.justify,
                          style: TextStyle(),
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(10),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                "Fecha de creación: ",
                                style: TextStyle(
                                    fontSize:
                                        _sc.getProportionateScreenHeight(14),
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(fechaCreacion)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(20),
                      ),
                      GestureDetector(
                        onTap: () {
                          _irdetalles();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Click aquí para ver detalles",
                              style: TextStyle(color: Colors.blue[400])),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    proyectos = new List();
    instanciar_sesion();
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");
    id_user = spreferences.getString("id");
    //marcadores();
    nombres();

    //_getCurrentLocation();
    //obtenerposicion();
  }

  Future<String> nombres() async {
    var response = await http.get(
        Uri.parse(
            '${URL_SERVER}nombre_secretaria?bd=${bd}&dep=${widget.dpto}&muni=${widget.muni}&cor=${widget.corre}&id=${widget.secre}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    setState(() {
      if (widget.secre != "0") {
        secretaria = reponsebody['secretaria']['des_secretarias'];
      }

      if (widget.dpto != "0" && widget.tipo == "Busqueda") {
        departamento = reponsebody['dpto']['NOM_DPTO'];
      } else if (widget.dpto != "0") {
        departamento = widget.dpto;
      }

      if (widget.muni != "0" && widget.tipo == "Busqueda") {
        municipio = reponsebody['muni']['NOM_MUNI'];
      } else if (widget.muni != "0") {
        municipio = widget.muni;
      }

      if (widget.corre != "0" && widget.tipo == "Busqueda") {
        corregimiento = reponsebody['corre']['NOM_CORREGI'];
      } else if (widget.corre != "0") {
        corregimiento = widget.corre;
      }
    });
  }

  Future<String> marcadores() async {
    var markerId;
    Marker marker;
    LatLng _position;
    //GoogleMapController controller = await _controller.future;
    // print(widget.tipo);
    if (widget.tipo == "Geo") {
      print(
          '${URL_SERVER}geomarkerstexto?bd=${bd}&dep=${widget.dpto}&muni=${widget.muni}&cor=${widget.corre}&id=${widget.secre}');
      var response = await http.get(
          Uri.parse(
              '${URL_SERVER}geomarkerstexto?bd=${bd}&dep=${widget.dpto}&muni=${widget.muni}&cor=${widget.corre}&id=${widget.secre}'),
          headers: {"Accept": "application/json"});

      final reponsebody = json.decode(response.body);
      proyectos = reponsebody['proyectos'];
      for (var i = 0; i < proyectos.length; i++) {
        _position = LatLng(double.parse(proyectos[i]["lat_ubic"]),
            double.parse(proyectos[i]["long_ubi"]));
        markerId = MarkerId(proyectos[i]["id_proyect"].toString());
        marker = Marker(
          markerId: markerId,
          position: LatLng(double.parse(proyectos[i]["lat_ubic"]),
              double.parse(proyectos[i]["long_ubi"])),
          onTap: () {
            _onMarkerTapped(
                '${proyectos[i]["id_proyect"]}',
                proyectos[i]["nombre_proyect"],
                proyectos[i]["fec_crea_proyect"],
                '${proyectos[i]["lat_ubic"]}',
                '${proyectos[i]["long_ubi"]}');
          },
        );

        setState(() {
          // adding a new marker to map
          markers[markerId] = marker;
          resultado = proyectos.length;
        });
      }
      if (proyectos.length > 0) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _position,
              zoom: 14,
            ),
          ),
        );
      }
    } else {
      var response = await http.get(
          Uri.parse(
              '${URL_SERVER}geomarkers?bd=${bd}&dep=${widget.dpto}&muni=${widget.muni}&cor=${widget.corre}&id=${widget.secre}'),
          headers: {"Accept": "application/json"});

      final reponsebody = json.decode(response.body);
      proyectos = reponsebody['proyectos'];
      for (var i = 0; i < proyectos.length; i++) {
        _position = LatLng(double.parse(proyectos[i]["lat_ubic"]),
            double.parse(proyectos[i]["long_ubi"]));
        markerId = MarkerId(proyectos[i]["id_proyect"].toString());
        marker = Marker(
          markerId: markerId,
          position: LatLng(double.parse(proyectos[i]["lat_ubic"]),
              double.parse(proyectos[i]["long_ubi"])),
          onTap: () {
            _onMarkerTapped(
                proyectos[i]["id_proyect"].toString(),
                proyectos[i]["nombre_proyect"],
                proyectos[i]["fec_crea_proyect"],
                proyectos[i]["lat_ubic"].toString(),
                proyectos[i]["long_ubi"].toString());
          },
        );

        setState(() {
          // adding a new marker to map
          markers[markerId] = marker;
          resultado = proyectos.length;
        });
      }
      if (proyectos.length > 0) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _position,
              zoom: 14,
            ),
          ),
        );
      }
    }

    return "Success!";
  }

  _onMarkerTapped(String id_proyect, String nombre_proyect,
      String fec_crea_proyect, String lat_ubic, String long_ubi) {
    setState(() {
      idActual = id_proyect.toString();
      descripcionActual = nombre_proyect;
      fechaCreacion = fec_crea_proyect;
      latActual = lat_ubic;
      longActual = long_ubi;
      pinPillPosition = 0;
    });
  }

  _cerrar() {
    setState(() {
      pinPillPosition = -400;
    });
  }

  _irdetalles() {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => DetalleProyetcosPage(
                idproyect: idActual,
              )),
    );
  }

  _listado_proyectos() {
    if (widget.tipo == "Geo") {
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ListadoProyectos(
                tipo: widget.tipo,
                departamento: departamento,
                municipio: municipio,
                secretaria: secretaria,
                corregimiento: corregimiento)),
      );
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ListadoProyectos(
                tipo: widget.tipo,
                departamento: widget.dpto,
                municipio: widget.muni,
                corregimiento: widget.corre,
                secretaria: widget.secre)),
      );
    }
  }
}

/*
Container(
                        width: double.infinity,
                        child: Text(
                          "Criterios de la busqueda",
                          style: TextStyle(
                              fontSize: defaultpadding - 3,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(20),
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Secretarías: ",
                              style: TextStyle(
                                  fontSize: defaultpadding - 5,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              secretaria,
                              style: TextStyle(
                                  fontSize: defaultpadding - 5,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(3),
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Departamento: ",
                              style: TextStyle(
                                  fontSize: defaultpadding - 5,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              departamento,
                              style: TextStyle(
                                  fontSize: defaultpadding - 5,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(3),
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Municipio: ",
                              style: TextStyle(
                                  fontSize: defaultpadding - 5,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              municipio,
                              style: TextStyle(
                                  fontSize: defaultpadding - 5,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(3),
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Corregimiento: ",
                              style: TextStyle(
                                  fontSize: defaultpadding - 5,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              corregimiento,
                              style: TextStyle(
                                  fontSize: defaultpadding - 5,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(20),
                      ),
                      GestureDetector(
                        onTap: () {
                          _listado_proyectos();
                        },
                        child: Container(
                          child: Text(
                            "VER BUSQUEDA PROYECTOS EN LISTADO",
                            style: TextStyle(
                                fontSize: _sc.getProportionateScreenHeight(14),
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[400]),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(20),
                      ),
                      Container(
                        child: Text(
                            "Resultado de la busqueda (${resultado.toString()})",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: _sc.getProportionateScreenHeight(14),
                            )),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(25),
                      ),*/

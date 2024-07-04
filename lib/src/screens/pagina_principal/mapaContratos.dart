import 'dart:math';
import 'dart:typed_data';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gmp/src/screens/detalle_contratos/detallecontratos.dart';
import 'package:gmp/src/screens/pagina_principal/utils.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as formato;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart' as geo;
import 'dart:ui' as ui;
import 'package:label_marker/label_marker.dart';

class MapaContratosPage extends StatefulWidget {
  final int idProyecto;
  final String nombreProyecto;
  MapaContratosPage({Key key,  this.idProyecto, this.nombreProyecto}) : super(key: key);

  @override
  _MapaContratosPageState createState() => _MapaContratosPageState();
}

class _MapaContratosPageState extends State<MapaContratosPage> {
  
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(4.746066296247144, -74.06451278339043),
    zoom: 13.4746,
  );
  Set<Marker> markers = new Set();
  Uint8List customIcon;
  Uint8List customIconPosition;

  Location location;
  LocationData currentposition;


  SharedPreferences spreferences;
  String bd;
  String empresa;
  List<dynamic> listaContratos;

  final geo.Geolocator geolocator = geo.Geolocator()..forceAndroidLocationManager;
  double radio = 0;
  geo.Position posicion;
  Utils utils = new Utils(); 

  double alto = 0;
  SizeConfig _sc = SizeConfig();

  //detalle de contrato
  final oCcy = new formato.NumberFormat("#,##0", "es_CO");
  String idContrato = "";
  String numeroContrato = "";
  String objetoContrato = "";
  String contratista = "";
  String estado = "";
  double total = 0;
  String porAvance = "";
  int distancia = 0;

  bool loading = true;
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return BlurryModalProgressHUD(
      inAsyncCall: loading,
      blurEffectIntensity: 4,
      progressIndicator: Image.asset(
        'assets/images/gmp.gif',
        width: 200,
        height: 100,
      ),
      dismissible: false,
      opacity: 0.6,
      color: Colors.white,
      child: Container(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: kazul,
            title: Text("CONTRATOS RELACIONADOS", style: TextStyle(fontSize: 20)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
          ),
          body: Stack(
          children: [
            Container(
              width: double.infinity,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: markers,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              top: size.height * 0.15,
              left: size.width * 0.08,
              child: Container(
                width: size.width * 0.84,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.nombreProyecto,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kazul, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
             AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              top: size.height * 0.63,
              left: size.width * 0.08,
              child: Container(
                width: size.width * 0.84,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                            color: kazul,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text((numeroContrato).toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color.fromARGB(90, 169, 170, 170),
                                width: 2.0,
                              ),
                            ),
                          ),
                          width: size.width * 0.50,
                          child: Text(
                            objetoContrato, 
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kazul),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 2,
                      color: Color.fromARGB(90, 169, 170, 170),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.engineering, color: krosado,),
                        SizedBox(width: 5),
                        Container(
                          child: Text(
                            "Contr: ", 
                            style: TextStyle(fontSize: 13, color: krosado, fontWeight: FontWeight.bold),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          child: Text(
                            contratista, 
                            style: TextStyle(fontSize: 13, color: kazul),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.percent, color: knaranja,),
                        SizedBox(width: 5),
                        Container(
                          child: Text(
                            "Avance: ", 
                            style: TextStyle(fontSize: 13, color: knaranja, fontWeight: FontWeight.bold),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          child: Text(
                            porAvance, 
                            style: TextStyle(fontSize: 13, color: kazul),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5),
                        Container(
                          child: Text(
                            "\$", 
                            style: TextStyle(fontSize: 19, color: krojo, fontWeight: FontWeight.bold),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        SizedBox(width: 13),
                        Container(
                          child: Text(
                            "Valor: ", 
                            style: TextStyle(fontSize: 13, color: krojo, fontWeight: FontWeight.bold),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          child: Text(
                            "\$${oCcy.format(total)}", 
                            style: TextStyle(fontSize: 13, color: kazul),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.route, color: kverde,),
                        SizedBox(width: 10),
                        Container(
                          child: Text(
                             "Esta ubicado a "+distancia.toString()+" Mts.", 
                            style: TextStyle(fontSize: 11, color: kazul),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white,
                              width: 0.4,
                            ),
                            color: colorContarto(estado)
                          ),
                          child: Text(
                            estado,
                            style: TextStyle(
                              color: Colors.black, 
                              fontWeight: FontWeight.bold,
                              fontSize: 10
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: (size.height * 0.015)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => {
                            verContrato(idContrato)
                          },
                          child: Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.2,
                              ),
                              color: kverde
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.message, color: Colors.white),
                                SizedBox(width: 4),
                                Text("Detalles", style: TextStyle(color: Colors.white)),
                                SizedBox(width: 11),
                              ]
                            ) 
                          ),
                        )
                      ],
                    ),
                  ]
                ),
              ),
            )],
          )
        ),
      )
    );
  }


  @override
  void initState() {
    super.initState();
    location = new Location();
    _setIcon();
    cerrarmodal();
  }

  determinePosition() async {
    posicion = await geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.high
    );
  }

  colorContarto(estado){
    Color color;
    if (estado == "Ejecucion") {
      color = Color(0xFF2ED26E); 
    } else if (estado == "Terminado") {
      color = Color(0xFF387EFC); 
    } else if (estado == "Suspendido") {
      color = Color(0xFFEA4359);
    } else if (estado == "Liquidado") {
      color = Color(0xFFFDC20D);
    }
    return color;
  }

  int calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371.0;

    double lat1Rad = radians(point1.latitude);
    double lon1Rad = radians(point1.longitude);
    double lat2Rad = radians(point2.latitude);
    double lon2Rad = radians(point2.longitude);

    double dlon = lon2Rad - lon1Rad;
    double dlat = lat2Rad - lat1Rad;
    double a = sin(dlat / 2) * sin(dlat / 2) +cos(lat1Rad) * cos(lat2Rad) * sin(dlon / 2) * sin(dlon / 2);
    double c = 2 * asin(sqrt(a));
    double distanceInKm = earthRadius * c;
    double distanceInMeters = distanceInKm * 1000;
    return distanceInMeters.round(); 
  }

  double radians(double degrees) {
    return degrees * (pi / 180);
  }

  _setIcon() async {
    await determinePosition();
    customIcon =  await getBytesFromAsset('assets/images/Icon_Contract.png', 90);
    customIconPosition =  await getBytesFromAsset('assets/images/Icon_Position.png', 60);
    _determinePosition();
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }


  _determinePosition() async {
   
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
      currentposition = onValue;
      consultarContratos();
    });

  }

  consultarContratos() async{
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");

    var response = await http.get(
        Uri.parse('${URL_SERVER}contratos-proyectos?bd=${bd}&id=${widget.idProyecto.toString()}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    LatLng punto2 = LatLng(currentposition.latitude, currentposition.longitude);;
    var lista = [];

    setState(() {
      listaContratos = [];
      listaContratos = reponsebody['contratos'];
      if(listaContratos.length > 0){
        for (var x = 0; x < listaContratos.length; x++) {
          var punto1 = LatLng(double.parse(listaContratos[x]["lat_ubic"]), double.parse(listaContratos[x]["long_ubi"]));
          listaContratos[x]["distancia"] = calculateDistance(punto1, punto2);
        }
        mostrarContratoDetalle(listaContratos[0]);
      }
      markers.clear();
      _addMarkers();
    });
  }

  _addMarkers() {
    markers.add(Marker(
      //add first marker
      markerId: MarkerId("Mi posición"),
      position: LatLng(currentposition.latitude, currentposition.longitude),
      infoWindow: InfoWindow(
        //popup info
        title: "Mi posición",
        snippet: "Actual",
      ),
      icon: BitmapDescriptor.fromBytes(customIconPosition),
    ));
    for (var item in listaContratos) {
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(item["id_contrato"].toString()),
        position: LatLng(double.parse(item["lat_ubic"]), double.parse(item["long_ubi"])),
        icon: BitmapDescriptor.fromBytes(customIcon),
        onTap: () {
          mostrarContratoDetalle(item);
        }
      ));

      markers.addLabelMarker(LabelMarker(
        label: "# "+item["ncont"].toString(),
        markerId: MarkerId(item["id_contrato"].toString()+"l"),
        position: LatLng(double.parse(item["lat_ubic"]) + 0.003, double.parse(item["long_ubi"])),
        backgroundColor: kazul,
        )).then((value) {
          setState(() {});
        },
    );
    }
    calcularRadio();
  }

  calcularRadio() {   
    for (var item in listaContratos) {
      var dis = utils.calcularDistancia(posicion, double.parse(item["lat_ubic"]),  double.parse(item["long_ubi"]));
      if(dis >= radio){
        setState(() {
          radio = dis;
        });
      }
    }

    posicionNueva();
  }

  posicionNueva() async {
    await location.getLocation().then((onValue) {
        currentposition = onValue;
        const double offset = 0.010;
        final LatLng newCenter = LatLng(currentposition.latitude - offset, currentposition.longitude);
        _goToPosition(newCenter);
      });
  }

  Future<void> _goToPosition(LatLng posicion) async {
    final CameraPosition _kLake = CameraPosition(
      target: posicion,
      zoom: getZoomLevel(radio)
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));

    setState(() {
      loading = false;
    });
  }

  getZoomLevel(double radius) {
    radius = radius * 1000;
    double zoomLevel = 11;
    if (radius > 0) {
      double radiusElevated = radius + radius / 2;
      double scale = radiusElevated / 500;
      zoomLevel = 16 - log(scale) / log(2);
    }
    zoomLevel = num.parse(zoomLevel.toStringAsFixed(2));
    
    return zoomLevel;
  }

  cerrarmodal() {
    setState(() {
      alto = -1 * _sc.getProportionateScreenHeight(370);
    });
  }

  mostrarContratoDetalle(var item){
    setState(() { 
      idContrato = item["id_contrato"].toString();
      numeroContrato = item["ncont"];
      objetoContrato = item["obj"];
      contratista = item ["descontita"];
      estado = item["estado"];
      porAvance = item["porav_contrato"];
      total = double.parse(item["total"].toString());
      distancia = item["distancia"];
    });
  }

  verContrato(String idCon) {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => DetalleContratosPage(id_con: idCon)),
    );
  }

}

class CustomMarkerPainter extends CustomPainter {
  final String text;

  CustomMarkerPainter(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);
    final offset = Offset(0, 0);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
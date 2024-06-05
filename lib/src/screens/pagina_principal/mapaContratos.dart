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
            title: Center(child: Text("CONTRATOS RELACIONADOS")),
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
              bottom: alto,
              child: Container(
                height: 370,
                width: size.width,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child:  Column(
                  children : <Widget>[
                    Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.close),
                            tooltip: 'Cerrar ventana',
                            onPressed: () {
                              setState(() {
                                cerrarmodal();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                        child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(widget.nombreProyecto, maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kazul
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Scrollable(
                          // Wrap Scrollable around the entire content that you want to be scrollable
                          viewportBuilder: (BuildContext context, ViewportOffset offset) {
                            return Column(
                              children: [ Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: Container(
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 10),
                                        Text("Nº de contrato: "+numeroContrato, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                        Text("Objeto: "+objetoContrato, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 6),
                                        Text(contratista+" (contratista)"),
                                        SizedBox(height: 6),
                                        Text("Estado: "+estado),
                                        SizedBox(height: 6),
                                        Text("Avance: "+ porAvance),
                                        SizedBox(height: 6),
                                        Text("Valor: "+ "\$${oCcy.format(total)}")
                                      ],
                                    ),
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/images/swipe.gif',
                                          width: 50,
                                          height: 40,
                                        )
                                      ],
                                    ),
                                    ),
                                ),
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Ver detalle',
                                    color: kverde,
                                    icon: Icons.details_sharp,
                                    onTap: () => {
                                      verContrato(idContrato)
                                    },
                                  ),
                                ],
                              )
                              ]
                            );
                          }
                      )
                    )
                  ]
                )
              )),
            ],
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
        desiredAccuracy: geo.LocationAccuracy.high);
  }


  _setIcon() async {
    await determinePosition();
    customIcon =  await getBytesFromAsset('assets/images/Icon_Contract.png', 90);
    customIconPosition =  await getBytesFromAsset('assets/images/Icon_Position.png', 60);
    consultarContratos();
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
      _addMarkers();
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
    setState(() {
      listaContratos = [];
      listaContratos = reponsebody['contratos'];
      markers.clear();
      _determinePosition();
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

    _goToPosition(currentposition);
  }

  Future<void> _goToPosition(LocationData posicion) async {
    final CameraPosition _kLake = CameraPosition(
        target: LatLng(posicion.latitude, posicion.longitude),
        zoom: getZoomLevel(radio));

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
      alto = 0; 
      total = double.parse(item["total"].toString());
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
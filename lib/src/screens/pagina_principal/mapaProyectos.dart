import 'dart:async';
import 'dart:typed_data';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmp/src/screens/detalle_proyectos/detalleproyectos.dart';
import 'package:gmp/src/screens/pagina_principal/geolocalizacionFiltro.dart';
import 'package:gmp/src/screens/pagina_principal/mapaContratos.dart';
import 'package:gmp/src/screens/pagina_principal/utils.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

// ignore: must_be_immutable
class MapaProyectosPage extends StatefulWidget {
 
  final String idEntidad;
  final String bd;
  final String nombreEntidad;
  double radiusCircle;
  
  
  MapaProyectosPage(this.idEntidad, this.nombreEntidad, this.bd, this.radiusCircle,
      {Key key })
      : super(key: key);

  @override
  _MapaProyectosPagePageState createState() => _MapaProyectosPagePageState();
}

class _MapaProyectosPagePageState extends State<MapaProyectosPage> {
  
  String currentAddress = 'My Address';
  LocationData currentposition;
  Location location;
  Completer<GoogleMapController> _controller = Completer();


  List<dynamic> listaProyectos;
  List<dynamic> listaProyectosFiltrados;

  Set<Marker> markers = new Set();
  Set<Circle> circles = new Set();
  Uint8List  customIcon;
  double alto = 0;

  SizeConfig _sc = SizeConfig();
  Utils utils = new Utils(); 

  SharedPreferences spreferences;
  
  final geo.Geolocator geolocator = geo.Geolocator()..forceAndroidLocationManager;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(4.746066296247144, -74.06451278339043),
    zoom: 13.4746,
  );

  bool loading = true;

  @override
  void initState() {
    super.initState();
    location = new Location();
    listaProyectosFiltrados = [];
    _setIcon();
    cerrarmodal();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    SizeConfig _sc = SizeConfig();
    return new BlurryModalProgressHUD(
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
      child: Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: kazul,
        title: Center(child: Text("PROYECTOS RELACIONADOS", style: TextStyle(fontSize: 15),)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child:GestureDetector(
              onTap: () {
                mostrarcaja(context);
              },
              child: Icon(
                Icons.filter_alt
              ),
            ), 
          )
          
        ],
      ),
      body:Stack(
        children: [
          Container(
            width: double.infinity,
            child: GoogleMap(
              mapType: MapType.normal,
              circles: circles,
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
              height: 650,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.nombreEntidad, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: kazul))
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Proyectos en la posición seleccionada", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black))
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    height: 450,
                    color: Colors.white,
                    child:  ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: listaProyectosFiltrados.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Container(
                                child: ListTile(
                                  leading: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: kazul,
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text((index+1).toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                  title: Text(listaProyectosFiltrados[index]["nombre_proyect"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  subtitle: Text(listaProyectosFiltrados[index]["dsecretar_proyect"], style: TextStyle(fontSize: 11)),
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
                                  caption: 'Contratos',
                                  color: Colors.blue,
                                  icon: Icons.archive,
                                  onTap: () => {
                                    verContratos(listaProyectosFiltrados[index]["id_proyect"], listaProyectosFiltrados[index]["nombre_proyect"])
                                  },
                                ),
                                IconSlideAction(
                                  caption: 'Ver detalle',
                                  color: kverde,
                                  icon: Icons.details_sharp,
                                  onTap: () => {
                                    verDetalle(listaProyectosFiltrados[index]["id_proyect"].toString())
                                  },
                                ),
                              ],
                            );
                      }
                    )
                  )
                ]
              ),
            )
          ),
        ]
      ),
    ));
  }


  _setIcon() async {
    customIcon =  await getBytesFromAsset('assets/images/Icon_Project.png', 90);
    _listarProyectos();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

   _listarProyectos() async {
   
    listaProyectos = [];
    var response = await http.get(
        Uri.parse('${URL_SERVER}listar_proyectos_mapa?bd=gmp_${widget.bd}'),
        headers: {"Accept": "application/json"});

    var reponsebody = json.decode(response.body);
    print(reponsebody);
      
    setState(() {
      listaProyectos = reponsebody['proyectos'];
      filtrarProyectos();
    });
  }

   filtrarProyectos() async {
    if(widget.radiusCircle != 0){
      List<dynamic> filtrado = [];
      geo.Position posicion = await this.determinePosition();
      for (var x = 0; x < listaProyectos.length; x++) {
        var dis = utils.calcularDistancia(posicion, double.parse(listaProyectos[x]["lat_ubic"]),  double.parse(listaProyectos[x]["long_ubi"]));
        if( dis < (widget.radiusCircle/1000)){
          filtrado.add(listaProyectos[x]);
        }
      }
      setState(() {
        listaProyectos = filtrado;
        markers.clear();
        _determinePosition();
      });
    }else{
      setState(() {
        markers.clear();
        _determinePosition();
      });
    }
  }

  Future<geo.Position> determinePosition() async {
    geo.Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);
    return position;
  }

  Future<void>  _generateCircle() async {
    circles = Set.from([
      Circle(
          circleId: CircleId("myCircle"),
          radius: widget.radiusCircle,
          center: LatLng(currentposition.latitude, currentposition.longitude),
          fillColor: Color.fromARGB(22, 234, 45, 174),
          strokeColor: Color.fromARGB(125, 233, 11, 170),
          strokeWidth: 2)
    ]);
    setState(() {
      loading = false;
    });
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
      _goToPosition(currentposition);
    });

  }

  

  Future<void> _goToPosition(LocationData posicion) async {
    final CameraPosition _kLake = CameraPosition(
        target: LatLng(posicion.latitude, posicion.longitude),
        zoom: getZoomLevel(widget.radiusCircle));

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    setState(() {
      _addMarkers();
    });
  }

  void _addMarkers() {
    markers.add(Marker(
      //add first marker
      markerId: MarkerId("Mi posición"),
      position: LatLng(currentposition.latitude, currentposition.longitude),
      infoWindow: InfoWindow(
        //popup info
        title: "Mi posición",
        snippet: "Actual",
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));

    for (var item in listaProyectos) {
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(item["id_proyect"].toString()),
        position: LatLng(double.parse(item["lat_ubic"]), double.parse(item["long_ubi"])),
        icon: BitmapDescriptor.fromBytes(customIcon),
        onTap: () {
          mostrarProyectos(double.parse(item["lat_ubic"]), double.parse(item["long_ubi"]));
        }
      ));
    }
    _generateCircle();
  }

  double getZoomLevel(double radius) {
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
      alto = -1 * _sc.getProportionateScreenHeight(680);
    });
  }

  mostrarProyectos(double lat, double long){
    var lista = [];
    for (var x = 0; x < listaProyectos.length; x++) {
      if( lat ==   double.parse(listaProyectos[x]["lat_ubic"]) && long == double.parse(listaProyectos[x]["long_ubi"])){
        lista.add(listaProyectos[x]);
      }
    }
    setState(() { 
      listaProyectosFiltrados = [];
      listaProyectosFiltrados = lista;
      alto = 0;
    });
  }

  verDetalle(String idProyecto) async {
    spreferences = await SharedPreferences.getInstance();
    spreferences.setString("bd", "gmp_"+widget.bd);
    spreferences.setString("empresa", widget.bd);
     Navigator.push(
      this.context,
      CupertinoPageRoute(
          builder: (context) => DetalleProyetcosPage(idproyect: idProyecto)),
    );
  }

  verContratos(int idP, String nombre) async {
    spreferences = await SharedPreferences.getInstance();
    spreferences.setString("bd", "gmp_"+widget.bd);
    spreferences.setString("empresa", widget.bd);
     Navigator.push(
      this.context,
      CupertinoPageRoute(
          builder: (context) => MapaContratosPage(idProyecto: idP, nombreProyecto: nombre)),
    );
  }

  mostrarcaja(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return GeolocalizacionFiltro();
    }).whenComplete(() {

    });
  }
}
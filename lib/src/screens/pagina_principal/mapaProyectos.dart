import 'dart:async';
import 'dart:typed_data';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
import 'dart:math' show cos, sqrt, sin, asin;

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
  double derecha = -800;

  SizeConfig _sc = SizeConfig();
  Utils utils = new Utils(); 

  SharedPreferences spreferences;
  
  final geo.Geolocator geolocator = geo.Geolocator()..forceAndroidLocationManager;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(4.746066296247144, -74.06451278339043),
    zoom: 13.4746,
  );

  bool loading = true;

  String combosecre = "0";
  List secretarias = [];

  Size size;

  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    location = new Location();
    listaProyectosFiltrados = [];
    _setIcon();
    _listarSecretarias();
    _currentSliderValue = widget.radiusCircle / 1000;
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    size = MediaQuery.of(context).size;
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
        backgroundColor: Colors.white,
        title: Center(
          child: Column(
            children: [
              Text(widget.nombreEntidad, style: TextStyle(fontSize: 18, color: kazul)),
              SizedBox(height: 5),
              Text("PROYECTOS RELACIONADOS", style: TextStyle(fontSize: 13, color: kazul)),
            ]
          ),
        ),
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
                _abrirFiltros();
              },
              child: Icon(
                Icons.filter_alt,
                color: kazul,
              ),
            ), 
          )
        ],
        iconTheme: IconThemeData(color: kazul),
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
              zoomControlsEnabled: false, 
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            top: size.height * 0.62,
            child: Container(
              height: 290,
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10)
              ),
              child:  Column(
                children : <Widget>[
                  Container(
                    height: 290,
                    color: Colors.transparent,
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        height: size.height * 0.25,
                        enlargeCenterPage: true,
                        autoPlay: false,
                        aspectRatio: 16 / 9,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.8,
                      ),
                      itemCount: listaProyectosFiltrados.length,
                      itemBuilder: (BuildContext context, int itemIndex) =>
                        Container(
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
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: kazul,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text((itemIndex+1).toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
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
                                    width: size.width * 0.57,
                                    child: Text(
                                      listaProyectosFiltrados[itemIndex]["nombre_proyect"], 
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kazul),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                height: 2,
                                color: Color.fromARGB(90, 169, 170, 170),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.account_balance, color: krosado,),
                                  SizedBox(width: 10),
                                  Container(
                                    child: Text(
                                      listaProyectosFiltrados[itemIndex]["dsecretar_proyect"], 
                                      style: TextStyle(fontSize: 11, color: kazul),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.route, color: kamarillo,),
                                  SizedBox(width: 10),
                                  Container(
                                    child: Text(
                                      "Esta ubicado a "+listaProyectosFiltrados[itemIndex]["distancia"].toString()+" Mts.", 
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
                                      color: colorProyecto(listaProyectosFiltrados[itemIndex]["estado_proyect"])
                                    ),
                                    child: Text(
                                      listaProyectosFiltrados[itemIndex]["estado_proyect"],
                                      style: TextStyle(
                                        color: Colors.black, 
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: (size.height * 0.01)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => {
                                      verContratos(listaProyectosFiltrados[itemIndex]["id_proyect"], listaProyectosFiltrados[itemIndex]["nombre_proyect"])
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.2,
                                        ),
                                        color: kazuloscuro
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.archive, color: Colors.white),
                                          SizedBox(width: 4),
                                          Text("Contratos", style: TextStyle(color: Colors.white),)
                                        ]
                                      ) 
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => {
                                      verDetalle(listaProyectosFiltrados[itemIndex]["id_proyect"].toString())
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
                        )
                    )
                  )
                ]
              ),
            )
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            right: derecha,
            top: size.height * 0.12,
            child: Container(
              color: Colors.white,
              height: size.height,
              width: size.width * 0.8,
              padding: EdgeInsets.only(top: 00),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: _sc.getProportionateScreenHeight(70),
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.blue[800]),
                    child: Center(
                      child: Text(
                        "Filtrar Proyectos",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: _sc.getProportionateScreenHeight(18)),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
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
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: <Widget>[
                      Text("Cambiar un rango de búsqueda en KM",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  _sc.getProportionateScreenHeight(14))),
                      SizedBox(
                        height: 10,
                      ),
                      Slider(
                        value: _currentSliderValue,
                        max: 5,
                        divisions: 10,
                        label: _currentSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        width: double.infinity,
                        child: Column (
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                          Text(_currentSliderValue != 0 ? "(Rango de busqueda "+ _currentSliderValue.toString()+" KM)" : "Todos"),
                        ]),
                      ),
                      SizedBox(height: 70),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => {
                              _listarProyectos2()
                            },
                            child: Container(
                              width: size.width * 0.6,
                              height: 50,
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.2,
                                ),
                                color: kamarillo
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.filter_alt_sharp, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text("Aplicar filtros", style: TextStyle(fontSize: 16,color:Colors.white)),
                                ]
                              ) 
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () => {
                              setState((){
                                _currentSliderValue = widget.radiusCircle / 1000;
                                combosecre = "0";
                                derecha = -800;
                                loading = true;
                                _listarProyectos();
                              })
                            },
                            child: Container(
                              width: size.width * 0.6,
                              height: 50,
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.2,
                                ),
                                color: krojo
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cleaning_services, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text("Borrar filtros", style: TextStyle(fontSize: 16,color:Colors.white)),
                                ]
                              ) 
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ])
            ),
          )
        ]
      ),
    ));
  }

  _setIcon() async {
    customIcon =  await getBytesFromAsset('assets/images/Icon_Project.png', 70);
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
      const double offset = 0.015;
      final LatLng newCenter = LatLng(currentposition.latitude - offset, currentposition.longitude);
      _goToPosition(newCenter);
    });

  }

  Future<void> _goToPosition(LatLng posicion) async {
    final CameraPosition _kLake = CameraPosition(
      target: posicion,
      zoom: getZoomLevel(widget.radiusCircle)
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    
    LatLng punto2 = LatLng(currentposition.latitude, currentposition.longitude);;
    var lista = [];
    
    for (var x = 0; x < listaProyectos.length; x++) {
      var punto1 = LatLng(double.parse(listaProyectos[x]["lat_ubic"]), double.parse(listaProyectos[x]["long_ubi"]));
      listaProyectos[x]["distancia"] = calculateDistance(punto1, punto2);
      lista.add(listaProyectos[x]);
    }

    setState(() {
      _addMarkers();
      listaProyectosFiltrados = [];
      listaProyectosFiltrados = lista;
    });
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

  mostrarProyectos(double lat, double long){
    var lista = [];
    for (var x = 0; x < listaProyectos.length; x++) {
      if( lat ==   double.parse(listaProyectos[x]["lat_ubic"]) && long == double.parse(listaProyectos[x]["long_ubi"])){
        lista.add(listaProyectos[x]);
      }
    }
    setState(() { 
      alto = 300;
      listaProyectosFiltrados = [];
      listaProyectosFiltrados = lista;
    });
  }

  colorProyecto(estado){
    Color color;
    if (estado == "En Ejecucion") {
      color = Color(0xFF2ED26E); // Green color
    } else if (estado == "Ejecutado") {
      color = Color(0xFF387EFC); // Blue color
    } else if (estado == "Priorizado") {
      color = Color(0xFF1BBC9B); // Teal color
    } else if (estado == "Radicado") {
      color = Color(0xFFEA4359); // Red color
    } else if (estado == "Registrado") {
      color = Color(0xFFFDC20D); // Yellow color (same for both states)
    } else if (estado == "No Viabilizado") {
      color = Color(0xFFFDC20D); // Yellow color (same for both states)
    }

    return color;
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

  _abrirFiltros(){
    setState(() {
      if(derecha == 0){
        derecha = -800;
      }else{
        derecha = 0;
      }
    });
  }

  _listarSecretarias() async {
    var response = await http.get(
      Uri.parse('${URL_SERVER}secretariasl?bd=gmp_${widget.bd}'),
      headers: {"Accept": "application/json"}
    );

    final reponsebody = json.decode(response.body);

    this.setState(() {
      secretarias = reponsebody['secretarias'];
    });
  }

  _listarProyectos2() async {
    setState(() {
      loading = true;
    });
    listaProyectos = [];
    var response = await http.get(
        Uri.parse('${URL_SERVER}listar_proyectos_mapa?bd=gmp_${widget.bd}'),
        headers: {"Accept": "application/json"});

    var reponsebody = json.decode(response.body);
      
    setState(() {
      listaProyectos = reponsebody['proyectos'];
      filtrarProyectos2();
    });
  }

  filtrarProyectos2() async {
    if(_currentSliderValue != 0){
      List<dynamic> filtrado = [];
      geo.Position posicion = await this.determinePosition();
      for (var x = 0; x < listaProyectos.length; x++) {
        var dis = utils.calcularDistancia(posicion, double.parse(listaProyectos[x]["lat_ubic"]),  double.parse(listaProyectos[x]["long_ubi"]));
          if(combosecre != "0"){
            if( dis < (_currentSliderValue) && listaProyectos[x]["secretaria_proyect"] == combosecre){
              filtrado.add(listaProyectos[x]);
            }
          }else{
            if( dis < (_currentSliderValue)){
              filtrado.add(listaProyectos[x]);
            }
          }
      }
      setState(() {
        listaProyectos = filtrado;
        markers.clear();
        _determinePosition2();
      });
    }
  }

  _determinePosition2() async {
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
      const double offset = 0.015;
      final LatLng newCenter = LatLng(currentposition.latitude - offset, currentposition.longitude);
      _goToPosition2(newCenter);
    });

  }

  Future<void> _goToPosition2(LatLng posicion) async {
    final CameraPosition _kLake = CameraPosition(
      target: posicion,
      zoom: getZoomLevel(_currentSliderValue * 1000)
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    
    LatLng punto2 = LatLng(currentposition.latitude, currentposition.longitude);;
    var lista = [];
    
    for (var x = 0; x < listaProyectos.length; x++) {
      var punto1 = LatLng(double.parse(listaProyectos[x]["lat_ubic"]), double.parse(listaProyectos[x]["long_ubi"]));
      listaProyectos[x]["distancia"] = calculateDistance(punto1, punto2);
      lista.add(listaProyectos[x]);
    }

    setState(() {
      _addMarkers2();
      listaProyectosFiltrados = [];
      listaProyectosFiltrados = lista;
    });
  }

  void _addMarkers2() {
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
    _generateCircle2();
  }

  Future<void>  _generateCircle2() async {
    circles = Set.from([
      Circle(
          circleId: CircleId("myCircle"),
          radius: _currentSliderValue * 1000,
          center: LatLng(currentposition.latitude, currentposition.longitude),
          fillColor: Color.fromARGB(22, 234, 45, 174),
          strokeColor: Color.fromARGB(125, 233, 11, 170),
          strokeWidth: 2)
    ]);
    setState(() {
      loading = false;
    });
  }

}
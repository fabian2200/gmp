import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/pagina_principal/mapaProyectos.dart';
import 'package:gmp/src/screens/pagina_principal/utils.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as direccion;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:permission_handler/permission_handler.dart' as pn;


class GeolocalizacionNueva extends StatefulWidget {
  GeolocalizacionNueva({Key key}) : super(key: key);

  @override
  _CGeolocalizacionNuevaPageState createState() => _CGeolocalizacionNuevaPageState();
}

class _CGeolocalizacionNuevaPageState extends State<GeolocalizacionNueva> {
 
  SharedPreferences spreferences;
  List companias;
  LocationData currentPosition;
  final geo.Geolocator geolocator = geo.Geolocator()..forceAndroidLocationManager;
  Location location;
  String pais = "";
  String departamento = "";
  String ciudad = "";
  String address = "";
  String entidadNombre = "";
  String nombre = "";
  String imagen = "";

  List entidadesInfo = [];
  List entidadesInfoOriginal = [];

  final oCcy = new NumberFormat("#,##0", "es_CO");
  Random random = new Random();
  double _currentSliderValue = 2;
  bool loading = false;
  Utils utils = new Utils(); 

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    SizeConfig _sc = SizeConfig();
    return  BlurryModalProgressHUD(
      inAsyncCall: loading,
      blurEffectIntensity: 4,
      progressIndicator: Image.asset(
        'assets/images/gmp.gif',
        width: 200,
        height: 100,
      ),
      dismissible: false,
      opacity: 0.9,
      color: Colors.white,
      child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children:<Widget> [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultpadding),
                height: size.height * 0.1,
                width: double.infinity,
                decoration: BoxDecoration(),
                child: Row(
                  children: [
                    SizedBox(
                      width: defaultpadding - 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Bienvenido",
                          style: TextStyle(
                              fontSize:
                                  _sc.getProportionateScreenHeight(18)),
                        ),
                        Text(
                          nombre,
                          style: TextStyle(
                              fontSize:
                                  _sc.getProportionateScreenHeight(19),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      height: _sc.getProportionateScreenHeight(50),
                      width: _sc.getProportionateScreenHeight(50),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imagen == "noimage" || imagen == null
                                ? NetworkImage(
                                    "${URLROOT}/images/noimage.png")
                                : NetworkImage(
                                    "${URLROOT}/images/foto/${imagen}"),
                            fit: BoxFit.cover),
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(25),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kverde,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3)
                    ),
                  ],
                ),
                child:  ExpansionCard(
                  margin: EdgeInsets.only(top: 0),
                  title:  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: _sc.getProportionateScreenHeight(40),
                          width: double.infinity,
                          decoration: BoxDecoration(color: kverde),
                          padding: EdgeInsets.only(top: 10),
                          child:  Text(
                            "PARÁMETROS DE BÚSQUEDA",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: _sc.getProportionateScreenHeight(15)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  children: <Widget>[ 
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      ),
                      child: Column(
                      children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 32, left: 32),
                            width: double.infinity,
                            child: Row (
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                              Text("Pais: "+ pais, style: TextStyle(fontWeight: FontWeight.w800)),
                            ]),
                          ),
                          SizedBox(height: 10),  
                          Container(
                            padding: const EdgeInsets.only(left: 32),
                            width: double.infinity,
                            child: Row (
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                              Text("Departamento: "+departamento, style: TextStyle(fontWeight: FontWeight.w800)),
                            ]),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.only(left: 32),
                            width: double.infinity,
                            child: Row (
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                              Text("Ciudad: "+ciudad, style: TextStyle(fontWeight: FontWeight.w800)),
                            ]),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.only(left: 32),
                            width: double.infinity,
                            child: Row (
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                              Text("Dirección: "+address, style: TextStyle(fontWeight: FontWeight.w800)),
                            ]),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
                            child: Column(
                              children: <Widget>[
                                Text("Seleccione un rango de búsqueda en KM",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
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
                                      filtrarProyectos();
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 12),
                            width: double.infinity,
                            child: Column (
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                              Text(_currentSliderValue != 0 ? "(Rango de busqueda "+ _currentSliderValue.toString()+" KM)" : "Todos"),
                            ]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                      ],
                    ),
                  )
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              child: Column(
                children: <Widget>[
                  _generarCards()
                ],
              )
            )
          ]
        )
      ),
      )
    ));
  }

  @override
  void initState() {
    super.initState();
    companias = [];
    instanciarSesion();
  }

  instanciarSesion() async {
   
    setState(() {
      loading = true;
    });
    
    spreferences = await SharedPreferences.getInstance();
    setState(() {
      imagen = spreferences.getString("imagen");
      nombre = spreferences.getString("nombre");
    });
    location = new Location();
    obtenerposicion();
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

    await requestPermissions(); 

    await location.getLocation().then((onValue) {
      currentPosition = onValue;
      obtenerdireccion(onValue);
    });

  }

  Future<void> requestPermissions() async {
    var status = await pn.Permission.notification.status;
    if (!status.isGranted) {
      var concedio = await pn.Permission.notification.request();
      if (concedio.isGranted) {
        print('Location permission granted.');
      } else {
        print('Location permission denied.');
      }
    }
  }

  obtenerdireccion(onValue) async {
    List<dynamic> placemarks = await direccion.placemarkFromCoordinates(
        onValue.latitude, onValue.longitude);
    setState(() {
      pais = placemarks.first.country;
      departamento = placemarks.first.administrativeArea;
      ciudad = placemarks.first.locality;
      address = placemarks.first.street;
      validarexistencia();
    });
    
  }

  _generarCards(){

    SizeConfig().init(context);
    SizeConfig _sc = SizeConfig();

    return  Container(
            child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: entidadesInfo.length == 0 ? 0 : entidadesInfo.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
              children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kazul,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3)
                    ),
                  ],
                ),
                child: ExpansionCard(
                  initiallyExpanded: true,
                  margin: EdgeInsets.only(top: 0),
                  title: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: _sc.getProportionateScreenHeight(40),
                          width: double.infinity,
                          decoration: BoxDecoration(color: kazul),
                          padding: EdgeInsets.only(top: 10),
                          child:  Text(
                            entidadesInfo[index]['item']['companias_descripcion'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: _sc.getProportionateScreenHeight(15)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  children: <Widget> [ 
                    Column(
                    children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: entidadesInfo[index]['secretarias'].length == null ? 0 : entidadesInfo[index]['secretarias'].length,
                            itemBuilder: (BuildContext context, int index2) {
                              return InkWell(
                                onTap: () {
                                  
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
                                          color: Color(
                                            (random.nextDouble() * 0xFFFFFF).toInt()
                                          ).withOpacity(0.4),
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
                                            "${entidadesInfo[index]['secretarias'][index2]['des_secretarias']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "Presupuesto: \$${oCcy.format(entidadesInfo[index]['secretarias'][index2]['valor'])}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green[800]),
                                          ),
                                          Text(
                                            "Comprometido:  \$${oCcy.format(entidadesInfo[index]['secretarias'][index2]['comprometido'])}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.red[600]),
                                          ),
                                          Text(
                                            "Proyectos: ${entidadesInfo[index]['secretarias'][index2]['cp']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[600]),
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
                    Container(
                      padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        color: Colors.white,
                      ),
                      height: 70,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: InkWell( 
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  MapaProyectosPage(entidadesInfo[index]['item']['companias_id'].toString(),  entidadesInfo[index]['item']['companias_descripcion'],  entidadesInfo[index]['item']['companias_login'], _currentSliderValue*1000),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 245, 138, 51),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon( Icons.my_location, color:  Colors.white),
                                    SizedBox(width: 3,),
                                    Text("Ver proyectos en mapa", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))
                                  ],
                                )
                              )
                            )
                          ),
                        ],
                      ),
                    )
                    ],
                  )],
                )),
                SizedBox(
                  height: 30
                )
              ]
            );
          })
        );
  }


  validarexistencia() async {
    
    var response = await http.get(
        Uri.parse('${URL_SERVER}validarnombrecompania2?nombre=$ciudad'),
        headers: {"Accept": "application/json"});

    var reponsebody = json.decode(response.body);

    List companias = reponsebody['companias'];

    if(companias.length > 0){
      for (var item in companias) {
        obtenerSecertarias(item['companias_login'], item);
      }
    }else{
      setState(() {
        loading = false;
      });
    }
  }

  obtenerSecertarias(String bd, var item) async {
    bd = "gmp_"+bd;
    var response = await http.get(
        Uri.parse('${URL_SERVER}listadosecretarias2?bd=${bd}'),
        headers: {"Accept": "application/json"});

    var reponsebody = json.decode(response.body);

    var secretarias = reponsebody['secretarias'];

    agregarLista(item, secretarias);

  }

  filtrarProyectos() async {
    
    setState(() {
      loading = true;
    });

    try {
      entidadesInfo = [];
      entidadesInfo.addAll(entidadesInfoOriginal);
      geo.Position posicion = await this.determinePosition();
      for (var x = 0; x < entidadesInfo.length; x++) {
        for (var y = 0; y < entidadesInfo[x]["secretarias"].length; y++) {
          entidadesInfo[x]["secretarias"][y]["cp"] = entidadesInfo[x]["secretarias"][y]["proyects"].length;
          if(_currentSliderValue != 0){
            for (var z = 0; z < entidadesInfo[x]["secretarias"][y]["proyects"].length; z++) {
              var proyecto = entidadesInfo[x]["secretarias"][y]["proyects"][z];
              var dis = utils.calcularDistancia(posicion, double.parse(proyecto["lat_ubic"]),  double.parse(proyecto["long_ubi"]));
              if( dis > _currentSliderValue){
                setState(() {
                  entidadesInfo[x]["secretarias"][y]["cp"] =  entidadesInfo[x]["secretarias"][y]["cp"] - 1;
                }); 
              }
            }
          }else{
            setState(() {
              entidadesInfo[x]["secretarias"][y]["cp"] = entidadesInfo[x]["secretarias"][y]["proyects"].length;
              loading = false;
            });
          }
        }
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
    }
    
  }

  Future<geo.Position> determinePosition() async {
    geo.Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);
    return position;
  }

 

  agregarLista( var item, var secretariasAsoc){
    var json = {
      "item": item,
      "secretarias": secretariasAsoc
    };


    setState(() {
      entidadesInfo.add(json);
      entidadesInfoOriginal.add(json);
      _generarCards();
      loading = false;
    });
  }
}

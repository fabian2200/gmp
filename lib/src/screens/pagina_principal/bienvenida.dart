import 'package:flutter/material.dart';
import 'package:gmp/src/providers/push_notification_provider.dart';
import 'package:gmp/src/screens/companias/companias.dart';
import 'package:gmp/src/screens/notificaciones/notificaciones.dart';
import 'package:gmp/src/screens/pagina_principal/geolocalizacionNueva.dart';
import 'package:gmp/src/screens/perfil/perfil.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BienvenidaPage extends StatefulWidget {
  BienvenidaPage({Key key}) : super(key: key);

  @override
  _BienvenidaPageState createState() => _BienvenidaPageState();
}

class _BienvenidaPageState extends State<BienvenidaPage> {
  SharedPreferences spreferences;
  int _currentIndex = 0;
  bool notificaciones = false;
  int numeroNotificaciones = 0;
  List notificacionesListaNoLeidas;

  bool not = false;


  
  final List<Widget> _children = [
    GeolocalizacionNueva(),
    CompaniasPage(),
    PerfilPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            leading: Container(
              padding: EdgeInsets.only(top: 20, left: 15),
              child: Text("GMP", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kazul))),
            toolbarHeight: 60,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            actions: [
              Container( 
                margin: EdgeInsets.only(top: 15, right: 30),
                child: GestureDetector(
                  onTap: (() => 
                    onTabTapped2()
                  ),
                    child: Stack(
                    children: <Widget>[
                      Icon(
                        not == false ? Icons.notifications_none: Icons.notifications,
                        color: Colors.grey[600],
                        size: 30,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          child: Text(numeroNotificaciones.toString(), style: TextStyle(color: Colors.white, fontSize: 10)),
                          alignment: Alignment.center,
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: kazul,
                            shape: BoxShape.circle
                          ),
                        ),
                      )
                    ],
                  )
                )
              )
            ],
          ),
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.white,
            buttonBackgroundColor: kazuloscuro,
            color: kazuloscuro,
            height: 60,
            items: const <Widget>[
              Icon(
                Icons.home,
                size: 33,
                color: Colors.white,
              ),
              Icon(
                Icons.store_mall_directory_rounded,
                size: 33,
                color: Colors.white,
              ),
              Icon(
                Icons.person_outline,
                size: 33,
                color: Colors.white,
              ),
            ],
            onTap: onTabTapped
          ),
          body: not == true? NotificacionesPage(): _children[_currentIndex]),
    );
  }

  void onTabTapped(int index) async {
    setState(() {
      not = false;
      _currentIndex = index;
    });

    await consultarNotificaciones();
  }

  void onTabTapped2() async {
    if(not == false){
      await consultarNotificaciones();
      setState(() {
        not = true;
      });
    }else{
      await consultarNotificaciones();
      setState(() {
        not = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final pushProvidern = new PushNotificationProvider();
    pushProvidern.initNotificaciones();
    pushProvidern.mensajes.listen((event) {
      MotionToast(
        color: Colors.orange,
        description: event,
        icon: Icons.message,
      ).show(this.context);

      consultarNotificaciones();
    });
    iniciar();
    notificacionesListaNoLeidas = [];
    consultarNotificaciones();
  }

  iniciar() async {
    spreferences = await SharedPreferences.getInstance();
    final pushProvider = new PushNotificationProvider();
    notificaciones = spreferences.getBool("notificaciones");
    if (notificaciones) {
      pushProvider.initNotificaciones();
      pushProvider.getToken();
    }
  }

  consultarNotificaciones() async {
    spreferences = await SharedPreferences.getInstance();
    var id_usu = int.parse(spreferences.getString("id"));
    
    var response = await http.get(
      Uri.parse('${URL_SERVER}notificaciones?id_usu=${id_usu}'),
      headers: {"Accept": "application/json"});

    var reponsebody = json.decode(response.body);

    List notificaciones = reponsebody['notificaciones'];
    notificaciones = await limpiarEliminadas(notificaciones);
    var ntl = await filtrarLeidas(notificaciones);

    setState(() {
      numeroNotificaciones = notificaciones.length;
      notificacionesListaNoLeidas = ntl;
      numeroNotificaciones = notificacionesListaNoLeidas.length;
    });

    
  }

  filtrarLeidas(List lista) async {
    var listaf = [];
    for (var item in lista) {
      if(item["estado"] == 1){
        listaf.add(item);
      }
    }
    return listaf;
  }

   limpiarEliminadas(List lista) async {
    var listaf = [];
    for (var item in lista) {
      if(item["detalle"].length >  0){
        listaf.add(item);
      }
    }
    return listaf;
  }

}

/*import 'package:flutter/material.dart';
import 'package:gmp/src/providers/push_notification_provider.dart';
import 'package:gmp/src/screens/buscar/buscar.dart';
import 'package:gmp/src/screens/estadisticas/estadisticas.dart';
import 'package:gmp/src/screens/geo/geo.dart';
import 'package:gmp/src/screens/inicio/dashboard.dart';
import 'package:gmp/src/screens/perfil/perfil.dart';
import 'package:gmp/src/screens/secretarias/secretarias.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrincipalPage extends StatefulWidget {
  PrincipalPage({Key key}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  SharedPreferences spreferences;
  int _currentIndex = 0;
  bool notificaciones = false;
  final List<Widget> _children = [
    DashboardPage(),
    SecretariaPage(),
    //BuscarPage(),
    GeoPage(),
    EstadisticasPage(),
    PerfilPage()
  ];

  final List<String> _titles = [
    "Inicio",
    "Secretarías",
    "Busqueda",
    "Geolocalización",
    "Estadísticas",
    "Perfil"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          //appBar: AppBar(title: Text(_titles[_currentIndex])),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: onTabTapped, // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.apps),
                label: 'Secretarías',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.my_location),
                label: 'Geo',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.pie_chart_outlined),
                label: 'Estadísticas',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.person_outline),
                label: 'Perfil',
              )
            ],
          ),
          body: _children[_currentIndex]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    iniciar();
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
}*/

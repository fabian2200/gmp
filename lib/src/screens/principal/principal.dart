import 'package:flutter/material.dart';
import 'package:gmp/src/providers/push_notification_provider.dart';
import 'package:gmp/src/screens/estadisticas/estadisticas.dart';
import 'package:gmp/src/screens/geo/geo.dart';
import 'package:gmp/src/screens/inicio/dashboard.dart';
import 'package:gmp/src/screens/perfil/perfil.dart';
import 'package:gmp/src/screens/secretarias/secretarias.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motion_tab_bar/MotionBadgeWidget.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';


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
    //SecretariaPage(),
    GeoPage(),
    EstadisticasPage(),
    //PerfilPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        bottomNavigationBar: MotionTabBar(
          labels: [
            "Inicio","Geolocalización","Estadísticas"
          ],
          initialSelectedTab: "Inicio",
          tabIconColor: Colors.white,
          tabIconSize: 28.0,
          tabIconSelectedSize: 32.0,
          tabSize: 50,
          tabSelectedColor: Color.fromARGB(255, 255, 255, 255),
          tabIconSelectedColor: kazuloscuro,
          tabBarColor: kazuloscuro,
          tabBarHeight: 55,
          onTabItemSelected: (int value){
            print(value);
            setState(() {
              _currentIndex = value;
            });
          },
          icons: [
            Icons.home,Icons.my_location,Icons.pie_chart_outline
          ],
          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
}

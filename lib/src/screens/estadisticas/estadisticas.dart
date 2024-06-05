import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/estadisticas/calificaciones/calificaciones.dart';
import 'package:gmp/src/screens/estadisticas/disponibilidad_presupuestal/disponibilidadpresupuestal.dart';
import 'package:gmp/src/screens/estadisticas/estadoproyectos/estadoproyectos.dart';
import 'package:gmp/src/screens/estadisticas/presupuestoasignado/presupuestoasignado.dart';

class EstadisticasPage extends StatefulWidget {
  EstadisticasPage({Key key}) : super(key: key);

  @override
  _EstadisticasPageState createState() => _EstadisticasPageState();
}

class _EstadisticasPageState extends State<EstadisticasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Estadísticas"),
        ),
        body: Container(
            alignment: Alignment.topCenter,
            height: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => PresupuestoAsignadoPage()),
                    );
                  },
                  child: Image.asset(
                    "assets/images/ICONOS2.png",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => EstadoProyectosPage()),
                    );
                  },
                  child: Image.asset(
                    "assets/images/ICONOS.png",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              DisponibilidadPresupuestalPage()),
                    );
                  },
                  child: Image.asset(
                    "assets/images/ICONOS3.png",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => CalificacionesPage()),
                    );
                  },
                  child: Image.asset(
                    "assets/images/ICONOS4.png",
                  ),
                ),
              ],
            )));
  }
}

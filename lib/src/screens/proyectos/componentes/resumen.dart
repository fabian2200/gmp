import 'package:flutter/material.dart';
import 'package:gmp/src/screens/proyectos/componentes/circulo.dart';
import 'package:gmp/src/settings/constantes.dart';

class ResumenPage extends StatefulWidget {
  ResumenPage({Key key}) : super(key: key);

  @override
  _ResumenPageState createState() => _ResumenPageState();
}

class _ResumenPageState extends State<ResumenPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: <Widget>[
          Container(
            height: 200,
            width: 200,
            child: CustomPaint(
              painter: Circulo(Colors.green, 260),
              child: Center(
                child: Text(
                  "60%",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CalificarPage extends StatefulWidget {
  final idProyect;
  CalificarPage({Key key, this.idProyect}) : super(key: key);

  @override
  _CalificarPageState createState() => _CalificarPageState();
}

class _CalificarPageState extends State<CalificarPage> {
  SharedPreferences spreferences;
  double estrelas = 0;
  String bd;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(
                "Valora este proyecto",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Center(
            child: Text(
              "Tu opinión nos interesa",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomCenter,
            child: dibujarestrellas(estrelas),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
            child: GestureDetector(
              onTap: (){
                calificar();
              },
                          child: Container(height: size.height * 0.06,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: BorderRadius.circular(20)
              ),
              child: Center(child: Text("Calificar",style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white,fontSize: 20),),),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() { 
    super.initState();
    instanciar_sesion();
  }

  Future<String> calificar() async {
    var spreferences = await SharedPreferences.getInstance();
    var id_usu = spreferences.getString("id");

    var response = await http.get(
      Uri.parse('${URL_SERVER}guardarrating_proyectos?bd=${bd}&num_contrato=${widget.idProyect}&value=${estrelas}&id_usu=${id_usu}'),
      headers: {"Accept": "application/json"}
    );
    
    Navigator.of(context).pop();
    final responseBody = json.decode(response.body);
    var codigo = responseBody["existe"];

    switch (codigo) {
      case 1:
        _mensaje(Colors.orange,"Ya usted califico este proyecto, su calificación fue actualizada a "+estrelas.toString(), context);
        break;
      case 0:
        _mensaje(Colors.green,"Calificación registrada correctamente", context);
        break;
    }
  }


  _mensaje( Color color, String mensaje, BuildContext context){
    MotionToast(
      color: color,
      description: mensaje,
      icon: Icons.message,
    ).show(context);

    if(mensaje == "Usuario registrado correctamente"){
      Timer(Duration(milliseconds: 2000), () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    }
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
  }

  Widget dibujarestrellas(double numero) {
    Widget rating = Row();
    int estrellas;
    estrellas = numero.floor();
    if (estrellas == 1) {
      rating = rating = Row(
        children: [
          Spacer(),
          GestureDetector(
            onTap: () {
              seleccionado(1);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(2);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(3);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(4);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(5);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          Spacer()
        ],
      );
    } else if (estrellas == 2) {
      rating = rating = Row(
        children: [
          Spacer(),
          GestureDetector(
            onTap: () {
              seleccionado(1);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(2);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(3);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(4);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(5);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          Spacer()
        ],
      );
    } else if (estrellas == 3) {
      rating = rating = Row(
        children: [
          Spacer(),
          GestureDetector(
            onTap: () {
              seleccionado(1);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(2);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(3);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(4);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(5);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          Spacer()
        ],
      );
    } else if (estrellas == 4) {
      rating = Row(
        children: [
          Spacer(),
          GestureDetector(
            onTap: () {
              seleccionado(1);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(2);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(3);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(4);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(5);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          Spacer()
        ],
      );
    } else if (estrellas == 5) {
      rating = Row(
        children: [
          Spacer(),
          GestureDetector(
            onTap: () {
              seleccionado(1);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(2);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(3);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(4);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(5);
            },
            child: Icon(
              Icons.star,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          Spacer()
        ],
      );
    } else if (estrellas == 0) {
      rating = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          GestureDetector(
            onTap: () {
              seleccionado(1);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(2);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(3);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(4);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              seleccionado(5);
            },
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[600],
              size: 50,
            ),
          ),
          Spacer()
        ],
      );
    }
    return rating;
  }

  seleccionado(double estrellas) {
    setState(() {
      estrelas = estrellas;
    });
  }
}

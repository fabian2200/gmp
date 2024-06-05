import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CambiarPasswordPage extends StatefulWidget {
  CambiarPasswordPage({Key key}) : super(key: key);

  @override
  _CambiarPasswordPageState createState() => _CambiarPasswordPageState();
}

class _CambiarPasswordPageState extends State<CambiarPasswordPage> {
  SizeConfig _sc = SizeConfig();
  SharedPreferences spreferences;
  TextEditingController actualcontroller = new TextEditingController();
  TextEditingController nuevacontroller = new TextEditingController();
  //TextEditingController telefonocontroller = new TextEditingController();
  TextEditingController repetircontroller = new TextEditingController();
  String bd;
  String id;
  String email;
  FToast fToast;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cambiar contraseña"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: defaultpadding,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
              child: Text(
                "Contraseña actual",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: defaultpadding - 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _sc.getProportionateScreenWidth(defaultpadding - 1),
              ),
              child: Container(
                height: _sc.getProportionateScreenHeight(50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: TextField(
                      obscureText: true,
                      controller: actualcontroller,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Contraseña actual'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: _sc.getProportionateScreenHeight(defaultpadding),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
              child: Text(
                "Contraseña nueva",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: defaultpadding - 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _sc.getProportionateScreenWidth(defaultpadding - 1),
              ),
              child: Container(
                height: _sc.getProportionateScreenHeight(50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: TextField(
                      controller: nuevacontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Contraseña nueva'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: _sc.getProportionateScreenHeight(defaultpadding),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
              child: Text(
                "Repetir contraseña",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: defaultpadding - 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _sc.getProportionateScreenWidth(defaultpadding - 1),
              ),
              child: Container(
                height: _sc.getProportionateScreenHeight(50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: TextField(
                      obscureText: true,
                      controller: repetircontroller,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Repetir contraseña'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: _sc.getProportionateScreenHeight(defaultpadding),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _sc.getProportionateScreenWidth(defaultpadding - 1),
              ),
              child: GestureDetector(
                onTap: () {
                  guardar();
                  print("Guardando cambios");
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: defaultpadding - 6),
                  decoration: BoxDecoration(
                      color: kazuloscuro,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "Guardar cambios",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: _sc.getProportionateScreenHeight(14),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    instanciar_sesion();
    fToast = FToast();
    fToast.init(context);
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    id = spreferences.getString("id");
    email = spreferences.getString("email");
  }

  guardar() async {
    if (actualcontroller.text == "") {
      _mensaje(
          "Debe escribir una contraseña actual", krojo, Icons.cancel_outlined);
      return;
    }

    if (nuevacontroller.text == "") {
      _mensaje(
          "Debe escribir una contraseña nueva", krojo, Icons.cancel_outlined);
      return;
    }

    if (repetircontroller.text == "") {
      _mensaje("Debe repetir la contraseña", krojo, Icons.cancel_outlined);
      return;
    }

    if (repetircontroller.text != nuevacontroller.text) {
      _mensaje("Las contraseñas no coinciden", krojo, Icons.cancel_outlined);
      return;
    }

    final response = await http.get(Uri.parse(
        '${URL_SERVER}cambiarpass?email=${email}&actual=${actualcontroller.text}&nueva=${nuevacontroller.text}&id=${id}'));
    final reponsebody = json.decode(response.body);
    if (reponsebody['mensaje'] == "ok") {
      _mensaje("Contraseña guardada correctamente", kverde, Icons.check);
    } else {
      _mensaje(
          "La contraseña actual no coincide", krojo, Icons.cancel_outlined);
    }
  }

  _mensaje(String texto, Color color, IconData icono) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, color: Colors.white),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}

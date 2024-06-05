import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditarPerfilPage extends StatefulWidget {
  EditarPerfilPage({Key key}) : super(key: key);

  @override
  _EditarPerfilPageState createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  SizeConfig _sc = SizeConfig();
  SharedPreferences spreferences;
  TextEditingController nombrescontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  //TextEditingController telefonocontroller = new TextEditingController();
  TextEditingController biocontroller = new TextEditingController();
  String bd;
  String id;
  FToast fToast;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Perfil"),
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
              "Nombres",
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
                    controller: nombrescontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'nombres'),
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
              "Correo electrónico",
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
                    controller: emailcontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Correo electrónico'),
                  ),
                ),
              ),
            ),
          ),
          /*SizedBox(
              height: _sc.getProportionateScreenHeight(defaultpadding),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
              child: Text(
                "Telefono",
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
                      controller: telefonocontroller,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Telefono'),
                    ),
                  ),
                ),
              ),
            ),*/
          SizedBox(
            height: _sc.getProportionateScreenHeight(defaultpadding),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
            child: Text(
              "Bio",
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
                    maxLines: null,
                    minLines: 6,
                    keyboardType: TextInputType.multiline,
                    controller: biocontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Biografía'),
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
                    color: kazuloscuro, borderRadius: BorderRadius.circular(5)),
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
      ),
    );
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
    setState(() {
      //telefonocontroller.text = spreferences.getString("telefono");
      nombrescontroller.text = spreferences.getString("nombre");
      emailcontroller.text = spreferences.getString("email");
      biocontroller.text = spreferences.getString("bio");
    });
  }

  guardar() async {
    final response = await http.get(Uri.parse(
        '${URL_SERVER}editarperfil?email=${emailcontroller.text}&nombre=${nombrescontroller.text}&bio=${biocontroller.text}&id=${id}'));
    final reponsebody = json.decode(response.body);
    if (reponsebody["mensaje"] == "1") {
      //print("Se han guardado los datos");
      spreferences.setString("email", emailcontroller.text);
      spreferences.setString("nombre", nombrescontroller.text);
      spreferences.setString("bio", biocontroller.text);
      _mensaje(
          "Se han guardado los cambios correctamente", kverde, Icons.check);
    } else {
      _mensaje(
          "No se ha podido actualziar el perfil", krojo, Icons.cancel_outlined);
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

// email, nombre, telefono

import 'dart:async';
import 'dart:convert';
import 'package:gmp/src/settings/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gmp/src/settings/size_config.dart';
import '../../settings/constantes.dart';
import 'package:motion_toast/motion_toast.dart';

import '../login.dart';

class OlvidoPassword extends StatefulWidget {
  const OlvidoPassword({ Key key }) : super(key: key);

  @override
  State<OlvidoPassword> createState() => _OlvidoPasswordState();
}

class _OlvidoPasswordState extends State<OlvidoPassword> {

  bool loading = false;

  SizeConfig _sc = SizeConfig();

  BoxDecoration decoration = BoxDecoration(
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          );


  //campos de registro

  TextEditingController emailcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body:  !loading ? SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: _sc.getProportionateScreenHeight(defaultpadding)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 SizedBox(
                    height: _sc.getProportionateScreenHeight(30),
                  ),
                  Container(
                    height: size.height / 5,
                    width: size.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: _sc.getProportionateScreenWidth(40.0)),
                      child: Image.asset("assets/images/logo.png"),
                    ),
                  ),
                  SizedBox(
                    height: _sc.getProportionateScreenHeight(30),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            _sc.getProportionateScreenHeight(defaultpadding)),
                    child: Text(
                      "Olvido de contraseña",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: _sc.getProportionateScreenHeight(22)),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            _sc.getProportionateScreenHeight(defaultpadding)),
                    child: Text(
                      "Para continuar con la recuperación de su contraseña, por favor ingrese el email con el cual se registro.",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: _sc.getProportionateScreenHeight(22)),
                    ),
                  ),
                  SizedBox(height: 40),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: _sc
                              .getProportionateScreenWidth(defaultpadding - 1),
                        ),
                        child: Container(
                          height: _sc.getProportionateScreenHeight(50),
                          decoration: this.decoration,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailcontroller,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: 'Email'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(35),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              _sc.getProportionateScreenWidth(espacio_login),
                        ),
                        child: Container(
                          width: double.infinity,
                          child: MaterialButton(
                            color:  kazuloscuro ,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              //side: BorderSide(color: Colors.red)
                            ),
                            onPressed: () {
                              _guardar(context);
                            },
                            child: Text(
                              "Recuperar contraseña",
                              style: TextStyle(
                                  fontSize: _sc.getProportionateScreenHeight(defaultpadding),
                                  color: Colors.white),
                            ),
                            height: _sc.getProportionateScreenHeight(50),
                          ),
                        ),
                      ),
                    ]
                  )
              ]
            )
          )
        )
      ) : Center(
                child: Column(
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 100),
                      child:  SpinKitCubeGrid(
                        color: kazul,
                        size: 50.0
                      ),
                    )
                  ],
                ) 
              )
    );
  }

  _guardar (BuildContext context) async {

    
    var pemail = emailcontroller.text;
   
    if(_validarCampos(pemail)){
      setState(() {
        loading = true;
      });
      var response = await http.get(Uri.parse('${URL_EMAIL}olvido_password.php?email=$pemail'));

      final reponsebody = json.decode(response.body);

      var codigo = reponsebody["success"];
      var mensaje = reponsebody["mensaje"];

      switch (codigo) {
        case 0:
          _mensaje(Colors.orange, mensaje, context, codigo);
          break;
        case 1:
          _mensaje(Colors.green, mensaje, context, codigo);
          break;
      }
    }else{
       _mensaje(Colors.red,"Todos los campos son de carácter obligatorio.", context, 0);
    }
  }

  _mensaje( Color color, String mensaje, BuildContext context, int codigo){
    setState(() {
      loading = false;
    });

    MotionToast(
      color: color,
      description: mensaje,
      icon: Icons.message,
    ).show(context);

    if(codigo == 1){
      Timer(Duration(milliseconds: 2000), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }

  }

  _validarCampos(String pemail){
    if(pemail.isEmpty){
      return false;
    }
    return true;
  }
}
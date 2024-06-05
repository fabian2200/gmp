import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../settings/constantes.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';


import '../login.dart';

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({ Key key }) : super(key: key);

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {

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
  DateTime _selectedDate;
  
  TextEditingController idcontroller = new TextEditingController();
  TextEditingController nombrescontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passcontroller = new TextEditingController();
  TextEditingController biocontroller = new TextEditingController();
  TextEditingController datecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;

    return BlurryModalProgressHUD(
      inAsyncCall: loading,
      blurEffectIntensity: 4,
      progressIndicator: Image.asset(
        'assets/images/gmp.gif',
        width: 200,
        height: 100,
      ),
      dismissible: false,
      opacity: 0.4,
      color: Colors.black87,
      child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: _sc.getProportionateScreenHeight(defaultpadding)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                      "Registro de usuario",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: _sc.getProportionateScreenHeight(22)),
                    ),
                  ),
                  SizedBox(height: 10),
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
                                keyboardType: TextInputType.number,
                                controller: idcontroller,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: 'Identificación'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
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
                                keyboardType: TextInputType.text,
                                controller: nombrescontroller,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: 'Nombre completo'),
                              ),
                            ),
                          ),
                        ),
                      ),
                       SizedBox(height: 10),
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
                                keyboardType: TextInputType.text,
                                controller: emailcontroller,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: 'Correo electronico'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
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
                                keyboardType: TextInputType.visiblePassword,
                                controller: passcontroller,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: 'Contraseña'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
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
                                keyboardType: TextInputType.text,
                                controller: datecontroller,
                                decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Fecha de nacimiento'),
                                onTap: () {
                                  _selectDate(context);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                       Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: _sc
                              .getProportionateScreenWidth(defaultpadding - 1),
                        ),
                        child: Container(
                          height: 100,
                          decoration: this.decoration,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                        height: _sc.getProportionateScreenHeight(30),
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
                              loginUserPassword(context);
                            },
                            child: Text(
                              "Guardar",
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
      )
    ));
  }



  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: kazul,
                onPrimary: kbackgroundcolor,
                surface: kverdemuyclaro,
                onSurface: kazul,
              ),
              dialogBackgroundColor: kbackgroundcolor,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      String year = _selectedDate.year.toString();
      String month = _selectedDate.month < 10? "0"+_selectedDate.month.toString(): _selectedDate.month.toString();
      String day = _selectedDate.day < 10? "0"+_selectedDate.day.toString(): _selectedDate.day.toString();;
      datecontroller.text = year+"-"+month+"-"+day;
    }
  }

  loginUserPassword(BuildContext context) async {
    var pemail = emailcontroller.text;
    var pcontra = passcontroller.text;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: pemail,
        password: pcontra,
      );
      _guardar(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _mensaje(Colors.red,"La contraseña proporcionada es demasiado débil.", context);
      } else if (e.code == 'email-already-in-use') {
        _mensaje(Colors.red,"La cuenta ya existe para ese correo electrónico.", context);
      }
    } catch (e) {
      print(e);
    }
  }

  _guardar (BuildContext context) async {

    var pnombre = nombrescontroller.text;
    var pemail = emailcontroller.text;
    var pcontra = passcontroller.text;
    var pfecha = datecontroller.text;
    var pbio = biocontroller.text;
    var pid = idcontroller.text;

    if(_validarCampos(pnombre, pemail, pcontra, pfecha, pbio, pid)){
      setState(() {
        loading = true;
      });
      var response = await http.get(Uri.parse('${URL_SERVER}registrar?nombre=$pnombre&email=$pemail&contra=$pcontra&fecha=$pfecha&bio=$pbio&id=$pid'));

      final reponsebody = json.decode(response.body);

      var codigo = reponsebody["existe"];

      switch (codigo) {
        case 99:
          _mensaje(Colors.orange,"Debe ser mayor de edad para poder registrarse.", context);
          break;
        case 1:
          _mensaje(Colors.orange,"Ya existe un usuario con ese email.", context);
          break;
        case 0:
          await _guardarPreferencias(pemail);
          _mensaje(Colors.green,"Usuario registrado correctamente", context);
          break;
      }
    }else{
       _mensaje(Colors.red,"Todos los campos son de caracter obligatorio.", context);
    }
  }

  _mensaje( Color color, String mensaje, BuildContext context){
    setState(() {
      loading = false;
    });

    MotionToast(
      color: color,
      description: mensaje,
      icon: Icons.message,
    ).show(context);

    if(mensaje == "Usuario registrado correctamente"){
      Timer(Duration(milliseconds: 2000), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }

  }

  _validarCampos(String pnombre, String pemail, String pcontra, String pfecha, String pbio, String pid){
    if(pnombre.isEmpty || pemail.isEmpty || pcontra.isEmpty || pfecha.isEmpty || pbio.isEmpty || pid.isEmpty){
      return false;
    }
    return true;
  }

  _guardarPreferencias(String email) async {
    var spreferences = await SharedPreferences.getInstance();
      var response = await http.get(Uri.parse('${URL_SERVER}usuario?email=$email&id='),headers: {"Accept": "application/json"});

      final reponsebody = json.decode(response.body);

      spreferences.setString("email", reponsebody['usuario']['email']);
      spreferences.setString("nombre", reponsebody['usuario']['nombre']);
      spreferences.setString("bio", reponsebody['usuario']['bio'] ?? '');
      spreferences.setString("alias", reponsebody['alias'] ?? '');
      spreferences.setBool("notificaciones", true);
      spreferences.setString("id", reponsebody['usuario']['id'].toString());
      spreferences.setString("id_usu", reponsebody['usuario']['id'].toString());
      spreferences.setString("imagen", reponsebody['usuario']['imagen']);
  }
}
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmp/src/blocs/auth_bloc.dart';
import 'package:gmp/src/screens/pagina_principal/bienvenida.dart';
import 'package:gmp/src/screens/registro_usuario/olvidoPassword.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'registro_usuario/registroUsuario.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
//import 'package:apple_sign_in/apple_sign_in.dart';

String username;
//GoogleSignIn _googleSingIn = GoogleSignIn(scopes: ['profile', 'email']);

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SizeConfig _sc = SizeConfig();
  String usuario;
  String contra;
  String errorMessage;
  String errorcontra = "";
  String errorusuario = "";
  final llave = GlobalKey<FormState>();
  final key = new GlobalKey<ScaffoldState>();
  //LoginServicio _ls;
  int isloading = 0;
  int color = 0;
  SharedPreferences spreferences;
  GoogleSignInAccount _currentUser;
  bool isIOS13 = true;
  FToast fToast;

  String bd;

  TextEditingController controllerUser = new TextEditingController();
  TextEditingController controllerPass = new TextEditingController();

  String mensaje = "";
  String usuarioValue;
  String contraValue;

  final formKey = GlobalKey<FormState>();

  bool loading = false;

  void login(BuildContext context) async {
    //return datauser;
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return  BlurryModalProgressHUD(
      inAsyncCall: loading,
      blurEffectIntensity: 4,
      progressIndicator: Image.asset(
        'assets/images/gmp.gif',
        width: 200,
        height: 100,
      ),
      dismissible: false,
      opacity: 0.9,
      color: Colors.white,
      child: Scaffold(
      backgroundColor: Colors.white,
      key: key,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: _sc.getProportionateScreenHeight(defaultpadding),
              horizontal: _sc.getProportionateScreenHeight(defaultpadding - 10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: size.height / 5,
                  width: size.width,
                  decoration: BoxDecoration(
                      //color: Colors.blue
                      ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _sc.getProportionateScreenWidth(40.0)),
                    child: Image.asset("assets/images/logo.png"),
                  ),
                ),
                SizedBox(
                  height: _sc.getProportionateScreenHeight(60),
                ),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                _sc.getProportionateScreenHeight(defaultpadding)),
                        child: Text(
                          "Ingresa con tu cuenta",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: _sc.getProportionateScreenHeight(22),
                            color: Color.fromARGB(255, 100, 100, 100)
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(10),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Text(errorusuario + " " + errorcontra,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, color: Colors.red)),
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(20),
                      ),
                      Form(
                        key: llave,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: _sc
                                    .getProportionateScreenWidth(defaultpadding - 1),
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
                                      offset:
                                          Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Center(
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Correo electrónico',
                                          icon: Icon(Icons.email)
                                        ),
                                        onSaved: (value) {
                                          usuario = value;
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            setState(() {
                                              errorusuario =
                                                  "Debe escrbir un correo electrónico, ";
                                            });
                                            return null;
                                          } else {
                                            setState(() {
                                              errorusuario = "";
                                            });
                                          }
                                        }),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  _sc.getProportionateScreenHeight(defaultpadding),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    _sc.getProportionateScreenWidth(espacio_login),
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
                                      offset:
                                          Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Center(
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Contraseña',
                                          icon: Icon(Icons.key)
                                        ),
                                        obscureText: true,
                                        onSaved: (value) {
                                          contra = value;
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            setState(() {
                                              errorcontra =
                                                  "Debe ingresar una contraseña";
                                            });
                                            return null;
                                            //return "Debe ingresar una contraseña";
                                          } else {
                                            setState(() {
                                              errorcontra = "";
                                            });
                                          }
                                        }),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _sc.getProportionateScreenHeight(15),
                            ),
                            Row(
                              mainAxisAlignment:  MainAxisAlignment.end,
                              children: <Widget>[
                                  
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OlvidoPassword()),
                                      );
                                    },
                                    child: new Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: _sc.getProportionateScreenHeight(defaultpadding),
                                        vertical: 10
                                      ),
                                      child: new Text("¿Olvidaste la contraseña?", style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: _sc.getProportionateScreenHeight(20),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    _sc.getProportionateScreenWidth(espacio_login),
                              ),
                              child: Container(
                                width: double.infinity,
                                child: MaterialButton(
                                  color: color == 0 ? kazuloscuro : kverde,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    //side: BorderSide(color: Colors.red)
                                  ),
                                  onPressed: () {
                                    _logueo(context);
                                  },
                                  child: setUpButtonChild(),
                                  height: _sc.getProportionateScreenHeight(50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(25),
                      ),
                      Container(
                        width: double.infinity,
                        child: Align(
                          child: Text(
                            "- O ingresa con -",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(defaultpadding + 5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              authBloc.loginGoogle(context);
                            },
                            child: Container(
                              height: _sc.getProportionateScreenHeight(50),
                              width:  _sc.getProportionateScreenHeight(50),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(_sc.getProportionateScreenHeight(15)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 51, 51, 51).withOpacity(0.2), // color de la sombra con opacidad
                                    spreadRadius: 2, // expansión de la sombra
                                    blurRadius: 2, // desenfoque de la sombra
                                    offset: Offset(2, 2), // desplazamiento de la sombra (x, y)
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/google.png",
                                  width: _sc.getProportionateScreenHeight(40),
                                ),
                              ),
                            )
                          ),
                          SizedBox(
                            width: _sc.getProportionateScreenWidth(20),
                          ),
                          GestureDetector(
                            onTap: () {
                              logIn();
                            },
                            child: Container(
                              height: _sc.getProportionateScreenHeight(50),
                              width:  _sc.getProportionateScreenHeight(50),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(_sc.getProportionateScreenHeight(15)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25), // color de la sombra con opacidad
                                    spreadRadius: 2, // expansión de la sombra
                                    blurRadius: 2, // desenfoque de la sombra
                                    offset: Offset(2, 2), // desplazamiento de la sombra (x, y)
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/apple.png",
                                  width: _sc.getProportionateScreenHeight(30),
                                ),
                              ),
                            )
                          ),
                          
                        ],
                      ),
                      /*
                      Align(
                        child: SignInButton(
                          Buttons.Google,
                          text: "Continuar con Google",
                          onPressed: () {
                            authBloc.loginGoogle(context);
                          },
                        ),
                      ),
                      isIOS13 == true
                          ? Align(
                              child: SignInButton(
                                Buttons.AppleDark,
                                text: "Continuar con apple",
                                onPressed: () {
                                  //signinapple(context);
                                  logIn();
                                },
                              ),
                            )
                          : Container(),*/
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(defaultpadding + 15),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _sc.getProportionateScreenWidth(defaultpadding)
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistroUsuario()),
                              );
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: '¿No tienes una cuenta?  ',
                                style: TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' Regístrate ahora',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: kazuloscuro)
                                  ),
                                ],
                              ),
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                )
              ],
              )
            ),
        ),
      ),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    instanciar_sesion();
    fToast = FToast();
    fToast.init(context);
  }

  void _presionado() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      //print("Entrando a la funcion");
      login(context);
    }
  }

  Drawer _drawer(BuildContext context) {
    final tipo = null;
    if (tipo == null) {
      return null;
    } else {
      return Drawer();
    }
  }

  _logueo(BuildContext context) async {
    
    setState(() {
      color = 0;
      isloading = 1;
      loading = true;
    });

    if (llave.currentState.validate()) {
      llave.currentState.save();
    } else {
      return;
    }

    setState(() {
      color = 0;
      isloading = 0;
      loading = true;
    });

    //print('${URL_SERVER}login?email=$usuario&password=$contra');
    final response = await http
        .get(Uri.parse('${URL_SERVER}login?email=$usuario&password=$contra'));
    final reponsebody = json.decode(response.body);

    if (reponsebody['logueo']) {
      setState(() {
        isloading = 2;
        color = 1;
        loading = false;
      });

      Timer(Duration(milliseconds: 1000), () {
        spreferences.setString("email", reponsebody['usuario']['email']);
        spreferences.setString("nombre", reponsebody['usuario']['nombre']);
        spreferences.setString("imagen", reponsebody['usuario']['imagen']);
        //spreferences.setString("rol", reponsebody['usuario']['rol']);
        spreferences.setString("alias", reponsebody['alias'] ?? "");
        spreferences.setString("id", reponsebody['usuario']['id'].toString());
        spreferences.setString("bio", reponsebody['usuario']['bio'].toString());
         spreferences.setBool("notificaciones", true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BienvenidaPage()));
      });
    } else {
      mostrar_mensaje();
      //print("Error");
      Timer(Duration(milliseconds: 1500), () {
        setState(() {
          isloading = 0;
        });
      });
    }
  }

  Widget setUpButtonChild() {
    if (isloading == 0) {
      return new Text(
        "Ingresa",
        style: TextStyle(
            fontSize: _sc.getProportionateScreenHeight(defaultpadding),
            color: Colors.white),
      );
    } else if (isloading == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 2,
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    //isIOS13 = false;
  }

  void logIn() async {
    final AuthorizationResult result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:

        // Navigate to secret page (shhh!)
        /*Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => AfterLoginPage(credential: result.credential)));*/
        print(
            "${result.credential.fullName.givenName} ${result.credential.fullName.familyName} ${result.credential.email} ");
        registrar_google(
            "${result.credential.fullName.givenName} ${result.credential.fullName.familyName}",
            "${result.credential.email}",
            context);
        break;

      case AuthorizationStatus.error:
        print("Sign in failed: ${result.error.localizedDescription}");
        setState(() {
          errorMessage = "Sign in failed";
        });
        break;

      case AuthorizationStatus.cancelled:
        print('User cancelled');
        break;
    }
  }

  Future<String> registrar_google(
      String nombre, String email, BuildContext context) async {
    spreferences = await SharedPreferences.getInstance();

    var response = await http.get(
        Uri.parse(
            '${URL_SERVER}rfacebook?bd=${bd}&nombre=${nombre}&email=${email}&contra='),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    //print(reponsebody);

    spreferences.setString("email", reponsebody['usuario']['email']);
    spreferences.setString("nombre", reponsebody['usuario']['nombre']);
    spreferences.setString("imagen", reponsebody['usuario']['imagen'] ?? '');
    spreferences.setString(
        "telefono", reponsebody['usuario']['telefono'] ?? '');
    spreferences.setString("id_usu", reponsebody['usuario']['id'].toString());
    spreferences.setString("id", reponsebody['usuario']['id'].toString());
    spreferences.setBool("notificaciones", true);

    //print(reponsebody['usuario']['email']);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => BienvenidaPage()));

    return "Success!";
  }

  mostrar_mensaje() {
    setState(() {
      loading = false;
      this.errorusuario = "Usuario o contraseña errado";
    });
  }

  _mensaje(String texto) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: krojo,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cancel_outlined, color: Colors.white),
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

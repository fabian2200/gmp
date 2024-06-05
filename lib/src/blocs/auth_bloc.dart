import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/pagina_principal/bienvenida.dart';
import 'package:gmp/src/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:gmp/src/settings/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/cuentaDesactivadaPage.dart';

class AuthBloc {
  final authService = AuthService();
  final googleSignIn = GoogleSignIn(scopes: ['email']);

  Stream<User> get currentUser => authService.currentUser;
  String bd;
  SharedPreferences spreferences;

  Future<String> loginGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      ////FIREBASE AUTH
      final result = await authService.signInWithCredential(credential);

      spreferences = await SharedPreferences.getInstance();

      //print('${result.user}');
      buscar_proyectos(result.user.displayName, result.user.email, context);

      //return result.user;

    } catch (error) {
      print(error);
    }

    //return "true";
  }

  Future<String> buscar_proyectos(
      String nombre, String email, BuildContext context) async {
    print('${URL_SERVER}vrfacebook?bd=${bd}&nombre=${nombre}&email=${email}&contra=');
    var response = await http.get(
        Uri.parse(
            '${URL_SERVER}vrfacebook?bd=${bd}&nombre=${nombre}&email=${email}&contra='),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    //print(reponsebody);

    if (reponsebody['usuario'] == true) {
      registrar_google(nombre, email, context);
    } else {
      registrar_google(nombre, email, context);
    }
    return "Success!";
  }

  Future<String> registrar_google(
      String nombre, String email, BuildContext context) async {
    spreferences = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.parse(
            '${URL_SERVER}rfacebook?bd=${bd}&nombre=$nombre&email=$email&contra=&fecha=&bio=&id='),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    //print(reponsebody);

    if(reponsebody['usuario']['estado'] == "Activo"){
      spreferences.setString("email", reponsebody['usuario']['email']);
      spreferences.setString("nombre", reponsebody['usuario']['nombre']);
      spreferences.setString("bio", reponsebody['usuario']['bio'] ?? '');
      spreferences.setString("alias", reponsebody['alias'] ?? '');
      spreferences.setBool("notificaciones", true);
      spreferences.setString("id", reponsebody['usuario']['id'].toString());
      spreferences.setString("id_usu", reponsebody['usuario']['id'].toString());
      spreferences.setString("imagen", reponsebody['usuario']['imagen']);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BienvenidaPage()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CuentaDesactivadaPage()));
    }
    return "Success!";
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:gmp/src/settings/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc {
  final authService = AuthService();
  final googleSignIn = GoogleSignIn(scopes: ['email']);

  Stream<User> get currentUser => authService.currentUser;
  String bd;
  SharedPreferences spreferences;

  Future<String> loginGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken
      );

      final result = await authService.signInWithCredential(credential);

      spreferences = await SharedPreferences.getInstance();

      var res2 = await registrar_google(result.user.displayName, result.user.email, context);
      return res2;
    } catch (error) {
      return("Error: "+error.toString());
    }
  }

  Future<String> registrar_google(String nombre, String email, BuildContext context) async {
    try {
      spreferences = await SharedPreferences.getInstance();
      var response = await http.get(
        Uri.parse('${URL_SERVER}rfacebook?bd=${bd}&nombre=$nombre&email=$email&contra=&fecha=&bio=&id='),
        headers: {"Accept": "application/json"}
      );
      
      final reponsebody = json.decode(response.body);

      if(reponsebody['usuario']['estado'] == "Activo"){
        spreferences.setString("email", reponsebody['usuario']['email']);
        spreferences.setString("nombre", reponsebody['usuario']['nombre']);
        spreferences.setString("bio", reponsebody['usuario']['bio'] ?? '');
        spreferences.setBool("notificaciones", true);
        spreferences.setString("id", reponsebody['usuario']['id'].toString());
        spreferences.setString("id_usu", reponsebody['usuario']['id'].toString());
        spreferences.setString("imagen", reponsebody['usuario']['imagen']);
      }
      return(reponsebody['usuario']['estado']);
    } catch (error) {
      return("Error: "+error.toString());
    }
  }
}

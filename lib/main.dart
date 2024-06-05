import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/blocs/auth_bloc.dart';
import 'package:gmp/src/screens/login.dart';
import 'package:gmp/src/screens/pagina_principal/bienvenida.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences spreferences = await SharedPreferences.getInstance();
  var email = spreferences.getString("email");
  await Firebase.initializeApp();
  runApp(
    Provider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        home: email == null ? LoginPage() : BienvenidaPage(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

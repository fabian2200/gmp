import 'package:flutter/material.dart';
import 'package:gmp/src/screens/companias/companias.dart';
import 'package:gmp/src/screens/login.dart';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GMP',
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          builder: (BuildContext context){
            switch(settings.name){
              case "/":
                return LoginPage();
              case "/companias":
                return CompaniasPage();  
            }
            return null;
          }
          );
      },
    );
  }
}
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import 'login.dart';

class CuentaDesactivadaPage extends StatefulWidget {
  State<CuentaDesactivadaPage> createState() => _CuentaDesactivadaPageState();
}

class _CuentaDesactivadaPageState extends State<CuentaDesactivadaPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar : true,
      appBar: AppBar(
         elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          padding: EdgeInsets.only(left: 30),
          child: Text(""),
        ),
      ),
      body: Center(
        child: Container(
          width: 400,
          height: 700,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 300,
                width: 300,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
              SizedBox(
                height: 10
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 92, 138, 238),
                ),
                child: Column(children: [
                  Icon(Icons.error, size: 60, color: Colors.white,),
                  SizedBox(
                    height: 20
                  ),
                  Text(
                    "Su cuenta se encuentra en proceso de eliminación de datos, este proceso podrá durar entre 10 y 90 días, Si tiene alguna pregunta o necesita asistencia adicional, no dude en ponerse en contacto con nuestro equipo de soporte.",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )
                ])
              ),
              SizedBox(
                height: 30
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    icon: Icon(Icons.arrow_back),
                    label: Text('Volver al login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    icon: Icon(Icons.contact_emergency),
                    label: Text('Equipo de soporte'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
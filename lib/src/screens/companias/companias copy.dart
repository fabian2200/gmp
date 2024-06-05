import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/login.dart';
import 'package:gmp/src/screens/principal/principal.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_text/skeleton_text.dart';

class CompaniasPage1 extends StatefulWidget {
  CompaniasPage1({Key key}) : super(key: key);

  @override
  _CompaniasPageState createState() => _CompaniasPageState();
}

class _CompaniasPageState extends State<CompaniasPage1> {
  SizeConfig _sc = SizeConfig();
  List companias;
  SharedPreferences spreferences;
  String email = "";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: size.height * 0.12, // Set this height
        flexibleSpace: SafeArea(
          top: true,
          bottom: false,
          left: false,
          right: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: defaultpadding - 5),
            child: Row(
              children: [
                Container(
                  width: _sc.getProportionateScreenHeight(54),
                  height: _sc.getProportionateScreenHeight(54),
                  decoration: BoxDecoration(
                    color: knaranja,
                    borderRadius: BorderRadius.circular(5000),
                  ),
                  child: Center(
                    child: Text(
                      email.substring(0, 1),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  width: defaultpadding - 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bienvenido",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Text(
                      email,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),

        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.exit_to_app),
            onPressed: () {
              salir();
            },
          ),
        ],
      ),
      body: new ListView.builder(
        itemCount: companias == null ? 0 : companias.length,
        itemBuilder: (BuildContext context, int index) {
          return Stack(children: <Widget>[
            companias_carga(),
            Card(
              child: InkWell(
                onTap: () {
                  ir(
                      companias[index]['companias_id'].toString(),
                      companias[index]['companias_login'],
                      companias[index]['lat_ubic'],
                      companias[index]['long_ubi']);
                },
                child: Image.network(
                    '${RUTA_IMAGEN}ImgEmpresa/${companias[index]['companias_img']}'),
              ),
            ),
          ]);
        },
      ), /*Column(
          companias_carga(),
          SizedBox(
            height: 5
          ),
          companias_carga(),
          SizedBox(
            height: 5
          ),
          companias_carga(),
          SizedBox(
            height: 5
          ),
          companias_carga()
        ]
      ) */ /*: */
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    companias = new List();
    instanciar_sesion();
    getData();
  }

  Future<String> getData() async {
    var response = await http.get(Uri.parse('${URL_SERVER}companias'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    this.setState(() {
      this.companias = reponsebody['companias'];
    });

    return "Success!";
  }

  ir(String id, String bd, String lat, String lng) {
    //Timer(Duration(milliseconds: 1000), () {
    spreferences.setString("bd", "gmp_" + bd);
    spreferences.setString("empresa", bd);
    spreferences.setString("lat", lat);
    spreferences.setString("lng", lng);
    spreferences.setString("id_emp", id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PrincipalPage()),
    );
    // });
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    setState(() {
      email = spreferences.getString("nombre");
    });
  }

  salir() async {
    await spreferences.clear();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Widget companias_carga() {
    return SkeletonAnimation(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.14,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.0),
              color: Colors.grey[300]),
        ),
      ),
    );
  }
}

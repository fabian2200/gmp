/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gmp/src/screens/comentarios/componentes/vistacomentarios.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RespuestasPage extends StatefulWidget {
  final String id;
  final List respuestas;
  final String image;
  final String name;
  final String comentario;
  final String tipo;
  RespuestasPage(
      {Key key,
      this.id,
      this.respuestas,
      this.image,
      this.name,
      this.comentario,
      this.tipo})
      : super(key: key);

  @override
  _RespuestasPageState createState() => _RespuestasPageState();
}

TextEditingController txtenviar = new TextEditingController();

class _RespuestasPageState extends State<RespuestasPage> {
  List responses;
  SharedPreferences spreferences;
  String bd;
  String empresa;
  int isloading=0;

  @override
  Widget build(BuildContext context) {
    SizeConfig _sc = SizeConfig();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Respuestas",
          style: TextStyle(color: Colors.blue[800]),
        ),
        iconTheme: IconThemeData(
          color: Colors.blue[800], //change your color here
        ),
      ),
      /*bottomSheet: Container(
        width: double.infinity,
        decoration:
            BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: size.height * 0.05,
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: txtenviar,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Escribe tu comentario aquí'),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                        onTap: (){
                          responder(txtenviar.text,widget.id);
                        },
                              child: Container(
                  height: size.height * 0.04,
                  width: size.width * 0.1,
                  decoration: BoxDecoration(),
                  child: Icon(Icons.send, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),*/
      body: Stack(
        children: <Widget>[
          
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: defaultpadding,
                  backgroundImage: NetworkImage('${widget.image}'),
                ),
                SizedBox(width: _sc.getProportionateScreenWidth(10)),
                Column(
                  children: [
                    Container(
                      width: size.width * 0.80,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: _sc
                                    .getProportionateScreenHeight(16),
                              ),
                            ),
                            Container(
                              child: Text(
                                widget.comentario,
                                style: TextStyle(
                                  fontSize: _sc
                                      .getProportionateScreenHeight(14),
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  _sc.getProportionateScreenHeight(5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _sc.getProportionateScreenHeight(5),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: _sc.getProportionateScreenHeight(20),
          ),
          Container(
            height: size.height,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.18),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: responses == null ? 0 : responses.length,
                  shrinkWrap: true,
                  
                  itemBuilder: (BuildContext context, int index) {
                    return VistaComentario(
                        comentarios: responses,
                        sc: _sc,
                        size: size,
                        index: index,
                        mres: "no",
                        tam: 0.65,
                        tipo: "contrato");
                  }),
            ),
          ),
          SizedBox(
            height: _sc.getProportionateScreenHeight(30),
          ),
          Container(
            child: Positioned(
                        bottom: 0,
                        left: 0,
                        height: 500,
                        child: Container(
                            width: double.infinity,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(color: Colors.grey),),),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          //width: size.width * 0.78,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey[300]),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: TextFormField(
                                              controller: txtenviar,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      'Escribe tu comentario aquí'),
                                            ),
                                          )),
                                    ),
                                    isloading == 0
                                        ? GestureDetector(
                                            onTap: () {
                                              this.setState(() {
                                                isloading = 1;
                                              });
                                              responder(txtenviar.text,widget.id);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: size.width * 0.1,
                                                decoration: BoxDecoration(),
                                                child: Icon(Icons.send,
                                                    color: Colors.blue[700]),
                                              ),
                                            ),
                                          )
                                        : CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.blue[900]),
                                            strokeWidth: 2,
                                          ),
                                  ],
                                ),
                              ),
                            )),
                      ),
          ),
          
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    responses = new List();
    responses = widget.respuestas;
  }

  Future<String> responder(String texto, String id) async {
    var response;
    if (widget.tipo == "proyecto") {
      var response = await http.get(
          Uri.encodeFull(
              '${URL_SERVER}comentarios_proyectos?bd=${bd}&id_con=${widget.id}'),
          headers: {"Accept": "application/json"});
    } else {
      var response = await http.get(
          Uri.encodeFull(
              '${URL_SERVER}comentarios?bd=${bd}&id_con=${widget.id}'),
          headers: {"Accept": "application/json"});
    }

    final reponsebody = json.decode(response.body);

    this.setState(() {
      //widget.respuestas = reponsebody['comentarios'];
      //valur = (int.parse(reponsebody['rating']["total"]) / int.parse(reponsebody['rating']["todos"]));
    });
    return "Success!";
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");
  }
}*/

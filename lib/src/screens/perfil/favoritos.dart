import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmp/src/screens/detalle_contratos/detallecontratos.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../detalle_proyectos/detalleproyectos.dart';

class FavoritosPage extends StatefulWidget {
  final idUsuario;
  FavoritosPage({Key key, this.idUsuario}) : super(key: key);

  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  SizeConfig _sc = SizeConfig();

  SharedPreferences spreferences;
  String bd;

  List<dynamic> listaMeGusta = [];
  List<dynamic> listaComentarios = [];
 
  int seleccionado = 1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Actividad"),
        toolbarHeight: 60,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body:  Container(
          height: size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: defaultpadding + 15,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          cambiar(1);
                        },
                        child: Container(
                          width: (size.width / 2.5) - 15,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                            color: seleccionado == 1
                                ? Colors.blue[900]
                                : Colors.white,
                            border: Border.all(color: Colors.blue[900]),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(10.0),
                              bottomLeft: const Radius.circular(10.0)
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Me Gusta",
                              style: TextStyle(
                                  color: seleccionado == 1
                                      ? Colors.white
                                      : Colors.blue[900],
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          cambiar(2);
                        },
                        child: Container(
                          width: (size.width / 2.5) - 15,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                            color: seleccionado == 2
                                ? Colors.blue[900]
                                : Colors.white,
                            border: Border.all(color: Colors.blue[900]),
                            borderRadius: BorderRadius.only(
                              topRight: const Radius.circular(10.0),
                              bottomRight: const Radius.circular(10.0)
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Comentarios",
                              style: seleccionado == 2
                                  ? TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)
                                  : TextStyle(
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: defaultpadding + 15,
                ),
                seleccionado == 1 ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: listaMeGusta.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: GestureDetector(
                        onTap: () {
                          if(listaMeGusta[index]["tipo_like"] == "P"){
                            verDetalleProyectoLike(listaMeGusta[index]["id_global"].toString(), listaMeGusta[index]["bd_destino"]);
                          }else{
                            verContrato(listaMeGusta[index]["id_global"].toString(), listaMeGusta[index]["bd_destino"]);
                          }
                        },
                        child: Card(
                          elevation: 5,
                          shadowColor: Colors.grey,
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  width: size.width*0.13,
                                  child: Icon(Icons.thumb_up_alt_outlined, size: 57, color: listaMeGusta[index]["tipo_like"] == "P" ? Color.fromARGB(117, 106, 167, 216) : Color.fromARGB(127, 30, 97, 32))
                                ),
                                SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  width: size.width*0.57,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Indicaste que te gusta el "+(listaMeGusta[index]["tipo_like"] == "P" ? 'Proyecto' : 'Contrato'), style: TextStyle(fontWeight: FontWeight.bold, color: kazul)),
                                      SizedBox(height: 5),
                                      Text(listaMeGusta[index]["descr"], style: TextStyle(fontSize: 11)),
                                      SizedBox(height: 10),
                                      Container(height: 1, color: Colors.grey),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(Icons.account_balance, color: krosado),
                                          SizedBox(width: 10),
                                          Text(listaMeGusta[index]["compania_desc"])
                                        ],
                                      ),
                                      SizedBox(height: 7),
                                      Text(calcularFechas(listaMeGusta[index]["created_at"]), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  width: size.width*0.10,
                                  child: Icon(Icons.keyboard_arrow_right_outlined, size: 50, color: Color.fromARGB(172, 94, 94, 94),)
                                ),
                              ],
                            ),
                          )
                        )
                      )
                    );
                  },
                ) : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: listaComentarios.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: GestureDetector(
                        onTap: () {
                          if(listaComentarios[index]["tipo"] == "P"){
                            if(listaComentarios[index]["tipo_comentario"] == "C"){
                              verDetalleProyectoLike(listaComentarios[index]["id_con"].toString(), listaComentarios[index]["bd_destino"]);
                            }else{
                              verDetalleProyectoLike(listaComentarios[index]["desc"]["id_proyecto"].toString(), listaComentarios[index]["bd_destino"]);
                            }
                          }else{
                            if(listaComentarios[index]["tipo_comentario"] == "C"){
                              verContrato(listaComentarios[index]["id_con"].toString(), listaComentarios[index]["bd_destino"]);
                            }else{
                              verContrato(listaComentarios[index]["desc"]["max_id"].toString(), listaComentarios[index]["bd_destino"]);
                            }
                          }
                        },
                        child: Card(
                          elevation: 5,
                          shadowColor: Colors.grey,
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  width: size.width*0.13,
                                  child: Icon(Icons.messenger_outline, size: 57, color: listaComentarios[index]["tipo"] == "P" ? Color.fromARGB(117, 106, 167, 216) : Color.fromARGB(127, 30, 97, 32))
                                ),
                                SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  width: size.width*0.58,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text((listaComentarios[index]["tipo_comentario"] == "C" ? 'Hiciste' : 'Respondiste')+" un comentario en el "+(listaComentarios[index]["tipo"] == "P" ? 'Proyecto' : 'Contrato'), style: TextStyle(fontWeight: FontWeight.bold, color: kazul)),
                                      SizedBox(height: 5),
                                      Text(listaComentarios[index]["desc"]["desc"], style: TextStyle(fontSize: 11)),
                                      SizedBox(height: 10),
                                      Container(height: 1, color: Colors.grey),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(Icons.account_balance, color: krosado),
                                          SizedBox(width: 10),
                                          Text(listaComentarios[index]["compania_desc"])
                                        ],
                                      ),
                                      listaComentarios[index]["response"] != 0 ? Column(
                                        children: [
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(Icons.person_2, color: knaranja),
                                              SizedBox(width: 10),
                                              Text(listaComentarios[index]["desc_usu_res"]["desc"])
                                            ],
                                          ),
                                        ],
                                      ): Center(),
                                      SizedBox(height: 5),
                                      Text(calcularFechas(listaComentarios[index]["created_at"]), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  width: size.width*0.10,
                                  child: Icon(Icons.keyboard_arrow_right_outlined, size: 50, color: Color.fromARGB(172, 94, 94, 94),)
                                ),
                              ],
                            ),
                          )
                        )
                      )
                    );
                  },
                ),
              ]
            )
          )
      )
    );
  }

  @override
  void initState() {
    super.initState();
    consultarLikesComentarios();
  }

  consultarLikesComentarios() async{
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");

    var response = await http.get(
      Uri.parse('${URL_SERVER}me-gusta-comentarios?id=${widget.idUsuario.toString()}'),
      headers: {"Accept": "application/json"}
    );

    final reponsebody = json.decode(response.body);
    setState(() {
      listaMeGusta = reponsebody["megusta"];
      listaComentarios = reponsebody["comentarios"];
    });
  }

  cambiar(int sel) {
    setState(() {
      seleccionado = sel;
    });
  }

  calcularFechas(var fecha){
    DateTime fecha1 =  DateTime.parse(fecha);
    DateTime fecha2 =  DateTime.now();

    Duration _diastotales = fecha2.difference(fecha1);

    List<String> meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo","Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
    
    var horas = fecha1.hour;
    var minutos = fecha1.minute;
    var ampm = horas >= 12 ? 'PM' : 'AM';

    if(horas > 12){
      horas = horas - 12;
    }

    if(_diastotales.inDays == 0){
      if(_diastotales.inMinutes < 10){
        return "Hace un momento";
      }else{
        if(_diastotales.inMinutes < 60){
          return "Hace "+_diastotales.inMinutes.toString()+" Minutos(s)";
        }else{
          return "Hace "+_diastotales.inHours.toString()+" Hora(s)";
        }
      }
    }else{
      if (_diastotales.inDays == 1) {
        return "Ayer a "+(horas == 1? 'la ' : 'las ')+(horas).toString()+ " y "+fecha1.second.toString()+" "+ampm;
      }else{
        if(_diastotales.inDays <= 7){
          return "Hace "+_diastotales.inDays.toString()+" dias ";
        }else{
          return fecha1.day.toString() +" de " +meses[fecha1.month - 1] +" del " +fecha1.year.toString() +", ";
        }
      }
    }
  }

  verDetalleProyectoLike(String idProyecto, String bdLike) async {
    spreferences = await SharedPreferences.getInstance();
    spreferences.setString("bd", bdLike);
    spreferences.setString("empresa", bdLike.split('_')[1].toString());
    
    Navigator.push(
      this.context,
      CupertinoPageRoute(
        builder: (context) => DetalleProyetcosPage(idproyect: idProyecto)
      ),
    );
  }

  verContrato(String idCon, String bdLike) async {

    spreferences = await SharedPreferences.getInstance();
    spreferences.setString("bd", bdLike);
    spreferences.setString("empresa", bdLike.split('_')[1].toString());

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DetalleContratosPage(id_con: idCon)
      ),
    );
  }
}
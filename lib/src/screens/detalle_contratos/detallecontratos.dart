import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/comentarios/comentarioscontratos.dart';
import 'package:gmp/src/screens/detalle_contratos/calificaciones.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleContratosPage extends StatefulWidget {
  final String id_con;
  DetalleContratosPage({Key key, this.id_con}) : super(key: key);

  @override
  _DetalleContratosPageState createState() => _DetalleContratosPageState();
}

class _DetalleContratosPageState extends State<DetalleContratosPage> {
  SizeConfig _sc = SizeConfig();
  SharedPreferences spreferences;
  String bd;
  String empresa;
  List contratos;
  String valur = "0";
  String valor;
  String num_contrato;
  String duracion;
  String interventor;
  String estad_contrato;
  String link;
  String nombre_proyecto = "";
  List estado_inicial;
  List avances;
  List estado_final;
  List lista_slider;
  int banproducto;
  String id_usu;
  String likes;
  String comentarios;
  Color color;
  Color colorazul = Colors.blue[900];
  Color colorblanco = Colors.white;
  int seleccionado = 1;

  var tienelikes = false;
  final oCcy = new NumberFormat("#,##0", "es_CO");

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            padding: EdgeInsets.only(left: defaultpadding + 30),
            child:Text("Detalle del contrato")
          ),
          toolbarHeight: 60,
          backgroundColor: kazul,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(defaultpadding),
            child: Column(
              children: [
                SizedBox(height: defaultpadding),
                Container(
                  width: size.width * 0.9,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ 
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Información del contrato",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: _sc.getProportionateScreenHeight(23),
                            color: kazuloscuro
                          ),
                        ),
                      ),
                      SizedBox(
                        height: defaultpadding - 5,
                      ),
                      nombre_proyecto != "" ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: Text(
                                nombre_proyecto,
                                textAlign: TextAlign.justify,
                                style: TextStyle(),
                              )
                            ),
                        ],
                      ) : Column(
                        children: <Widget>[
                          nombre_cargando(),
                          SizedBox(
                            height: 5,
                          ),
                          nombre_cargando(),
                          SizedBox(
                            height: 5,
                          ),
                          nombre_cargando(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      SizedBox(height: defaultpadding),
                      valor == null ? nombre_cargando() : Row(
                        children: <Widget>[
                          Text(
                            "Valor: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            "\$ ${oCcy.format(int.parse(valor)).replaceAll(",00", "")}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: defaultpadding - 15),
                      duracion == null ? nombre_cargando() : Row(
                        children: <Widget>[
                          Text(
                            "Duración: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            "${duracion}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: defaultpadding - 15),
                      interventor == null ? nombre_cargando() : Row(
                        children: <Widget>[
                          Text(
                            "Interventor: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Expanded(
                            child: Text(
                              "${interventor}",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      estad_contrato == null ? nombre_cargando() : Row(
                        children: <Widget>[
                          Text(
                            "Estado actual del proyecto: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          badges.Badge(
                            toAnimate: false,
                            shape: badges.BadgeShape.square,
                            badgeColor: color,
                            borderRadius: BorderRadius.circular(8),
                            badgeContent: Text(
                              estad_contrato,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ]
                  )
                ),
                SizedBox(
                  height: _sc.getProportionateScreenHeight(30),
                ),
                GestureDetector(
                  onTap: () {
                    openBrowserTab(link);
                  },
                  child: Text(
                    'Ver contrato en el secop',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.blueAccent
                    ),
                  ),
                ),
                SizedBox(
                  height: _sc.getProportionateScreenHeight(30),
                ),
                Center(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          cambiar(1);
                        },
                        child: Container(
                          width: (size.width / 3) - 15,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                            color: seleccionado == 1
                                ? Colors.blue[900]
                                : Colors.white,
                            border: Border.all(color: Colors.blue[900]),
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(10.0),
                                bottomLeft: const Radius.circular(10.0)),
                          ),
                          child: Center(
                            child: Text(
                              "Fase inicial",
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
                          width: (size.width / 3) - 15,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                            color: seleccionado == 2
                                ? Colors.blue[900]
                                : Colors.white,
                            border: Border.all(color: Colors.blue[900]),
                          ),
                          child: Center(
                            child: Text(
                              "Avances",
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
                      GestureDetector(
                        onTap: () {
                          cambiar(3);
                        },
                        child: Container(
                          width: (size.width / 3) - 15,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                            color: seleccionado == 3
                                ? Colors.blue[900]
                                : Colors.white,
                            border: Border.all(color: Colors.blue[900]),
                            borderRadius: BorderRadius.only(
                                topRight: const Radius.circular(10.0),
                                bottomRight: const Radius.circular(10.0)),
                          ),
                          child: Center(
                            child: Text(
                              "Fase final",
                              style: seleccionado == 3
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
                  height: 16,
                ),
                lista_slider != null
                    ? lista_slider.length > 0
                        ? Imagenes(
                            size: size,
                            lista_slider: lista_slider,
                            empresa: empresa)
                        : Container(
                            height: size.height * 0.3,
                            decoration: BoxDecoration(border: Border()),
                            child: Image.asset('assets/images/no-image.jpg',
                                fit: BoxFit.cover),
                          )
                    : Container(),
                SizedBox(height: 5),
                SizedBox(height: 5),
                Row(
                  children: [
                    Center(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              gustar();
                            },
                            child: tienelikes == false? Icon(
                              Icons.favorite_border,
                              color: Colors.redAccent,
                              size: 40,
                            ) : Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                              size: 40,
                            ),
                          ),
                          Text(
                            likes == null ? '0' : likes,
                            style: TextStyle(
                                fontSize: defaultpadding - 5,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: defaultpadding,
                          ),
                          GestureDetector(
                            onTap: () {
                              mostrarcaja(context);
                            },
                            child: Icon(
                              Icons.message,
                              color: Colors.blueAccent,
                              size: 40,
                            ),
                          ),
                          Text(
                            comentarios == null ? "0" : comentarios,
                            style: TextStyle(
                                fontSize: defaultpadding - 5,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: _sc.getProportionateScreenWidth(20),
                          ),
                          GestureDetector(
                            onTap: () {
                              modalCalificaciones(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.star, color: Colors.yellow, size: 40),
                                Text(
                                  valur.toString(),
                                  style: TextStyle(
                                      fontSize: defaultpadding - 5,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    instanciar_sesion();
  }

  verificarLike() async {
    var response = await http.get(
      Uri.parse('${URL_SERVER}verificar-likes-contrato?bd=${bd}&id_con=${num_contrato}&id_usu=${id_usu}'),
      headers: {"Accept": "application/json"});
    var reponsebody = json.decode(response.body);

    var likes = reponsebody['like'];
    if(likes[0]["likes"] > 0){
      setState(() {
        tienelikes = true;
      });
    }else{
      setState(() {
        tienelikes = false;
      });
    }
  }

  Future<String> gustar() async {
    
     if(tienelikes == true){
      setState(() {
        tienelikes = false;
        likes = (int.parse(likes) - 1).toString();
      });
    }else{
       setState(() {
        tienelikes = true;
        likes = (int.parse(likes) + 1).toString();
      });
    }

    var response = await http.get(
        Uri.parse(
            '${URL_SERVER}likes?bd=${bd}&id_con=${num_contrato}&id_usu=${id_usu}'),
        headers: {"Accept": "application/json"});
    buscar_contratos();
  }

  Future<String> rating() async {
    var total;
    var todos;
    var temp;
    var response = await http.get(
        Uri.parse('${URL_SERVER}contrato?bd=${bd}&id=${widget.id_con}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);
    this.setState(() {
      total = reponsebody['rating']["total"].toString();
      todos = reponsebody['rating']["todos"].toString();
      temp = (int.parse(total) / int.parse(todos)).toString();
      valur = temp.substring(0, temp.indexOf("."));
    });

    return "Success!";
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");
    id_usu = spreferences.getString("id");
    buscar_contratos();
  }

  Future<String> buscar_contratos() async {
    var response = await http.get(
      Uri.parse('${URL_SERVER}contrato?bd=${bd}&id=${widget.id_con}'),
      headers: {"Accept": "application/json"}
    );

    final reponsebody = json.decode(response.body);

    this.setState(() {
      nombre_proyecto = reponsebody['contrato']['obj_contrato'];
      this.valor = reponsebody['contrato']['vcontr_contrato'].toString();
      this.num_contrato = reponsebody['contrato']["num_contrato"].toString();
      this.duracion = reponsebody['contrato']['durac_contrato'];
      this.interventor = reponsebody['contrato']['nom_interventores'];
      this.estad_contrato = reponsebody['contrato']['estad_contrato'];
      this.link = reponsebody['contrato']['secop_contrato'];
      this.avances = reponsebody['avances'];
      this.estado_inicial = reponsebody['estado_inicial'];
      this.estado_final = reponsebody['estado_final'];
      this.likes = reponsebody['likes'].toString();
      this.comentarios = reponsebody['comentarios'].toString();

      if (estad_contrato == "Ejecucion") {
        color = Colors.green[800];
      } else if (estad_contrato == "Suspendido") {
        color = Colors.red[800];
      } else if (estad_contrato == "Liquidado") {
        color = Colors.yellow[800];
      } else if (estad_contrato == "Terminado") {
        color = Colors.blue[800];
      }
      lista_slider = this.estado_inicial;
      verificarLike();
    });
    return "Success!";
  }

  Widget nombre_cargando() {
    return SkeletonAnimation(
      child: Container(
        height: 10,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.0), color: Colors.grey[300]),
      ),
    );
  }

  openBrowserTab(String url) async {
     if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  cambiar(int sel) {
    setState(() {
      seleccionado = sel;
      if (sel == 1) {
        lista_slider = estado_inicial;
      } else if (sel == 2) {
        lista_slider = avances;
      } else if (sel == 3) {
        lista_slider = estado_final;
      }
    });
  }

  mostrarcaja(BuildContext context) {
    var pad = MediaQuery.of(context).padding.top;
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return ComentariosContratosPage(id_con: widget.id_con, valortop: pad);
        }).whenComplete(() {
      print('Hey there, I\'m calling after hide bottomSheet');
    });
  }

  modalCalificaciones(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return CalificarPage(idProyect: num_contrato);
        }).whenComplete(() {
      rating();
    });
  }
}

class Imagenes extends StatelessWidget {
  const Imagenes({
    Key key,
    @required this.size,
    @required this.lista_slider,
    @required this.empresa,
  }) : super(key: key);

  final Size size;
  final List lista_slider;
  final String empresa;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: size.height * 0.25,
        enlargeCenterPage: true,
        autoPlay: false,
        aspectRatio: 16 / 9,
        enableInfiniteScroll: true,
        viewportFraction: 0.82,
      ),
      items: lista_slider.map((i) {
        return Builder(builder: (BuildContext context) {
          return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(color: Color.fromARGB(255, 216, 216, 216)),
              child: i['tipo'] == "P"
                  ? Image.network(
                      '${URL_PROYECTOS}${empresa}/${i['num_contrato_galeria']}/${i["img_galeria"]}',
                      fit: BoxFit.cover)
                  : Image.network(
                      '${URL_CONTRATOS}${empresa}/${i['num_contrato_galeria']}/${i["img_galeria"]}',
                      fit: BoxFit.cover));
        });
      }).toList(),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/comentarios/comentarios.dart';
import 'package:gmp/src/screens/detalle_proyectos/calificaciones.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:skeleton_text/skeleton_text.dart';

class DetalleProyetcosPage extends StatefulWidget {
  final idproyect;
  DetalleProyetcosPage({Key key, this.idproyect}) : super(key: key);

  @override
  _DetalleProyetcosPageState createState() => _DetalleProyetcosPageState();
}

class _DetalleProyetcosPageState extends State<DetalleProyetcosPage> {
  SizeConfig _sc = SizeConfig();
  SharedPreferences spreferences;
  String bd;
  String empresa;
  String id_usu;
  List proyecto;
  String valur = "0";
  String nombre_proyecto;
  String secretaria_proyecto;
  String numero_proyecto;
  String tipo_proyecto;
  List estado_inicial;
  List avances;
  List estado_final;
  String estado_proyect;
  String porceEjec_proyect;
  List lista_slider;
  List metas_producto;
  int banproducto;
  String likes;
  String comentarios;
  Color color;
  Color colorazul = Colors.blue[900];
  Color colorblanco = Colors.white;
  int seleccionado = 1;
  var tienelikes = false;
  int idProyecto;

  String dsecretar_proyect = "";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            padding: EdgeInsets.only(left: defaultpadding + 30),
            child:Text("Detalle del proyecto")
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
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
                          "Información del proyecto",
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
                      nombre_proyecto != null ? Text(nombre_proyecto) : Column(
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
                      estado_proyect == null ? nombre_cargando() : Row(
                        children: <Widget>[
                          Text(
                            "Estado actual del proyecto: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: defaultpadding - 3),
                          ),
                          badges.Badge(
                            toAnimate: false,
                            shape: badges.BadgeShape.square,
                            badgeColor: color,
                            borderRadius: BorderRadius.circular(8),
                            badgeContent: Text(estado_proyect,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: defaultpadding - 6,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      porceEjec_proyect == null ? nombre_cargando() : Row(
                        children: <Widget>[
                          Text(
                            "Porcetanje de ejecución: ${porceEjec_proyect}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: defaultpadding - 3),
                          ),
                        ],
                      ),
                      SizedBox( height: 5),
                      Container(
                        height: 2,
                        color: Color.fromARGB(90, 169, 170, 170),
                      ),
                       SizedBox( height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.account_balance, color: Colors.grey),
                          SizedBox(width: 10),
                          Container(
                            width: size.width * 0.7,
                            child: Text(
                              dsecretar_proyect,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: defaultpadding - 3
                              ),
                            ),
                          )
                               
                        ],
                      )
                    ]
                  )
                ),
                SizedBox(
                  height: defaultpadding + 15,
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
                SizedBox(height: 15),
                Row(
                  children: [
                    Center(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
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
                              size: 40
                            ),
                          ),
                          Text(
                            comentarios == null ? "0" : comentarios,
                            style: TextStyle(
                                fontSize: defaultpadding - 5,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: defaultpadding, //size.width * 0.7,
                          ),
                          GestureDetector(
                            onTap: () {
                              modalCalificaciones(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.star, color: Color.fromARGB(255, 255, 219, 59), size: 40),
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
                SizedBox(
                  height: _sc.getProportionateScreenHeight(20),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Metas de producto",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: _sc.getProportionateScreenHeight(20)),
                  ),
                ),
                SizedBox(
                  height: _sc.getProportionateScreenHeight(10),
                ),
                banproducto == 0
                    ? Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "No hay información disponible",
                          style: TextStyle(
                            fontSize: _sc.getProportionateScreenHeight(15),
                          ),
                        ),
                      )
                    : Text("Si hay información")
              ],
            ),
          ),
        ),
      ),
    );
  }

  mostrarcaja(BuildContext context) {
    var pad = MediaQuery.of(context).padding.top;
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return ComentariosPage(
            idproyect: widget.idproyect,
            valortop: pad,
            valorbottom: MediaQuery.of(context).padding.bottom,
          );
        }).whenComplete(() {
      buscar_proyectos();
    });
  }

  modalCalificaciones(BuildContext context) {
    var pad = MediaQuery.of(context).padding.top;
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return CalificarPage(idProyect: widget.idproyect);
        }).whenComplete(() {
      
      rating();
    });
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");
    id_usu = spreferences.getString("id");
    buscar_proyectos();
    rating();
  }

  Future<String>  gustar() async{

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
        Uri.parse('${URL_SERVER}likes_proyectos?bd=${bd}&id_con=${widget.idproyect}&id_usu=${id_usu}'),
        headers: {"Accept": "application/json"});
        buscar_proyectos();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    proyecto = new List();
    avances = new List();
    colorazul = Colors.blue[900];
    colorblanco = Colors.white;
    metas_producto = new List();
    estado_inicial = new List();
    estado_final = new List();
    avances = new List();
    lista_slider = new List();
    instanciar_sesion();
  }

  Future<String> buscar_proyectos() async {
    var response = await http.get(
      Uri.parse('${URL_SERVER}proyecto?bd=${bd}&id=${widget.idproyect}'),
      headers: {"Accept": "application/json"}
    );

    final reponsebody = json.decode(response.body);

    this.setState(() {
      idProyecto = reponsebody['proyecto']['id_proyect'];
      nombre_proyecto = reponsebody['proyecto']['nombre_proyect'];
      secretaria_proyecto = reponsebody['proyecto']['dsecretar_proyect'];
      this.numero_proyecto = reponsebody['proyecto']['cod_proyect'];
      this.tipo_proyecto = reponsebody['proyecto']['dtipol_proyec'];
      this.estado_inicial = reponsebody['estado_inicial'];
      this.avances = reponsebody['avances'];
      this.estado_final = reponsebody['estado_final'];
      this.estado_proyect = reponsebody['proyecto']['estado_proyect'];
      this.porceEjec_proyect = reponsebody['proyecto']['porceEjec_proyect'];
      this.dsecretar_proyect = reponsebody['proyecto']['dsecretar_proyect'];
      this.banproducto = metas_producto.length;
      this.likes = reponsebody['likes'].toString();
      this.comentarios = reponsebody['comentarios'].toString();
      if (estado_proyect == "En Ejecucion") {
        color = Colors.green[800];
      } else if (estado_proyect == "No Viabilizado") {
        color = Colors.red[800];
      } else if (estado_proyect == "Priorizado") {
        color = Colors.yellow[800];
      } else if (estado_proyect == "Ejecutado") {
        color = Colors.blue[800];
      } else if (estado_proyect == "Registrado") {
        color = Colors.grey[700];
      } else if (estado_proyect == "Radicado") {
        color = Colors.pink[800];
      }
      lista_slider = this.estado_inicial;
      verificarLike();
    });

    return "Success!";
  }

   verificarLike() async {
    var response = await http.get(
      Uri.parse('${URL_SERVER}verificar-likes-proyecto?bd=${bd}&id_pro=${idProyecto}&id_usu=${id_usu}'),
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


  Future<String> rating() async {
    var total;
    var todos;
    var temp;

    var response = await http.get(
      Uri.parse('${URL_SERVER}proyecto?bd=${bd}&id=${widget.idproyect}'),
      headers: {"Accept": "application/json"}
    );

    final reponsebody = json.decode(response.body);
    this.setState(() {
      total = reponsebody['rating']["total"].toString();
      todos = reponsebody['rating']["todos"].toString();
      temp = (total == "null" ? 0 : int.parse(total) / int.parse(todos)).toString();
      valur = temp == "0" ? "0": temp.substring(0, temp.indexOf("."));
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
                      '${URL_PROYECTOS}${empresa}/${i['numero']}/${i["img_galeria"]}',
                      fit: BoxFit.cover)
                  : Image.network(
                      '${URL_CONTRATOS}${empresa}/${i['numero']}/${i["img_galeria"]}',
                      fit: BoxFit.cover));
        });
      }).toList(),
    );
  }
}

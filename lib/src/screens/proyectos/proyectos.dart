import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gmp/src/screens/contratos/contratos.dart';
import 'package:gmp/src/screens/detalle_proyectos/detalleproyectos.dart';
import 'package:gmp/src/screens/proyectos/componentes/circulo.dart';
import 'package:gmp/src/screens/proyectos/componentes/resumen.dart';
import 'package:gmp/src/screens/proyectos/proyectos.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

class ProyectosPage extends StatefulWidget {
  final String id;
  final String nombreSecretaria;

  ProyectosPage({Key key, this.id, this.nombreSecretaria}) : super(key: key);

  @override
  _ProyectosPageState createState() => _ProyectosPageState();
}

class _ProyectosPageState extends State<ProyectosPage> {
  SizeConfig _sc = SizeConfig();
  String bd;
  List proyectos;
  List secretaria;
  String empresa;
  SharedPreferences spreferences;
  int actual = 0;
  int valor = 0;
  String pendiente = "\$0";
  String ejecutado = "\$0";
  double _anguloejecutado = 0;
  double porcentaje_ejecutado = 0;
  final oCcy = new NumberFormat("#,##0", "es_CO");
  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  var data1 = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, 1.0, 1.5, 2.0, 5.0, 7.0];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kgrayfondo,
        appBar: AppBar(
          title: Text(
            widget.nombreSecretaria,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: kazuloscuro, fontSize: 15),
          ),
          elevation: 0,
          backgroundColor: kgrayfondo,
          iconTheme: IconThemeData(
            color: kazuloscuro, //change your color here
          ),
          /*bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultpadding),
                  child: TabBar(
                    isScrollable: true,
                    indicatorWeight: 5,
                    indicatorSize: TabBarIndicatorSize.label, //makes it better
                    labelColor: Color(0xff1a73e8), //Google's sweet blue
                    unselectedLabelColor: Color(0xff5f6368), //niceish grey
                    indicator: MD2Indicator(
                        //it begins here
                        indicatorHeight: 3,
                        indicatorColor: kazuloscuro,
                        indicatorSize: MD2IndicatorSize
                            .normal //3 different modes tiny-normal-full
                        ),
                    tabs: [
                      Container(
                        child: Text(
                          "Resumen",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "Proyectos",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),*/
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "\$${oCcy.format(valor)}",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
              ),
              Center(
                child: Text(
                  "Presupuesto",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600]),
                ),
              ),
              SizedBox(
                height: _sc.getProportionateScreenHeight(40),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: _sc.getProportionateScreenWidth(200),
                      child: CustomPaint(
                        painter: Circulo(kverdepastel, _anguloejecutado),
                        child: Center(
                          child: Text(
                            "${oCcy.format(porcentaje_ejecutado)}%",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultpadding),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Pendiente",
                                        style: TextStyle(
                                            color: kvinotinto,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        pendiente,
                                        style: TextStyle(
                                            fontSize: _sc
                                                .getProportionateScreenHeight(
                                                    14),
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: defaultpadding),
                                  width: _sc.getProportionateScreenWidth(40),
                                  height: _sc.getProportionateScreenWidth(60),
                                  child: Sparkline(
                                    data: data,
                                    lineWidth: 4.0,
                                    lineGradient: new LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.red[800],
                                        Colors.red[200]
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: _sc.getProportionateScreenHeight(10),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultpadding),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Ejecutado",
                                      style: TextStyle(
                                          color: kverdepastel,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      ejecutado,
                                      style: TextStyle(
                                          fontSize: _sc
                                              .getProportionateScreenHeight(14),
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: defaultpadding),
                                  width: _sc.getProportionateScreenWidth(40),
                                  height: _sc.getProportionateScreenWidth(60),
                                  child: Sparkline(
                                    data: data1,
                                    lineWidth: 4.0,
                                    lineGradient: new LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.green[800],
                                        Colors.green[200]
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: defaultpadding + defaultpadding,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Listado de proyectos",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800]),
                  ),
                ),
              ),
              SizedBox(
                height: defaultpadding,
              ),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: proyectos == null ? 0 : proyectos.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Container(
                        width: size.width,
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultpadding - 10,
                              horizontal: defaultpadding),
                          child: Text(
                            '${proyectos[index]['estado_proyect']} (${proyectos[index]['cont']})',
                            style: TextStyle(
                                fontSize: _sc.getProportionateScreenHeight(
                                    defaultpadding - 3),
                                fontWeight: FontWeight.w600,
                                color: kazuloscuro),
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: proyectos[index]['proyectos'] == null
                            ? 0
                            : proyectos[index]['proyectos'].length,
                        itemBuilder: (BuildContext context, int index1) {
                          var proy = [];
                          proy = proyectos[index]['proyectos'];
                          return InkWell(
                            onTap: () {
                              verproyecto(
                                  proy[index1]['id_proyect'].toString(),
                                  proy[index1]['estado_proyect'],
                                  '${URL_PROYECTOS}${empresa}/${proy[index1]['num_proyect_galeria']}/${proy[index1]['img_galeria']}');
                            },
                            child: Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Container(
                                child: ListTile(
                                    leading: CircleAvatar(
                                      radius: defaultpadding + 10,
                                      backgroundImage: NetworkImage(
                                          '${URL_PROYECTOS}${empresa}/${proy[index1]['num_proyect_galeria']}/${proy[index1]['img_galeria']}'),
                                    ),
                                    title: Text(
                                        proy[index1]['nombre_proyect'].length >=
                                                79
                                            ? '${proy[index1]['nombre_proyect'].substring(0, 1).toUpperCase()}${proy[index1]['nombre_proyect'].substring(1, 79).toLowerCase()} '
                                            : '${proy[index1]['nombre_proyect'].substring(0, 1).toUpperCase()}${proy[index1]['nombre_proyect'].substring(1).toLowerCase()} ',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    subtitle: RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                        text:
                                            '${proy[index1]['dtipol_proyec']}',
                                        style: TextStyle(color: Colors.black54),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '\n${proy[index1]['fec_crea_proyect']}',
                                              style: TextStyle(
                                                  color: Colors.black54))
                                        ],
                                      ),
                                    )
                                    //Text('${proy[index1]['dtipol_proyec']}'),
                                    ),
                              ),
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Contratos',
                                  color: Colors.blue,
                                  icon: Icons.archive,
                                  onTap: () => {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => ContratosPage(
                                            id: proy[index1]['id_proyect']
                                                .toString()),
                                      ),
                                    )
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");
    buscar_proyectos();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    proyectos = [];
    secretaria = [];
    instanciar_sesion();
  }

  Future<String> buscar_proyectos() async {
    var pend = 0;
    var eje = 0;
    var response = await http.get(
        Uri.parse('${URL_SERVER}secretaria?bd=${bd}&id=${widget.id}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    eje = reponsebody["secretaria"][0]['TOTAL_EJECUCION_PROYECTOS'];
    pend = reponsebody['valor'] - eje;

    this.setState(() {
      this.proyectos = reponsebody['proyectos'];
      this.secretaria = reponsebody['secretaria'];
      this.valor = reponsebody['valor'];
      if (pend > 1000000) {
        this.pendiente = oCcy.format(pend / 1000000) + "M";
      } else {
        this.pendiente = oCcy.format(pend);
      }

      if (eje > 1000000) {
        this.ejecutado = oCcy.format(eje / 1000000) + "M";
      } else {
        this.ejecutado = oCcy.format(eje);
      }

      _anguloejecutado = (360 * eje) / valor;
      porcentaje_ejecutado = (100 * eje) / valor;
    });

    return "Success!";
  }

  verproyecto(String idproyect, String estado, String imagen) {
    if (estado == "Ejecutado" || estado == "En Ejecucion") {
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => DetalleProyetcosPage(idproyect: idproyect)),
      );
    }
  }
}

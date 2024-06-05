import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gmp/src/screens/contratos/contratos.dart';
import 'package:gmp/src/screens/detalle_proyectos/detalleproyectos.dart';
import 'package:gmp/src/screens/proyectos/proyectos.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Proyectos1Page extends StatefulWidget {
  final String id;
  final String nombreSecretaria;

  Proyectos1Page({Key key, this.id, this.nombreSecretaria}) : super(key: key);

  @override
  _Proyectos1PageState createState() => _Proyectos1PageState();
}

class _Proyectos1PageState extends State<Proyectos1Page> {
  SizeConfig _sc = SizeConfig();
  String bd;
  List proyectos;
  String empresa;
  SharedPreferences spreferences;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text(widget.nombreSecretaria)),
      body: new ListView.builder(
        shrinkWrap: true,
        itemCount: proyectos == null ? 0 : proyectos.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey),
                      bottom: BorderSide(color: Colors.grey),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(defaultpadding - 10),
                  child: Text(
                    '${proyectos[index]['estado_proyect']} (${proyectos[index]['cont']})',
                    style: TextStyle(
                        fontSize: _sc
                            .getProportionateScreenHeight(defaultpadding - 3),
                        fontWeight: FontWeight.w500),
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
                  var proy = new List();
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
                                proy[index1]['nombre_proyect'].length >= 79
                                    ? '${proy[index1]['nombre_proyect'].substring(0, 1).toUpperCase()}${proy[index1]['nombre_proyect'].substring(1, 79).toLowerCase()} '
                                    : '${proy[index1]['nombre_proyect'].substring(0, 1).toUpperCase()}${proy[index1]['nombre_proyect'].substring(1).toLowerCase()} ',
                                textAlign: TextAlign.justify,
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text: '${proy[index1]['dtipol_proyec']}',
                                style: TextStyle(color: Colors.black54),
                                children: [
                                  TextSpan(
                                      text:
                                          '\n${proy[index1]['fec_crea_proyect']}',
                                      style: TextStyle(color: Colors.black54))
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
                                    id: proy[index1]['id_proyect'].toString()),
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
    proyectos = new List();
    instanciar_sesion();
  }

  Future<String> buscar_proyectos() async {
    var response = await http.get(
        Uri.parse('${URL_SERVER}secretaria?bd=${bd}&id=${widget.id}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    print(reponsebody['secretaria']);

    this.setState(() {
      this.proyectos = reponsebody['proyectos'];
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

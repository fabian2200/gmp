import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gmp/src/screens/contratos/contratos.dart';
import 'package:gmp/src/screens/detalle_proyectos/detalleproyectos.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ListadoProyectos extends StatefulWidget {
  final String tipo;
  final String departamento;
  final String municipio;
  final String corregimiento;
  final String secretaria;
  ListadoProyectos(
      {Key key,
      this.tipo,
      this.departamento,
      this.municipio,
      this.corregimiento,
      this.secretaria})
      : super(key: key);

  @override
  _ListadoProyectosState createState() => _ListadoProyectosState();
}

class _ListadoProyectosState extends State<ListadoProyectos> {
  SizeConfig _sc = SizeConfig();
  SharedPreferences spreferences;
  String bd;
  String empresa;
  List proyectos;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Listado de proyectos"),
        ),
        body: ListView.builder(
                shrinkWrap: true,
                itemCount: proyectos == null
                    ? 0
                    : proyectos.length,
                itemBuilder: (BuildContext context, int index1) {
                  var proy = new List();
                  proy = proyectos;
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
                                ),)
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
                                builder: (context) =>
                                    ContratosPage(id: proy[index1]['id_proyect'].toString()),
                              ),
                            )
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<String> verproyectos() async {
    if (widget.tipo == "Geo") {
      var response = await http.get(
          Uri.parse(
              '${URL_SERVER}busproyectostexto?bd=${bd}&id=${widget.secretaria}&dep=${widget.departamento}&mun=${widget.municipio}&cor=${widget.corregimiento}'),
          headers: {"Accept": "application/json"});

      final reponsebody = json.decode(response.body);
      //print(reponsebody);
      this.setState(() {
        proyectos = reponsebody["proyectos"];
      });
    } else {
      print(
          '${URL_SERVER}busproyectos?bd=${bd}&id=${widget.secretaria}&dep=${widget.departamento}&mun=${widget.municipio}&cor=${widget.corregimiento}');
      var response = await http.get(
          Uri.parse(
              '${URL_SERVER}busproyectos?bd=${bd}&id=${widget.secretaria}&dep=${widget.departamento}&mun=${widget.municipio}&cor=${widget.corregimiento}'),
          headers: {"Accept": "application/json"});

      final reponsebody = json.decode(response.body);
      //print(reponsebody);
      this.setState(() {
        proyectos = reponsebody["proyectos"];
      });
    }

    return "Success!";
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");
    verproyectos();
  }

  @override
  void initState() {
    super.initState();
    proyectos = new List();
    instanciar_sesion();
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

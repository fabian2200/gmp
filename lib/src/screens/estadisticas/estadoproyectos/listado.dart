import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gmp/src/screens/contratos/contratos.dart';
import 'package:gmp/src/screens/detalle_proyectos/detalleproyectos.dart';
import 'package:gmp/src/screens/estadisticas/estadoproyectos/grafica.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ListadoEstado extends StatefulWidget {
  final String estado;
  final String idSecretaria;
  ListadoEstado({Key key,this.estado, this.idSecretaria}) : super(key: key);

  @override
  _ListadoEstadoState createState() => _ListadoEstadoState();
}

class _ListadoEstadoState extends State<ListadoEstado> {
  List proyectos;
  SharedPreferences spreferences;
  String bd;
    String empresa;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
       appBar: AppBar(
         title: Text("Listado proyectos")
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

    );
  }

  @override
  void initState() {
    super.initState();
    proyectos = new List();
    instanciar_sesion();
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");
    buscar_proyectos();
  }

  Future<String> buscar_proyectos() async {
    //print('${URL_SERVER}buscarproyectosestados?bd=${bd}&estado=${widget.estado}&id=${widget.idSecretaria}');
    var response = await http.get(
        Uri.parse('${URL_SERVER}buscarproyectosestados?bd=${bd}&estado=${widget.estado}&id=${widget.idSecretaria}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

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
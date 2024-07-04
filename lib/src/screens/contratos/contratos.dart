import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gmp/src/screens/detalle_contratos/detallecontratos.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContratosPage extends StatefulWidget {
  final String id;
  ContratosPage({Key key, this.id}) : super(key: key);

  @override
  _ContratosPageState createState() => _ContratosPageState();
}

class _ContratosPageState extends State<ContratosPage> {
  SizeConfig _sc = SizeConfig();
  String bd;
  List contratos;
  String empresa;
  SharedPreferences spreferences;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Contratos")),
      body: new ListView.builder(
        shrinkWrap: true,
        itemCount: contratos == null ? 0 : contratos.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              vercontrato(contratos[index]['id_con'].toString(),
                  contratos[index]['estado_proyect']);
            },
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: defaultpadding + 10,
                    backgroundImage: NetworkImage(
                        '${URL_CONTRATOS}${empresa}/${contratos[index]['num_contrato_galeria']}/${contratos[index]['img_galeria']}'),
                  ),
                  title: Text(
                      contratos[index]['obj_contrato'].length >= 79
                          ? '${contratos[index]['obj_contrato'].substring(0, 1).toUpperCase()}${contratos[index]['obj_contrato'].substring(1, 79).toLowerCase()} '
                          : '${contratos[index]['obj_contrato'].substring(0, 1).toUpperCase()}${contratos[index]['obj_contrato'].substring(1).toLowerCase()} ',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: '${contratos[index]['destipolg_contrato']}',
                      style: TextStyle(color: Colors.black54),
                      children: [
                        TextSpan(
                            text: '\n${contratos[index]['fcrea_contrato']}',
                            style: TextStyle(color: Colors.black54))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    instanciar_sesion();
  }

  Future<String> buscar_contratos() async {
    var response = await http.get(
      Uri.parse('${URL_SERVER}contratos?bd=${bd}&id=${widget.id}'),
      headers: {"Accept": "application/json"}
    );

    final reponsebody = json.decode(response.body);

    this.setState(() {
      this.contratos = reponsebody['contratos'];
    });

    return "Success!";
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");
    buscar_contratos();
  }

  vercontrato(String id_con, String estado) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DetalleContratosPage(id_con: id_con)
      ),
    );
  }
}

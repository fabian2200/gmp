import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/respuestas/respuestas.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';

class VistaComentario extends StatelessWidget {
  const VistaComentario({
    Key key,
    @required this.comentarios,
    @required SizeConfig sc,
    @required this.size,
    @required this.index,
    @required this.mres,
    @required this.tam,
    @required this.tipo,
    @required this.idProyecto,
    @required this.fecha,
    @required this.hora
  })  : _sc = sc,
        super(key: key);

  final List comentarios;
  final SizeConfig _sc;
  final Size size;
  final int index;
  final String mres;
  final double tam;
  final String tipo;
  final String idProyecto;
  final String fecha;
  final String hora;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: defaultpadding,
            backgroundImage: NetworkImage(comentarios[index]['imagen'] ==
                    "noimage"
                ? '${URL_SERVER}/images/foto/${comentarios[index]['imagen']}.png'
                : '${URL_SERVER}/images/foto/${comentarios[index]['imagen']}'),
          ),
          SizedBox(width: _sc.getProportionateScreenWidth(10)),
          Column(
            children: [
              Container(
                width: size.width * tam,
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
                        comentarios[index]['nombre'],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: _sc.getProportionateScreenHeight(16),
                        ),
                      ),
                      Container(
                        child: Text(
                          comentarios[index]["comentario"],
                          style: TextStyle(
                            fontSize: _sc.getProportionateScreenHeight(14),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _sc.getProportionateScreenHeight(5),
                      ),
                       Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(calcularFechas(fecha)+"A las ", style: TextStyle(fontStyle: FontStyle.italic, fontSize: _sc.getProportionateScreenHeight(10))),
                            Text(hora, style: TextStyle(fontStyle: FontStyle.italic, fontSize: _sc.getProportionateScreenHeight(10)))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: _sc.getProportionateScreenHeight(5),
              ),
              mres == "si"
                  ? GestureDetector(
                      onTap: () {
                        var imagen;
                        if (comentarios[index]['imagen'] == "noimage") {
                          imagen =
                              '${URL_SERVER}/images/foto/${comentarios[index]['imagen']}.png';
                        } else {
                          imagen =
                              '${URL_SERVER}/images/foto/${comentarios[index]['imagen']}';
                        }
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RespuestasPage(
                                id: comentarios[index]['id'].toString(),
                                respuestas: comentarios[index]['respuestas'],
                                name: comentarios[index]['nombre'],
                                comentario: comentarios[index]['comentario'],
                                image: imagen,
                                tipo: tipo,
                                idProyecto: idProyecto),
                          ),
                        );
                      },
                      child: Container(
                        width: size.width * 0.65,
                        child: Row(children: [
                          Text(
                            "Respuestas (${comentarios[index]['response']})",
                            style: TextStyle(
                                fontSize: _sc.getProportionateScreenHeight(14)),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              var imagen;
                              if (comentarios[index]['imagen'] == "noimage") {
                                imagen =
                                    '${URL_SERVER}/images/foto/${comentarios[index]['imagen']}.png';
                              } else {
                                imagen =
                                    '${URL_SERVER}/images/foto/${comentarios[index]['imagen']}';
                              }
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => RespuestasPage(
                                      id: comentarios[index]['id'].toString(),
                                      respuestas: comentarios[index]
                                          ['respuestas'],
                                      name: comentarios[index]['nombre'],
                                      comentario: comentarios[index]
                                          ['comentario'],
                                      image: imagen,
                                      tipo: tipo),
                                ),
                              );
                            },
                            child: Text(
                              "Responder",
                              style: TextStyle(
                                  fontSize:
                                      _sc.getProportionateScreenHeight(14),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700]),
                            ),
                          )
                        ]),
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  calcularFechas(var fecha){
    DateTime fecha1 =  DateTime.parse(fecha);
    DateTime fecha2 =  DateTime.now();

    Duration _diastotales = fecha2.difference(fecha1);

    List<String> meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo","Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
    
    if(_diastotales.inDays == 0){
      return "Hoy ";
    }else{
      if (_diastotales.inDays == 1) {
        return "Ayer ";
      }else{
        if(_diastotales.inDays <= 7){
          return "Hace "+_diastotales.inDays.toString()+" dias ";
        }else{
          return fecha1.day.toString()+" de "+meses[fecha1.month]+" del "+fecha1.year.toString()+", ";
        }
        
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:gmp/src/screens/estadisticas/estadoproyectos/listado.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:pie_chart/pie_chart.dart';

class InterfazGrafica extends StatefulWidget {
  final SizeConfig sc;
  final Map<String, double> dataMap;
  final int total;
  final String idSecretaria;
  final String nombreSecretaria;
  final int ejecucion;
  final int ejecutados;
  final int radicados;
  final int priorizados;
  final int registrados;
  final int no_viabilizados;
  final List<Color> colores;
  final BuildContext context;

  InterfazGrafica({Key key, this.sc, this.dataMap, this.total, this.idSecretaria, this.nombreSecretaria,
  this.ejecucion, this.ejecutados, this.radicados, this.priorizados, this.registrados, this.no_viabilizados, this.colores,this.context}) : super(key: key);

  @override
  _InterfazGraficaState createState() => _InterfazGraficaState();
}

class _InterfazGraficaState extends State<InterfazGrafica> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: widget.sc.getProportionateScreenHeight(0),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: double.infinity,
                  child: Text(
                    widget.nombreSecretaria,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: widget.sc.getProportionateScreenHeight(15)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Card(
              child: Container(
                  width: double.infinity,
                  height: 300,
                  child: widget.dataMap.isNotEmpty
                      ? PieChart(
                          dataMap: widget.dataMap,
                          colorList: widget.colores,
                        )
                      : Text("No existen datos")),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 8.0),
                child: Container(
                  width: double.infinity,
                  child: Text(
                    "NÚMERO DE PROYECTOS (${widget.total.toString() == null ? '0' : widget.total.toString()})",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: widget.sc.getProportionateScreenHeight(15)),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey[300]))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: (){
                          _ir("En ejecucion",widget.idSecretaria);
                        },
                        trailing: Icon(Icons.keyboard_arrow_right),
                        leading: ClipOval(
                          child: Image.asset(
                            "assets/images/verde.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          "Proyectos en Ejecución (${widget.ejecucion == null ? '0' : widget.ejecucion})",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: widget.sc.getProportionateScreenHeight(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey[300]))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: (){
                          _ir("No Viabilizado",widget.idSecretaria);
                        },
                        trailing: Icon(Icons.keyboard_arrow_right),
                        leading: ClipOval(
                          child: Image.asset(
                            "assets/images/rojo.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          "Proyectos no Viabilizados (${widget.no_viabilizados == null ? '0' : widget.no_viabilizados})",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: widget.sc.getProportionateScreenHeight(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey[300]))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: (){
                          _ir("Priorizado",widget.idSecretaria);
                        },
                        trailing: Icon(Icons.keyboard_arrow_right),
                        leading: ClipOval(
                          child: Image.asset(
                            "assets/images/naranja.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          "Proyectos Priorizados (${widget.priorizados == null ? '0' : widget.priorizados})",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: widget.sc.getProportionateScreenHeight(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey[300]))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: (){
                          _ir("Radicado",widget.idSecretaria);
                        },
                        trailing: Icon(Icons.keyboard_arrow_right),
                        leading: ClipOval(
                          child: Image.asset(
                            "assets/images/amarillo.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          "Proyectos Radicados (${widget.radicados == null ? '0' : widget.radicados})",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: widget.sc.getProportionateScreenHeight(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey[300]))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: (){
                          _ir("Registrado",widget.idSecretaria);
                        },
                        trailing: Icon(Icons.keyboard_arrow_right),
                        leading: ClipOval(
                          child: Image.asset(
                            "assets/images/gris.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          "Proyectos Registrados (${widget.registrados == null ? '0' : widget.registrados})",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: widget.sc.getProportionateScreenHeight(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey[300]))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: (){
                          _ir("Ejecutado",widget.idSecretaria);
                        },
                        trailing: Icon(Icons.keyboard_arrow_right),
                        leading: ClipOval(
                          child: Image.asset(
                            "assets/images/azul.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          "Proyectos Ejecutados (${widget.ejecutados == null ? '0' : widget.ejecutados})",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: widget.sc.getProportionateScreenHeight(16),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
  }

  _ir(String estado,String id){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ListadoEstado(idSecretaria: id,estado: estado)),
    );
  }
  
}
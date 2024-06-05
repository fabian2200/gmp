import 'package:flutter/material.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:line_icons/line_icons.dart';

class DashboardCPage extends StatefulWidget {
  DashboardCPage({Key key}) : super(key: key);

  @override
  _DashboardCPageState createState() => _DashboardCPageState();
}

class _DashboardCPageState extends State<DashboardCPage> {
  @override
  SizeConfig _sc = SizeConfig();
  SharedPreferences spreferences;
  String imagen = "";

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kgrayfondo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Inicio",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Container(
                      width: _sc.getProportionateScreenHeight(40),
                      height: _sc.getProportionateScreenHeight(40),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: imagen == "noimage" || imagen == null
                                ? NetworkImage("${URLROOT}/images/noimage.png")
                                : NetworkImage("${URLROOT}/images/${imagen}"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Alcaldia de Valledupar",
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.06),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: _sc.getProportionateScreenHeight(50),
                        height: _sc.getProportionateScreenHeight(50),
                        decoration: BoxDecoration(
                          color: Colors.green[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(Icons.attach_money,
                              size: _sc.getProportionateScreenHeight(30),
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Presupuesto total",
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "\$8.000.000.000",
                            style: TextStyle(
                                color: Colors.green[800],
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: defaultpadding,
                ),
                Text(
                  "Avances del presupuesto",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: _sc.getProportionateScreenWidth(160),
                        child: Center(
                          child: SleekCircularSlider(
                            appearance: CircularSliderAppearance(
                              size: 160,
                              angleRange: 360,
                              startAngle: 150,
                              animationEnabled: true,
                              customWidths:
                                  CustomSliderWidths(progressBarWidth: 5),
                              customColors: CustomSliderColors(
                                shadowColor: Colors.white,
                                progressBarColor: Colors.green[300],
                              ),
                            ),
                            min: 1,
                            max: 100,
                            initialValue: 50,
                          ),
                        ),
                      ),
                      Spacer(),
                      Column(children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(15),
                          width: _sc.getProportionateScreenWidth(140),
                          //height: 100,
                          decoration: BoxDecoration(
                            color: krojoclaro,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.08),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Pendente",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800]),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "4.000M",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[800],
                                    ),
                                  )
                                ],
                              ),
                              Spacer(),
                              Icon(LineIcons.lineChart, color: krojo, size: 35)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          width: _sc.getProportionateScreenWidth(140),
                          decoration: BoxDecoration(
                            color: kverdeclaro,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.08),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Ejecutado",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800]),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "4.000M",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[800],
                                    ),
                                  )
                                ],
                              ),
                              Spacer(),
                              Icon(LineIcons.lineChart,
                                  color: Colors.green, size: 35)
                            ],
                          ),
                        )
                      ]),
                    ],
                  ),
                ),
                SizedBox(
                  height: defaultpadding,
                ),
                Text(
                  "Resumen de la entidad",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                SizedBox(
                  height: defaultpadding,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: size.width * 0.43,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Icon(LineIcons.hamburger,
                              color: Colors.blue, size: 50),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "240k",
                            style: TextStyle(fontSize: 30),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Proyectos",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700]),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: size.width * 0.43,
                      height: size.height * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: defaultpadding,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: size.width * 0.43,
                      height: size.height * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: size.width * 0.43,
                      height: size.height * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                )
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

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    setState(() {
      imagen = spreferences.getString("imagen");
    });
  }
}

import 'package:flutter/material.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';

class PQRSPage extends StatefulWidget {
  PQRSPage({Key key}) : super(key: key);

  @override
  State<PQRSPage> createState() => _PQRSPageState();
}

class _PQRSPageState extends State<PQRSPage> {
  @override
  SizeConfig _sc = SizeConfig();
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController asuntocontroller = new TextEditingController();
    TextEditingController descripcioncontroller = new TextEditingController();
    String combotipo = "";
    return Scaffold(
      appBar: AppBar(
        title: Text("Atención al usuario"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: size.height * 0.03,
          ),
          Center(
            child: Text(
              "¿En que podemos ayudarte?",
              style: TextStyle(
                fontSize: size.height * 0.02,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: defaultpadding + 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
            child: Text(
              "Tipo de solicitud",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: defaultpadding - 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _sc.getProportionateScreenWidth(defaultpadding - 1),
            ),
            child: Container(
              height: _sc.getProportionateScreenHeight(50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                        fillColor: Colors.white24,
                        hintText: ''),
                    value: combotipo,
                    items: [
                      DropdownMenuItem(
                        child: Text("Seleccione una opción"),
                        value: "",
                      ),
                      DropdownMenuItem(
                        child: Text("Petición"),
                        value: "Petición",
                      ),
                      DropdownMenuItem(
                        child: Text("Queja"),
                        value: "Queja",
                      ),
                      DropdownMenuItem(
                        child: Text("Reclamo"),
                        value: "Reclamo",
                      ),
                      DropdownMenuItem(
                        child: Text("Sugerencia"),
                        value: "Sugerencia",
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        combotipo = value;
                      });
                    },
                    onSaved: (value) {
                      combotipo = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Debe un tipo";
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: defaultpadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
            child: Text(
              "Asunto",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: defaultpadding - 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _sc.getProportionateScreenWidth(defaultpadding - 1),
            ),
            child: Container(
              height: _sc.getProportionateScreenHeight(50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: TextField(
                    controller: asuntocontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Asunto'),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: defaultpadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
            child: Text(
              "Descripción",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: defaultpadding - 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _sc.getProportionateScreenWidth(defaultpadding - 1),
            ),
            child: Container(
              height: _sc.getProportionateScreenHeight(150),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: TextField(
                    minLines: 6,
                    maxLines: null,
                    maxLength: 200,
                    keyboardType: TextInputType.multiline,
                    controller: descripcioncontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Descripción'),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: defaultpadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultpadding),
            child: Text(
              "Correo electrónico",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: defaultpadding - 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _sc.getProportionateScreenWidth(defaultpadding - 1),
            ),
            child: Container(
              height: _sc.getProportionateScreenHeight(50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: TextField(
                    controller: asuntocontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Correo'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

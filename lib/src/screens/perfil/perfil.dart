import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmp/src/screens/detalle_contratos/detallecontratos.dart';
import 'package:gmp/src/screens/login.dart';
import 'package:gmp/src/screens/pdfViewer/pdfViewerPage.dart';
import 'package:gmp/src/screens/perfil/ayuda.dart';
import 'package:gmp/src/screens/perfil/cambiarpassword.dart';
import 'package:gmp/src/screens/perfil/editarperfil.dart';
import 'package:gmp/src/screens/perfil/pqrs.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class PerfilPage extends StatefulWidget {
  PerfilPage({Key key}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  SharedPreferences spreferences;
  String nombre = "";
  String imagen = "";
  String bd = "";
  String email = "";
  String id = "";
  dynamic imageFile;
  bool _checkbox = false;

  final picker = ImagePicker();
  Dio dio = new Dio();

  String baseUrl = URL_SERVER2+"images/foto/";
  String url;
  Widget _cr;

  bool loading = false;

  bool loaded = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
          body: Container(
            height: size.height,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: defaultpadding,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showSelectionDialog(context);
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: size.width * 0.4,
                          height: size.width * 0.4,
                          decoration: BoxDecoration(
                            color: kazul,
                            borderRadius: BorderRadius.circular(1000),
                          
                          ),
                          child: loading == true? 
                            ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child:  _cr,
                            ) : Center(
                            child: CircularProgressIndicator( color:  Colors.white),
                            ) ,
                        ),
                        Positioned(
                            bottom: 0,
                            right: 10,
                            child: Container(
                              child: Icon(Icons.camera_alt, color: Colors.white),
                              alignment: Alignment.center,
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(width: 4, color: Colors.white),
                                color: kazul,
                                shape: BoxShape.circle
                              ),
                            ),
                          )
                      ],
                    ) 
                  ),
                  SizedBox(
                    height: defaultpadding - 10,
                  ),
                  Text(
                    nombre,
                    style: TextStyle(
                        fontSize: defaultpadding - 3,
                        fontWeight: FontWeight.w500,
                        color: kazuloscuro),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: defaultpadding - 3,
                    ),
                  ),
                  SizedBox(
                    height: defaultpadding + defaultpadding,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultpadding, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditarPerfilPage()),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.person_outline),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Editar Perfil",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultpadding, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CambiarPasswordPage()),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.vpn_key_outlined),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Cambiar contraseña",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AyudaPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultpadding, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.help_outline),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Ayuda",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      openBrowserTab("${URL_SIN}POLÍTICA_PRIVACIDAD_GMP.pdf");
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultpadding, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.book_outlined),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Políticas de uso",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultpadding, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.notifications_outlined),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            "Notificaciones",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Checkbox(
                          value: _checkbox,
                          onChanged: (value) {
                            setState(() {
                              _checkbox = !_checkbox;
                              generarToken(_checkbox);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PQRSPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultpadding, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.analytics_outlined),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Atención al usuario",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      salir();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultpadding, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.close),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Salir",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      )
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    instanciar_sesion();
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    setState(() {
      url = spreferences.getString("imagen") != "noimage"? baseUrl+spreferences.getString("imagen"): baseUrl+"noimage.png";
      nombre = spreferences.getString("nombre");
      id = spreferences.getString("id");
      email = spreferences.getString("email");
      _checkbox = spreferences.getBool("notificaciones");
      actualizarClip(url);
    });
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Selecione de donde tomar la imagen"),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.image_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Galeria"),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _seleccionarImagen();
                      },
                    ),
                    Divider(),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.camera_alt_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Camara"),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _openCamera();
                      },
                    )
                  ],
                ),
              ));
        });
  }

  salir() async {
    await spreferences.clear();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
  
  
  _seleccionarImagen() async {
    var picketfile;
    picketfile = await picker.pickImage(source: ImageSource.gallery);
    var imagenPerfil = File(picketfile.path);
    cambiarFotoPerfil(imagenPerfil);
  }


  _openCamera() async {
    var picture = await picker.pickImage(source: ImageSource.camera);
    var imagenPerfil = File(picture.path);
    cambiarFotoPerfil(imagenPerfil);
    
  }

  openBrowserTab(String url) async {
     Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => PdfViewerPage(url)),
    );
  }

  cambiarFotoPerfil(File imagenPerfil) async {
    spreferences = await SharedPreferences.getInstance();

    setState(() {
      loading = false;
    });
    String filename = imagenPerfil.path.split('/').last;
    FormData datos = new FormData.fromMap({
      'imagen': await MultipartFile.fromFile(imagenPerfil.path, filename: filename),
      'id': id,
    });

    final link = URL_FOTO_PERFIL + "cambiarFotoPeril.php";
    var reponsebody;
    await dio.post(link, data: datos).then((value) {
       reponsebody = json.decode(value.toString());
    });

    setState(() {
      _cr = CircularProgressIndicator();
    });

    var url = baseUrl+reponsebody["imagen"];
    spreferences.setString("imagen", reponsebody["imagen"]);

    actualizarClip(url);
  }

  actualizarClip(String url) async {
     Uint8List bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();
    setState(() {
      _cr = Image.memory(bytes, fit: BoxFit.cover);
      loading = true;
    });
  }


  generarToken(bool estado) {
    guardarToken(estado);
  }

  guardarToken(bool estado) {
    spreferences.setBool("notificaciones", estado);
  }
}

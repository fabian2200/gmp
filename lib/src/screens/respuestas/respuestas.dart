import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/comentarios/componentes/vistacomentarios.dart';
import 'package:gmp/src/screens/notificaciones/shimmer_item.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class RespuestasPage extends StatefulWidget {
  final String id;
  final List respuestas;
  final String image;
  final String name;
  final String comentario;
  final String tipo;
  final String idProyecto;
  RespuestasPage(
      {Key key,
      this.id,
      this.respuestas,
      this.image,
      this.name,
      this.comentario,
      this.tipo,
      this.idProyecto})
      : super(key: key);

  @override
  _RespuestasPageState createState() => _RespuestasPageState();
}

TextEditingController txtenviar = new TextEditingController();
TextEditingController txtenditar = new TextEditingController();

class _RespuestasPageState extends State<RespuestasPage> {
  List responses;
  SharedPreferences spreferences;
  String bd;
  String empresa;
  int isloading = 0;
  String id_user;

  bool loading = false;
  bool emojiShowing = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig _sc = SizeConfig();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Respuestas",
          style: TextStyle(color: Colors.blue[800]),
        ),
        iconTheme: IconThemeData(
          color: Colors.blue[800], 
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            radius: defaultpadding,
                            backgroundImage: NetworkImage('${widget.image}'),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Container(
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.name,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: _sc
                                                .getProportionateScreenHeight(
                                                    16),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            widget.comentario,
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              fontSize: _sc
                                                  .getProportionateScreenHeight(
                                                      14),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: _sc
                                              .getProportionateScreenHeight(5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: _sc.getProportionateScreenHeight(5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(),
                        ),
                      ),
                      loading == false? Expanded(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 50),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                responses == null ? 0 : responses.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              bool longPress = false;
                              if(int.parse(id_user) == responses[index]['id_usu']){
                                  longPress = true;
                              }
                              return GestureDetector(
                                onLongPress: longPress ? (() {
                                  mostrarcaja(context, responses[index]['id_comentario'], responses[index]['comentario'], responses[index]['imagen']);
                                }): (() {
                                  print("no-------");
                                }),
                                child: VistaComentario(
                                  comentarios: responses,
                                  sc: _sc,
                                  size: size,
                                  index: index,
                                  mres: "no",
                                  tam: 0.65,
                                  tipo: "contrato",
                                  idProyecto: widget.idProyecto,
                                  fecha: responses[index]['fecha'],
                                  hora: responses[index]['hora'],
                                ),
                              );
                            }
                          )
                        ),
                      ) : ShimmerItem(),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            width: size.width,
            child: Offstage(
              offstage: !emojiShowing,
              child: SizedBox(
                height: 250,
                child: EmojiPicker(
                    onEmojiSelected: (Category category, Emoji emoji) {
                      _onEmojiSelected(emoji);
                    },
                    onBackspacePressed: _onBackspacePressed,
                    config: Config(
                        columns: 7,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        recentsLimit: 28,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL)),
              ),
            )
          ),
          Positioned(
            bottom: 0,
            left: 0,
            width: size.width,
            child: Container(
              decoration: BoxDecoration(color: kazul, border: Border()),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Material(
                      color: kazul,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            emojiShowing = !emojiShowing;
                          });
                        },
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.68,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          onTap: (() {
                            setState(() {
                              if(emojiShowing == true){
                                emojiShowing = false;
                              }
                            });
                          }),
                          controller: txtenviar,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Escribe tu comentario aquí...'),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.12,
                      child: isloading == 0
                          ? GestureDetector(
                              onTap: () {
                                this.setState(() {
                                  isloading = 1;
                                });
                                responder(txtenviar.text, widget.id);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child: Icon(Icons.send,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                                strokeWidth: 3,
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    responses = new List.empty();
    instanciarSesion();
  }

  Future<String> listarrespuesta() async {
    setState(() {
      loading = true;
    });

    if (widget.tipo == "proyecto") {
      var response = await http.get(
          Uri.parse(
              '${URL_SERVER}comentarios_proyectos_respuestas?bd=${bd}&id=${widget.id}'),
          headers: {"Accept": "application/json"});
      final reponsebody = json.decode(response.body);
      this.setState(() {
        responses = reponsebody['respuestas'];
        loading = false;
      });
    } else {
      var response = await http.get(
          Uri.parse(
              '${URL_SERVER}comentarios_respuestas?bd=${bd}&id=${widget.id}'),
          headers: {"Accept": "application/json"});
      final reponsebody = json.decode(response.body);
      this.setState(() {
        responses = reponsebody['respuestas'];
        loading = false;
      });
    }

    return "Success!";
  }

  Future<String> responder(String texto, String id) async {
    //print(widget.tipo);
    if (widget.tipo == "proyecto") {
      var response = await http.get(
          Uri.parse(
              '${URL_SERVER}comentario_proyectos/guardar?bd=${bd}&id_con=${widget.idProyecto}&id_usu=${id_user}&response=${widget.id}&comentario=${txtenviar.text}'),
          headers: {"Accept": "application/json"});
      txtenviar.text = "";

      this.setState(() {
        isloading = 0;
      });
    } else {
      var response = await http.get(
          Uri.parse(
              '${URL_SERVER}comentario/guardar?bd=${bd}&id_con=${widget.idProyecto}&id_usu=${id_user}&response=${widget.id}&comentario=${txtenviar.text}'),
          headers: {"Accept": "application/json"});
      txtenviar.text = "";

      this.setState(() {
        isloading = 0;
      });
    }

    listarrespuesta();

    return "Success!";
  }

  instanciarSesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");
    id_user = spreferences.getString("id");
    await listarrespuesta();
  } 
  
  _onEmojiSelected(Emoji emoji) {
    txtenviar
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: txtenviar.text.length));
  }

  _onBackspacePressed() {
    txtenviar
      ..text = txtenviar.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: txtenviar.text.length));
  }

  mostrarcaja(BuildContext context, int idComentario, String comentario, String imagen) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
            ),
            height: 170,
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(
              children: [
                Center(
                  child: Text("¿Que desea hacer?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: (() {
                    Navigator.pop(context);
                    mensajeEliminar(idComentario);
                  }),
                  child: Row(
                    children: [
                      Icon(Icons.delete_forever, size: 30),
                      SizedBox(width: 10),
                      Text("Eliminar el comentario", style: TextStyle(fontSize: 20))
                    ],
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: (() {
                    Navigator.pop(context);
                    cajaEditar(context, idComentario, comentario, imagen);
                  }),
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 30),
                      SizedBox(width: 10),
                      Text("Editar el comentario", style: TextStyle(fontSize: 20))
                    ],
                  )
                )
              ],
            ),
          );
        }).whenComplete(() {
      print('Hey there, I\'m calling after hide bottomSheet');
    });
  }

  mensajeEliminar(int idComentario){
   AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      headerAnimationLoop: false,
      animType: AnimType.TOPSLIDE,
      showCloseIcon: true,
      closeIcon: const Icon(Icons.close_fullscreen_outlined),
      btnCancelText: 'Cancelar',
      btnOkText: 'Eliminar',
      btnCancelColor: Colors.red,
      btnOkColor: kazul,
      desc:'¿Seguro que quieres eliminar este comentario?',
      btnCancelOnPress: () {
       
      },
      onDissmissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
      btnOkOnPress: () {
       eliminarComentario(idComentario);
      },
    ).show();
  }

  eliminarComentario(int idComentario) async {
    setState(() {
      loading = true;
    });
    await http.get(Uri.parse('${URL_SERVER}eliminar-comentario?bd=${bd}&id_com=${idComentario}&tipo=${widget.tipo}'),headers: {"Accept": "application/json"}); 
    listarrespuesta();
  }

  cajaEditar(BuildContext context, int idComentario, String comentario, String imagen) {
    setState(() {
      txtenditar.text = comentario;
    });
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
          ),
          height: 560,
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: defaultpadding,
                      backgroundImage: NetworkImage(imagen == "noimage"
                          ? '$URL_SERVER/images/foto/$imagen.png'
                          : '$URL_SERVER/images/foto/$imagen'),
                    ),
                    SizedBox(width: 6),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 250,
                          height: 56,
                          padding: EdgeInsets.only(left: 7, top: 3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: TextFormField(
                                  controller: txtenditar,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Escribe tu comentario aquí...'),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ]
                    ),
                  ]
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () { Navigator.pop(context); },
                      child: Text('Cancelar'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kazul, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        editarComentario(idComentario, txtenditar.text);
                      },
                      child: Text('Guardar'),
                    )
                  ],
                )
              ],
            ) 
          )
        );
      }).whenComplete(() {
    });
  }

  editarComentario(int idComentario, String comentario) async {
    setState(() {
      loading = true;
    });
    await http.get(Uri.parse('${URL_SERVER}editar-comentario?bd=$bd&id_com=$idComentario&tipo=${widget.tipo}&comentario=$comentario'),headers: {"Accept": "application/json"}); 
    listarrespuesta();
  }

}

import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/notificaciones/shimmer_item.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'componentes/vistacomentarios.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ComentariosPage extends StatefulWidget {
  final idproyect;
  final valortop;
  final valorbottom;
  ComentariosPage({Key key, this.idproyect, this.valortop, this.valorbottom})
      : super(key: key);

  @override
  _ComentariosPageState createState() => _ComentariosPageState();
}

TextEditingController txtenviar = new TextEditingController();
TextEditingController txtenditar = new TextEditingController();

class _ComentariosPageState extends State<ComentariosPage> {
  SharedPreferences spreferences;
  String bd;
  String empresa;
  String id_user;
  List comentarios;
  //String txtenviar;
  int isloading = 0;
  int iscomentando = 0;

  bool loading = false;
  bool emojiShowing = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    SizeConfig _sc = SizeConfig();
    return Scaffold(
      body:Container(
        height: size.height - widget.valortop,
        margin: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: size.height * 0.007,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[400]),
                      child: Padding(
                        padding: const EdgeInsets.only(top: defaultpadding),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _sc.getProportionateScreenHeight(10),
                ),
                loading == false? Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child:  ListView.builder(
                      itemCount:
                          comentarios == null ? 0 : comentarios.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        bool longPress = false;
                        if(int.parse(id_user) == comentarios[index]['id_usu']){
                            longPress = true;
                        }
                        return GestureDetector(
                          onLongPress: longPress ? (() {
                            mostrarcaja(context, comentarios[index]['id'], comentarios[index]['comentario'], comentarios[index]['imagen']);
                          }): (() {
                            print("no-------");
                          }),
                          child: VistaComentario(
                            comentarios: comentarios,
                            sc: _sc,
                            size: size,
                            index: index,
                            mres: "si",
                            tam: 0.75,
                            tipo: "proyecto",
                            idProyecto: widget.idproyect,
                            fecha: comentarios[index]['fecha'],
                            hora: comentarios[index]['hora']
                          )
                        );
                      }
                    ),
                  )
                ): ShimmerItem(),
                Offstage(
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
                ),
                SizedBox(
                  height: _sc.getProportionateScreenHeight(15),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              width: size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: kazul,
                  border: Border()
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                          color: Colors.white,
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
                                hintText: 'Escribe tu comentario aquí'),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.15,
                        child: isloading == 0
                            ? GestureDetector(
                                onTap: () {
                                  this.setState(() {
                                    isloading = 1;
                                  });
                                  enviarcomentario();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child:
                                        Icon(Icons.send, color: Colors.white),
                                  ),
                                ),
                              )
                            : Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
      )
    );
  }

  @override
  void initState() {
    super.initState();
    instanciarSesion();
  }

  Future<String> listarcomentarios() async {
    setState(() {
      loading = true;
    });
    var response = await http.get(
        Uri.parse(
            '${URL_SERVER}comentarios_proyectos?bd=${bd}&id_con=${widget.idproyect}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    this.setState(() {
      comentarios = reponsebody['comentarios'];
      isloading = 0;
      loading = false;
    });
    return "Success!";
  }

  Future<String> enviarcomentario() async {
    var response = await http.get(
        Uri.parse(
            '${URL_SERVER}comentario_proyectos/guardar?bd=${bd}&id_con=${widget.idproyect}&id_usu=${id_user}&response=0&comentario=${txtenviar.text}'),
        headers: {"Accept": "application/json"});
    txtenviar.text = "";

    this.setState(() {
      isloading = 0;
    });
    listarcomentarios();

    return "Success!";
  }

  instanciarSesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");
    id_user = spreferences.getString("id");
    listarcomentarios();
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
    String tipo = "proyecto";
    await http.get(Uri.parse('${URL_SERVER}eliminar-comentario?bd=${bd}&id_com=${idComentario}&tipo=${tipo}'),headers: {"Accept": "application/json"}); 
    listarcomentarios();
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
                        foregroundColor: Colors.white, backgroundColor: Colors.red, // foreground
                      ),
                      onPressed: () { Navigator.pop(context); },
                      child: Text('Cancelar'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: kazul, // foreground
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
    
    String tipo = "proyecto";
    var respuesta = await http.get(Uri.parse('${URL_SERVER}editar-comentario?bd=$bd&id_com=$idComentario&tipo=$tipo&comentario=$comentario'),headers: {"Accept": "application/json"}); 
    listarcomentarios();
  }
}

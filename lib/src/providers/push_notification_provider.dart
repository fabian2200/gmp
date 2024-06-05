import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  SharedPreferences spreferences;

  final _mesajeController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mesajeController.stream;


  initNotificaciones() {
    _firebaseMessaging.requestPermission();

    /*_firebaseMessaging.getToken().then((token) {
      print("======= TOKEN ========");
      print(token);
      guardartoken(token);
    });*/

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //RemoteNotification notification = message.notification;
      //AndroidNotification android = message.notification?.android;
      print("==== ON MESSAGE ====");
      print(message.notification.body);
      _mesajeController.sink.add(message.notification.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

  }

  getToken(){
    _firebaseMessaging.requestPermission();

    _firebaseMessaging.getToken().then((token) {
      print("======= TOKEN ========");
      print(token);
      guardartoken(token);
    });
  }

  guardartoken(String token) async {
    spreferences = await SharedPreferences.getInstance();
    String id_usu = spreferences.getString("id_usu");
    if (spreferences.getString("id_usu") != null) {
      print('${URL_SERVER}gtoken?id=${id_usu}&token=${token}');
      var response = await http.get(
          Uri.parse('${URL_SERVER}guardartoken?id=${id_usu}&token=${token}'),
          headers: {"Accept": "application/json"});
      final reponsebody = json.decode(response.body);
    }
  }

  dispose(){
    _mesajeController?.close();
  }
}

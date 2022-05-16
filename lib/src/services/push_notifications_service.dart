// SHA1: 28:46:E0:08:32:D4:1E:76:02:B4:A2:FB:E8:81:BA:1E:8E:45:BA:EC
//TOKEN: fwsmDLV0Tu-hNWQG4fLnb9:APA91bG-iBWlNafZdxs403tPoJ3L4UuuXoRcu426OlmiJmA-iSyPlYd8qsWwV3Ttr0jc_tyl6nSz3C_QPzdoiPu2xBVDV-GPJv2zJPVRbGThvQL9rdfU38kgX60r7c_tc6Hllj5sJ3uL

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream =
      new StreamController.broadcast();

  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    // print('onBackground Handler ${message.messageId}');
    print(message.data);
    _messageStream.add(message.notification?.body ?? 'No title');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    //print('onMessage Handler ${message.messageId}');
    print(message.data);
    _messageStream.add(message.notification?.body ?? 'No title');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    //print('onMessageOpenApp Handler ${message.messageId}');
    print(message.data);
    _messageStream.add(message.notification?.body ?? 'No title');
  }

  static Future initializeApp() async {
    //Push notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    //Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    //Local Notifications
  }

  static closeStreams() {
    _messageStream.close();
  }
}

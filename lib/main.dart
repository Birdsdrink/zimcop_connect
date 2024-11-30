import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:zimcop_connect/const/message_const.dart';
import 'package:zimcop_connect/services/chat_service.dart';
import 'package:zimcop_connect/services/display_notification_service.dart';
import 'package:zimcop_connect/services/auth_gate.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final ChatService chatService = ChatService();
final DisplayNotificationService displayNotificationService =
    DisplayNotificationService();

Future<void> myBackgroundMessageHandler(RemoteMessage event) async {
  String? tittle = event.notification!.title;
  String? body = event.notification!.body;
  Map message = event.toMap();
  var payload = message['data'];

  //DISPLAYING NOTIFICATIONS DEPENDING ON TYPE
  if (tittle == NotificationType.call) {
    var callID = payload['call_ID'] as String;
    var callerName = payload['caller_name'] as String;
    var uid = payload['uid'] as String;
    var hasVideo = payload['has_video'] == "true";

    displayNotificationService.callInvitation(
        surname: callerName, myUserID: uid, callID: callID, hasVideo: hasVideo);
  } else if (tittle == NotificationType.message) {
    var surname = payload['sender_surname'] as String;
    var senderID = payload['sender_id'] as String;

    displayNotificationService.messageNotification(
        surname: surname, senderID: senderID, message: body!);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Initialising Firebase on opening app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  //Update delivered messages when opening app
  chatService.updateDeliveredMessages;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen(myBackgroundMessageHandler);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZIMCOP connect',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}

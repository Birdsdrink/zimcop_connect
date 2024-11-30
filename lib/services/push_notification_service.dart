import "dart:convert";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:googleapis_auth/auth_io.dart" as auth;
import "package:zimcop_connect/const/message_const.dart";
import "auth_service.dart";

class PushNotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  //Getting Firebase Access Token
  Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "zimcop-connect-d7a36",
      "private_key_id": "36da9c75377a0aad141aa7666fe800530f3add43",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCIX9RVbjRBSNPc\n6dBwih/RmDOWrxoHOyQl3ssYGNIihLZwFsd4JcWSy6G0C1ucKc2yJPakovNXfyL7\nCX2lDrroWfIo1t46hDeluGZ+4Tsvb2aMTc+aAz/XX4KTG3vTvi22k5M/GlmYZivX\nFU+ouGhgQDPUOA4/sDMChyBe4LrGoIXNgAURb7WRDYK7PRKJV72ZUGfrbJYeHTLI\nN86juYqw1pMCheGVeix1v7SBHjC0S7Nmu46NH/gh07e5SQPFYqjXB9k8QU4xUimt\nM7pbx93cGIT4TXApMLbkMbnrFAdabreh1DnGPgoPQf6tP/pTK7nf6dtvKxtPZZGm\nbSWZtkoPAgMBAAECggEAFp+PIfz+PjZOrz86jPDdBnAxXrX9o2V0QbQMDRtRANjz\nSvT8cjoR5KBTWwLnV6i3ru3i3L0LkWBN9UdFyLQA3brOKWg7xYlZkexdVH8Yym24\nnV3rKqmPVbNKfgz5Jc9O1hL1QmqkoluQukWWyW6OIimEb5g9BOO+EpVIEXVGhtys\nVo8bebjQ73wqMJaQg7Tp+hl+2ex6SVngSfSwoOYyaZ8yXJmtNDa6miueCfufKah3\nfXmtTDbcxueyXrJLXxQpXVsuOr5DAQLTdCjTU9vbU4Q5Uj5GOX82bBr8sspqlYwV\n+Zbu6SUZJOyDNvRoUBId/8gV9QOMqZmp983y8KDrQQKBgQC80wN/Mh4srABixRQg\nJUvvxoMIlPWISgADKVMhVPwiY73yGaSi+6fkqvb3Lo6oL7dqWjKQo7v8dVgfdFmR\nrEjhzaCZERCgNshgxyyVnaOFJz9pdKI4PqPTP/psVIZzdSdLYqQCu08ceyIxxthK\nn52gdTbDgjuCTCYmDDMG/vMo+wKBgQC44/0iZDWXxOhaPtq+6Ul07yo34xoWKwtw\ntTFIxdHcuG5u5rZw8kO1l8bZ0s3bp6AgOGYT0AzuWg7fgy1fOnQvvKDPAUPyYB9v\n0lYVkAJ1WqCrd8+QRNd8thQO6XVW3QWY8jdchvotM4srkgW/y8xO3shu1YrHOzvy\nERfFWU4+/QKBgQCnhVIh47Xvjf2doxkS1+QB6w1PbNBUxMo0A9KzzLEQVYssIeH1\nkuzGK4OFkrGPtx2zZihcOFdMSFMRPOlGGyJh6ktj4UbtzQyDB9GfP0bWmBZjGc3d\ntn0jqywiNe8+uZ5N/Epj/gfWzctte+ticS+oLrWSSJVBKQvjT4lp2ICkRwKBgGB5\nrruEWKax+6AjjhbyOf9HUNtKqHEK0vRjx6y2dHRc1FsQDgDPmV8nLH66zeohBJ/r\nbfBGrois+3fLxiAbq0bBgZOikGbnm1/I/FxSAcZknNP8N5WLJnoPtFW3oh/KQsJ1\nGUgxsldlvufkURWsbRZ2j1WuHbUqBnSgUKwMlpStAoGAB592vyG4S5B6Lp8X7HE4\nrd8cDy0PBGadYl8EXp5PM9KOvm+geCk4t4iMjFnxCWQaSodX9N9HTJ86yeNDKVpH\nx9n8HrkxK8pESlJTvIKwyf8Yjn2fkEjZVbvtweJh9wEwFc/vKpgWmzbpEgVLm84O\nJFfwlDWF2q89Q+qdMhJ7a44=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "zimcop-connect@zimcop-connect-d7a36.iam.gserviceaccount.com",
      "client_id": "103683129011363450418",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/zimcop-connect%40zimcop-connect-d7a36.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    final scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();

    return credentials.accessToken.data;
  }

  //Getting my device token
  Future<String?> getFcmToken() async {
    //Request Permission first
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    //Getting token
    String? myToken = await FirebaseMessaging.instance.getToken();
    debugPrint(myToken);
    return myToken;
  }

  //Saving Token to firestore
  Future<void> saveTokenToFirestore({required String token}) async {
    bool isUserLoggedin = AuthService().isLoggedIn();
    if (isUserLoggedin) {
      await AuthService().updateFcmToken(token);
    }
    // also save if token changes
    messaging.onTokenRefresh.listen((event) async {
      if (isUserLoggedin) {
        await AuthService().updateFcmToken(token);
      }
    });
  }

  //SENDING CALL NOTIFICATION
  Future<void> sendCallNotification(
      {required String callID,
      required String calleeID,
      required String callerSurname,
      required String fcmToken,
      required String hasVideo}) async {
    final String serverAccessTokenKey = await getAccessToken();
    String endpointFirebaseCloudMessaging =
        "https://fcm.googleapis.com/v1/projects/zimcop-connect-d7a36/messages:send";

    //Map containing Notification details
    final Map<String, dynamic> message = {
      'message': {
        'token': fcmToken,
        'notification': {
          'title': NotificationType.call,
          'body': "Pick Up Call",
        },
        'data': {
          "call_ID": callID,
          "caller_name": callerSurname,
          "uid": calleeID,
          "has_video": hasVideo,
        },
      }
    };

    //Sending
    final response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessTokenKey'
      },
      body: jsonEncode(message),
    );

    //Checking if notification send successfuly
    if (response.statusCode == 200) {
      debugPrint("Notification sent successfully");
    } else {
      debugPrint("Failed to send message: ${response.statusCode}");
    }
  }

  //SENDING MESSAGE NOTIFICATION
  Future<void> sendMessageNotification({
    required String senderSurname,
    required String senderID,
    required String content,
    required String fcmToken,
  }) async {
    final String serverAccessTokenKey = await getAccessToken();
    String endpointFirebaseCloudMessaging =
        "https://fcm.googleapis.com/v1/projects/zimcop-connect-d7a36/messages:send";

    //Map containing Notification details
    final Map<String, dynamic> message = {
      'message': {
        'token': fcmToken,
        'notification': {
          'title': NotificationType.message,
          'body': content,
        },
        'data': {
          "sender_surname": senderSurname,
          "sender_id": senderID,
        },
      }
    };

    //Sending
    final response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessTokenKey'
      },
      body: jsonEncode(message),
    );

    //Checking if notification send successfuly
    if (response.statusCode == 200) {
      debugPrint("Notification sent successfully");
    } else {
      debugPrint("Failed to send message: ${response.statusCode}");
    }
  }

  //DISPLAYING NOTIFICATIONS USING LOCAL NOTIFICATIONS
}

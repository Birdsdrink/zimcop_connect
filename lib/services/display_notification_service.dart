import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zimcop_connect/const/message_const.dart';
import 'package:zimcop_connect/const/style_const.dart';
import 'package:zimcop_connect/main.dart';
import 'package:zimcop_connect/services/auth_service.dart';
import 'package:zimcop_connect/services/shared_pref.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:zimcop_connect/views/pages/single_chat_page.dart';
import 'package:zimcop_connect/views/pages/video_call.dart';
import 'package:zimcop_connect/views/pages/voice_call.dart';

class DisplayNotificationService {
  final AuthService authService = AuthService();

  //CALL NOTIFICATION
  callInvitation(
      {required String surname,
      required String myUserID,
      required String callID,
      required bool hasVideo}) async {
    final player = AudioPlayer();
    await player.play(AssetSource('audio/gore.mp3'));
    Future.delayed(const Duration(seconds: 45)).then((_) async {
      await player.stop();
    });

    double? screenHeight = await SharedPrefHelper().getScreenHeight();
    double? screenWidth = await SharedPrefHelper().getScreenWidth();

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 45),
        behavior: SnackBarBehavior.floating,
        margin:
            EdgeInsets.only(bottom: screenHeight! - 200, left: 10, right: 10),
        dismissDirection: DismissDirection.startToEnd,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        content: Column(
          children: [
            Row(
              children: [
                Image.asset("assets/images/logoBlack.png", height: 40),
                const Spacer(),
                Text(hasVideo
                    ? "...INCOMING VIDEO CALL"
                    : "...INCOMING VOICE CALL"),
              ],
            ),
            Text(surname,
                style: const TextStyle(color: tittleTextColor, fontSize: 18)),
            const SizedBox(height: 3),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                    await player.stop();
                    if (hasVideo == true) {
                      navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => VideoCall(
                              callID: callID,
                              userID: myUserID,
                              surname: surname)));
                    } else {
                      navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => VoiceCall(
                                callID: callID,
                                userID: myUserID,
                                surname: surname,
                                picUrl: "",
                              )));
                    }
                  },
                  child: Container(
                    height: 25,
                    width: screenWidth! * 0.4,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                        child: Text("ACCEPT",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                    await player.stop();
                  },
                  child: Container(
                    height: 25,
                    width: screenWidth * 0.4,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                      child: Text(
                        "REJECT",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  //MESSAGE NOTIFICATION
  messageNotification(
      {required String surname,
      required String senderID,
      required String message}) async {
    final player = AudioPlayer();
    double? screenHeight = await SharedPrefHelper().getScreenHeight();
    String? rank, surname, profPicUrl, fcmToken;

    QuerySnapshot querySnapshot = await authService.getUserByUid(senderID);
    rank = "${querySnapshot.docs[0]["rank"]}";
    surname = "${querySnapshot.docs[0]["surname"]}";
    profPicUrl = "${querySnapshot.docs[0]["profilePicUrl"]}";
    surname = surname[0].toUpperCase() + surname.substring(1);
    fcmToken = "${querySnapshot.docs[0]["fcmToken"]}";

    await player.play(AssetSource('audio/walkie-talkie-beep1.mp3'));
    Future.delayed(const Duration(seconds: 1), () async => await player.stop());

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin:
            EdgeInsets.only(bottom: screenHeight! - 200, left: 10, right: 10),
        dismissDirection: DismissDirection.startToEnd,
        backgroundColor: Color.fromARGB(255, 17, 107, 5),
        content: GestureDetector(
          onTap: () async {
            scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            await player.stop();
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => SingleChatPage(
                  rank: rank!,
                  surname: surname!,
                  receiverProfPicUrl: profPicUrl!,
                  receiverID: senderID,
                  fcmToken: fcmToken!,
                ),
              ),
            );
          },
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset("assets/images/logoBlack.png", height: 40),
                  const Spacer(),
                  const Text(NotificationType.message),
                ],
              ),
              Text("from $surname",
                  style: const TextStyle(color: tittleTextColor, fontSize: 18)),
              const SizedBox(height: 3),
              Text(message,
                  style: const TextStyle(color: tittleTextColor, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

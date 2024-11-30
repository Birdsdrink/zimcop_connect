import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zimcop_connect/const/call_const.dart';

class VoiceCall extends StatelessWidget {
  const VoiceCall(
      {super.key,
      required this.userID,
      required this.callID,
      required this.surname,
      required this.picUrl});
  final String userID;
  final String callID;
  final String surname;
  final String picUrl;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ZegoUIKitPrebuiltCall(
      appID: CallInfo.appID,
      appSign: CallInfo.appSign,
      userID: userID,
      userName: surname,
      callID: callID,
      //config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),

      // Modify your custom configurations here.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        ..avatarBuilder = (BuildContext context, Size size, ZegoUIKitUser? user,
            Map extraInfo) {
          return user != null
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        picUrl,
                      ),
                    ),
                  ),
                )
              : const SizedBox();
        }
        ..audioVideoView = ZegoCallAudioVideoViewConfig(
          backgroundBuilder: (BuildContext context, Size size,
              ZegoUIKitUser? user, Map extraInfo) {
            return user != null
                ? ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Image.asset(
                      'assets/images/ringround.gif',
                      height: height,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                : const SizedBox();
          },
        ),
    );
  }
}

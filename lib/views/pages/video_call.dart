import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zimcop_connect/const/call_const.dart';

class VideoCall extends StatelessWidget {
  const VideoCall(
      {super.key,
      required this.userID,
      required this.callID,
      required this.surname});
  final String userID;
  final String callID;
  final String surname;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: CallInfo.appID,
      appSign: CallInfo.appSign,
      userID: userID,
      userName: surname,
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}

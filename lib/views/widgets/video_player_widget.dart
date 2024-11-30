import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zimcop_connect/const/style_const.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String videoTittle;

  VideoPlayerWidget({required this.videoUrl, required this.videoTittle});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.blue.withOpacity(0.3),
        middle: Text(
          widget.videoTittle,
          style: TextStyle(color: tittleTextColor),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: CustomVideoPlayer(
              customVideoPlayerController: _customVideoPlayerController),
        ),
      ),
    );
  }
}

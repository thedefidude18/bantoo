import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoForBackground extends StatefulWidget {
  const VideoForBackground({super.key});

  @override
  _VideoForBackgroundState createState() => _VideoForBackgroundState();
}

class _VideoForBackgroundState extends State<VideoForBackground> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.asset("assets/video/background_video.mp4")
    _controller = VideoPlayerController.asset("assets/video/new_background_video.mp4")
      ..initialize().then((_) {
        _controller.setVolume(0.0);
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
        
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: _controller.value.isInitialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller,
        ),
      )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
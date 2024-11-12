import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    Uri uri = Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
    _controller = VideoPlayerController.networkUrl(uri)
      ..initialize().then((onValue) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.play();
    // _controller.pause();
    // _controller.seekTo(const Duration(seconds: 20));
    // _controller.value.isPlaying;
    // _controller.value.isBuffering;
    // _controller.setPlaybackSpeed(1.5);
    // _controller.setClosedCaptionFile('path/to/subtitle.srt');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          },
          child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow)),
      body: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller)),
    );
  }
}

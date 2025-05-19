// lib/widgets/video_background_scaffold.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBackgroundScaffold extends StatefulWidget {
  final String videoAssetPath;
  final Widget child;

  const VideoBackgroundScaffold({
    super.key,
    required this.videoAssetPath,
    required this.child,
  });

  @override
  State<VideoBackgroundScaffold> createState() =>
      _VideoBackgroundScaffoldState();
}

class _VideoBackgroundScaffoldState extends State<VideoBackgroundScaffold> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAssetPath)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {
          _isVideoInitialized = true;
        });
        _controller.setLooping(true);
        _controller.setVolume(0.0); // Mute by default
        _controller.play();
      }).catchError((error) {
        // ignore: avoid_print
        print("Error initializing video: $error");
        setState(() {
          _isVideoInitialized = false; // Indicate error or no video
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor transparent is handled by the child Scaffold usually
      body: Stack(
        children: <Widget>[
          if (_isVideoInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          else
            Container(
              // Fallback background if video fails or is loading
              color: Colors.black,
              child: const Center(child: CircularProgressIndicator()),
            ),
          widget.child, // Your actual page content
        ],
      ),
    );
  }
}

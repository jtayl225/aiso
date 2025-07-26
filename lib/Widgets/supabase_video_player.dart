import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SupabaseVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const SupabaseVideoPlayer({super.key, required this.videoUrl});

  @override
  State<SupabaseVideoPlayer> createState() => _SupabaseVideoPlayerState();
}

class _SupabaseVideoPlayerState extends State<SupabaseVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play(); // Autoplay
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

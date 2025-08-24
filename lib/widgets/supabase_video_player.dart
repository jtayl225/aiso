// // import 'package:flutter/material.dart';
// // import 'package:video_player/video_player.dart';
// //

// // class SupabaseVideoPlayer extends StatefulWidget {
// //   final String videoUrl;

// //   const SupabaseVideoPlayer({super.key, required this.videoUrl});

// //   @override
// //   State<SupabaseVideoPlayer> createState() => _SupabaseVideoPlayerState();
// // }

// // class _SupabaseVideoPlayerState extends State<SupabaseVideoPlayer> {
// //   late VideoPlayerController _controller;
// //   bool _isInitialized = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
// //       ..initialize().then((_) {
// //         setState(() {
// //           _isInitialized = true;
// //         });
// //         _controller.setLooping(true);
// //         _controller.play(); // Autoplay
// //       });
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return _isInitialized
// //         ? AspectRatio(
// //             aspectRatio: _controller.value.aspectRatio,
// //             child: VideoPlayer(_controller),
// //           )
// //         : const Center(child: CircularProgressIndicator());
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:video_player/video_player.dart';

// // class SupabaseVideoPlayer extends StatefulWidget {
// //   final String videoUrl;

// //   const SupabaseVideoPlayer({super.key, required this.videoUrl});

// //   @override
// //   State<SupabaseVideoPlayer> createState() => _SupabaseVideoPlayerState();
// // }

// // class _SupabaseVideoPlayerState extends State<SupabaseVideoPlayer> {
// //   late VideoPlayerController _controller;
// //   bool _isInitialized = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
// //       ..initialize().then((_) {
// //         _controller.setLooping(true);
// //         setState(() {
// //           _isInitialized = true;
// //         });
// //       });
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _togglePlayPause() async {
// //     if (_controller.value.isPlaying) {
// //       await _controller.pause();
// //     } else {
// //       await _controller.play();
// //     }
// //     setState(() {}); // Force rebuild for overlay
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (!_isInitialized) {
// //       return const Center(child: CircularProgressIndicator());
// //     }

// //     return GestureDetector(
// //       onTap: _togglePlayPause,
// //       child: Stack(
// //         alignment: Alignment.center,
// //         children: [
// //           AspectRatio(
// //             aspectRatio: _controller.value.aspectRatio,
// //             child: VideoPlayer(_controller),
// //           ),
// //           if (!_controller.value.isPlaying)
// //             Container(
// //               color: Colors.black45,
// //               child: const Icon(
// //                 Icons.play_circle_fill,
// //                 size: 64,
// //                 color: Colors.white,
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:video_player/video_player.dart';

// // class SupabaseVideoPlayer extends StatefulWidget {
// //   final String videoUrl;

// //   const SupabaseVideoPlayer({super.key, required this.videoUrl});

// //   @override
// //   State<SupabaseVideoPlayer> createState() => _SupabaseVideoPlayerState();
// // }

// // class _SupabaseVideoPlayerState extends State<SupabaseVideoPlayer> {
// //   late VideoPlayerController _controller;
// //   bool _isInitialized = false;
// //   bool _showOverlay = true;

// //   @override
// //   void initState() {
// //     super.initState();

// //     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
// //       ..initialize().then((_) {
// //         setState(() {
// //           _isInitialized = true;
// //         });
// //         _controller.setLooping(true);
// //       });
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _togglePlayPause() async {
// //     if (_controller.value.isPlaying) {
// //       await _controller.pause();
// //     } else {
// //       await _controller.play();
// //     }

// //     setState(() {
// //       _showOverlay = !_controller.value.isPlaying;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (!_isInitialized) {
// //       return const Center(child: CircularProgressIndicator());
// //     }

// //     return MouseRegion(
// //       cursor: SystemMouseCursors.click,
// //       child: GestureDetector(
// //         onTap: _togglePlayPause,
// //         child: Stack(
// //           alignment: Alignment.center,
// //           children: [
// //             AspectRatio(
// //               aspectRatio: _controller.value.aspectRatio,
// //               child: VideoPlayer(_controller),
// //             ),
// //             if (_showOverlay)
// //               Container(
// //                 color: Colors.black38,
// //                 child: const Icon(
// //                   Icons.play_circle_fill,
// //                   size: 72,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // import 'package:web/web.dart' as web;
// // import 'dart:js_interop';


// // import 'package:flutter/material.dart';
// // import 'package:video_player/video_player.dart';

// // class SupabaseVideoPlayer extends StatefulWidget {
// //   final String videoUrl;

// //   const SupabaseVideoPlayer({super.key, required this.videoUrl});

// //   @override
// //   State<SupabaseVideoPlayer> createState() => _SupabaseVideoPlayerState();
// // }

// // class _SupabaseVideoPlayerState extends State<SupabaseVideoPlayer> {
// //   late VideoPlayerController _controller;
// //   bool _isInitialized = false;
// //   bool _showPlayOverlay = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
// //       ..initialize().then((_) {
// //         setState(() {
// //           _isInitialized = true;
// //         });
// //         _controller.setLooping(true);
// //         // Do not autoplay
// //       });
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   void _togglePlay() {
// //     if (_controller.value.isPlaying) {
// //       _controller.pause();
// //       setState(() => _showPlayOverlay = true);
// //     } else {
// //       _controller.play();
// //       setState(() => _showPlayOverlay = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (!_isInitialized) {
// //       return const Center(child: CircularProgressIndicator());
// //     }

// //     return GestureDetector(
// //       onTap: _togglePlay,
// //       child: Stack(
// //         alignment: Alignment.center,
// //         children: [
// //           AspectRatio(
// //             aspectRatio: _controller.value.aspectRatio,
// //             child: VideoPlayer(_controller),
// //           ),
// //           if (_showPlayOverlay)
// //             const Icon(Icons.play_circle_outline, size: 64, color: Colors.white),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class SupabaseVideoPlayer extends StatefulWidget {
//   final String videoUrl;
//   final bool autoPlay;
//   final bool showControls;
//   final double? aspectRatio;
  
//   const SupabaseVideoPlayer({
//     super.key, 
//     required this.videoUrl,
//     this.autoPlay = false,
//     this.showControls = true,
//     this.aspectRatio,
//   });

//   @override
//   State<SupabaseVideoPlayer> createState() => _SupabaseVideoPlayerState();
// }

// class _SupabaseVideoPlayerState extends State<SupabaseVideoPlayer> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//   bool _showControls = true;
//   bool _hasError = false;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _initializePlayer();
//   }

//   void _initializePlayer() {
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
//       ..initialize().then((_) {
//         if (mounted) {
//           setState(() {
//             _isInitialized = true;
//           });
//           _controller.setLooping(true);
          
//           if (widget.autoPlay) {
//             _controller.play();
//             if (widget.showControls) {
//               setState(() => _showControls = false);
//             }
//           }
//         }
//       }).catchError((error) {
//         if (mounted) {
//           setState(() {
//             _hasError = true;
//             _errorMessage = error.toString();
//           });
//         }
//       });

//     // Listen to player state changes
//     _controller.addListener(_onPlayerStateChanged);
//   }

//   void _onPlayerStateChanged() {
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   @override
//   void didUpdateWidget(SupabaseVideoPlayer oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.videoUrl != widget.videoUrl) {
//       _controller.dispose();
//       _hasError = false;
//       _errorMessage = null;
//       _isInitialized = false;
//       _initializePlayer();
//     }
//   }

//   @override
//   void dispose() {
//     _controller.removeListener(_onPlayerStateChanged);
//     _controller.dispose();
//     super.dispose();
//   }

//   void _togglePlay() {
//     if (_controller.value.isPlaying) {
//       _controller.pause();
//     } else {
//       _controller.play();
//     }
    
//     if (widget.showControls) {
//       setState(() => _showControls = true);
//       // Hide controls after 3 seconds during playback
//       if (_controller.value.isPlaying) {
//         Future.delayed(const Duration(seconds: 3), () {
//           if (mounted && _controller.value.isPlaying) {
//             setState(() => _showControls = false);
//           }
//         });
//       }
//     }
//   }

//   void _onTap() {
//     if (widget.showControls) {
//       setState(() => _showControls = !_showControls);
      
//       // Auto-hide controls during playback
//       if (_showControls && _controller.value.isPlaying) {
//         Future.delayed(const Duration(seconds: 3), () {
//           if (mounted && _controller.value.isPlaying) {
//             setState(() => _showControls = false);
//           }
//         });
//       }
//     } else {
//       _togglePlay();
//     }
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }

//   Widget _buildControls() {
//     final position = _controller.value.position;
//     final duration = _controller.value.duration;
//     final isPlaying = _controller.value.isPlaying;

//     return AnimatedOpacity(
//       opacity: _showControls ? 1.0 : 0.0,
//       duration: const Duration(milliseconds: 300),
//       child: Container(
//         decoration: null,
//         // decoration: isPlaying ? BoxDecoration(
//         //   gradient: LinearGradient(
//         //     begin: Alignment.topCenter,
//         //     end: Alignment.bottomCenter,
//         //     colors: [
//         //       Colors.black.withOpacity(0.7),
//         //       Colors.transparent,
//         //       Colors.transparent,
//         //       Colors.black.withOpacity(0.7),
//         //     ],
//         //   ),
//         // ) : null,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Top controls (if needed)
//             const SizedBox(height: 40),
            
//             // Center play/pause button
//             Center(
//               child: GestureDetector(
//                 onTap: _togglePlay,
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     isPlaying ? Icons.pause : Icons.play_arrow,
//                     size: 50,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
            
//             // Bottom controls
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // Progress bar
//                   VideoProgressIndicator(
//                     _controller,
//                     allowScrubbing: true,
//                     colors: const VideoProgressColors(
//                       playedColor: Colors.blue,
//                       bufferedColor: Colors.grey,
//                       backgroundColor: Colors.white24,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
                  
//                   // Time and controls row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         '${_formatDuration(position)} / ${_formatDuration(duration)}',
//                         style: const TextStyle(color: Colors.white, fontSize: 12),
//                       ),
//                       Row(
//                         children: [
//                           IconButton(
//                             onPressed: _togglePlay,
//                             icon: Icon(
//                               isPlaying ? Icons.pause : Icons.play_arrow,
//                               color: Colors.white,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               _controller.seekTo(Duration.zero);
//                             },
//                             icon: const Icon(Icons.replay, color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_hasError) {
//       return Container(
//         color: Colors.black,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.error_outline, size: 64, color: Colors.red),
//               const SizedBox(height: 16),
//               const Text(
//                 'Failed to load video',
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//               const SizedBox(height: 8),
//               if (_errorMessage != null)
//                 Text(
//                   _errorMessage!,
//                   style: const TextStyle(color: Colors.grey, fontSize: 12),
//                   textAlign: TextAlign.center,
//                 ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     _hasError = false;
//                     _errorMessage = null;
//                     _isInitialized = false;
//                   });
//                   _initializePlayer();
//                 },
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (!_isInitialized) {
//       return Container(
//         color: Colors.black,
//         child: const Center(
//           child: CircularProgressIndicator(color: Colors.blue),
//         ),
//       );
//     }

//     final aspectRatio = widget.aspectRatio ?? _controller.value.aspectRatio;

//     return GestureDetector(
//       onTap: _onTap,
//       child: Container(
//         color: Colors.black,
//         child: AspectRatio(
//           aspectRatio: aspectRatio,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               VideoPlayer(_controller),
//               if (widget.showControls) _buildControls(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SupabaseVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool showControls;
  final double? aspectRatio;
  final String? thumbnailUrl; // NEW: Custom thumbnail URL
  final Widget? customThumbnail; // NEW: Custom thumbnail widget
  final bool showThumbnailUntilPlay; // NEW: Show thumbnail until user plays
  
  const SupabaseVideoPlayer({
    super.key, 
    required this.videoUrl,
    this.autoPlay = false,
    this.showControls = true,
    this.aspectRatio,
    this.thumbnailUrl,
    this.customThumbnail,
    this.showThumbnailUntilPlay = false,
  });

  @override
  State<SupabaseVideoPlayer> createState() => _SupabaseVideoPlayerState();
}

class _SupabaseVideoPlayerState extends State<SupabaseVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  bool _hasError = false;
  bool _showThumbnail = false; // NEW: Track thumbnail visibility
  bool _hasStartedPlaying = false; // NEW: Track if video has started
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Show thumbnail initially if configured
    _showThumbnail = widget.showThumbnailUntilPlay && 
                     (widget.thumbnailUrl != null || widget.customThumbnail != null);
    _initializePlayer();
  }

  void _initializePlayer() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.setLooping(true);
          
          if (widget.autoPlay && !_showThumbnail) {
            _controller.play();
            _hasStartedPlaying = true;
            if (widget.showControls) {
              setState(() => _showControls = false);
            }
          }
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _errorMessage = error.toString();
          });
        }
      });

    _controller.addListener(_onPlayerStateChanged);
  }

  void _onPlayerStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(SupabaseVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller.dispose();
      _hasError = false;
      _errorMessage = null;
      _isInitialized = false;
      _hasStartedPlaying = false;
      _showThumbnail = widget.showThumbnailUntilPlay && 
                       (widget.thumbnailUrl != null || widget.customThumbnail != null);
      _initializePlayer();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onPlayerStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
      // Hide thumbnail when starting to play
      if (_showThumbnail) {
        setState(() {
          _showThumbnail = false;
          _hasStartedPlaying = true;
        });
      }
    }
    
    if (widget.showControls) {
      setState(() => _showControls = true);
      if (_controller.value.isPlaying) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _controller.value.isPlaying) {
            setState(() => _showControls = false);
          }
        });
      }
    }
  }

  void _onTap() {
    // If showing thumbnail, start playing on tap
    if (_showThumbnail) {
      _togglePlay();
      return;
    }

    if (widget.showControls) {
      setState(() => _showControls = !_showControls);
      
      if (_showControls && _controller.value.isPlaying) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _controller.value.isPlaying) {
            setState(() => _showControls = false);
          }
        });
      }
    } else {
      _togglePlay();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildThumbnail() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Custom thumbnail or image from URL
        if (widget.customThumbnail != null)
          widget.customThumbnail!
        else if (widget.thumbnailUrl != null)
          Image.network(
            widget.thumbnailUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Icon(Icons.error_outline, color: Colors.white, size: 50),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                ),
              );
            },
          ),
        
        // Play button overlay
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(20),
          child: const Icon(
            Icons.play_arrow,
            size: 50,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    final isPlaying = _controller.value.isPlaying;

    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40),
            
            // Center play/pause button
            Center(
              child: GestureDetector(
                onTap: _togglePlay,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            // Bottom controls
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.blue,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_formatDuration(position)} / ${_formatDuration(duration)}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _togglePlay,
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _controller.seekTo(Duration.zero);
                            },
                            icon: const Icon(Icons.replay, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Failed to load video',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _errorMessage = null;
                    _isInitialized = false;
                  });
                  _initializePlayer();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      );
    }

    final aspectRatio = widget.aspectRatio ?? _controller.value.aspectRatio;

    return GestureDetector(
      onTap: _onTap,
      child: Container(
        color: Colors.black,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Show video player
              VideoPlayer(_controller),
              
              // Show thumbnail overlay if needed
              if (_showThumbnail) _buildThumbnail(),
              
              // Show controls if not showing thumbnail
              if (widget.showControls && !_showThumbnail) _buildControls(),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage examples:
class VideoPlayerExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // With thumbnail URL
        SupabaseVideoPlayer(
          videoUrl: 'your-video-url',
          thumbnailUrl: 'your-thumbnail-url',
          showThumbnailUntilPlay: true,
        ),
        
        // With custom thumbnail widget
        SupabaseVideoPlayer(
          videoUrl: 'your-video-url',
          customThumbnail: Container(
            color: Colors.blue,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.video_library, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text('Custom Thumbnail', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          showThumbnailUntilPlay: true,
        ),
      ],
    );
  }
}
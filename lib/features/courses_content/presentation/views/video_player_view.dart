// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/services.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//   final String? title;

//   const VideoPlayerScreen({
//     Key? key,
//     required this.videoUrl,
//     this.title,
//   }) : super(key: key);

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen>
//     with TickerProviderStateMixin {
//   VideoPlayerController? _controller;
//   bool _isInitialized = false;
//   bool _isLoading = true;
//   bool _hasError = false;
//   bool _showControls = true;
//   bool _isPlaying = false;
//   bool _isFullscreen = false;
//   String? _errorMessage;

//   late AnimationController _controlsAnimationController;
//   late Animation<double> _controlsAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controlsAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _controlsAnimation = CurvedAnimation(
//       parent: _controlsAnimationController,
//       curve: Curves.easeInOut,
//     );
//     _initializeVideo();
//   }

//   Future<void> _initializeVideo() async {
//     try {
//       _controller =
//           VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
//       await _controller!.initialize();

//       _controller!.addListener(() {
//         if (mounted) {
//           setState(() {
//             _isPlaying = _controller!.value.isPlaying;
//           });
//         }
//       });

//       setState(() {
//         _isInitialized = true;
//         _isLoading = false;
//         _hasError = false;
//       });

//       _showControlsTemporarily();
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//         _errorMessage = 'Failed to load video: ${e.toString()}';
//       });
//     }
//   }

//   void _showControlsTemporarily() {
//     setState(() {
//       _showControls = true;
//     });
//     _controlsAnimationController.forward();

//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted && _isPlaying) {
//         _hideControls();
//       }
//     });
//   }

//   void _hideControls() {
//     _controlsAnimationController.reverse();
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (mounted) {
//         setState(() {
//           _showControls = false;
//         });
//       }
//     });
//   }

//   void _togglePlayPause() {
//     if (_controller != null && _isInitialized) {
//       setState(() {
//         if (_controller!.value.isPlaying) {
//           _controller!.pause();
//         } else {
//           _controller!.play();
//           _showControlsTemporarily();
//         }
//       });
//     }
//   }

//   void _toggleFullscreen() {
//     setState(() {
//       _isFullscreen = !_isFullscreen;
//     });

//     if (_isFullscreen) {
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ]);
//     } else {
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//       ]);
//     }
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     _controlsAnimationController.dispose();
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Scaffold(
//       backgroundColor: colorScheme.surface,
//       appBar: _isFullscreen
//           ? null
//           : AppBar(
//               title: Text(
//                 widget.title ?? 'Video Player',
//                 style: theme.textTheme.titleLarge?.copyWith(
//                   color: colorScheme.onSurface,
//                 ),
//               ),
//               backgroundColor: colorScheme.surface,
//               foregroundColor: colorScheme.onSurface,
//               elevation: 0,
//               // systemOverlayStyle: SystemUiOverlayStyle.,
//             ),
//       body: SafeArea(
//         child: _buildVideoContent(theme, colorScheme),
//       ),
//     );
//   }

//   Widget _buildVideoContent(ThemeData theme, ColorScheme colorScheme) {
//     if (_isLoading) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(
//               color: colorScheme.primary,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Loading video...',
//               style: theme.textTheme.bodyLarge?.copyWith(
//                 color: colorScheme.onSurface,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_hasError) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.error_outline,
//                 size: 64,
//                 color: colorScheme.error,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Error loading video',
//                 style: theme.textTheme.headlineSmall?.copyWith(
//                   color: colorScheme.error,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 _errorMessage ?? 'An unknown error occurred',
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   color: colorScheme.onSurface,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),
//               FilledButton.icon(
//                 onPressed: () {
//                   setState(() {
//                     _isLoading = true;
//                     _hasError = false;
//                   });
//                   _initializeVideo();
//                 },
//                 icon: const Icon(Icons.refresh),
//                 label: const Text('Retry'),
//                 style: FilledButton.styleFrom(
//                   backgroundColor: colorScheme.primary,
//                   foregroundColor: colorScheme.onPrimary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (!_isInitialized || _controller == null) {
//       return const SizedBox.shrink();
//     }

//     return GestureDetector(
//       onTap: () {
//         if (_showControls) {
//           _hideControls();
//         } else {
//           _showControlsTemporarily();
//         }
//       },
//       child: Container(
//         color: Colors.black,
//         child: Stack(
//           children: [
//             Center(
//               child: AspectRatio(
//                 aspectRatio: _controller!.value.aspectRatio,
//                 child: VideoPlayer(_controller!),
//               ),
//             ),
//             if (_showControls)
//               AnimatedBuilder(
//                 animation: _controlsAnimation,
//                 builder: (context, child) {
//                   return Opacity(
//                     opacity: _controlsAnimation.value,
//                     child: _buildControls(theme, colorScheme),
//                   );
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildControls(ThemeData theme, ColorScheme colorScheme) {
//     final position = _controller!.value.position;
//     final duration = _controller!.value.duration;

//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Colors.black.withOpacity(0.7),
//             Colors.transparent,
//             Colors.transparent,
//             Colors.black.withOpacity(0.7),
//           ],
//         ),
//       ),
//       child: Column(
//         children: [
//           // Top controls
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 if (_isFullscreen)
//                   IconButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     icon: const Icon(Icons.arrow_back),
//                     color: Colors.white,
//                   ),
//                 Expanded(
//                   child: Text(
//                     widget.title ?? 'Video Player',
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       color: Colors.white,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: _toggleFullscreen,
//                   icon: Icon(
//                       _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen),
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//           ),
//           const Spacer(),
//           // Center play button
//           Center(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: colorScheme.primary.withOpacity(0.9),
//                 shape: BoxShape.circle,
//               ),
//               child: IconButton(
//                 onPressed: _togglePlayPause,
//                 icon: Icon(
//                   _isPlaying ? Icons.pause : Icons.play_arrow,
//                   size: 48,
//                 ),
//                 color: colorScheme.onPrimary,
//                 iconSize: 48,
//               ),
//             ),
//           ),
//           const Spacer(),
//           // Bottom controls
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 // Progress bar
//                 VideoProgressIndicator(
//                   _controller!,
//                   allowScrubbing: true,
//                   padding: EdgeInsets.zero,
//                   colors: VideoProgressColors(
//                     playedColor: colorScheme.primary,
//                     bufferedColor: colorScheme.primary.withOpacity(0.3),
//                     backgroundColor: Colors.white.withOpacity(0.3),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 // Time and controls
//                 Row(
//                   children: [
//                     Text(
//                       _formatDuration(position),
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         color: Colors.white,
//                       ),
//                     ),
//                     const Spacer(),
//                     IconButton(
//                       onPressed: () {
//                         final newPosition =
//                             position - const Duration(seconds: 10);
//                         _controller!.seekTo(newPosition);
//                       },
//                       icon: const Icon(Icons.replay_10),
//                       color: Colors.white,
//                     ),
//                     IconButton(
//                       onPressed: _togglePlayPause,
//                       icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//                       color: Colors.white,
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         final newPosition =
//                             position + const Duration(seconds: 10);
//                         _controller!.seekTo(newPosition);
//                       },
//                       icon: const Icon(Icons.forward_10),
//                       color: Colors.white,
//                     ),
//                     const Spacer(),
//                     Text(
//                       _formatDuration(duration),
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

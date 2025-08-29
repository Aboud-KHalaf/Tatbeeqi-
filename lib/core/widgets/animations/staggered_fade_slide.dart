import 'package:flutter/material.dart';

/// A lightweight, reusable entrance animation that fades and slides
/// a child into view once (on first build) with an optional delay.
///
/// - Uses implicit animations for performance
/// - Does not re-animate on scroll
/// - Triggers only once per widget lifecycle
class StaggeredFadeSlide extends StatefulWidget {
  const StaggeredFadeSlide({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 350),
    this.beginOffset = const Offset(0, 0.06),
    this.curve = Curves.easeOut,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset beginOffset;
  final Curve curve;

  @override
  State<StaggeredFadeSlide> createState() => _StaggeredFadeSlideState();
}

class _StaggeredFadeSlideState extends State<StaggeredFadeSlide> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _scheduleStart();
  }

  Future<void> _scheduleStart() async {
    if (widget.delay > Duration.zero) {
      await Future.delayed(widget.delay);
    }
    if (mounted) {
      setState(() => _visible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final offset = _visible ? Offset.zero : widget.beginOffset;
    final opacity = _visible ? 1.0 : 0.0;

    return AnimatedSlide(
      offset: offset,
      duration: widget.duration,
      curve: widget.curve,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}

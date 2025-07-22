// Scroll-responsive animated wrapper for CreatePostBar
import 'package:flutter/widgets.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/create_post_bar.dart';

class AnimatedCreatePostBar extends StatefulWidget {
  final ValueNotifier<double> scrollOffset;

  const AnimatedCreatePostBar({
    super.key,
    required this.scrollOffset,
  });

  @override
  State<AnimatedCreatePostBar> createState() => _AnimatedCreatePostBarState();
}

class _AnimatedCreatePostBarState extends State<AnimatedCreatePostBar>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _shimmerController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Slide animation controller
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Shimmer animation controller
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Professional slide animation with smooth curve
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.fastOutSlowIn,
    ));

    // Fade in animation
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    // Shimmer effect animation
    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.ease,
    ));

    // Start animations with delay
    _slideController.forward();

    // Start breathing animation after slide completes
    _slideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Add occasional shimmer effect
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _startShimmerSequence();
          }
        });
      }
    });
  }

  void _startShimmerSequence() {
    if (!mounted) return;

    _shimmerController.forward().then((_) {
      if (mounted) {
        _shimmerController.reset();
        // Repeat shimmer every 8 seconds
        Future.delayed(const Duration(seconds: 8), () {
          _startShimmerSequence();
        });
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: ValueListenableBuilder<double>(
          valueListenable: widget.scrollOffset,
          builder: (context, scrollValue, child) {
            // Calculate scroll-based transformations
            final scrollProgress = (scrollValue / 200).clamp(0.0, 1.0);

            // Parallax effect - moves slightly slower than scroll
            final parallaxOffset = scrollValue * 0.1;

            // Opacity effect - fades slightly when scrolling
            final scrollOpacity = 1.0 - (scrollProgress * 0.15);

            return Transform.translate(
              offset: Offset(0, -parallaxOffset),
              child: AnimatedBuilder(
                animation: Listenable.merge([_shimmerAnimation]),
                builder: (context, child) {
                  return Opacity(
                    opacity: scrollOpacity,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: const CreatePostBar(),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

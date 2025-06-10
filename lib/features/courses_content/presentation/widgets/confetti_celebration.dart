import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiCelebration extends StatefulWidget {
  final Widget child;
  final bool celebrate;

  const ConfettiCelebration({
    super.key,
    required this.child,
    required this.celebrate,
  });

  @override
  State<ConfettiCelebration> createState() => _ConfettiCelebrationState();
}

class _ConfettiCelebrationState extends State<ConfettiCelebration> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiPiece> _confetti = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.addListener(() {
      if (_controller.isCompleted) {
        _controller.reset();
      }
    });

    // Generate confetti pieces
    for (int i = 0; i < 50; i++) {
      _confetti.add(ConfettiPiece(
        color: Color.fromRGBO(
          _random.nextInt(255),
          _random.nextInt(255),
          _random.nextInt(255),
          1,
        ),
        position: Offset(
          _random.nextDouble() * 400,
          _random.nextDouble() * -100,
        ),
        size: _random.nextDouble() * 10 + 5,
        speed: _random.nextDouble() * 200 + 100,
        angle: _random.nextDouble() * pi / 2 - pi / 4,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ConfettiCelebration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.celebrate && !oldWidget.celebrate) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.celebrate)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: ConfettiPainter(
                  confetti: _confetti,
                  progress: _controller.value,
                ),
                child: Container(),
              );
            },
          ),
      ],
    );
  }
}

class ConfettiPiece {
  final Color color;
  final Offset position;
  final double size;
  final double speed;
  final double angle;

  ConfettiPiece({
    required this.color,
    required this.position,
    required this.size,
    required this.speed,
    required this.angle,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiPiece> confetti;
  final double progress;

  ConfettiPainter({required this.confetti, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in confetti) {
      final paint = Paint()..color = piece.color;
      final position = Offset(
        piece.position.dx,
        piece.position.dy + piece.speed * progress,
      );
      canvas.drawCircle(position, piece.size, paint);
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}
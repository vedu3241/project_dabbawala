// proper red heart
import 'package:flutter/material.dart';

class DoubleTapLikeAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onDoubleTap;

  const DoubleTapLikeAnimation({
    Key? key,
    required this.child,
    required this.onDoubleTap,
  }) : super(key: key);

  @override
  _DoubleTapLikeAnimationState createState() => _DoubleTapLikeAnimationState();
}

class _DoubleTapLikeAnimationState extends State<DoubleTapLikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showHeart = false;
        });
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    widget.onDoubleTap();
    setState(() {
      _showHeart = true;
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The main content (usually an image)
          widget.child,

          // Heart overlay animation
          if (_showHeart)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red, // Red heart color
                      size: 80,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

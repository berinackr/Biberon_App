import 'package:flutter/material.dart';

class ForumBadge extends StatelessWidget {
  const ForumBadge({
    required this.icon,
    required this.text,
    super.key,
    this.color,
  });
  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1,
      child: SizedBox(
        width: 35,
        height: 35,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: Icon(icon),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Transform.scale(
                scale: 0.8,
                child: Container(
                  decoration: BoxDecoration(
                    color: color ?? Colors.orange[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 1,
                    ),
                    child: Text(text),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

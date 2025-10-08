import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({
    super.key,
    this.thickness = 0.5,
    this.color = const Color.fromRGBO(158, 158, 158, 1),
    this.text = 'Veya',
    this.width = double.infinity,
  });

  final double thickness;
  final Color color;
  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: thickness,
              color: color,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              text,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w300,
                  ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: thickness,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

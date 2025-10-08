import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ImageContaier extends StatelessWidget {
  const ImageContaier({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.grey.shade400,
      dashPattern: const [6, 6],
      borderType: BorderType.RRect,
      radius: const Radius.circular(360),
      padding: const EdgeInsets.all(5),
      child: ClipOval(
        child: SizedBox(
          height: 85,
          width: 85,
          child: Icon(
            Icons.photo_camera,
            size: 35,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }
}

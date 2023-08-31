import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final ImageProvider imageProvider;

  ImageDialog({required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Image(image: imageProvider),
      ),
    );
  }
}
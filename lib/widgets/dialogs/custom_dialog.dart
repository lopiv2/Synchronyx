import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  final Offset offset;

  const CustomDialog({required this.child, required this.offset});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      ),
    );
  }
}

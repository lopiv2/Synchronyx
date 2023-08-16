import 'package:flutter/material.dart';

class Platforms {
  Platforms({
    required this.title,
    this.icon = const Image(
      image: AssetImage("assets/icons/default_icon.png"),
      width: 1,
      height: 1,
      color: null,
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
    ),
    this.children = const <Platforms>[],
  });

  final String title;
  final Image icon;
  final List<Platforms> children;
}

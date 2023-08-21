import 'package:flutter/material.dart';

class Platforms {
  Platforms({
    required this.title,
    required this.value,
    this.icon = const Image(
      image: AssetImage("assets/icons/default_icon.png"),
      width: 1,
      height: 1,
      color: null,
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
    ),
    List<Platforms>? children,
  }) : children = children ?? [];

  final String title;
  final String value;
  final Image icon;
  List<Platforms> children;
}

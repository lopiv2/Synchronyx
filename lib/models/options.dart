import 'package:flutter/material.dart';

class Options {
  Options({
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
    List<Options>? children,
  }) : children = children ?? [];

  final String title;
  final String value;
  final Image icon;
  List<Options> children;
}

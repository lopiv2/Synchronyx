import 'package:flutter/material.dart';

class Platforms {
  Platforms({
    required this.title,
    required this.icon,
    this.children = const <Platforms>[],
  });

  final String title;
  final Image icon;
  final List<Platforms> children;

}

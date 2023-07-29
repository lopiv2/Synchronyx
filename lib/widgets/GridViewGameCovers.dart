import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import '3DModelLoader.dart';

class GridViewGameCovers extends StatelessWidget {
  GridViewGameCovers({super.key});
  late Scene _scene;
  Object? _bunny;
  double _ambient = 0.1;
  double _diffuse = 0.8;
  double _specular = 0.5;
  double _shininess = 0.0;
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 4,
      crossAxisSpacing: 80,
      children: _buildGridTileList(10),
    );
  }

  List<Container> _buildGridTileList(int count) => List.generate(
        count,
        (i) => Container(child: ModelLoader()),
      );
}


  /*List<Container> _buildGridTileList(int count) => List.generate(
      count,
      (i) =>
          Container(child: Image.asset('assets/buttons/ArcadeBoxButton.png')));
}*/

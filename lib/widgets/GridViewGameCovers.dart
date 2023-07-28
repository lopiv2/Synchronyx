import 'package:flutter/material.dart';

class GridViewGameCovers extends StatelessWidget {
  const GridViewGameCovers({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 4,
      crossAxisSpacing: 80,
      children: _buildGridTileList(30),
    );
  }


  List<Container> _buildGridTileList(int count) => List.generate(
      count,
      (i) =>
          Container(child: Image.asset('assets/buttons/ArcadeBoxButton.png')));
}

import 'package:flutter/material.dart';
import 'ImageCoverModel.dart';

class GridViewGameCovers extends StatelessWidget {
  GridViewGameCovers({super.key});
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 12,
      crossAxisSpacing: 8,
      children: _buildGridTileList(20),
    );
  }

  List<Container> _buildGridTileList(int count) => List.generate(
        count,
        (i) => Container(
          child: Transform.scale(
            scale:
                2.2, // Ajusta el tamaño de la imagen mostrada (50% en este ejemplo)
            child: ImageCoverModel(),
          ),
        ),
      );
}


  /*List<Container> _buildGridTileList(int count) => List.generate(
      count,
      (i) =>
          Container(child: Image.asset('assets/buttons/ArcadeBoxButton.png')));
}*/

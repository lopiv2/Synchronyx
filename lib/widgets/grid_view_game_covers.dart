import 'package:flutter/material.dart';
import '../models/game.dart';
import '../models/media.dart';
import 'image_cover_model.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart'
    as databaseFunctions;

class GridViewGameCovers extends StatelessWidget {
  GridViewGameCovers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Game>>(
      future: databaseFunctions.getAllGames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print(snapshot.connectionState);
          return CircularProgressIndicator(); // Displays a charging indicator while waiting
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No hay datos disponibles');
        } else {
          List<Game> listOfGames = snapshot.data!;
          return GridView.count(
            crossAxisCount: 4,
            padding: const EdgeInsets.all(4),
            mainAxisSpacing: 12,
            crossAxisSpacing: 8,
            children: _buildGridTileList(listOfGames),
          );
        }
      },
    );
  }

  List<Container> _buildGridTileList(List<Game> listOfGames) {
    List<Container> containers = [];

    for (Game game in listOfGames) {
      databaseFunctions.getMediaById(game.id).then((gameMedia) {
        containers.add(
          Container(
            child: Transform.scale(
              scale: 2.2,
              child: ImageCoverModel(
                game: game,
                gameMedia: gameMedia!,
              ),
            ),
          ),
        );
      });
    }

    return containers;
  }
}

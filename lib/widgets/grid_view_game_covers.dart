import 'package:flutter/material.dart';
import 'package:synchronyx/utilities/constants.dart';
import '../models/game.dart';
import '../models/gameMedia_response.dart';
import '../models/media.dart';
import 'image_cover_model.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart'
    as databaseFunctions;

class GridViewGameCovers extends StatelessWidget {
  const GridViewGameCovers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print(Constants.database);
    return FutureBuilder<List<Game>>(
      future: databaseFunctions.getAllGames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('Cargando datos...'); // Mensaje durante la carga inicial
        } else if (snapshot.data!.isEmpty) {
          return Text('No hay datos disponibles');
        } else {
          List<Game> listOfGames = snapshot.data!;
          return FutureBuilder<List<Container>>(
            future: _buildGridTileList(listOfGames),
            builder: (context, containerSnapshot) {
              if (containerSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (containerSnapshot.hasError) {
                return Text('Error: ${containerSnapshot.error}');
              } else if (!containerSnapshot.hasData) {
                return Text('Cargando contenedores...');
              } else {
                List<Container> containers = containerSnapshot.data!;
                return GridView.count(
                  crossAxisCount: 4,
                  padding: const EdgeInsets.all(4),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 8,
                  children: containers,
                );
              }
            },
          );
        }
      },
    );
  }

  Future<List<Container>> _buildGridTileList(List<Game> listOfGames) async {
    List<Container> containers = [];
    for (Game game in listOfGames) {
      Media? gameMedia = await databaseFunctions.getMediaById(game.id);
      if (gameMedia != null) {
        GameMediaResponse gameMediaResponse =
            GameMediaResponse.fromGameAndMedia(game, gameMedia);
        Constants.gamesInGrid.add(gameMediaResponse);
        containers.add(
          Container(
            child: Transform.scale(
              scale: 2.2,
              child: ImageCoverModel(
                game: game,
                gameMedia: gameMedia,
                onGameClick: (gameId) {
                  //print("Clicked on game with ID: $gameId");
                },
              ),
            ),
          ),
        );
      }
    }

    return containers;
  }
}

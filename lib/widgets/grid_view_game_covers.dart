import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/providers/app_state.dart';
import 'package:synchronyx/utilities/constants.dart';
import '../models/game.dart';
import '../models/gameMedia_response.dart';
import '../models/media.dart';
import 'image_cover_model.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart'
    as databaseFunctions;

class GridViewGameCovers extends StatefulWidget {
  const GridViewGameCovers({Key? key}) : super(key: key);

  @override
  State<GridViewGameCovers> createState() => _GridViewGameCoversState();
}

class _GridViewGameCoversState extends State<GridViewGameCovers> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return FutureBuilder<List<Game>>(
      future: databaseFunctions.getAllGamesWithFilter(appState.filter, appState.filterValue),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('Cargando datos...'); // Mensaje durante la carga inicial
        } else if (snapshot.data!.isEmpty) {
          return Text('');
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
    final appState = Provider.of<AppState>(context, listen: false);
    appState.gamesInGrid.clear();
    List<Container> containers = [];
    for (int index = 0; index < listOfGames.length; index++) {
      Media? gameMedia =
          await databaseFunctions.getMediaById(listOfGames[index].mediaId!);
      if (gameMedia != null) {
        GameMediaResponse gameMediaResponse =
            GameMediaResponse.fromGameAndMedia(listOfGames[index], gameMedia);
        appState.gamesInGrid.add(gameMediaResponse);
        appState.elementsAnimations.add(false);
        containers.add(
          Container(
            //color: Colors.red,
            child: Transform.scale(
              scale: 2.2,
              child: ImageCoverModel(
                game: listOfGames[index],
                gameMedia: gameMedia,
                index: index,
                onGameClick: (gameId) {
                  appState.clickedElementIndex = index;
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

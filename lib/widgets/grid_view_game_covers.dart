import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lioncade/providers/app_state.dart';
import '../models/game.dart';
import '../models/responses/gameMedia_response.dart';
import '../models/media.dart';
import 'image_cover_model.dart';
import 'package:lioncade/utilities/generic_database_functions.dart'
    as database_functions;

class GridViewGameCovers extends StatelessWidget {
  const GridViewGameCovers({Key? key}) : super(key: key);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    final appState = Provider.of<AppState>(context);
    return FutureBuilder<List<Game>>(
      future: database_functions.getAllGamesWithFilter(
          appState.filter,
          appState
              .filterValue), //Automatically filters according to the filter we apply from other filters
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text(
              'Cargando datos...'); // Mensaje durante la carga inicial
        } else if (snapshot.data!.isEmpty) {
          return const Text('');
        } else {
          List<Game> listOfGames = snapshot.data!;
          listOfGames.sort((a, b) => a.title.compareTo(b.title));
          return FutureBuilder<List<Container>>(
            future: _buildGridTileList(context, listOfGames),
            builder: (context, containerSnapshot) {
              if (containerSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (containerSnapshot.hasError) {
                return Text('Error: ${containerSnapshot.error}');
              } else if (!containerSnapshot.hasData) {
                return const Text('Cargando contenedores...');
              } else {
                List<Container> containers = containerSnapshot.data!;
                return GridView.count(
                  crossAxisCount: 4,
                  padding: const EdgeInsets.all(4),
                  mainAxisSpacing: 75,
                  crossAxisSpacing: 4,
                  children: containers,
                );
              }
            },
          );
        }
      },
    );
  }

  Future<List<Container>> _buildGridTileList(BuildContext context, List<Game> listOfGames) async {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.gamesInGrid.clear();
    List<Container> containers = [];
    for (int index = 0; index < listOfGames.length; index++) {
      Media? gameMedia =
          await database_functions.getMediaById(listOfGames[index].mediaId);
      if (gameMedia != null) {
        GameMediaResponse gameMediaResponse =
            GameMediaResponse.fromGameAndMedia(listOfGames[index], gameMedia);
        appState.gamesInGrid.add(gameMediaResponse);
        appState.elementsAnimations.add(false);
        containers.add(
          Container(
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

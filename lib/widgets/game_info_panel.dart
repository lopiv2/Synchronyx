import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:synchronyx/models/gameMedia_response.dart';
import 'package:synchronyx/widgets/buttons/icon_button_colored.dart';
import '../providers/app_state.dart';
import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart'
    as databaseFunctions;

class GameInfoPanel extends StatefulWidget {
  const GameInfoPanel({super.key, required this.appLocalizations});
  final AppLocalizations appLocalizations;

  @override
  State<GameInfoPanel> createState() => _GameInfoPanelState();
}

class _GameInfoPanelState extends State<GameInfoPanel> {
  late String url = "";
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    //url = appState.selectedGame!.media.videoUrl;
    ImageProvider<Object> imageWidgetMarquee;
    imageWidgetMarquee =
        FileImage(File(appState.selectedGame!.media.backgroundImageUrl));
    ImageProvider<Object> logoWidgetMarquee;
    logoWidgetMarquee = FileImage(File(appState.selectedGame!.media.logoUrl));
    playOst();
    return Column(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.3,
            color: Colors.white,
            child: appState.selectedGame?.media.videoUrl !=
                    "" //Arreglar esto en el futuro para que muestre el video o la imagen segun las opciones
                ? Text("Video holder")
                : Stack(
                    children: <Widget>[
                      imageWidgetMarquee != ""
                          ? Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageWidgetMarquee,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Text(""),
                      logoWidgetMarquee != ""
                          ? Positioned(
                              right: MediaQuery.of(context).size.width * 0.06,
                              bottom: -80,
                              child: FadeInDown(
                                  duration: Duration(seconds: 2),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: logoWidgetMarquee,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  )))
                          : Text(""),
                      Positioned(
                        right: MediaQuery.of(context).size.width * 0.17,
                        bottom: 10,
                        child: Stack(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(115, 158, 158, 158),
                                  borderRadius: BorderRadius.circular(
                                      5), // Ajusta este valor según tu preferencia
                                )),
                            Positioned(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.0085,
                                right:
                                    MediaQuery.of(context).size.width * 0.077,
                                child: Text(
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.012,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    appState.selectedGame!.game.rating
                                        .toString())),
                            Positioned(
                                //right: MediaQuery.of(context).size.width * 0.17,
                                bottom: 5,
                                right: 0,
                                child: RatingBar.builder(
                                  initialRating:
                                      appState.selectedGame!.game.rating,
                                  minRating: 0,
                                  maxRating: 5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
                                  itemSize:
                                      MediaQuery.of(context).size.width * 0.015,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                )),
                          ],
                        ),
                      )
                    ],
                  )
            //child: WinVideoPlayer(controller),
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                reload();
              },
              icon: Icon(Icons.shopping_cart),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                print('Botón 2');
              },
              icon: Icon(Icons.threesixty),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                print('Botón 3');
              },
              icon: Icon(Icons.settings),
              color: Colors.white,
            ),
            IconButtonHoverColored(
              icon: Icons.star_border_outlined,
              onPressed: () {},
              iconColor: Colors.yellow,
              backColor: Colors.grey,
            ),
            IconButtonHoverColored(
              icon: Icons.clear,
              onPressed: () {
                showDeleteConfirmationDialog(context, appState);
              },
              iconColor: Colors.red,
              backColor: Colors.grey,
            ),
            IconButton(
              onPressed: () {
                showDeleteConfirmationDialog(context, appState);
              },
              icon: Icon(Icons.play_arrow),
              color: Colors.white,
            ),
          ],
        ),
        Row(children: [
          Expanded(
              flex: 2,
              child: PushableButton(
                child: Text('ENROLL NOW'),
                height: 40,
                elevation: 8,
                hslColor: HSLColor.fromAHSL(1.0, 120, 1.0, 0.37),
                shadow: BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 2),
                ),
                onPressed: () => print('Button Pressed!'),
              )),
        ]),
      ],
    );
  }

  Future<void> playOst() async {
    //await player.play(AssetSource('music/theme.mp3'));
  }

  void reload() {
    //controller?.dispose();
    if (url != null) {}
  }

  @override
  void initState() {
    super.initState();
    //reload();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showDeleteConfirmationDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GameDeleteConfirmationDialog(
          selectedGame: appState.selectedGame!,
          onConfirm: (GameMediaResponse game) async {
            await databaseFunctions.deleteGame(game.game.id!);
            await databaseFunctions.deleteMediaByName(game);
            appState.gamesInGrid.removeWhere(
                (game) => game.game.id == appState.selectedGame!.game.id);
            //Refresh grid view when deleted
            appState.refreshGridView();
          },
          appLocalizations: widget.appLocalizations,
        );
      },
    );
  }
}

class GameDeleteConfirmationDialog extends StatefulWidget {
  final GameMediaResponse selectedGame;
  final Function(GameMediaResponse) onConfirm;
  final AppLocalizations appLocalizations;

  const GameDeleteConfirmationDialog(
      {super.key,
      required this.selectedGame,
      required this.onConfirm,
      required this.appLocalizations});

  @override
  State<GameDeleteConfirmationDialog> createState() =>
      _GameDeleteConfirmationDialogState();
}

class _GameDeleteConfirmationDialogState
    extends State<GameDeleteConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return AlertDialog(
      title: Text(widget.appLocalizations.confirmDelete),
      content: Text(
          widget.appLocalizations.sureDelete(widget.selectedGame.game.title)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el diálogo
          },
          child: Text(widget.appLocalizations.cancel),
        ),
        TextButton(
          onPressed: () {
            widget.onConfirm(widget
                .selectedGame); // Pasa el juego seleccionado a la función de confirmación
            Navigator.of(context).pop(); // Cierra el diálogo
          },
          child: Text(
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              widget.appLocalizations.delete),
        ),
      ],
    );
  }
}

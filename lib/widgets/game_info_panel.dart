import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:synchronyx/models/responses/gameMedia_response.dart';
import 'package:synchronyx/utilities/Constants.dart';
import 'package:synchronyx/utilities/generic_functions.dart';
import 'package:synchronyx/widgets/buttons/icon_button_colored.dart';
import 'package:synchronyx/widgets/dialogs/image_preview_dialog.dart';
import 'package:synchronyx/widgets/dialogs/ost_download_dialog.dart';
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
  late AnimationController _controller;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Consumer<AppState>(
      builder: (context, appState, child) {
        final selectedGame = appState.selectedGame;
        isFavorite = appState.selectedGame?.game.favorite == 1;

        return FutureBuilder<Widget>(
          future: _buildGameInfoPanel(appState, selectedGame),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Mostrar un indicador de carga mientras esperas
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return snapshot.data ??
                  SizedBox(); // Construir el widget obtenido o un SizedBox si es nulo
            }
          },
        );
      },
    );
  }

  Future<Widget> _buildGameInfoPanel(
      AppState appState, GameMediaResponse? selectedGame) async {
    bool isHovered = false;
    //Marquee
    ImageProvider<Object> imageWidgetMarquee;
    imageWidgetMarquee =
        FileImage(File(appState.selectedGame!.media.backgroundImageUrl));
    //Logo
    ImageProvider<Object> logoWidgetMarquee;
    logoWidgetMarquee = FileImage(File(appState.selectedGame!.media.logoUrl));
    //Screenshots
    GamePlatforms g = GamePlatforms.values.firstWhere(
        (element) => element.name == appState.selectedGame!.game.platform);
    Image platformIcon = g.image;
    PlatformStore p = PlatformStore.values.firstWhere(
        (element) => element.name == appState.selectedGame!.game.platformStore);
    Icon platformStoreIcon = p.icon;
    List<String> screensPaths =
        appState.selectedGame!.media.screenshots.split(',');
    String id = screensPaths[0].split('_')[0];
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String folder = '\\Synchronyx\\media\\screenshots\\$id\\';
    String screenFolder = '${appDocumentsDirectory.path}$folder';
    List<ImageProvider<Object>> imageProvidersMarquee = List.generate(
      screensPaths.length,
      (index) => FileImage(File('$screenFolder${screensPaths[index]}')),
    );
    List<String> developersList =
        appState.selectedGame!.game.developer.split(',');
    List<Widget> developerWidgets = developersList.map((developer) {
      return Text(style: TextStyle(color: Colors.white), '- $developer');
    }).toList();
    List<String> publisherList =
        appState.selectedGame!.game.publisher.split(',');
    List<Widget> publisherWidgets = publisherList.map((publisher) {
      return Text(
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.start,
          '- $publisher');
    }).toList();
    playOst();

    return Column(children: [
      Expanded(
          child: SingleChildScrollView(
              child: Column(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.3,
            color: Colors.white,
            child: appState.selectedGame?.media.videoUrl != ""
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
                                  controller: (controller) =>
                                      _controller = controller,
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
                      platformStoreIcon != ""
                          ? Positioned(
                              right: 20.01,
                              bottom: MediaQuery.of(context).size.height * 0.25,
                              child: Container(
                                  child: Icon(
                                platformStoreIcon.icon,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width * 0.02,
                              )))
                          : Text(""),
                      appState.selectedGame!.media.musicUrl != ""
                          ? Positioned(
                              left: 10.01,
                              bottom: MediaQuery.of(context).size.height * 0.24,
                              child: Tooltip(
                                  message:
                                      widget.appLocalizations.ostDownloadClick,
                                  child: InkWell(
                                    onTap: () {
                                      // Función que se ejecutará al tocar el icono
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return OstDownloadDialog(
                                            appLocalizations:
                                                widget.appLocalizations,
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          8.0), // Espacio de relleno alrededor del icono
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color.fromARGB(0, 33, 149,
                                            243), // Color de fondo del botón
                                      ),
                                      child: Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                    ),
                                  )),
                            )
                          : Positioned(
                              left: 10.01,
                              bottom: MediaQuery.of(context).size.height * 0.24,
                              child: Tooltip(
                                  message:
                                      widget.appLocalizations.ostDownloadClick,
                                  child: InkWell(
                                    onTap: () {
                                      // Función que se ejecutará al tocar el icono
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return OstDownloadDialog(
                                            appLocalizations:
                                                widget.appLocalizations,
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                          8.0), // Espacio de relleno alrededor del icono
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromARGB(0, 33, 149,
                                            243), // Color de fondo del botón
                                      ),
                                      child: Icon(
                                        Icons.music_off,
                                        color: Colors.white,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                    ),
                                  )),
                            ),
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
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.014,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          appState.selectedGame!.game.rating
                                              .toString()),
                                      GFRating(
                                        itemCount: 5,
                                        color: Colors.amber,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.015,
                                        value:
                                            appState.selectedGame!.game.rating,
                                        onChanged: (value) {},
                                      ),
                                    ])),
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
            IconButtonHoverColored(
              onPressed: () {
                reload();
              },
              icon: Icons.shopping_cart,
              iconColor: Colors.white,
            ),
            IconButtonHoverColored(
              onPressed: () {
                final appState = Provider.of<AppState>(context, listen: false);
                appState.toggleAnimations();
              },
              icon: Icons.threesixty,
              iconColor: Colors.white,
            ),
            IconButtonHoverColored(
              onPressed: () {
                print('Botón 3');
              },
              icon: Icons.settings,
              iconColor: Colors.white,
            ),
            ToggleFavoriteButton(),
            IconButtonHoverColored(
              icon: Icons.clear,
              onPressed: () {
                showDeleteConfirmationDialog(context, appState);
              },
              iconColor: Colors.red,
              backColor: Colors.grey,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0,
                  0), // Aplicar espacio de padding a la derecha del icono
              child: platformIcon,
            ),
            Text(
              appState.selectedGame!.game.platform.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                appState.selectedGame!.game.title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: MouseRegion(
                cursor: SystemMouseCursors
                    .click, // Cambia el cursor al estilo de un botón
                child: GestureDetector(
                  onTap: () {
                    _showImageDialog(context, imageProvidersMarquee[0]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: imageProvidersMarquee[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      0.195, // Ajusta la altura según tus necesidades
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Número de columnas en cada fila
                      mainAxisSpacing: 8.0, // Espacio vertical entre elementos
                      crossAxisSpacing:
                          8.0, // Espacio horizontal entre elementos
                    ),
                    itemCount: imageProvidersMarquee.length - 1,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          _showImageDialog(
                              context, imageProvidersMarquee[index + 1]);
                        },
                        onHover: (value) {
                          isHovered = value;
                          //print(isHovered);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: imageProvidersMarquee[index + 1],
                              fit: BoxFit.fitHeight,
                              colorFilter: isHovered
                                  ? ColorFilter.mode(
                                      const Color.fromARGB(255, 155, 16, 16)
                                          .withOpacity(0.1),
                                      BlendMode.srcATop,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 36, 16, 0),
                child: PushableButton(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                          appState.selectedGame?.game.installed == 1
                              ? widget.appLocalizations.play
                              : widget.appLocalizations.install,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(46, 12, 77, 12),
                  borderRadius: BorderRadius.circular(20),
                  //border: Border.all(),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(20, 12, 77, 12),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(26, 16, 26, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    widget.appLocalizations.launchDate),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    formatDateString(appState
                                        .selectedGame!.game.releaseDate
                                        .toString())),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                      child: const Divider()),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    widget.appLocalizations.developer),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GFAccordion(
                                    title: 'Pulse para abrir',
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    collapsedTitleBackgroundColor:
                                        const Color.fromARGB(0, 250, 205, 202),
                                    expandedTitleBackgroundColor:
                                        const Color.fromARGB(0, 250, 205, 202),
                                    contentBackgroundColor:
                                        const Color.fromARGB(0, 250, 205, 202),
                                    textStyle: const TextStyle(
                                        backgroundColor:
                                            Color.fromARGB(0, 244, 67, 54)),
                                    contentChild: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: developerWidgets),
                                    collapsedIcon: Icon(Icons.add),
                                    expandedIcon: Icon(Icons.minimize)),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                      child: const Divider()),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    widget.appLocalizations.publisher),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GFAccordion(
                                    title: 'Pulse para abrir',
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 2, 0, 0),
                                    collapsedTitleBackgroundColor:
                                        const Color.fromARGB(0, 250, 205, 202),
                                    expandedTitleBackgroundColor:
                                        const Color.fromARGB(0, 250, 205, 202),
                                    contentBackgroundColor:
                                        const Color.fromARGB(0, 250, 205, 202),
                                    textStyle: const TextStyle(
                                        backgroundColor:
                                            Color.fromARGB(0, 244, 67, 54)),
                                    contentChild:
                                        Column(children: publisherWidgets),
                                    collapsedIcon: const Icon(Icons.add),
                                    expandedIcon: const Icon(Icons.minimize)),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(
                          26, 0, 26, 0), // Agrega el padding deseado
                      child: const Divider()),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(
                          26, 0, 26, 0), // Agrega el padding deseado
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    widget.appLocalizations.playTime),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    style: TextStyle(color: Colors.white),
                                    formatMinutesToHMS(
                                        appState.selectedGame!.game.playTime)),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(
                          26, 0, 26, 0), // Agrega el padding deseado
                      child: const Divider()),
                ])))
      ])))
    ]);
  }

  void _showImageDialog(BuildContext context, ImageProvider imageProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageDialog(imageProvider: imageProvider);
      },
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
  }

  IconData updateFavIcon(int? value) {
    IconData ic = Icons.star;
    if (value == 1) {
      return Icons.star;
    } else {
      return Icons.star_border_outlined;
    }
  }

  @override
  void didUpdateWidget(GameInfoPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateFavIcon(Provider.of<AppState>(context).selectedGame?.game.favorite);
    _controller
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    //_controller.dispose();
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
            appState.updateSelectedGame(null);
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


class ToggleFavoriteButton extends StatefulWidget {
  @override
  _ToggleFavoriteButtonState createState() => _ToggleFavoriteButtonState();
}

class _ToggleFavoriteButtonState extends State<ToggleFavoriteButton> {
  bool isFavorite = false;

  void toggleIcon() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    isFavorite = appState.selectedGame?.game.favorite == 1;
    return IconButtonHoverColored(
      icon: isFavorite ? Icons.star : Icons.star_border_outlined,
      onPressed: () {
        databaseFunctions.favoriteGameById(appState.selectedGame?.game);
        bool b = convertIntBool(appState.selectedGame?.game.favorite);
        b = !b;
        int v = convertBoolInt(b);
        appState.selectedGame?.game.favorite = v;
        setState(() {
          isFavorite = !isFavorite; // Cambia el valor del estado
        });
      },
      iconColor: Colors.yellow,
      backColor: Colors.grey,
    );
  }
}

class ToggleGameCover extends StatefulWidget {
  const ToggleGameCover({super.key});

  @override
  State<ToggleGameCover> createState() => _ToggleGameCoverState();
}

class _ToggleGameCoverState extends State<ToggleGameCover> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

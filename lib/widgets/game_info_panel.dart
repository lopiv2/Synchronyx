import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:synchronyx/models/responses/gameMedia_response.dart';
import 'package:synchronyx/utilities/Constants.dart';
import 'package:synchronyx/utilities/audio_singleton.dart';
import 'package:synchronyx/utilities/generic_functions.dart';
import 'package:synchronyx/widgets/animation_container_logo.dart';
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
  final AudioManager audioManager = AudioManager();
  late String url = "";
  late AnimationController _controller =
      AnimationController(vsync: AnimatedListState());
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Consumer<AppState>(
      builder: (context, appState, child) {
        final selectedGame = appState.selectedGame;
        isFavorite = appState.selectedGame?.game.favorite == 1;

        return FutureBuilder<Widget>(
          future: _buildGameInfoPanel(context, appState, selectedGame),
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

  Future<Widget> _buildGameInfoPanel(BuildContext context, AppState appState,
      GameMediaResponse? selectedGame) async {
    bool isHovered = false;
    ScrollController _scrollController = ScrollController();
    audioManager.stop();
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
    String folder = '\\Synchronyx\\media\\screenshots\\$id\\';
    await Constants.initialize();
    String screenFolder = '${Constants.appDocumentsDirectory.path}$folder';
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
    if (appState.selectedOptions.playOSTOnSelectGame == 1) {
      playOst(appState);
    }
    Widget logoAnimationSelectedBuilder=Text('');
      logoAnimationSelectedBuilder =
          Constants.animationWidgets[appState.optionsResponse.logoAnimation]!(_controller);

    /*Widget Function(Duration p1, AnimationController p2)?
        logoAnimationSelectedBuilder =
        Constants.animationWidgets[appState.optionsResponse.logoAnimation];*/

    return Column(children: [
      Expanded(
          child: SingleChildScrollView(
              child: Column(children: [
        Container(
            // ignore: use_build_context_synchronously
            height: MediaQuery.of(context).size.height * 0.3,
            color: Colors.white,
            child: appState.selectedGame?.media.videoUrl != ""
                ? const Text("Video holder")
                : Stack(
                    children: <Widget>[
                      // ignore: unrelated_type_equality_checks
                      imageWidgetMarquee != ""
                          ? Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageWidgetMarquee,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : const Text(""),
                      // ignore: unrelated_type_equality_checks
                      logoWidgetMarquee != ""
                          ? Positioned(
                              // ignore: use_build_context_synchronously
                              right: MediaQuery.of(context).size.width * 0.06,
                              bottom: -80,
                              child: logoAnimationSelectedBuilder,
                            )
                          : const Text(""),
                      // ignore: unrelated_type_equality_checks
                      platformStoreIcon != ""
                          ? Positioned(
                              right: 20.01,
                              // ignore: use_build_context_synchronously
                              bottom: MediaQuery.of(context).size.height * 0.25,
                              child: Icon(
                                platformStoreIcon.icon,
                                color: Colors.white,
                                // ignore: use_build_context_synchronously
                                size: MediaQuery.of(context).size.width * 0.02,
                              ))
                          : const Text(""),
                      ToggleMusicIcon(
                        appLocalizations: widget.appLocalizations,
                        audioManager: audioManager,
                      ),
                      appState.selectedGame?.media.musicUrl != ''
                          ? PlayPauseSong(
                              appLocalizations: widget.appLocalizations,
                              audioManager: audioManager,
                              playOst: () => playOst(appState))
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
            ToggleGameCover(),
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
        const SizedBox(height: 20),
        /* ------------------------------- Screenshots ------------------------------ */
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
        /* ------------------------------ Launch button ----------------------------- */
        if (appState.selectedGame!.game.owned == 1)
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
                      color: Color.fromARGB(153, 12, 77, 12),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(2, 2), // changes position of shadow
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
                                    title: widget.appLocalizations.clickToOpen,
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
                                    collapsedIcon: const Icon(Icons.add),
                                    expandedIcon: const Icon(Icons.minimize)),
                              ],
                            ),
                          ),
                        ],
                      )),
                  const Padding(
                      padding: EdgeInsets.fromLTRB(26, 0, 26, 0),
                      child: Divider()),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    widget.appLocalizations.publisher),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GFAccordion(
                                    title: widget.appLocalizations.clickToOpen,
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(10, 2, 0, 0),
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
                  const Padding(
                      padding: EdgeInsets.fromLTRB(
                          26, 0, 26, 0), // Agrega el padding deseado
                      child: Divider()),
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    widget.appLocalizations.playTime),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    style: const TextStyle(color: Colors.white),
                                    formatMinutesToHMS(
                                        appState.selectedGame!.game.playTime)),
                              ],
                            ),
                          ),
                        ],
                      )),
                  const Padding(
                      padding: EdgeInsets.fromLTRB(
                          26, 0, 26, 0), // Agrega el padding deseado
                      child: Divider()),
                ]))),
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(46, 12, 77, 12),
                  borderRadius: BorderRadius.circular(20),
                  //border: Border.all(),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(153, 12, 77, 12),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(2, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.normal,
                          shadows: [
                            Shadow(
                              offset: const Offset(
                                  1.5, 1.5), // X and Y shadow displacement
                              blurRadius: 0.1, // Shadow blurring radius
                              color: Colors.black.withOpacity(
                                  0.8), // Shadow color with opacity
                            )
                          ],
                        ),
                        widget.appLocalizations.description),
                    Container(
                      color: const Color.fromARGB(0, 0, 0, 0),
                      // ignore: use_build_context_synchronously
                      width: MediaQuery.of(context).size.width * 0.25,
                      // ignore: use_build_context_synchronously
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: RawScrollbar(
                        thumbColor: const Color.fromARGB(92, 158, 158, 158),
                        trackVisibility: true,
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          child: Html(
                            data: appState.selectedGame!.game.description,
                            style: {
                              "body": Style(
                                fontSize: FontSize(14),
                                color: Colors.white,
                              ),
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                )))
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

  Future<void> playOst(AppState appState) async {
    List<String>? parts = appState.selectedGame?.media.musicUrl.split('_');
    String id = parts!.first;
    String soundFolder = '\\Synchronyx\\media\\audio\\$id\\';
    audioManager.audioPlayer.setReleaseMode(ReleaseMode.loop);
    if (appState.selectedGame?.media.musicUrl != '') {
      await audioManager.playFile(
          '${Constants.appDocumentsDirectory.path}$soundFolder${appState.selectedGame?.media.musicUrl}');
    }
  }

  void reload() {
    //controller?.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  IconData updateFavIcon(int? value) {
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
    /*_controller
      ..reset()
      ..forward();*/
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

class PlayPauseSong extends StatelessWidget {
  final AudioManager audioManager;
  final AppLocalizations appLocalizations;
  final AsyncCallback playOst;
  const PlayPauseSong(
      {super.key,
      required this.appLocalizations,
      required this.audioManager,
      required this.playOst});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return ValueListenableBuilder<bool>(
        valueListenable: audioManager.isPlayingNotifier,
        builder: (context, isPlaying, child) {
          return ValueListenableBuilder<String>(
              valueListenable: audioManager.currentUrlNotifier,
              builder: (context, url, child) {
                return Positioned(
                  left: 40.01,
                  bottom: MediaQuery.of(context).size.height * 0.24,
                  child: Tooltip(
                      message: appLocalizations.ostDownloadedClick,
                      child: InkWell(
                        onTap: () {
                          isPlaying
                              ? {
                                  audioManager.currentUrlNotifier.value =
                                      appState.selectedGame?.media.musicUrl ??
                                          '',
                                  audioManager.pause(),
                                  audioManager.isPlayingNotifier.value = false
                                }
                              : {
                                  if (url !=
                                      appState.selectedGame?.media.musicUrl)
                                    {
                                      playOst(),
                                      audioManager.isPlayingNotifier.value =
                                          true
                                    }
                                  else
                                    {
                                      audioManager.resume(),
                                      audioManager.isPlayingNotifier.value =
                                          true
                                    }
                                };
                        },
                        child: Container(
                          padding: const EdgeInsets.all(
                              8.0), // Espacio de relleno alrededor del icono
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(
                                0, 33, 149, 243), // Color de fondo del botón
                          ),
                          child: isPlaying
                              ? Icon(
                                  Icons.volume_up,
                                  color: Colors.white,
                                  size:
                                      MediaQuery.of(context).size.width * 0.02,
                                )
                              : Icon(
                                  Icons.volume_off,
                                  color: Colors.white,
                                  size:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                        ),
                      )),
                );
              });
        });
  }
}

class ToggleMusicIcon extends StatelessWidget {
  final AppLocalizations appLocalizations;
  final AudioManager audioManager;
  const ToggleMusicIcon(
      {super.key, required this.appLocalizations, required this.audioManager});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return appState.selectedGame!.media.musicUrl != ""
        ? Positioned(
            left: 10.01,
            bottom: MediaQuery.of(context).size.height * 0.24,
            child: Tooltip(
                message: appLocalizations.ostDownloadedClick,
                child: InkWell(
                  onTap: () {
                    audioManager.stop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return OstDownloadDialog(
                          appLocalizations: appLocalizations,
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(
                        8.0), // Espacio de relleno alrededor del icono
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(
                          0, 33, 149, 243), // Color de fondo del botón
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width * 0.02,
                    ),
                  ),
                )),
          )
        : Positioned(
            left: 10.01,
            bottom: MediaQuery.of(context).size.height * 0.24,
            child: Tooltip(
                message: appLocalizations.ostDownloadClick,
                child: InkWell(
                  onTap: () {
                    audioManager.stop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return OstDownloadDialog(
                          appLocalizations: appLocalizations,
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(
                        8.0), // Espacio de relleno alrededor del icono
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(
                          0, 33, 149, 243), // Color de fondo del botón
                    ),
                    child: Icon(
                      Icons.music_off,
                      color: Colors.red,
                      size: MediaQuery.of(context).size.width * 0.02,
                    ),
                  ),
                )),
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
    return AlertDialog(
      title: Text(widget.appLocalizations.confirmDelete),
      content: Text(
          widget.appLocalizations.sureDelete(widget.selectedGame.game.title)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(widget.appLocalizations.cancel),
        ),
        TextButton(
          onPressed: () {
            widget.onConfirm(widget
                .selectedGame); // Switches the selected set to the confirmation function
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red),
              widget.appLocalizations.delete),
        ),
      ],
    );
  }
}

class ToggleFavoriteButton extends StatefulWidget {
  const ToggleFavoriteButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
    return IconButtonHoverColored(
      onPressed: () {
        final appState = Provider.of<AppState>(context, listen: false);
        appState.toggleAnimations();
      },
      icon: Icons.threesixty,
      iconColor: Colors.white,
    );
  }
}

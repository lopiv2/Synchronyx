import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:lioncade/icons/custom_icons_icons.dart';
import 'package:lioncade/models/event.dart';
import 'package:lioncade/models/game.dart';
import 'package:lioncade/models/media.dart';
import 'package:lioncade/models/responses/rawg_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lioncade/providers/app_state.dart';
import 'package:lioncade/utilities/Constants.dart';
import 'package:lioncade/utilities/app_directory_singleton.dart';
import 'package:lioncade/utilities/generic_database_functions.dart'
    // ignore: library_prefixes
    as databaseFunctions;
import 'package:lioncade/utilities/generic_api_functions.dart';
import 'package:lioncade/utilities/generic_functions.dart';
import 'package:lioncade/widgets/cheap_shark_results_list.dart';

// ignore: must_be_immutable
class ClickedGameBuyableView extends StatelessWidget {
  RawgResponse game;

  ClickedGameBuyableView({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    DateTime dateReleased = DateTime.now();
    if (game.releaseDate != null) {
      dateReleased = DateTime.parse(game.releaseDate ?? '');
    }
    ScrollController scrollController = ScrollController();
    return Consumer<AppState>(builder: (context, appState, child) {
      return Column(children: [
        /* ----------------------------- Background Image ---------------------------- */
        Expanded(
          child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    game.imageUrl ?? '',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  GFIconButton(
                    onPressed: (() => {
                          appState.enableGameSearchViewPanel(false),
                          //appState.gameClicked = null,
                        }),
                    hoverColor: Colors.blueGrey,
                    icon: const Icon(
                        color: Colors.amber, CustomIcons.arrow_back_outline),
                  ),
                  /* ------------------------ Degraded shadow with data ----------------------- */
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.53,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.75),
                            spreadRadius: 2,
                            blurRadius: 20,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.487,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.17),
                          /* --------------------------- List of game Deals --------------------------- */
                          CheapSharkResultsList(
                            title: game.name ?? '',
                          ),
                        ],
                      ),
                    ),
                  ),
                  /* ---------------------------- Small game cover ---------------------------- */
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.07,
                    top: MediaQuery.of(context).size.height * 0.43,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.8), // Shadow color and opacity
                            spreadRadius: 2, // Shadow expansion radius
                            blurRadius: 2, // Shadow blurring radius
                            offset: const Offset(
                                2, 2), // Desplazamiento en X e Y de la sombra
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width * 0.11,
                      height: MediaQuery.of(context).size.height * 0.26,
                      child: CachedNetworkImage(
                        imageUrl: game.imageUrl ?? '',
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/icons/noimage.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  /* ---------------------------- Title of the game --------------------------- */
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.235,
                    top: MediaQuery.of(context).size.height * 0.42,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.235,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeIn(
                            animate: true,
                            duration: const Duration(seconds: 2),
                            child: Text(
                              game.name ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(3.0,
                                        3.0), // X and Y shadow displacement
                                    blurRadius: 1.0, // Shadow blurring radius
                                    color: Colors.black.withOpacity(
                                        0.8), // Shadow color with opacity
                                  ),
                                ],
                              ),
                              maxLines: 2, // Sets the maximum number of lines
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 3, 2, 3),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(1.5,
                                                1.5), // X and Y shadow displacement
                                            blurRadius:
                                                0.1, // Shadow blurring radius
                                            color: Colors.black.withOpacity(
                                                0.8), // Shadow color with opacity
                                          )
                                        ],
                                      ),
                                      'Release Date'),
                                  Text(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(1.5,
                                                1.5), // X and Y shadow displacement
                                            blurRadius:
                                                0.1, // Shadow blurring radius
                                            color: Colors.black.withOpacity(
                                                0.8), // Shadow color with opacity
                                          )
                                        ],
                                      ),
                                      'Platform')
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 2, 3),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(1.5,
                                                1.5), // X and Y shadow displacement
                                            blurRadius:
                                                0.1, // Shadow blurring radius
                                            color: Colors.black.withOpacity(
                                                0.8), // Shadow color with opacity
                                          )
                                        ],
                                      ),
                                      game.releaseDate ?? ''),
                                  Text(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(1.5,
                                                1.5), // X and Y shadow displacement
                                            blurRadius:
                                                0.1, // Shadow blurring radius
                                            color: Colors.black.withOpacity(
                                                0.8), // Shadow color with opacity
                                          )
                                        ],
                                      ),
                                      game.platform ?? '')
                                ]),
                          ),

                          /* ------------------------------- Description ------------------------------ */
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 2, 8),
                            child: Row(
                              children: [
                                const ToggleFavoriteOwnedButton(),
                                AddLaunchEventButton(
                                  releasedDate: dateReleased,
                                  game: game,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: const Color.fromARGB(0, 78, 20, 20),
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.height * 0.096,
                            child: RawScrollbar(
                              thumbColor:
                                  const Color.fromARGB(92, 158, 158, 158),
                              trackVisibility: true,
                              controller: scrollController,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: scrollController,
                                child: Html(
                                  data: game.description,
                                  style: {
                                    "body": Style(
                                      fontSize: FontSize(14),
                                      color: Colors.white,
                                    ),
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ]);
    });
  }
}

class AddLaunchEventButton extends StatefulWidget {
  final DateTime releasedDate; // Date of released game
  final RawgResponse game;

  const AddLaunchEventButton({
    Key? key,
    required this.releasedDate,
    required this.game, // Incluye la fecha en el constructor
  }) : super(key: key);

  @override
  State<AddLaunchEventButton> createState() => _AddLaunchEventButtonState();
}

class _AddLaunchEventButtonState extends State<AddLaunchEventButton> {
  @override
  Widget build(BuildContext context) {
    final dio = DioClient();
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final appState = Provider.of<AppState>(context);
    Media? mediaInfo;
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 2, 8),
        child: GFButton(
          onPressed: () async {
            String? finalLogoFolder;
            try {
              finalLogoFolder = await dio.processMediaFiles(
                  widget.game.marqueeUrl ?? '',
                  "event",
                  widget.game.name ?? '',
                  mediaInfo);
            } catch (e) {
              // Handles any errors that may occur when processing the file.
              print('Error processing the file: $e');
            }
            Event ev;
            if (finalLogoFolder != null) {
              ev = Event(
                  name: appLocalizations.launchEvent(widget.game.name ?? ''),
                  game: widget.game.name ?? '',
                  image: finalLogoFolder,
                  dismissed: 0,
                  releaseDate: DateTime.parse(widget.game.releaseDate ?? ''));
              final event = CalendarEventData(
                date: ev.releaseDate,
                title: ev.name,
              );
              appState.addEvent(event);
              databaseFunctions.insertEvent(ev);
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(appLocalizations.alertCreated),
                    backgroundColor: Colors.lightGreen,
                    content: Text(appLocalizations.alertCreatedCalendar),
                    actions: <Widget>[
                      TextButton(
                        child: Text(appLocalizations.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              // Maneja el caso en el que finalLogoFolder es nulo o no se pudo obtener.
              print('Could not obtain finalLogoFolder.');
            }
          },
          color: GFColors.ALT,
          hoverColor: Colors.blueGrey,
          text: appLocalizations.createAlert,
          icon: const Icon(
            color: Colors.amber,
            Icons.calendar_month,
          ),
        ));
  }
}

class ToggleFavoriteOwnedButton extends StatefulWidget {
  const ToggleFavoriteOwnedButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ToggleFavoriteOwnedButtonState createState() =>
      _ToggleFavoriteOwnedButtonState();
}

class _ToggleFavoriteOwnedButtonState extends State<ToggleFavoriteOwnedButton> {
  bool isOwned = false;

  void toggleIcon() {
    setState(() {
      isOwned = !isOwned;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final dio = DioClient();
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    return FutureBuilder<Game?>(
        future:
            databaseFunctions.getGameByTitle(appState.gameClicked.name ?? ''),
        builder: (context, snapshot) {
          if (snapshot.data?.owned == 1) {
            isOwned = true;
          }
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 2, 8),
            child: GFButton(
              onPressed: isOwned
                  ? null
                  : () {
                      if (!isOwned) {
                        dio.addBuyableGameToList(appState.gameClicked);
                        appState.updateSelectedGame(null);
                        appState.refreshGridView();
                        appState.enableGameSearchViewPanel(false);
                      }
                    },
              color: isOwned
                  ? hexToColor(appState.themeApplied.backgroundStartColor)
                  : GFColors.DANGER,
              hoverColor: Colors.blueGrey,
              text: !isOwned
                  ? appLocalizations.addToFavorite
                  : appLocalizations.ownedGame,
              icon: Icon(
                  color: Colors.amber,
                  isOwned ? Icons.star : Icons.star_border_outlined),
            ),
          );
        });
  }
}

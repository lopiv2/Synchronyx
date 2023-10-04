import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/icons/custom_icons_icons.dart';
import 'package:synchronyx/models/game.dart';
import 'package:synchronyx/models/responses/rawg_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:synchronyx/providers/app_state.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart'
    // ignore: library_prefixes
    as databaseFunctions;
import 'package:synchronyx/utilities/generic_api_functions.dart';
import 'package:synchronyx/widgets/cheap_shark_results_list.dart';

// ignore: must_be_immutable
class ClickedGameBuyableView extends StatelessWidget {
  RawgResponse game;

  ClickedGameBuyableView({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Column(children: [
      Expanded(
          child: SingleChildScrollView(
              child: Column(children: [
        Stack(
          children: [
            /* ----------------------------- Background Image ---------------------------- */
            Container(
              width: MediaQuery.of(context)
                  .size
                  .width, // Ancho igual al ancho de la pantalla
              height: MediaQuery.of(context).size.height *
                  1, // Alto igual al alto de la pantalla
              child: CachedNetworkImage(
                imageUrl: game.imageUrl ?? '',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/icons/noimage.png'),
                fit: BoxFit
                    .fill, // Ajusta la imagen para cubrir todo el contenedor
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* ---------------------------- Arrow back button --------------------------- */
                GFIconButton(
                  onPressed: () {},
                  hoverColor: Colors.blueGrey,
                  icon:
                      Icon(color: Colors.amber, CustomIcons.arrow_back_outline),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.47,
                ),
                /* ------------------------ Degraded shadow with data ----------------------- */
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width *
                      1, // Width equal to screen width
                  height: MediaQuery.of(context).size.height *
                      0.477, // Height equal to screen height
                  child: Column(
                    children: [
                      SizedBox(height:180),
                      /* --------------------------- List of game Deals --------------------------- */
                      CheapSharkResultsList(
                    title: game.name ?? '',
                  ),
                    ],
                  ),
                ),
              ],
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
                      offset:
                          Offset(2, 2), // Desplazamiento en X e Y de la sombra
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width *
                    0.13, // Ancho igual al ancho de la pantalla
                height: MediaQuery.of(context).size.height *
                    0.3, // Alto igual al alto de la pantalla
                child: CachedNetworkImage(
                  imageUrl: game.imageUrl ?? '',
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/icons/noimage.png'),
                  fit: BoxFit
                      .fill, // Ajusta la imagen para cubrir todo el contenedor
                ),
              ),
            ),

            /* ---------------------------- Title of the game --------------------------- */
            Positioned(
              left: MediaQuery.of(context).size.width * 0.235,
              top: MediaQuery.of(context).size.height * 0.42,
              child: Container(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeIn(
                      animate: true,
                      duration: Duration(seconds: 2),
                      child: Text(
                        game.name ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(
                                  3.0, 3.0), // X and Y shadow displacement
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
                      padding: EdgeInsets.fromLTRB(4, 3, 2, 3),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1.5,
                                          1.5), // X and Y shadow displacement
                                      blurRadius: 0.1, // Shadow blurring radius
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
                                      offset: Offset(1.5,
                                          1.5), // X and Y shadow displacement
                                      blurRadius: 0.1, // Shadow blurring radius
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      blurRadius: 0.1, // Shadow blurring radius
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
                                      offset: Offset(1.5,
                                          1.5), // X and Y shadow displacement
                                      blurRadius: 0.1, // Shadow blurring radius
                                      color: Colors.black.withOpacity(
                                          0.8), // Shadow color with opacity
                                    )
                                  ],
                                ),
                                game.platform ?? '')
                          ]),
                    ),

                    /* ------------------------------- Description ------------------------------ */
                    const Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 2, 8),
                      child: ToggleFavoriteOwnedButton(),
                    ),
                    Container(
                      color: Color.fromARGB(0, 0, 0, 0),
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.126,
                      child: RawScrollbar(
                        thumbColor: const Color.fromARGB(92, 158, 158, 158),
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
        ),
      ])))
    ]);
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
              color:
                  isOwned ? Color.fromARGB(255, 36, 100, 62) : GFColors.DANGER,
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

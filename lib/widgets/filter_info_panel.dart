import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/models/gameMedia_response.dart';
import 'package:synchronyx/widgets/buttons/icon_button_colored.dart';
import '../providers/app_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart'
    as databaseFunctions;

class FilterInfoPanel extends StatefulWidget {
  const FilterInfoPanel({super.key, required this.appLocalizations});
  final AppLocalizations appLocalizations;

  @override
  State<FilterInfoPanel> createState() => _GameInfoPanelState();
}

class _GameInfoPanelState extends State<FilterInfoPanel> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final selectedGame = appState.selectedGame;
        isFavorite = appState.selectedGame?.game.favorite == 1;
        return _buildGameInfoPanel(appState, selectedGame);
      },
    );
  }

  Widget _buildGameInfoPanel(
      AppState appState, GameMediaResponse? selectedGame) {
    //final isAnimationActive = animationState.isAnimationActive;
    playOst();

    return Column(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.3,
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/backgrounds/info.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: MediaQuery.of(context).size.width * 0.11,
                  bottom: MediaQuery.of(context).size.height * 0.13,
                  child: FadeIn(
                      animate: true,
                      duration: Duration(seconds: 2),
                      child: Text(
                        'Logo',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            )),
        Row(
          children: [
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      16, 16, 16, 0), // Márgenes izquierdo y derecho
                  child: Text('Tiempo Jugado',
                      style: const TextStyle(color: Colors.grey, fontSize: 16)),
                )),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      16, 16, 16, 0), // Márgenes izquierdo y derecho
                  child: Text('0h 00m 00s',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16)),
                ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              16, 16, 16, 0), // Márgenes izquierdo y derecho
          child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Color.fromARGB(46, 12, 77, 12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(181, 12, 77, 12),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
              )),
        )
      ],
    );
  }

  Future<void> playOst() async {
    //await player.play(AssetSource('music/theme.mp3'));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

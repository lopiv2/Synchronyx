import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/providers/app_state.dart';

class GameVisualOptions extends StatefulWidget {
  final AppLocalizations appLocalizations;
  const GameVisualOptions({super.key, required this.appLocalizations});

  @override
  State<GameVisualOptions> createState() => _GameVisualOptionsState();
}

class _GameVisualOptionsState extends State<GameVisualOptions> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Juegos",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ]),
      Container(
        height: 200,
        color: const Color.fromARGB(3, 244, 67, 54),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Selector<AppState, int>(
              selector: (_, provider) =>
                  provider.optionsResponse.twoDThreeDCovers,
              builder: (context, twoDThreeDCovers, child) {
                return ToggleSwitch(
                    databaseValue: twoDThreeDCovers,
                    text: widget.appLocalizations.options3dViewGames,
                    initialValue: '2d',
                    toggleValue: '3d',
                    onChanged: (value) {
                      if (value == true) {
                        twoDThreeDCovers = 1;
                      } else {
                        twoDThreeDCovers = 0;
                      }
                      appState.optionsResponse.twoDThreeDCovers =
                          twoDThreeDCovers;
                    });
              },
            ),
            Selector<AppState, int>(
              selector: (_, provider) =>
                  provider.optionsResponse.playOSTOnSelectGame,
              builder: (context, playOSTOnSelectGame, child) {
                return ToggleSwitch(
                    databaseValue: playOSTOnSelectGame,
                    text: widget.appLocalizations.optionsPlayOstSelectGame,
                    initialValue: widget.appLocalizations.no,
                    toggleValue: widget.appLocalizations.yes,
                    onChanged: (value) {
                      if (value == true) {
                        playOSTOnSelectGame = 1;
                      } else {
                        playOSTOnSelectGame = 0;
                      }
                      appState.optionsResponse.playOSTOnSelectGame =
                          playOSTOnSelectGame;
                    });
              },
            ),
            Selector<AppState, int>(
              selector: (_, provider) =>
                  provider.optionsResponse.showLogoNameOnGrid,
              builder: (context, showLogoNameOnGrid, child) {
                return ToggleSwitch(
                    databaseValue: showLogoNameOnGrid,
                    text: widget.appLocalizations.optionsShowLogoOnGrid,
                    initialValue: widget.appLocalizations.no,
                    toggleValue: widget.appLocalizations.yes,
                    onChanged: (value) {
                      if (value == true) {
                        showLogoNameOnGrid = 1;
                      } else {
                        showLogoNameOnGrid = 0;
                      }
                      appState.optionsResponse.showLogoNameOnGrid =
                          showLogoNameOnGrid;
                    });
              },
            ),
            Selector<AppState, int>(
              selector: (_, provider) =>
                  provider.optionsResponse.showEditorOnGrid,
              builder: (context, showEditorOnGrid, child) {
                return ToggleSwitch(
                    databaseValue: showEditorOnGrid,
                    text: widget.appLocalizations.optionsShowEditorOnGrid,
                    initialValue: widget.appLocalizations.no,
                    toggleValue: widget.appLocalizations.yes,
                    onChanged: (value) {
                      if (value == true) {
                        showEditorOnGrid = 1;
                      } else {
                        showEditorOnGrid = 0;
                      }
                      appState.optionsResponse.showEditorOnGrid =
                          showEditorOnGrid;
                    });
              },
            ),
          ],
        ),
      ),
    ]);
  }
}

class ToggleSwitch extends StatefulWidget {
  final int databaseValue; //Value from database
  final String text;
  final String initialValue;
  final String toggleValue;
  final ValueChanged<bool> onChanged;
  const ToggleSwitch({
    super.key,
    required this.text,
    required this.initialValue,
    required this.onChanged,
    required this.databaseValue,
    required this.toggleValue,
  });

  @override
  _Toggle2d3dState createState() => _Toggle2d3dState();
}

class _Toggle2d3dState extends State<ToggleSwitch> {
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    isSwitched = widget.databaseValue == 1 ? true : false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
              widget.onChanged(value);
            });
          },
        ),
        SizedBox(height: 20),
        Text(
          '${widget.text}: - ${isSwitched ? widget.toggleValue : widget.initialValue}',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

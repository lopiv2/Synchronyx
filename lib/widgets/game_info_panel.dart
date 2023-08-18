import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/models/game.dart';

import '../providers/app_state.dart';

class GameInfoPanel extends StatefulWidget {
  const GameInfoPanel({super.key});

  @override
  State<GameInfoPanel> createState() => _GameInfoPanelState();
}

class _GameInfoPanelState extends State<GameInfoPanel> {
  late String url = "";

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    if (appState.selectedGame?.media.videoUrl != null) {
      url = appState.selectedGame!.media.videoUrl;
      ImageProvider<Object> imageWidgetMarquee;
      imageWidgetMarquee =
          FileImage(File(appState.selectedGame!.media.marqueeUrl));
      return Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.3,
              color: Colors.white,
              child: appState.selectedGame?.media.videoUrl != ""
                  ? Text("Video holder")
                  : Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageWidgetMarquee,
                        ),
                      ),
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
              IconButton(
                onPressed: () {
                  print('Botón 3');
                },
                icon: Icon(Icons.star),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  print('Botón 4');
                },
                icon: Icon(Icons.play_arrow),
                color: Colors.white,
              ),
            ],
          ),
        ],
      );
    } else {
      return Text("nada");
    }
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
}

import 'package:flutter/material.dart';
import 'package:synchronyx/models/game.dart';
import 'package:video_player/video_player.dart';

class GameInfoPanel extends StatefulWidget {
  const GameInfoPanel({super.key});

  @override
  State<GameInfoPanel> createState() => _GameInfoPanelState();
}

class _GameInfoPanelState extends State<GameInfoPanel> {
  @override
  Widget build(BuildContext context) {
    late VideoPlayerController _controller;
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.black,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                print('Botón 1');
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
  }
}

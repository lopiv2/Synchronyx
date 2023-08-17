import 'package:flutter/material.dart';
import 'package:synchronyx/models/gameMedia_response.dart';

class AppState extends ChangeNotifier {
  GameMediaResponse? selectedGame;

  void updateSelectedGame(GameMediaResponse game) {
    selectedGame = game;
    notifyListeners();
  }
}

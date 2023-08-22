import 'package:flutter/material.dart';
import 'package:synchronyx/models/game.dart';
import 'package:synchronyx/models/gameMedia_response.dart';

class AppState extends ChangeNotifier {
  GameMediaResponse? selectedGame;
  List<GameMediaResponse> gamesInGrid = [];
  bool shouldRefreshGridView = false;
  bool _isImporting = false;
  bool get isImporting => _isImporting;

  void startImporting() {
    _isImporting = true;
    notifyListeners();
  }

  void stopImporting() {
    _isImporting = false;
    notifyListeners();
  }

  void updateSelectedGame(GameMediaResponse game) {
    selectedGame = game;
    notifyListeners();
  }

  void refreshGridView() {
    shouldRefreshGridView = !shouldRefreshGridView;
    notifyListeners();
  }

  void updateGamesInGrid() {
    notifyListeners();
  }
}

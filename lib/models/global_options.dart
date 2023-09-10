class GlobalOptions {
  int? id;
  late int twoDThreeDCovers;
  late int playOSTOnSelectGame;
  late int showLogoNameOnGrid;
  late int showEditorOnGrid;

  GlobalOptions({
    this.id,
    required this.twoDThreeDCovers,
    required this.playOSTOnSelectGame,
    required this.showLogoNameOnGrid,
    required this.showEditorOnGrid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'twoDThreeDCovers': twoDThreeDCovers,
      'playOSTOnSelectGame': playOSTOnSelectGame,
      'showLogoNameOnGrid': showLogoNameOnGrid,
      'showEditorOnGrid': showEditorOnGrid,
    };
  }

  // Copy Builder
  GlobalOptions.copy(GlobalOptions other) {
    id = other.id;
    twoDThreeDCovers = other.twoDThreeDCovers;
    playOSTOnSelectGame = other.playOSTOnSelectGame;
    showLogoNameOnGrid = other.showLogoNameOnGrid;
    showEditorOnGrid = other.showEditorOnGrid;
  }

  @override
  String toString() {
    return 'Options{id: $id, twoDThreeDCovers: $twoDThreeDCovers,playOSTOnSelectGame: $playOSTOnSelectGame, showLogoNameOnGrid: $showLogoNameOnGrid, showEditorOnGrid: $showEditorOnGrid}';
  }

  static GlobalOptions fromMap(Map<String, dynamic> map) {
    return GlobalOptions(
      id: map['id'] ?? '',
      twoDThreeDCovers: map['twoDThreeDCovers'] ?? '1',
      playOSTOnSelectGame: map['playOSTOnSelectGame'] ?? '1',
      showLogoNameOnGrid: map['showLogoNameOnGrid'] ?? '1',
      showEditorOnGrid: map['showEditorOnGrid'] ?? '1',
    );
  }
}

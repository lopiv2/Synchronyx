class GlobalOptions {
  int? id;
  late int twoDThreeDCovers;
  late int playOSTOnSelectGame;
  late int showLogoNameOnGrid;
  late int showEditorOnGrid;
  late String logoAnimation;

  GlobalOptions({
    this.id,
    required this.twoDThreeDCovers,
    required this.playOSTOnSelectGame,
    required this.showLogoNameOnGrid,
    required this.showEditorOnGrid,
    required this.logoAnimation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'twoDThreeDCovers': twoDThreeDCovers,
      'playOSTOnSelectGame': playOSTOnSelectGame,
      'showLogoNameOnGrid': showLogoNameOnGrid,
      'showEditorOnGrid': showEditorOnGrid,
      'logoAnimation': logoAnimation,
    };
  }

  // Copy Builder
  GlobalOptions.copy(GlobalOptions other) {
    id = other.id;
    twoDThreeDCovers = other.twoDThreeDCovers;
    playOSTOnSelectGame = other.playOSTOnSelectGame;
    showLogoNameOnGrid = other.showLogoNameOnGrid;
    showEditorOnGrid = other.showEditorOnGrid;
    logoAnimation = other.logoAnimation;
  }

  @override
  String toString() {
    return 'Options{id: $id, twoDThreeDCovers: $twoDThreeDCovers,playOSTOnSelectGame: $playOSTOnSelectGame, showLogoNameOnGrid: $showLogoNameOnGrid, showEditorOnGrid: $showEditorOnGrid. logoAnimation: $logoAnimation}';
  }

  static GlobalOptions fromMap(Map<String, dynamic> map) {
    return GlobalOptions(
      id: map['id'] ?? '',
      twoDThreeDCovers: map['twoDThreeDCovers'] ?? '1',
      playOSTOnSelectGame: map['playOSTOnSelectGame'] ?? '1',
      showLogoNameOnGrid: map['showLogoNameOnGrid'] ?? '1',
      showEditorOnGrid: map['showEditorOnGrid'] ?? '1',
      logoAnimation: map['logoAnimation'] ?? 'FadeInDown',
    );
  }
}

import 'package:lioncade/models/media.dart';

import '../game.dart';

class GameMediaResponse {
  Game game;
  Media media;

  GameMediaResponse({
    required this.game,
    required this.media,
  });

  Map<String, dynamic> toMap() {
    return {
      'game': game.toMap(),
      'media': media.toMap(),
    };
  }

  @override
  String toString() {
    return 'GameMediaResponse{game: $game,media: $media}';
  }

  factory GameMediaResponse.fromGameAndMedia(Game game, Media media) {
    return GameMediaResponse(
      game: game,
      // Otros campos de GameMediaResponse
      media: media,
    );
  }

  static GameMediaResponse fromMap(Map<String, dynamic> map) {
    return GameMediaResponse(
      game: Game.fromMap(map['game']),
      media: Media.fromMap(map['media']),
    );
  }
}

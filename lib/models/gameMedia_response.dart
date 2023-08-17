import 'package:synchronyx/models/media.dart';

import 'game.dart';

class GameMediaResponse {
  int id;
  String title;
  String description;
  String boxColor;
  String platform;
  String genres; // List of genres joined by commas
  int maxPlayers;
  String developer;
  String publisher;
  String region;
  String file;
  int releaseYear;
  double rating;
  int favorite; // boolean
  int playTime;
  DateTime? lastPlayed = DateTime.now();
  Media media;
  String tags; // List of tags joined by commas also

  GameMediaResponse({
    this.id = 0,
    required this.title,
    this.description = '',
    this.boxColor = '',
    required this.media,
    this.platform = '',
    this.genres = '',
    this.maxPlayers = 1,
    this.developer = '',
    this.publisher = '',
    this.region = '',
    this.file = '',
    this.releaseYear = 0,
    this.rating = 0.0,
    this.favorite = 0,
    this.playTime = 0,
    this.lastPlayed,
    this.tags = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'boxColor': boxColor,
      'media': media.toMap(),
      'platform': platform,
      'genres': genres,
      'maxPlayers': maxPlayers,
      'developer': developer,
      'publisher': publisher,
      'region': region,
      'file': file,
      'releaseYear': releaseYear,
      'rating': rating,
      'favorite': favorite,
      'playTime': playTime,
      'lastPlayed': lastPlayed?.toLocal(),
      'tags': tags,
    };
  }

  @override
  String toString() {
    return 'GameMediaResponse{id: $id, title: $title, description: $description,boxColor: $boxColor, media: $media, platform: $platform, genres: $genres, maxPlayers: $maxPlayers, developer: $developer, publisher: $publisher, region: $region, file: $file, releaseYear: $releaseYear, rating: $rating, favorite: $favorite, playTime: $playTime, lastPlayed: $lastPlayed, tags: $tags}';
  }

  factory GameMediaResponse.fromGameAndMedia(Game game, Media media) {
    return GameMediaResponse(
      id: game.id,
      title: game.title,
      description: game.description,
      boxColor: game.boxColor,
      platform: game.platform,
      genres: game.genres,
      maxPlayers: game.maxPlayers,
      developer: game.developer,
      publisher: game.publisher,
      region: game.region,
      file: game.file,
      releaseYear: game.releaseYear,
      rating: game.rating,
      favorite: game.favorite,
      playTime: game.playTime,
      lastPlayed: game.lastPlayed,
      tags: game.tags,
      // Otros campos de GameMediaResponse
      media: media,
    );
  }

  static GameMediaResponse fromMap(Map<String, dynamic> map) {
    return GameMediaResponse(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      boxColor: map['boxColor'] ?? '',
      media: Media.fromMap(map['media']),
      platform: map['platform'] ?? '',
      genres: map['genres'] ?? '',
      maxPlayers: map['maxPlayers'] ?? 1,
      developer: map['developer'] ?? '',
      publisher: map['publisher'] ?? '',
      region: map['region'] ?? '',
      file: map['file'] ?? '',
      releaseYear: map['releaseYear'] ?? 0,
      rating: map['rating'] ?? 0.0,
      favorite: map['favorite'] ?? 0,
      playTime: map['playTime'] ?? 0,
      lastPlayed: map['lastPlayed'] ?? null,
      tags: map['tags'] ?? '',
    );
  }
}

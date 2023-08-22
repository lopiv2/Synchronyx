import 'package:synchronyx/models/media.dart';

import 'game.dart';

class GameMediaResponse {
  int? id;
  String title;
  String description;
  String boxColor;
  String platform;
  String platformStore;
  String genres; // List of genres joined by commas
  int maxPlayers;
  String developer;
  String publisher;
  String region;
  String file;
  DateTime? releaseDate;
  double rating;
  int favorite; // boolean
  int playTime;
  DateTime? lastPlayed = DateTime.now();
  Media media;
  String tags; // List of tags joined by commas also

  GameMediaResponse({
    this.id,
    required this.title,
    this.description = '',
    this.boxColor = '',
    required this.media,
    this.platform = '',
    this.platformStore = '',
    this.genres = '',
    this.maxPlayers = 1,
    this.developer = '',
    this.publisher = '',
    this.region = '',
    this.file = '',
    this.releaseDate,
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
      'platformStore': platformStore,
      'genres': genres,
      'maxPlayers': maxPlayers,
      'developer': developer,
      'publisher': publisher,
      'region': region,
      'file': file,
      'releaseDate': releaseDate,
      'rating': rating,
      'favorite': favorite,
      'playTime': playTime,
      'lastPlayed': lastPlayed?.toLocal(),
      'tags': tags,
    };
  }

  @override
  String toString() {
    return 'GameMediaResponse{id: $id, title: $title, description: $description,boxColor: $boxColor, media: $media, platform: $platform, platformStore: $platformStore, genres: $genres, maxPlayers: $maxPlayers, developer: $developer, publisher: $publisher, region: $region, file: $file, releaseDate: $releaseDate, rating: $rating, favorite: $favorite, playTime: $playTime, lastPlayed: $lastPlayed, tags: $tags}';
  }

  factory GameMediaResponse.fromGameAndMedia(Game game, Media media) {
    return GameMediaResponse(
      id: game.id,
      title: game.title,
      description: game.description,
      boxColor: game.boxColor,
      platform: game.platform,
      platformStore: game.platformStore,
      genres: game.genres,
      maxPlayers: game.maxPlayers,
      developer: game.developer,
      publisher: game.publisher,
      region: game.region,
      file: game.file,
      releaseDate: game.releaseDate,
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
      platformStore: map['platformStore'] ?? '',
      genres: map['genres'] ?? '',
      maxPlayers: map['maxPlayers'] ?? 1,
      developer: map['developer'] ?? '',
      publisher: map['publisher'] ?? '',
      region: map['region'] ?? '',
      file: map['file'] ?? '',
      releaseDate: map['releaseDate'] ?? 0,
      rating: map['rating'] ?? 0.0,
      favorite: map['favorite'] ?? 0,
      playTime: map['playTime'] ?? 0,
      lastPlayed: map['lastPlayed'],
      tags: map['tags'] ?? '',
    );
  }
}

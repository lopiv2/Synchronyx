class Game {
  int? id;
  String title;
  String description;
  String boxColor;
  int mediaId;
  String platform;
  String platformStore;
  String genres; //List of genres joined by commas
  int maxPlayers;
  String developer;
  String publisher;
  String region;
  String file;
  DateTime? releaseDate = DateTime.now();
  double rating;
  int favorite; //boolean
  int installed; //boolean
  int owned; //boolean
  int playTime;
  DateTime? lastPlayed = DateTime.now();
  String tags; //List of tags joined by commas also

  Game({
    this.id,
    required this.title,
    this.description = '',
    this.boxColor = '',
    this.mediaId = 0,
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
    this.installed = 0,
    this.owned = 0,
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
      'mediaId': mediaId,
      'platform': platform,
      'platformStore': platformStore,
      'genres': genres,
      'maxPlayers': maxPlayers,
      'developer': developer,
      'publisher': publisher,
      'region': region,
      'file': file,
      'releaseDate': releaseDate?.toIso8601String(),
      'rating': rating,
      'favorite': favorite,
      'installed': installed,
      'owned': owned,
      'playTime': playTime,
      'lastPlayed': lastPlayed?.toIso8601String(),
      'tags': tags,
    };
  }

  @override
  String toString() {
    return 'Game{id: $id, title: $title, description: $description,boxColor: $boxColor, mediaId: $mediaId, platform: $platform,platformStore: $platformStore, genres: $genres, maxPlayers: $maxPlayers, developer: $developer, publisher: $publisher, region: $region, file: $file, releaseDate: $releaseDate, rating: $rating, favorite: $favorite,installed: $installed,owned: $owned, playTime: $playTime, lastPlayed: $lastPlayed, tags: $tags}';
  }

  static Game fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      boxColor: map['boxColor'] ?? '',
      mediaId: map['mediaId'] ?? '',
      platform: map['platform'] ?? '',
      platformStore: map['platformStore'] ?? '',
      genres: map['genres'] ?? '',
      maxPlayers: map['maxPlayers'] ?? 1,
      developer: map['developer'] ?? '',
      publisher: map['publisher'] ?? '',
      region: map['region'] ?? '',
      file: map['file'] ?? '',
      releaseDate: map['releaseDate'] != null
          ? DateTime.parse(map['releaseDate'])
          : DateTime.now(),
      rating: (map['rating'] ?? 0.0).toDouble(),
      favorite: map['favorite'] == 1 ? 1 : 0,
      owned: map['owned'] == 1 ? 1 : 0,
      installed: map['installed'] == 1 ? 1 : 0,
      playTime: map['playTime'] ?? 0,
      lastPlayed: map['lastPlayed'] != null
          ? DateTime.parse(map['lastPlayed'])
          : DateTime.now(),
      tags: map['tags'] ?? '',
    );
  }
}

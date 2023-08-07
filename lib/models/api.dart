class Api {
  int id;
  String name;
  String url;
  String apiKey;
  String steamId;

  Api({
    this.id=0,
    required this.name,
    required this.url,
    this.apiKey = '',
    this.steamId = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'apiKey': apiKey,
      'steamId': steamId,
    };
  }

  @override
  String toString() {
    return 'Game{id: $id, name: $name, url: $url,apiKey: $apiKey, steamId: $steamId}';
  }
}

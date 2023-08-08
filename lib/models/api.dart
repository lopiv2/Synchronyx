class Api {
  int id;
  String name;
  String? url;
  String apiKey;
  String steamId;

  Api({
    this.id = 0,
    required this.name,
    this.url,
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

  static Api fromMap(Map<String, dynamic> map) {
    return Api(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      url: map['url'],
      apiKey: map['apiKey'] ?? '',
      steamId: map['steamId'] ?? '',
    );
  }
}

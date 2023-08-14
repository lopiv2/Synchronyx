import 'dart:convert';

class Api {
  int id;
  String name;
  String? url;
  String metadataJson; // Field for storing metadata in JSON format

  Api({
    this.id = 0,
    required this.name,
    this.url,
    this.metadataJson = '', // Empty metadata initialization
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'metadataJson': metadataJson, // Store metadata in JSON format
    };
  }

  @override
  String toString() {
    return 'Api{id: $id, name: $name, url: $url, metadataJson: $metadataJson}';
  }

  static Api fromMap(Map<String, dynamic> map) {
    return Api(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      url: map['url'],
      metadataJson:
          map['metadataJson'] ?? '', // Retrieve metadata in JSON format
    );
  }

  /* -------- Method for establishing metadata from a map -------- */
  void setMetadata(Map<String, dynamic> metadata) {
    metadataJson = json.encode(metadata);
  }

  /* ------------- Method for obtaining the metadata as a map ------------- */
  Map<String, dynamic> getMetadata() {
    return json.decode(metadataJson);
  }
}

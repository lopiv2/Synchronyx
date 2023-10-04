class RawgResponse {
  final String? gameId;
  final String? name;
  final String? imageUrl;
  final String? iconUrl;
  final String? description;
  final String? developer;
  final String? publisher;
  final String? platform;
  final String? store;
  final String? releaseDate;
  final String? screenshots;
  final double metacriticInfo; //1 to 5

  RawgResponse({
    this.name,
    this.gameId,
    this.releaseDate,
    this.iconUrl,
    required this.imageUrl,
    this.description,
    required this.metacriticInfo,
    this.screenshots,
    this.store,
    this.developer,
    this.platform,
    this.publisher,
  });

  // Constructor de fábrica para convertir JSON en RawgResponse
  factory RawgResponse.fromJson(Map<String, dynamic> json) {
    return RawgResponse(
      gameId: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      iconUrl: json['iconUrl'] as String? ?? '',
      imageUrl: json['background_image'] as String? ?? '',
      description: json['description'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      store: json['store'] as String? ?? '',
      releaseDate: json['released'] as String? ?? '',
      metacriticInfo: json['rating'] as double? ??
          0.0, // Valor predeterminado 0.0 si es nulo
      // Agrega aquí todas las propiedades necesarias
    );
  }
}

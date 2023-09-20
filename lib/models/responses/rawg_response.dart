
class RawgResponse {
  final String? gameId;
  final String? name;
  final String? imageUrl;
  final String? iconUrl;
  final String? developer;
  final String? publisher;
  final String? releaseDate;
  final String? screenshots;
  final double metacriticInfo; //1 to 5

  RawgResponse({
    this.name,
    this.gameId,
    this.releaseDate,
    this.iconUrl,
    required this.imageUrl,
    required this.metacriticInfo,
    this.screenshots,
    this.developer,
    this.publisher,
  });

  // Constructor de fábrica para convertir JSON en RawgResponse
  factory RawgResponse.fromJson(Map<String, dynamic> json) {
  return RawgResponse(
    gameId: json['id']?.toString() ?? '',
    name: json['name'] as String? ?? '',
    iconUrl: json['iconUrl'] as String? ?? '',
    imageUrl: json['background_image'] as String? ?? '',
    releaseDate: json['released'] as String? ?? '',
    metacriticInfo: json['rating'] as double? ?? 0.0, // Valor predeterminado 0.0 si es nulo
    // Agrega aquí todas las propiedades necesarias
  );
}

}

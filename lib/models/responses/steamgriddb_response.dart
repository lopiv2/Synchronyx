class SteamgridDBResponse {
  final String? gameId;
  final String? name;
  final String? coverUrl;
  final String? iconUrl;
  final String? logoUrl;
  final String? marqueeUrl;

  SteamgridDBResponse({
    this.name,
    this.gameId,
    this.coverUrl,
    this.iconUrl,
    this.logoUrl,
    this.marqueeUrl,
  });

  // Constructor de fábrica para convertir JSON en RawgResponse
  factory SteamgridDBResponse.fromJson(Map<String, dynamic> json) {
    return SteamgridDBResponse(
      gameId: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      coverUrl: json['coverUrl'] as String? ?? '',
      iconUrl: json['iconUrl'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      marqueeUrl: json['marqueeUrl'] as String? ?? '',
    );
  }
}

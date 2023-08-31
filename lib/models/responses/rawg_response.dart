class RawgResponse {
  final String? gameId;
  final String imageUrl;
  final String? developer;
  final String? publisher;
  final String? releaseDate;
  final String? screenshots;
  final double metacriticInfo; //1 to 5

  RawgResponse({
    this.gameId,
    this.releaseDate,
    required this.imageUrl,
    required this.metacriticInfo,
    this.screenshots,
    this.developer,
    this.publisher,
  });
}

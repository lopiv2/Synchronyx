class Game {
  int id; // Identificador único del juego
  String title; // Título del juego
  late String description; // Descripción o sinopsis del juego
  late String coverImage; // Ruta o URL de la imagen de portada del juego
  late String backImage; // Ruta o URL de la imagen de contraportada del juego
  late String
      platform; // Plataforma en la que se juega el juego (ejemplo: PC, PlayStation, Xbox, etc.)
  late List<String>
      genres; // Géneros del juego (ejemplo: acción, aventura, estrategia, etc.)
  late int maxPlayers; // Maximo de jugadores
  late String developer; // Desarrollador del juego
  late String publisher; // Editor del juego
  late String region; // Region del juego
  late String file; // Archivo del juego (Si es un ROM)
  late int releaseYear; // Año de lanzamiento del juego
  late double rating; // Valoración o calificación del juego
  late bool favorite; // Indica si el juego es uno de los favoritos del usuario
  late int playTime; // Tiempo total de juego registrado para este juego
  late DateTime lastPlayed; // Fecha y hora del último juego
  late List<String> tags; // Etiquetas o categorías asociadas al juego

  Game({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'age': description,
    };
  }

  @override
  String toString() {
    return 'Game{id: $id, title: $title, age: $description}';
  }
}

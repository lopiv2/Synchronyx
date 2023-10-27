
class Emulators {
  int? id;
  String name='';
  String url='';
  String systems=''; //Systems emulated
  String icon='';
  String description='';
  int installed=0; //If installed or not
  int likes=0;

  Emulators({
    this.id,
    required this.name,
    required this.url,
    required this.systems,
    required this.icon,
    required this.description,
    required this.installed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'systems': systems,
      'icon': icon,
      'description': description,
      'installed': installed,
    };
  }

  // Copy Builder
  Emulators.copy(Emulators other) {
    id = other.id;
    name = other.name;
    url = other.url;
    systems = other.systems;
    icon = other.icon;
    description = other.description;
    installed = other.installed;
  }

  @override
  String toString() {
    return 'Emulators{id: $id, name: $name,url: $url, systems: $systems, icon: $icon,description: $description,installed: $installed}';
  }

  static Emulators fromMap(Map<String, dynamic> map) {
    return Emulators(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      url: map['url'] ?? '',
      systems: map['systems'] ?? '',
      icon: map['icon'] ?? '',
      description: map['description'] ?? '',
      installed: map['installed'] ?? '0',
    );
  }
}

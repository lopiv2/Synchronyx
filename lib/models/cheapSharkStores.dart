class CheapSharkStore {
  final String storeID;
  final String storeName;
  final String storeLogoUrl;

  CheapSharkStore({
    required this.storeID,
    required this.storeName,
    required this.storeLogoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'storeID': storeID,
      'storeName': storeName,
      'storeLogoUrl': storeLogoUrl,
      // Agrega aquí cualquier otro atributo que desees incluir en la representación JSON
    };
  }
}

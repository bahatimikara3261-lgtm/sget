class Balance {
  final String soldecdf;
  final String soldeusd;

  Balance({required this.soldecdf, required this.soldeusd});

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      soldecdf: json['soldecdf'] ?? 'Non spécifié', // Gestion des valeurs nulles
      soldeusd: json['soldeusd'] ?? 'Non spécifié',
    );
  }
}
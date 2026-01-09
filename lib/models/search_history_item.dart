class SearchHistoryItem {
  final String asal;
  final String tujuan;
  final DateTime createdAt;
  final bool isFavorite;

  const SearchHistoryItem({
    required this.asal,
    required this.tujuan,
    required this.createdAt,
    required this.isFavorite,
  });

  String get key => '$asal|||$tujuan';

  SearchHistoryItem copyWith({
    String? asal,
    String? tujuan,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return SearchHistoryItem(
      asal: asal ?? this.asal,
      tujuan: tujuan ?? this.tujuan,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

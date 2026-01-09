class RouteRecommendation {
  final String tipe; // mis: "Langsung" / "Transit"
  final String kodeTrayek; // mis: "BB-DYH" atau "K3"
  final String rute; // mis: "Buah Batu - Dayeuhkolot"
  final int? totalTarif; // rupiah

  const RouteRecommendation({
    required this.tipe,
    required this.kodeTrayek,
    required this.rute,
    this.totalTarif,
  });

  factory RouteRecommendation.fromJson(Map<String, dynamic> json) {
    String pickStr(List<String> keys, {String fallback = ''}) {
      for (final k in keys) {
        final v = json[k];
        if (v is String && v.trim().isNotEmpty) return v.trim();
      }
      return fallback;
    }

    int? pickInt(List<String> keys) {
      for (final k in keys) {
        final v = json[k];
        if (v is int) return v;
        if (v is num) return v.toInt();
        if (v is String) {
          final cleaned = v.replaceAll(RegExp(r'[^0-9]'), '');
          if (cleaned.isNotEmpty) return int.tryParse(cleaned);
        }
      }
      return null;
    }

    final tipe = pickStr(['tipe', 'type', 'jenis'], fallback: 'Langsung');
    final kode = pickStr(['kode_trayek', 'kodeTrayek', 'kode', 'trayek'], fallback: '-');
    final rute = pickStr(['rute', 'route', 'nama', 'keterangan'], fallback: '-');
    final tarif = pickInt(['total_tarif', 'totalTarif', 'tarif', 'harga', 'price']);

    return RouteRecommendation(
      tipe: tipe,
      kodeTrayek: kode,
      rute: rute,
      totalTarif: tarif,
    );
  }
}

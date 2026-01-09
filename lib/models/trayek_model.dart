import 'dart:convert';

class Trayek {
  final int id;
  final String kodeTrayek;
  final String namaTrayek;

  final double latAsal;
  final double lngAsal;
  final double latTujuan;
  final double lngTujuan;

  final String ruteJson;
  final List<String> daftarJalan;

  final String gambarUrl;
  final String kodeBalik;

  final int harga;
  final String warnaAngkot;

  const Trayek({
    required this.id,
    required this.kodeTrayek,
    required this.namaTrayek,
    required this.latAsal,
    required this.lngAsal,
    required this.latTujuan,
    required this.lngTujuan,
    required this.ruteJson,
    required this.daftarJalan,
    required this.gambarUrl,
    required this.kodeBalik,
    required this.harga,
    required this.warnaAngkot,
  });

  factory Trayek.fromJson(Map<String, dynamic> json) {
    return Trayek(
      id: (json['id'] as num).toInt(),
      kodeTrayek: (json['kode_trayek'] ?? '') as String,
      namaTrayek: (json['nama_trayek'] ?? '') as String,

      latAsal: (json['lat_asal'] as num?)?.toDouble() ?? 0.0,
      lngAsal: (json['lng_asal'] as num?)?.toDouble() ?? 0.0,
      latTujuan: (json['lat_tujuan'] as num?)?.toDouble() ?? 0.0,
      lngTujuan: (json['lng_tujuan'] as num?)?.toDouble() ?? 0.0,

      ruteJson: (json['rute_json'] ?? '') as String,
      daftarJalan: (json['daftar_jalan'] as List? ?? []).map((e) => e.toString()).toList(),

      gambarUrl: (json['gambar_url'] ?? '') as String,
      kodeBalik: (json['kode_balik'] ?? '') as String,

      harga: (json['harga'] as num?)?.toInt() ?? 0,
      warnaAngkot: (json['warna_angkot'] ?? '#000000') as String,
    );
  }

  Map<String, dynamic>? get geoJson {
    if (ruteJson.trim().isEmpty) return null;
    try {
      return jsonDecode(ruteJson) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}

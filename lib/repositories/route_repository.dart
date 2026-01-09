import 'package:dio/dio.dart';
import '../models/route_recommendation.dart';
import '../models/trayek_model.dart';

/// Repository untuk rekomendasi rute berdasarkan trayek data.
/// Menggunakan algoritma sederhana: cari trayek yang daftarJalannya mengandung asal & tujuan.
class RouteRepository {
  final Dio dio;
  RouteRepository(this.dio);

  Future<List<RouteRecommendation>> fetchRecommendations({
    required String asal,
    required String tujuan,
  }) async {
    try {
      // Fetch trayek
      final res = await dio.get('/trayeks');
      if (res.data is! List) return [];

      final trayeks = (res.data as List)
          .map((e) => Trayek.fromJson(e as Map<String, dynamic>))
          .toList();

      // Filter: trayek yg daftarJalannya ada asal & ada tujuan
      final asalLower = asal.toLowerCase();
      final tujuanLower = tujuan.toLowerCase();

      final rekomendasi = trayeks.where((t) {
        final jalanStr = t.daftarJalan.map((j) => j.toLowerCase()).join(' ');
        return jalanStr.contains(asalLower) && jalanStr.contains(tujuanLower);
      }).map((t) => RouteRecommendation(
            tipe: 'Langsung',
            kodeTrayek: t.kodeTrayek,
            rute: t.namaTrayek,
            totalTarif: t.harga,
          )).toList();

      return rekomendasi;
    } catch (_) {
      return [];
    }
  }
}


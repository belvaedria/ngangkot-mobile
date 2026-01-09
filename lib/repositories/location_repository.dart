import 'package:dio/dio.dart';

/// Repository untuk mengambil daftar lokasi/jalan.
/// Dalam implementasi sebenarnya, ini bisa gabung dari API atau dari trayek data.
class LocationRepository {
  final Dio dio;
  LocationRepository(this.dio);

  /// Mengembalikan daftar jalan kosong.
  /// Gunakan LocationCubit.loadFromTrayeks() untuk mengambil dari trayek data.
  Future<List<String>> fetchLocations() async {
    try {
      // Try simple endpoint
      final res = await dio.get('/trayeks');
      if (res.data is List) {
        final list = res.data as List;
        final jalanSet = <String>{};
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            final daftarJalan = item['daftar_jalan'] as List?;
            if (daftarJalan != null) {
              for (final jalan in daftarJalan) {
                jalanSet.add(jalan.toString());
              }
            }
          }
        }
        return jalanSet.toList()..sort();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}


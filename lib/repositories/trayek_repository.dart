import 'package:dio/dio.dart';
import '../models/trayek_model.dart';

class TrayekRepository {
  final Dio dio;
  TrayekRepository(this.dio);

  Future<List<Trayek>> fetchTrayeks() async {
    final res = await dio.get('/trayeks');
    final List list = res.data as List; // karena JSON kamu bentuknya langsung list
    return list.map((e) => Trayek.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Trayek> fetchDetail(String kodeTrayek) async {
    final res = await dio.get('/trayeks/$kodeTrayek');
    return Trayek.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Trayek> getByKode(String kode) async {
  final res = await dio.get('/trayeks/$kode');
  return Trayek.fromJson(res.data as Map<String, dynamic>);
}

}

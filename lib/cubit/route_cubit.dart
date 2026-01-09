import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/route_repository.dart';
import 'route_state.dart';

class RouteCubit extends Cubit<RouteState> {
  final RouteRepository repo;

  RouteCubit(this.repo) : super(const RouteInitial());

  Future<void> search({required String asal, required String tujuan}) async {
    emit(const RouteLoading());
    try {
      final list = await repo.fetchRecommendations(asal: asal, tujuan: tujuan);
      emit(RouteLoaded(list));
    } catch (e) {
      emit(RouteError(e.toString()));
    }
  }
}

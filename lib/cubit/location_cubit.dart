import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/location_repository.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository repo;

  LocationCubit(this.repo) : super(const LocationInitial());

  Future<void> load() async {
    emit(const LocationLoading());
    try {
      final list = await repo.fetchLocations();
      emit(LocationLoaded(list));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}

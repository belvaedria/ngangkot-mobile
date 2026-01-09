import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/trayek_repository.dart';
import 'trayek_state.dart';

class TrayekCubit extends Cubit<TrayekState> {
  final TrayekRepository repo;
  TrayekCubit(this.repo) : super(const TrayekState());

  Future<void> load() async {
    emit(state.copyWith(status: TrayekStatus.loading, error: null));
    try {
      final data = await repo.fetchTrayeks();
      emit(state.copyWith(status: TrayekStatus.success, items: data));
    } catch (_) {
      emit(state.copyWith(status: TrayekStatus.failure, error: 'Gagal ambil data trayek'));
    }
  }
}

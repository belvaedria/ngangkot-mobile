import 'package:flutter_bloc/flutter_bloc.dart';

/// Academic-safe: in-memory only (no local storage / DB).
class FavoriteTrayekCubit extends Cubit<Set<String>> {
  FavoriteTrayekCubit() : super(<String>{});

  bool isFav(String code) => state.contains(code);

  void toggle(String code) {
    final c = code.trim();
    if (c.isEmpty) return;
    final next = Set<String>.of(state);
    if (next.contains(c)) {
      next.remove(c);
    } else {
      next.add(c);
    }
    emit(next);
  }

  void clear() => emit(<String>{});
}

import '../../models/trayek_model.dart';

enum TrayekStatus { initial, loading, success, failure }

class TrayekState {
  final TrayekStatus status;
  final List<Trayek> items;
  final String? error;

  const TrayekState({
    this.status = TrayekStatus.initial,
    this.items = const [],
    this.error,
  });

  TrayekState copyWith({
    TrayekStatus? status,
    List<Trayek>? items,
    String? error,
  }) {
    return TrayekState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
    );
  }
}

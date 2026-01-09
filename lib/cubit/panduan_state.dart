import 'package:equatable/equatable.dart';
import '../models/guide.dart';

abstract class PanduanState extends Equatable {
  const PanduanState();

  @override
  List<Object> get props => [];
}

class PanduanInitial extends PanduanState {}

class PanduanLoading extends PanduanState {}

class PanduanLoaded extends PanduanState {
  final List<Guide> guides;

  const PanduanLoaded(this.guides);

  @override
  List<Object> get props => [guides];

  PanduanLoaded copyWith({List<Guide>? guides}) {
    return PanduanLoaded(guides ?? this.guides);
  }
}

class PanduanError extends PanduanState {
  final String message;

  const PanduanError(this.message);

  @override
  List<Object> get props => [message];
}

import 'package:equatable/equatable.dart';
import '../models/report.dart';

abstract class LaporanState extends Equatable {
  const LaporanState();

  @override
  List<Object> get props => [];
}

class LaporanInitial extends LaporanState {}

class LaporanLoading extends LaporanState {}

class LaporanLoaded extends LaporanState {
  final List<Report> reports;

  const LaporanLoaded(this.reports);

  @override
  List<Object> get props => [reports];

  LaporanLoaded copyWith({List<Report>? reports}) {
    return LaporanLoaded(reports ?? this.reports);
  }
}

class LaporanError extends LaporanState {
  final String message;

  const LaporanError(this.message);

  @override
  List<Object> get props => [message];
}

class LaporanSubmitted extends LaporanState {
  final Report report;

  const LaporanSubmitted(this.report);

  @override
  List<Object> get props => [report];
}

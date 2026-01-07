import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/report.dart';
import 'laporan_state.dart';

class LaporanCubit extends Cubit<LaporanState> {
  LaporanCubit() : super(LaporanInitial());

  // Counter untuk generate unique ID
  int _reportCounter = 4;

  // Dummy data untuk laporan
  final List<Report> _reports = [
    Report(
      id: '1',
      category: ReportCategory.keterlambatan,
      description: 'Angkot K3 tidak kunjung datang selama 30 menit di BEC',
      status: ReportStatus.pending,
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Report(
      id: '2',
      category: ReportCategory.fasilitasRusak,
      description: 'Kursi angkot FD-1 robek dan kotor sekali',
      status: ReportStatus.diproses,
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Report(
      id: '3',
      category: ReportCategory.pengemudiBermasalah,
      description: 'Pengemudi ugal-ugalan dan merokok saat mengemudi',
      status: ReportStatus.selesai,
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  void loadReports() {
    try {
      emit(LaporanLoading());
      // Simulasi loading
      Future.delayed(const Duration(milliseconds: 500), () {
        emit(LaporanLoaded(List.from(_reports)));
      });
    } catch (e) {
      emit(LaporanError('Gagal memuat laporan: ${e.toString()}'));
    }
  }

  Future<void> submitReport({
    required String category,
    required String description,
    String? imageUrl,
  }) async {
    try {
      emit(LaporanLoading());

      // Generate unique ID
      final newId = _reportCounter.toString();
      _reportCounter++;

      // Create new report with PENDING status
      final newReport = Report(
        id: newId,
        category: category,
        description: description,
        status: ReportStatus.pending,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      );

      // Add to list
      _reports.insert(0, newReport);

      // Simulasi delay submit
      await Future.delayed(const Duration(milliseconds: 800));

      // Emit submitted state first
      emit(LaporanSubmitted(newReport));

      // Then emit loaded state with updated list
      await Future.delayed(const Duration(milliseconds: 300));
      emit(LaporanLoaded(List.from(_reports)));
    } catch (e) {
      emit(LaporanError('Gagal mengirim laporan: ${e.toString()}'));
    }
  }

  void updateReportStatus(String reportId, String newStatus) {
    final currentState = state;
    if (currentState is LaporanLoaded) {
      final updatedReports = currentState.reports.map((report) {
        if (report.id == reportId) {
          return report.copyWith(status: newStatus);
        }
        return report;
      }).toList();

      // Update internal list
      final index = _reports.indexWhere((r) => r.id == reportId);
      if (index != -1) {
        _reports[index] = _reports[index].copyWith(status: newStatus);
      }

      emit(LaporanLoaded(updatedReports));
    }
  }

  List<Report> getMyReports() {
    final currentState = state;
    if (currentState is LaporanLoaded) {
      return List.from(currentState.reports);
    }
    return List.from(_reports);
  }

  List<Report> getReportsByStatus(String status) {
    final currentState = state;
    if (currentState is LaporanLoaded) {
      return currentState.reports
          .where((report) => report.status == status)
          .toList();
    }
    return _reports.where((report) => report.status == status).toList();
  }

  List<Report> getReportsByCategory(String category) {
    final currentState = state;
    if (currentState is LaporanLoaded) {
      return currentState.reports
          .where((report) => report.category == category)
          .toList();
    }
    return _reports.where((report) => report.category == category).toList();
  }

  Report? getReportById(String id) {
    final currentState = state;
    if (currentState is LaporanLoaded) {
      try {
        return currentState.reports.firstWhere((report) => report.id == id);
      } catch (e) {
        return null;
      }
    }
    try {
      return _reports.firstWhere((report) => report.id == id);
    } catch (e) {
      return null;
    }
  }

  void deleteReport(String reportId) {
    final currentState = state;
    if (currentState is LaporanLoaded) {
      final updatedReports = currentState.reports
          .where((report) => report.id != reportId)
          .toList();

      // Remove from internal list
      _reports.removeWhere((report) => report.id == reportId);

      emit(LaporanLoaded(updatedReports));
    }
  }

  int getTotalReports() {
    final currentState = state;
    if (currentState is LaporanLoaded) {
      return currentState.reports.length;
    }
    return _reports.length;
  }

  int getReportCountByStatus(String status) {
    return getReportsByStatus(status).length;
  }

  Map<String, int> getReportStatistics() {
    return {
      'total': getTotalReports(),
      'pending': getReportCountByStatus(ReportStatus.pending),
      'diproses': getReportCountByStatus(ReportStatus.diproses),
      'selesai': getReportCountByStatus(ReportStatus.selesai),
    };
  }
}

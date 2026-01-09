import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../cubit/laporan_cubit.dart';
import '../../cubit/laporan_state.dart';
import '../../models/report.dart';
import '../../theme/app_theme.dart';
import 'report_detail_page.dart';

class MyReportsPage extends StatelessWidget {
  const MyReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Laporan Saya'),
        backgroundColor: AppColors.white,
        elevation: 2,
        shadowColor: AppColors.dark.withOpacity(0.1),
      ),
      body: BlocBuilder<LaporanCubit, LaporanState>(
        builder: (context, state) {
          if (state is LaporanLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LaporanError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.danger,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is LaporanLoaded) {
            final reports = state.reports;

            if (reports.isEmpty) {
              return _buildEmptyState(context);
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return _buildReportCard(context, report);
              },
            );
          }

          // Initial or unknown state
          return _buildEmptyState(context);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.description_outlined,
                size: 64,
                color: AppColors.textHint.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Belum Ada Laporan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Anda belum pernah membuat laporan.\nLaporkan masalah yang Anda temui.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/reports/create');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Buat Laporan Baru'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, Report report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportDetailPage(report: report),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getCategoryColor(report.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(report.category),
                  color: _getCategoryColor(report.category),
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // Report Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            ReportCategory.getDisplayName(report.category),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusBadge(report.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDate(report.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Chevron
              const Icon(
                Icons.chevron_right,
                color: AppColors.textHint,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case ReportStatus.pending:
        color = AppColors.pending;
        label = 'PENDING';
        break;
      case ReportStatus.diproses:
        color = AppColors.processing;
        label = 'DIPROSES';
        break;
      case ReportStatus.selesai:
        color = AppColors.completed;
        label = 'SELESAI';
        break;
      default:
        color = AppColors.textHint;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case ReportCategory.keterlambatan:
        return Icons.access_time;
      case ReportCategory.fasilitasRusak:
        return Icons.build;
      case ReportCategory.pengemudiBermasalah:
        return Icons.person_off;
      case ReportCategory.lainnya:
        return Icons.more_horiz;
      default:
        return Icons.description;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case ReportCategory.keterlambatan:
        return AppColors.pending;
      case ReportCategory.fasilitasRusak:
        return AppColors.danger;
      case ReportCategory.pengemudiBermasalah:
        return AppColors.dark;
      case ReportCategory.lainnya:
        return AppColors.textSecondary;
      default:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini • ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Kemarin • ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }
}

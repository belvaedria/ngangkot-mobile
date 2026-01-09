import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/report.dart';
import '../../theme/app_theme.dart';

class ReportDetailPage extends StatelessWidget {
  final Report report;

  const ReportDetailPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Laporan'),
        backgroundColor: AppColors.white,
        elevation: 2,
        shadowColor: AppColors.dark.withOpacity(0.1),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: _getStatusColor(report.status).withOpacity(0.1),
              child: Column(
                children: [
                  Icon(
                    _getStatusIcon(report.status),
                    size: 48,
                    color: _getStatusColor(report.status),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getStatusLabel(report.status),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(report.status),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getStatusMessage(report.status),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Report Info Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Laporan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    'ID Laporan',
                    '#${report.id.padLeft(4, '0')}',
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    'Kategori',
                    ReportCategory.getDisplayName(report.category),
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    'Tanggal Laporan',
                    DateFormat('dd MMMM yyyy, HH:mm').format(report.createdAt),
                  ),
                ],
              ),
            ),

            // Description Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deskripsi Masalah',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    report.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Photo (if available)
            if (report.imageUrl != null) ...[
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Foto Pendukung',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        report.imageUrl!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: AppColors.background,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 48,
                                color: AppColors.textHint,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case ReportStatus.pending:
        return AppColors.pending;
      case ReportStatus.diproses:
        return AppColors.processing;
      case ReportStatus.selesai:
        return AppColors.completed;
      default:
        return AppColors.textHint;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case ReportStatus.pending:
        return Icons.schedule;
      case ReportStatus.diproses:
        return Icons.hourglass_empty;
      case ReportStatus.selesai:
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case ReportStatus.pending:
        return 'Menunggu Diproses';
      case ReportStatus.diproses:
        return 'Sedang Diproses';
      case ReportStatus.selesai:
        return 'Selesai';
      default:
        return status;
    }
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case ReportStatus.pending:
        return 'Laporan Anda sedang menunggu untuk diproses';
      case ReportStatus.diproses:
        return 'Tim kami sedang menangani laporan Anda';
      case ReportStatus.selesai:
        return 'Laporan Anda telah selesai ditangani';
      default:
        return '';
    }
  }
}

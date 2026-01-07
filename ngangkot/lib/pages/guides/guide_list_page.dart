import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/panduan_cubit.dart';
import '../../cubit/panduan_state.dart';
import '../../models/guide.dart';
import '../../theme/app_theme.dart';
import 'guide_detail_page.dart';

class GuideListPage extends StatelessWidget {
  const GuideListPage({super.key});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'map':
        return Icons.map;
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'location_on':
        return Icons.location_on;
      case 'info':
        return Icons.info;
      case 'help':
        return Icons.help;
      default:
        return Icons.help_outline;
    }
  }

  Color _getIconColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.success,
      AppColors.routePurple,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Panduan Aplikasi'),
        backgroundColor: AppColors.white,
        elevation: 2,
        shadowColor: AppColors.dark.withValues(alpha: 0.1),
      ),
      body: BlocBuilder<PanduanCubit, PanduanState>(
        builder: (context, state) {
          if (state is PanduanLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is PanduanError) {
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

          if (state is PanduanLoaded) {
            if (state.guides.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.library_books_outlined,
                      size: 80,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum ada panduan',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.guides.length,
              itemBuilder: (context, index) {
                final guide = state.guides[index];
                return _buildGuideCard(context, guide, index);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildGuideCard(BuildContext context, Guide guide, int index) {
    final iconColor = _getIconColor(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: AppColors.dark.withValues(alpha: 0.08),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GuideDetailPage(guide: guide),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getIconData(guide.icon),
                    size: 32,
                    color: iconColor,
                  ),
                ),

                const SizedBox(width: 16),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guide.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        guide.description.length > 60
                            ? '${guide.description.substring(0, 60)}...'
                            : guide.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

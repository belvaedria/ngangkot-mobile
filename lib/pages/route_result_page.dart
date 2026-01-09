import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/history_cubit.dart';
import '../cubit/route_cubit.dart';
import '../cubit/route_state.dart';
import '../models/search_history_item.dart';
import '../theme/app_theme.dart';
import '../cubit/trayek_cubit.dart';
import '../cubit/trayek_state.dart';
import 'trayek_detail_page.dart';


class RouteResultPage extends StatefulWidget {
  final String asal;
  final String tujuan;

  const RouteResultPage({
    super.key,
    required this.asal,
    required this.tujuan,
  });

  @override
  State<RouteResultPage> createState() => _RouteResultPageState();
}

class _RouteResultPageState extends State<RouteResultPage> {
  @override
  void initState() {
    super.initState();
    context.read<RouteCubit>().search(asal: widget.asal, tujuan: widget.tujuan);
  }

  bool _isFav(List<SearchHistoryItem> items) {
    return items.any(
      (e) => e.asal == widget.asal && e.tujuan == widget.tujuan && e.isFavorite,
    );
  }

  Future<void> _toggleFav() async {
    final history = context.read<HistoryCubit>();
    final items = history.state;
    final existing = items.where((e) => e.asal == widget.asal && e.tujuan == widget.tujuan).toList();
    if (existing.isEmpty) {
      await history.addSearch(asal: widget.asal, tujuan: widget.tujuan);
    }

    final updated = history.state
        .firstWhere((e) => e.asal == widget.asal && e.tujuan == widget.tujuan);
    history.toggleFavorite(updated);

    if (!mounted) return;
    final nowFav = history.state
        .any((e) => e.asal == widget.asal && e.tujuan == widget.tujuan && e.isFavorite);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(nowFav
            ? 'Berhasil ditambahkan ke favorit'
            : 'Dihapus dari favorit'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rekomendasi Trayek'),
        backgroundColor: AppColors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Menampilkan rekomendasi angkot untuk',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${widget.asal} → ${widget.tujuan}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  BlocBuilder<HistoryCubit, List<SearchHistoryItem>>(
                    builder: (context, items) {
                      final fav = _isFav(items);
                      return IconButton(
                        onPressed: _toggleFav,
                        icon: Icon(
                          fav ? Icons.star : Icons.star_border,
                          color: fav ? Colors.amber[700] : AppColors.textHint,
                        ),
                        tooltip: 'Favorit',
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<RouteCubit, RouteState>(
                  builder: (context, state) {
                    if (state is RouteLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is RouteError) {
                      return Center(
                        child: Text(
                          'Gagal memuat rekomendasi.\n${state.message}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      );
                    }
                    if (state is RouteLoaded) {
                      if (state.items.isEmpty) {
                        return const Center(
                          child: Text(
                            'Tidak ada rekomendasi trayek untuk rute ini.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        );
                      }
                      return ListView.separated(
                        itemCount: state.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final item = state.items[i];
                          return InkWell(
                          onTap: () async {
                            final trayekCubit = context.read<TrayekCubit>();

                            // Pastikan data trayek sudah ada
                            if (trayekCubit.state.status != TrayekStatus.success) {
                              await trayekCubit.load();
                            }

                            final trayekList = trayekCubit.state.items;
                            final idx = trayekList.indexWhere((t) => t.kodeTrayek == item.kodeTrayek);

                            if (idx == -1) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Detail trayek ${item.kodeTrayek} tidak ditemukan')),
                              );
                              return;
                            }

                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TrayekDetailPage(trayek: trayekList[idx]),
                              ),
                            );
                          },

                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.directions_bus, color: AppColors.textSecondary),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${item.tipe} • ${item.kodeTrayek}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.rute,
                                          style: const TextStyle(color: AppColors.textSecondary),
                                        ),
                                        if (item.totalTarif != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            'Total: Rp ${item.totalTarif}',
                                            style: const TextStyle(color: AppColors.textSecondary),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, color: AppColors.textHint),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

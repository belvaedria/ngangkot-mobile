import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/trayek_cubit.dart';
import '../cubit/trayek_state.dart';
import '../models/trayek_model.dart';
import '../theme/app_theme.dart';
import 'search_route_page.dart';
import 'trayek_detail_page.dart';

// Catatan scope: Info Trayek hanya menampilkan informasi trayek.
// History + Favorite dipakai untuk fitur Cari Rute (SearchRoutePage / RouteResultPage).

class InfoTrayekPage extends StatefulWidget {
  const InfoTrayekPage({super.key});

  @override
  State<InfoTrayekPage> createState() => _InfoTrayekPageState();
}

class _InfoTrayekPageState extends State<InfoTrayekPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color parseHexColor(String hex) {
    var h = hex.trim().replaceAll('#', '');
    if (h.length == 6) h = 'FF$h'; // tambah alpha
    final val = int.tryParse(h, radix: 16) ?? 0xFF9E9E9E;
    return Color(val);
  }


String _badgeText(String kodeTrayek) {
  // Request: tampilkan 2 digit terakhir (angka) dari kodeTrayek.
  final digits = RegExp(r'\d').allMatches(kodeTrayek).map((m) => m.group(0)!).toList();
  if (digits.isNotEmpty) {
    final last2 = digits.length >= 2 ? digits.sublist(digits.length - 2) : ['0', digits.last];
    return last2.join();
  }
  // Fallback: ambil 2 karakter terakhir non-spasi
  final s = kodeTrayek.replaceAll(' ', '');
  if (s.length <= 2) return s;
  return s.substring(s.length - 2);
}

  List<Trayek> _filter(List<Trayek> all) {
    if (_query.isEmpty) return all;
    return all.where((t) {
      final kode = (t.kodeTrayek).toLowerCase();
      final nama = (t.namaTrayek).toLowerCase();
      return kode.contains(_query) || nama.contains(_query);
    }).toList();
  }

  Color _colorForKode(String kode, String warnaHex) {
    return parseHexColor(warnaHex.isEmpty ? '#9E9E9E' : warnaHex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Route Info'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar (list trayek)
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),

          // CTA Search Route (asal - tujuan) sesuai fitur kamu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchRoutePage()),
              ),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.alt_route, color: AppColors.primary),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Cari rute (asal → tujuan)',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: AppColors.textHint),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: BlocBuilder<TrayekCubit, TrayekState>(
              builder: (context, state) {
                if (state.status == TrayekStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.error != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Gagal memuat trayek:\n${state.error}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => context.read<TrayekCubit>().load(),
                            child: const Text('Coba lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final filtered = _filter(state.items);

                if (filtered.isEmpty) {
                  return const Center(child: Text('Trayek tidak ditemukan'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final t = filtered[i];
                    final kode = t.kodeTrayek;
                    final title = t.namaTrayek;

                    final color = _colorForKode(kode, t.warnaAngkot);

                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TrayekDetailPage(trayek: t)),
                      ),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _badgeText(kode),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}

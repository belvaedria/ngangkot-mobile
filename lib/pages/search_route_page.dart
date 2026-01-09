import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/history_cubit.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';
import '../models/search_history_item.dart';
import 'route_result_page.dart';

class SearchRoutePage extends StatefulWidget {
  const SearchRoutePage({super.key});

  @override
  State<SearchRoutePage> createState() => _SearchRoutePageState();
}

class _SearchRoutePageState extends State<SearchRoutePage> {
  final asalCtrl = TextEditingController();
  final tujuanCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ambil list lokasi/jalan dari Laravel
    context.read<LocationCubit>().load();
  }

  @override
  void dispose() {
    asalCtrl.dispose();
    tujuanCtrl.dispose();
    super.dispose();
  }

  void _swap() {
    final a = asalCtrl.text;
    asalCtrl.text = tujuanCtrl.text;
    tujuanCtrl.text = a;
    setState(() {});
  }

  Future<void> _submit() async {
    final asal = asalCtrl.text.trim();
    final tujuan = tujuanCtrl.text.trim();
    if (asal.isEmpty || tujuan.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi awal dan tujuan wajib diisi.')),
      );
      return;
    }

    await context.read<HistoryCubit>().addSearch(asal: asal, tujuan: tujuan);

    if (!mounted) return;
    // Sesuai modul: pakai Snackbar/Alert sebagai feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mencari rekomendasi: $asal → $tujuan')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RouteResultPage(asal: asal, tujuan: tujuan),
      ),
    );
  }

  Future<void> _pickLocation({
    required TextEditingController target,
    required String title,
  }) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final searchCtrl = TextEditingController();
        String q = '';
        return StatefulBuilder(
          builder: (context, setModal) {
            final locState = context.watch<LocationCubit>().state;
            final all = locState is LocationLoaded ? locState.locations : <String>[];
            final list = all.where((e) => e.toLowerCase().contains(q)).toList();
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 12,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: searchCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Cari lokasi...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => setModal(() => q = v.trim().toLowerCase()),
                    ),
                    const SizedBox(height: 8),
                    if (locState is LocationLoading) ...[
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ] else if (locState is LocationError) ...[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Gagal memuat daftar lokasi.\n${locState.message}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () => context.read<LocationCubit>().load(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Coba lagi'),
                            )
                          ],
                        ),
                      ),
                    ] else ...[
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final opt = list[i];
                            return ListTile(
                              dense: true,
                              leading: const Icon(Icons.place, size: 18),
                              title: Text(opt),
                              onTap: () => Navigator.pop(context, opt),
                            );
                          },
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (picked != null) {
      target.text = picked;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Rute')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Form
            _LocationField(
              label: 'Lokasi awal',
              controller: asalCtrl,
              onTap: () => _pickLocation(target: asalCtrl, title: 'Pilih lokasi awal'),
            ),
            const SizedBox(height: 12),
            Center(
              child: IconButton(
                onPressed: _swap,
                icon: const Icon(Icons.swap_vert),
                tooltip: 'Tukar lokasi',
              ),
            ),
            const SizedBox(height: 12),
            _LocationField(
              label: 'Tujuan',
              controller: tujuanCtrl,
              onTap: () =>
                  _pickLocation(target: tujuanCtrl, title: 'Pilih tujuan'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.search),
                label: const Text('Cari'),
              ),
            ),
            const SizedBox(height: 24),

            // History + Favorites
            BlocBuilder<HistoryCubit, List<SearchHistoryItem>>(
              builder: (context, items) {
                final favs = items.where((e) => e.isFavorite).toList();
                final recents = items.where((e) => !e.isFavorite).toList();

                if (items.isEmpty) {
                  return const Text(
                    'Belum ada riwayat pencarian.',
                    style: TextStyle(color: Colors.black54),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (favs.isNotEmpty) ...[
                      const Text('Favorit',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      ...favs.map((e) => _HistoryTile(
                            item: e,
                            onTap: () {
                              asalCtrl.text = e.asal;
                              tujuanCtrl.text = e.tujuan;
                              setState(() {});
                            },
                            onFav: () => context.read<HistoryCubit>().toggleFavorite(e),
                            onDelete: () => context.read<HistoryCubit>().removeItem(e),
                          )),
                      const SizedBox(height: 16),
                    ],
                    const Text('Riwayat terbaru',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    ...recents.take(10).map((e) => _HistoryTile(
                          item: e,
                          onTap: () {
                            asalCtrl.text = e.asal;
                            tujuanCtrl.text = e.tujuan;
                            setState(() {});
                          },
                          onFav: () => context.read<HistoryCubit>().toggleFavorite(e),
                          onDelete: () => context.read<HistoryCubit>().removeItem(e),
                        )),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => context.read<HistoryCubit>().clear(),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Hapus semua'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;

  const _LocationField({
    required this.label,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.place_outlined),
        suffixIcon: const Icon(Icons.keyboard_arrow_down),
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final SearchHistoryItem item;
  final VoidCallback onTap;
  final VoidCallback onFav;
  final VoidCallback onDelete;

  const _HistoryTile({
    required this.item,
    required this.onTap,
    required this.onFav,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.history),
        title: Text('${item.asal} → ${item.tujuan}'),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              onPressed: onFav,
              icon: Icon(item.isFavorite ? Icons.star : Icons.star_border),
              tooltip: 'Favorit',
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.close),
              tooltip: 'Hapus',
            ),
          ],
        ),
      ),
    );
  }
}

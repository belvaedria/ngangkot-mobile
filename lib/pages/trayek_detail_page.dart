import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/trayek_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/trayek_cubit.dart';
import '../cubit/favorite_trayek_cubit.dart';

Color parseHexColor(String hex) {
  final cleaned = hex.replaceAll('#', '');
  return Color(int.parse('FF$cleaned', radix: 16));
}

List<LatLng> parseGeoJsonLineString(String ruteJson) {
  final obj = jsonDecode(ruteJson);
  final features = (obj['features'] as List);
  final geometry = features.first['geometry'];
  final coords = (geometry['coordinates'] as List);

  return coords
      .map<LatLng>((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
      .toList();
}

Widget buildTrayekMap({
  required List<LatLng> points,
  required LatLng start,
  required LatLng end,
  required Color lineColor,
}) {
  final center = points.isNotEmpty ? points[points.length ~/ 2] : start;

  return FlutterMap(
    options: MapOptions(initialCenter: center, initialZoom: 12),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.ngangkot',
      ),
      PolylineLayer(polylines: [Polyline(points: points, strokeWidth: 5, color: lineColor)]),
      MarkerLayer(
        markers: [
          Marker(point: start, width: 40, height: 40, child: const Icon(Icons.location_on, size: 40)),
          Marker(point: end, width: 40, height: 40, child: const Icon(Icons.flag, size: 34)),
        ],
      ),
    ],
  );
}

class TrayekDetailPage extends StatefulWidget {
  final Trayek trayek;
  const TrayekDetailPage({super.key, required this.trayek});

  @override
  State<TrayekDetailPage> createState() => _TrayekDetailPageState();
}

class _TrayekDetailPageState extends State<TrayekDetailPage> {
  bool isBalik = false;
  Trayek? trayekBalik;
  bool loadingBalik = false;
  String? errorBalik;

  Future<void> loadBalik(String kodeBalik) async {
    setState(() {
      loadingBalik = true;
      errorBalik = null;
    });
    try {
      final repo = context.read<TrayekCubit>().repo;
      final t = await repo.getByKode(kodeBalik);

      setState(() {
        trayekBalik = t;
        isBalik = true;
      });
    } catch (e) {
      setState(() {
        errorBalik = 'Gagal memuat rute balik: $e';
        isBalik = false;
      });
    } finally {
      setState(() => loadingBalik = false);
    }
  }
    

  @override
  Widget build(BuildContext context) {
    final trayekPergi = widget.trayek;

    final active = isBalik ? (trayekBalik ?? trayekPergi) : trayekPergi;

    final points = active.ruteJson.trim().isEmpty ? <LatLng>[] : parseGeoJsonLineString(active.ruteJson);
    final start = LatLng(active.latAsal, active.lngAsal);
    final end = LatLng(active.latTujuan, active.lngTujuan);

    final lineColor = active.warnaAngkot.trim().isEmpty
        ? Theme.of(context).colorScheme.primary
        : parseHexColor(active.warnaAngkot);


    return Scaffold(
      appBar: AppBar(
        title: Text(active.kodeTrayek),
        actions: [
          BlocBuilder<FavoriteTrayekCubit, Set<String>>(
            builder: (context, favs) {
              final code = active.kodeTrayek;
              final isFav = favs.contains(code);
              return IconButton(
                onPressed: () => context.read<FavoriteTrayekCubit>().toggle(code),
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                tooltip: isFav ? 'Hapus dari favorit' : 'Tambah ke favorit',
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // MAP FULL BACKGROUND
          Positioned.fill(
            child: buildTrayekMap(
              points: points.isEmpty ? [start, end] : points,
              start: start,
              end: end,
              lineColor: lineColor,
            ),
          ),

          // Floating Back Button feel (optional)
          // Kalau kamu mau appBar transparan nanti bisa, tapi ini cukup dulu.

          // BUSKU BOTTOM SHEET
          DraggableScrollableSheet(
            initialChildSize: 0.48,
            minChildSize: 0.32,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 12,
                      offset: Offset(0, -2),
                      color: Colors.black26,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // handle bar
                    const SizedBox(height: 10),
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // HEADER BLUE (Busku style)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
                          const Icon(Icons.directions_bus, color: Colors.white),
                          
                          const SizedBox(width: 10),

                          // TITLE + CHIP
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    Chip(
                                      label: Text(
                                        active.kodeTrayek,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: parseHexColor(active.warnaAngkot),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  active.namaTrayek,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // SWAP BUTTON (Pergi <-> Balik)
                          InkWell(
                            borderRadius: BorderRadius.circular(999),
                            onTap: () async {
                              if (isBalik) {
                                setState(() => isBalik = false);
                                return;
                              }

                              // kalau belum pernah load rute balik
                              if (trayekBalik == null && !loadingBalik) {
                                await loadBalik(trayekPergi.kodeBalik);
                              } else {
                                setState(() => isBalik = true);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                shape: BoxShape.circle,
                              ),
                              child: loadingBalik
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.swap_vert,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                      if (errorBalik != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                        child: Text(
                          errorBalik!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    // CONTENT (scrollable) - ini yang ngikut scrollController
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Gambar trayek
                          Center(
                            child: Image.asset(
                              'assets/images/angkot/${active.gambarUrl}.png',
                              height: 120,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.directions_bus, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 14),

                          const Text(
                            'Daftar Jalan yang Dilalui',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          ...List.generate(active.daftarJalan.length, (i) {
                            final isFirst = i == 0;
                            final isLast = i == active.daftarJalan.length - 1;

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // garis + dot
                                SizedBox(
                                  width: 26,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        margin: const EdgeInsets.only(top: 4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isFirst
                                              ? Colors.green
                                              : isLast
                                                  ? Colors.red
                                                  : Colors.orange,
                                        ),
                                      ),
                                      if (!isLast)
                                        Container(
                                          width: 2,
                                          height: 34,
                                          margin: const EdgeInsets.only(top: 2),
                                          color: Colors.black12,
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // text
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      active.daftarJalan[i],
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),

                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );


  }
}
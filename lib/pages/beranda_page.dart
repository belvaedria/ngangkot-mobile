import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/artikel_cubit.dart';
import '../cubit/artikel_state.dart';
import '../theme/app_theme.dart';
import 'articles/article_detail_page.dart';
import 'search_route_page.dart';
import '../cubit/history_cubit.dart';
import '../models/search_history_item.dart';
import 'route_result_page.dart';
import 'info_trayek_page.dart';


class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: AppColors.white,
        elevation: 2,
        shadowColor: AppColors.dark.withOpacity(0.1),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const SizedBox(height: 16),
            // Search Bar (mati, tapi jadi trigger ke halaman cari rute)
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchRoutePage()),
                ),
                borderRadius: BorderRadius.circular(12),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari angkot ke tujuan...',
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.textHint),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Quick Actions
          GridView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            children: [
              _ActionCard(
                title: 'Cari Rute',
                subtitle: 'Dapatkan rokemendasi rute',
                icon: Icons.alt_route,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchRoutePage()),
                ),
              ),
              _ActionCard(
                title: 'Info Trayek',
                subtitle: 'Lihat informasi lengkap trayek',
                icon: Icons.directions_bus,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InfoTrayekPage()),
                ),
              ),
            ],
          ),

            const SizedBox(height: 24),

            // Rute Favorit Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rute Favorit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to Info Trayek
                    },
                    child: const Text('Lihat Semua'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 100,
              child: BlocBuilder<HistoryCubit, List<SearchHistoryItem>>(
                builder: (context, items) {
                  final favs = items.where((e) => e.isFavorite).toList();

                  if (favs.isEmpty) {
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: const [
                        RouteCard(
                          code: '★',
                          name: 'Belum ada\nfavorit',
                          color: AppColors.routePurple,
                        ),
                      ],
                    );
                  }

                  final List<Widget> cards = favs.take(10).map<Widget>((e) {
                    final code = _routeCode(e.asal, e.tujuan);
                    final name = '${e.asal} → ${e.tujuan}';

                    return RouteCard(
                      code: code,
                      name: name,
                      color: AppColors.routeGreen,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RouteResultPage(asal: e.asal, tujuan: e.tujuan),
                          ),
                        );
                      },
                    );
                  }).toList();

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: cards,
                  );
                },
              ),
            ),


            const SizedBox(height: 24),

            // Informasi Terbaru Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Informasi Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Articles from BlocBuilder
            BlocBuilder<ArtikelCubit, ArtikelState>(
              builder: (context, state) {
                if (state is ArtikelLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state is ArtikelError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: AppColors.danger),
                    ),
                  );
                }

                if (state is ArtikelLoaded) {
                  return Column(
                    children: [
                      ...state.articles.take(2).map((article) {
                        return ArticleCard(
                          title: article.title,
                          category: article.category,
                          imageUrl: article.imageUrl,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ArticleDetailPage(
                                  article: article,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                      // Laporkan Masalah Card
                      const ReportAlertCard(),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/reports/create');
        },
        backgroundColor: AppColors.danger,
        icon: const Icon(Icons.report_problem),
        label: const Text('Lapor'),
      ),
    );
  }
}


// Article Card Widget
class ArticleCard extends StatelessWidget {
  final String title;
  final String category;
  final String imageUrl;
  final VoidCallback onTap;

  const ArticleCard({
    super.key,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {},
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.textHint.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: const Icon(
                  Icons.image,
                  color: AppColors.textHint,
                  size: 32,
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: category == 'INFO'
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: category == 'INFO'
                              ? AppColors.primary
                              : AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Report Alert Card
class ReportAlertCard extends StatelessWidget {
  const ReportAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/reports/create');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Laporkan Masalah',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.danger,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.danger,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _routeCode(String asal, String tujuan) {
  String first(String s) => s.trim().isEmpty ? '?' : s.trim()[0].toUpperCase();
  return '${first(asal)}→${first(tujuan)}';
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class RouteCard extends StatelessWidget {
  final String code;
  final String name;
  final Color color;
  final VoidCallback? onTap;

  const RouteCard({
    super.key,
    required this.code,
    required this.name,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  code,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
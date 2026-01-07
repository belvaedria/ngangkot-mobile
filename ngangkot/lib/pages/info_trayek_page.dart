import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class InfoTrayekPage extends StatefulWidget {
  const InfoTrayekPage({super.key});

  @override
  State<InfoTrayekPage> createState() => _InfoTrayekPageState();
}

class _InfoTrayekPageState extends State<InfoTrayekPage> {
  final TextEditingController _searchController = TextEditingController();
  List<TrayekData> _filteredTrayeks = [];

  final List<TrayekData> _allTrayeks = [
    TrayekData(
      code: 'FD-1',
      name: 'Simpang Soetta Kiaracondong 2',
      route: 'Simpang Soetta → Pasar Baru',
      color: AppColors.routeGreen,
      operationalHours: '05:00 - 18:30 WIB',
      status: 'OPERASIONAL',
    ),
    TrayekData(
      code: 'K3',
      name: 'Bandung Electronic Centre',
      route: 'Bandung Electronic → Baleendah',
      color: AppColors.routePurple,
      operationalHours: '04:30 - 20:00 WIB',
      status: 'OPERASIONAL',
    ),
    TrayekData(
      code: 'K1',
      name: 'Leuwipanjang → Soreang',
      route: 'Leuwipanjang → Soreang',
      color: AppColors.routeGreen,
      operationalHours: '04:40 - 20:30 WIB',
      status: 'OPERASIONAL',
    ),
    TrayekData(
      code: 'K2',
      name: 'Alun-Alun Bandung',
      route: 'Alun-Alun → Kota Baru Parahyangan',
      color: AppColors.routeRed,
      operationalHours: '04:30 - 20:00 WIB',
      status: 'OPERASIONAL',
    ),
    TrayekData(
      code: 'K6',
      name: 'Leuwipanjang → TERMINAL MAJALAYA',
      route: 'Leuwipanjang → Terminal Majalaya',
      color: AppColors.routeOrange,
      operationalHours: '06:00 - 13:00 WIB',
      status: 'OPERASIONAL',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredTrayeks = _allTrayeks;
    _searchController.addListener(_filterTrayeks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTrayeks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTrayeks = _allTrayeks;
      } else {
        _filteredTrayeks = _allTrayeks.where((trayek) {
          return trayek.code.toLowerCase().contains(query) ||
              trayek.name.toLowerCase().contains(query) ||
              trayek.route.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Info Trayek'),
        backgroundColor: AppColors.white,
        elevation: 2,
        shadowColor: AppColors.dark.withOpacity(0.1),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari rute atau kode...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon:
                            const Icon(Icons.clear, color: AppColors.textHint),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Trayek List
          Expanded(
            child: _filteredTrayeks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.textHint.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Trayek tidak ditemukan',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTrayeks.length,
                    itemBuilder: (context, index) {
                      final trayek = _filteredTrayeks[index];
                      return TrayekCard(
                        trayek: trayek,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TrayekDetailPage(trayek: trayek),
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

// Trayek Card Widget
class TrayekCard extends StatelessWidget {
  final TrayekData trayek;
  final VoidCallback onTap;

  const TrayekCard({
    super.key,
    required this.trayek,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Left colored stripe
            Container(
              width: 6,
              height: 100,
              decoration: BoxDecoration(
                color: trayek.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Route badge
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: trayek.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          trayek.code,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Route info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Route name
                          Text(
                            trayek.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 4),

                          // Status badge
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: AppColors.success,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'OPERASIONAL',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          // Operational hours
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                trayek.operationalHours,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Chevron
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textHint,
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

// Trayek Data Model
class TrayekData {
  final String code;
  final String name;
  final String route;
  final Color color;
  final String operationalHours;
  final String status;

  TrayekData({
    required this.code,
    required this.name,
    required this.route,
    required this.color,
    required this.operationalHours,
    required this.status,
  });
}

// Dummy Detail Page
class TrayekDetailPage extends StatelessWidget {
  final TrayekData trayek;

  const TrayekDetailPage({super.key, required this.trayek});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Trayek ${trayek.code}'),
        backgroundColor: AppColors.white,
        elevation: 2,
        shadowColor: AppColors.dark.withOpacity(0.1),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Placeholder
            Container(
              height: 250,
              color: AppColors.white,
              child: Stack(
                children: [
                  // Grid pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GridPainter(),
                    ),
                  ),
                  // Mock route
                  Center(
                    child: Icon(
                      Icons.map,
                      size: 64,
                      color: AppColors.textHint.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Route Info Card
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
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: trayek.color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            trayek.code,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trayek.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'OPERASIONAL',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Route details
                  _buildInfoRow(Icons.route, 'Rute', trayek.route),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.access_time, 'Jam Operasional',
                      trayek.operationalHours),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Pemberhentian Utama
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
                    'Pemberhentian Utama',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStopItem(
                      trayek.route.split(' → ')[0], trayek.code, true),
                  _buildStopItem('Pasar Baru', trayek.code, false),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStopItem(String name, String code, bool isFirst) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isFirst ? trayek.color : AppColors.textSecondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
              ),
              if (!isFirst)
                Container(
                  width: 2,
                  height: 20,
                  color: AppColors.border,
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  code,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Grid Painter (reuse from beranda_page)
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withOpacity(0.3)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

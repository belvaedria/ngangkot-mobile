import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/nav_cubit.dart';
import 'cubit/artikel_cubit.dart';
import 'cubit/panduan_cubit.dart';
import 'cubit/laporan_cubit.dart';
import 'cubit/auth_cubit.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/beranda_page.dart';
import 'pages/info_trayek_page.dart';
import 'pages/akun_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/reports/create_report_page.dart';
import 'pages/reports/my_reports_page.dart';
import 'pages/guides/guide_list_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => NavCubit()),
        BlocProvider(create: (_) => ArtikelCubit()..loadArticles()),
        BlocProvider(create: (_) => PanduanCubit()..loadGuides()),
        BlocProvider(create: (_) => LaporanCubit()..loadReports()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ngangkot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/beranda': (_) => const RootPage(),
        '/': (_) => const RootPage(),
        '/profile': (_) => const ProfilePage(),
        '/settings': (_) => const SettingsPage(),
        '/reports/create': (_) => const CreateReportPage(),
        '/reports/my': (_) => const MyReportsPage(),
        '/guides': (_) => const GuideListPage(),
      },
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavCubit, int>(
      builder: (context, index) {
        Widget body;
        if (index == 0) {
          body = const BerandaPage();
        } else if (index == 1) {
          body = const InfoTrayekPage();
        } else if (index == 2) {
          body = const AkunPage();
        } else {
          body = const SettingsPage();
        }
        return Scaffold(
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (i) => context.read<NavCubit>().setIndex(i),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.map), label: 'Info Trayek'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
            ],
          ),
        );
      },
    );
  }
}

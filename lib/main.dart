import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'services/dio_client.dart';
import 'repositories/trayek_repository.dart';
import 'repositories/location_repository.dart';
import 'repositories/route_repository.dart';
import 'cubit/trayek_cubit.dart';
import 'cubit/history_cubit.dart';
import 'cubit/location_cubit.dart';
import 'cubit/route_cubit.dart';
import 'cubit/favorite_trayek_cubit.dart';
import 'bloc/nav_cubit.dart';
import 'cubit/artikel_cubit.dart';
import 'cubit/panduan_cubit.dart';
import 'cubit/laporan_cubit.dart';
import 'cubit/auth_cubit.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/beranda_page.dart';
import 'pages/info_trayek_page.dart';
import 'pages/search_route_page.dart';
import 'pages/route_result_page.dart';
import 'pages/akun_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/reports/create_report_page.dart';
import 'pages/reports/my_reports_page.dart';
import 'pages/guides/guide_list_page.dart';
import 'theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');

  final dio = DioClient.create();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => NavCubit()),
        RepositoryProvider<Dio>(create: (_) => dio),
        RepositoryProvider(
          create: (ctx) => TrayekRepository(ctx.read<Dio>()),
        ),
        RepositoryProvider(
          create: (ctx) => LocationRepository(ctx.read<Dio>()),
        ),
        RepositoryProvider(
          create: (ctx) => RouteRepository(ctx.read<Dio>()),
        ),
        BlocProvider(
          create: (ctx) => TrayekCubit(ctx.read<TrayekRepository>())..load(),
        ),
        BlocProvider(
          create: (_) => HistoryCubit(),
        ),
        BlocProvider(
          create: (ctx) => LocationCubit(ctx.read<LocationRepository>()),
        ),
        BlocProvider(
          create: (ctx) => RouteCubit(ctx.read<RouteRepository>()),
        ),
        BlocProvider(create: (_) => FavoriteTrayekCubit()),
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/beranda': (_) => const RootPage(),
        '/': (_) => const RootPage(),
        '/search-route': (_) => const SearchRoutePage(),
        '/profile': (_) => const ProfilePage(),
        '/settings': (_) => const SettingsPage(),
        '/reports/create': (_) => const CreateReportPage(),
        '/reports/my': (_) => const MyReportsPage(),
        '/guides': (_) => const GuideListPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/route-result') {
          final args = settings.arguments;
          if (args is Map) {
            final asal = (args['asal'] ?? '').toString();
            final tujuan = (args['tujuan'] ?? '').toString();
            return MaterialPageRoute(
              builder: (_) => RouteResultPage(asal: asal, tujuan: tujuan),
              settings: settings,
            );
          }
        }
        return null;
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

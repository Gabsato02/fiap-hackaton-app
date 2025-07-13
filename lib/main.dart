import 'package:fiap_hackaton_app/modules/goals/presentation/views/goals.dart';
import 'package:fiap_hackaton_app/modules/login/presentation/views/login.dart';
import 'package:fiap_hackaton_app/modules/production/presentation/views/production_dashboard.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/views/sales.dart';
import 'package:fiap_hackaton_app/modules/stock/presentation/views/stock.dart';
import 'package:fiap_hackaton_app/store/index.dart';
import 'package:flutter/material.dart';
import 'package:fiap_hackaton_app/modules/host/presentation/components/custom_appbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:fiap_hackaton_app/modules/notifications/presentation/views/notification_screen.dart';
import 'package:fiap_hackaton_app/services/notification_service.dart';
import 'package:fiap_hackaton_app/store/notification_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final notificationService = NotificationService();
  await notificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalState()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        Provider<NotificationService>(create: (_) => notificationService),
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) =>
            Login(clientId: DefaultFirebaseOptions.currentPlatform.apiKey),
        '/home': (context) => const HomeTabs(),
        '/notifications': (context) => const NotificationScreen(),
      },
    );
  }
}

class HomeTabs extends StatelessWidget {
  const HomeTabs({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: TabBarView(
          children: [
            Sales(),
            ProductionDashboard(),
            Stock(),
            Goals(),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.shopping_cart), text: "Vendas"),
            Tab(icon: Icon(Icons.agriculture), text: "Produção"),
            Tab(icon: Icon(Icons.inventory), text: "Estoque"),
            Tab(icon: Icon(Icons.flag), text: "Metas"),
          ],
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.transparent,
        ),
      ),
    );
  }
}

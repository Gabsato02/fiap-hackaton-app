import 'package:fiap_hackaton_app/modules/goals/presentation/views/goals.dart';
import 'package:fiap_hackaton_app/modules/login/presentation/views/login.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/views/sales.dart';
import 'package:fiap_hackaton_app/modules/stock/presentation/views/STOCK.dart';
import 'package:flutter/material.dart';
import 'package:fiap_hackaton_app/modules/host/presentation/components/custom_appbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
        '/login': (context) => Login(clientId: DefaultFirebaseOptions.currentPlatform.apiKey),
        '/home': (context) => const HomeTabs(),
      },
    );
  }
}

class HomeTabs extends StatelessWidget {
  const HomeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(),
        body: const TabBarView(
          children: [
            Sales(),
            Stock(),
            Goals(),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.shopping_cart), text: "Vendas"),
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

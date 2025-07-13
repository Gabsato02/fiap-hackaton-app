import 'package:fiap_hackaton_app/domain/entities/index.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_chart.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_list.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_modal.dart';
import 'package:flutter/material.dart';
import 'package:fiap_hackaton_app/store/index.dart';
import 'package:provider/provider.dart';
import 'package:fiap_hackaton_app/modules/sales/infrastructure/repositories/index.dart';
import 'package:fiap_hackaton_app/domain/entities/goal.dart';
import 'package:fiap_hackaton_app/domain/entities/app_notification.dart';
import 'package:fiap_hackaton_app/services/notification_service.dart';
import 'package:fiap_hackaton_app/store/notification_provider.dart';
import 'package:intl/intl.dart';

class Sales extends StatefulWidget {
  const Sales({Key? key}) : super(key: key);
  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  List<Product> products = [];
  List<Sale> sales = [];
  Map<String, int> groupedSales = {};
  bool isLoading = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userId = context.read<GlobalState>().userInfo?.id;
      if (userId != null) {
        _fetchSales();
      }
    });
    _fetchProducts();
  }

  Map<String, int> groupSalesByProduct(List<Sale> sales) {
    final Map<String, int> result = {};
    for (final sale in sales) {
      final String productName = sale.product_name;
      final int total = sale.total_price;
      if (result.containsKey(productName)) {
        result[productName] = result[productName]! + total;
      } else {
        result[productName] = total;
      }
    }
    return result;
  }

  Future<void> _fetchProducts() async {
    try {
      final snapshot = await FirestoreService.getStockProducts();
      List<Product> stockProducts = snapshot.docs.map((doc) {
        return Product.fromJson(doc.id, doc.data());
      }).toList();
      setState(() {
        products = stockProducts;
      });
    } catch (e) {
      print('Erro ao buscar produtos: $e');
    }
  }

  Future<void> _fetchSales() async {
    if (userId == null) return;
    setState(() {
      isLoading = true;
    });
    try {
      final snapshot = await FirestoreService.getUserSales(userId!);
      List<Sale> userSales = snapshot.docs.map((doc) {
        return Sale.fromJson(doc.id, doc.data());
      }).toList();
      setState(() {
        sales = userSales;
        isLoading = false;
        groupedSales = groupSalesByProduct(sales);
      });
    } catch (e) {
      print('Erro ao buscar vendas: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> handleSaveSale(Sale sale) async {
    Map<String, num> previousGoalValues = await _getCurrentGoalValues();

    final payload = sale;
    if (payload.sale_id == null || payload.sale_id!.isEmpty) {
      await FirestoreService.saveSale(payload.toJson());
    } else {
      await FirestoreService.editSale(payload.sale_id!, payload.toJson());
    }
    final product = products.firstWhere((p) => p.id == sale.product_id);
    final newQuantity = product.quantity - sale.product_quantity;
    await FirestoreService.updateProductQuantity(sale.product_id, newQuantity);

    await _fetchSales();
    await _fetchProducts();

    await _checkSalesGoals(previousGoalValues);
  }

  Future<Map<String, num>> _getCurrentGoalValues() async {
    if (userId == null) return {};
    final goalsSnapshot = await FirestoreService.getGoals(userId!);
    final salesGoals = goalsSnapshot.docs
        .map((doc) => Goal.fromFirestore(doc))
        .where((g) => g.type == 'sales')
        .toList();

    final Map<String, num> goalValues = {};
    for (var goal in salesGoals) {
      final salesSnapshot = await FirestoreService.getSalesByDateRange(
          userId!, goal.startDate, goal.endDate);
      final totalSales = salesSnapshot.docs
          .map((doc) => Sale.fromJson(doc.id, doc.data()))
          .fold<num>(0, (sum, sale) => sum + sale.total_price);
      goalValues[goal.id] = totalSales;
    }
    return goalValues;
  }

  Future<void> _checkSalesGoals(Map<String, num> previousGoalValues) async {
    if (userId == null || !mounted) return;
    try {
      final goalsSnapshot = await FirestoreService.getGoals(userId!);
      final salesGoals = goalsSnapshot.docs
          .map((doc) => Goal.fromFirestore(doc))
          .where((g) => g.type == 'sales')
          .toList();

      if (salesGoals.isEmpty) return;

      final allUserSales = sales;

      for (var goal in salesGoals) {
        final salesForGoal = allUserSales.where((s) {
          try {
            final saleDate = DateTime.parse(s.date);
            return saleDate.isAfter(
                    goal.startDate.subtract(const Duration(days: 1))) &&
                saleDate.isBefore(goal.endDate.add(const Duration(days: 1)));
          } catch (e) {
            return false;
          }
        });
        final currentSalesValue =
            salesForGoal.fold<num>(0, (sum, s) => sum + s.total_price);

        final previousValue = previousGoalValues[goal.id] ?? 0;

        if (currentSalesValue >= goal.targetValue &&
            previousValue < goal.targetValue) {
          final notificationProvider = context.read<NotificationProvider>();
          final notificationService = context.read<NotificationService>();

          final notification = AppNotification(
            title: '🏆 Meta de Vendas Atingida!',
            body:
                'Parabéns! Você atingiu sua meta "${goal.title}" com ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(currentSalesValue)}.',
            receivedTime: DateTime.now(),
          );

          notificationProvider.addNotification(notification);

          notificationService.showNotification(
              id: goal.id.hashCode,
              title: notification.title,
              body: notification.body);
        }
      }
    } catch (e) {
      print("Erro ao verificar metas de vendas: $e");
    }
  }

  void _openSalesModal(Sale? currentSale) {
    showDialog(
      context: context,
      builder: (context) => SalesModal(
        open: true,
        onClose: () => Navigator.of(context).pop(),
        onSave: (Sale sale) async {
          await handleSaveSale(sale);
          Navigator.of(context).pop();
        },
        products: products,
        currentSale: currentSale,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: products.isEmpty ? null : () => _openSalesModal(null),
        label: const Text('Adicionar Venda'),
        icon: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SalesChart(
              title: 'Vendas por produto',
              data: groupedSales,
              isLoading: isLoading,
            ),
            const SizedBox(height: 32),
            SalesList(
              sales: sales,
              isLoading: isLoading,
              refreshList: _fetchSales,
              openSalesModal: (context, sale) async {
                _openSalesModal(sale);
              },
            ),
          ],
        ),
      ),
    );
  }
}

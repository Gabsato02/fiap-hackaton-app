import 'package:fiap_hackaton_app/domain/entities/index.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_chart.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_list.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_modal.dart';
import 'package:flutter/material.dart';
import 'package:fiap_hackaton_app/store/index.dart';
import 'package:provider/provider.dart'; // ajuste o path conforme necessário
import 'package:fiap_hackaton_app/modules/sales/infrastructure/repositories/index.dart';

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

import 'package:fiap_hackaton_app/modules/sales/domain/entities/index.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_chart.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_list.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_modal.dart';
import 'package:flutter/material.dart';

class Sales extends StatefulWidget {
  const Sales({Key? key}) : super(key: key);

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  final List<Product> products = [
    Product(id: '1', name: 'Produto A', price: 12.5),
    Product(id: '2', name: 'Produto B', price: 9.99),
  ];

  List<Sale> sales = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSales();
  }

  Future<void> _fetchSales() async {
    isLoading = true;
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      sales = [
        Sale(
          id: 's1',
          date: '2025-07-01T10:00:00Z',
          totalPrice: '75.00',
          productPrice: 25,
          productQuantity: 3,
          productId: '1',
          sellerId: 'u1',
        ),
        Sale(
          id: 's2',
          date: '2025-07-02T14:30:00Z',
          totalPrice: '45.00',
          productPrice: 15,
          productQuantity: 3,
          productId: '2',
          sellerId: 'u2',
        ),
        Sale(
          id: 's3',
          date: '2025-07-03T09:15:00Z',
          totalPrice: '120.00',
          productPrice: 40,
          productQuantity: 3,
          productId: '3',
          sellerId: 'u1',
        ),
      ];

      isLoading = false;
    });
  }

  void _openSalesModal() {
    showDialog(
      context: context,
      builder: (context) => SalesModal(
        open: true,
        onClose: () => Navigator.of(context).pop(),
        products: products,
        currentSale: null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final salesData = {
      'Produto A': 50.0,
      'Produto B': 30.0,
    };

    final chartColors = [Colors.blue, Colors.orange];

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openSalesModal,
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
              data: salesData,
              colors: chartColors,
              isLoading: isLoading, 
            ),
            const SizedBox(height: 32),
            SalesList(sales: sales, isLoading: isLoading),
          ],
        ),
      ),
    );
  }
}

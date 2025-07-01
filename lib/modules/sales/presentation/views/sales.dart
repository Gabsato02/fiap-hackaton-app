import 'package:fiap_hackaton_app/modules/sales/domain/entities/index.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_list.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_modal.dart';
import 'package:flutter/material.dart';

// Supondo que você já criou SalesModal e Product

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
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

  // Exemplo de produtos mockados
  final List<Product> products = [
    Product(id: '1', name: 'Produto A', price: 12.5),
    Product(id: '2', name: 'Produto B', price: 9.99),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openSalesModal,
        label: const Text('Adicionar Venda'),
        icon: const Icon(Icons.add),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SalesList(),
      ),
    );
  }
}

import 'package:fiap_hackaton_app/modules/sales/domain/entities/index.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_card.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_filter.dart';
import 'package:flutter/material.dart';

class SalesList extends StatelessWidget {
  final List<Sale> sales;
  final bool isLoading;

  const SalesList({
    super.key,
    required this.sales,
    this.isLoading = false,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 88),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Histórico de Vendas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 16),
          const SalesFilter(),
          const SizedBox(height: 8),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (!isLoading && sales.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('Nenhuma venda encontrada')),
            ),
          if (!isLoading)
            ...sales.map((sale) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: SalesCard(sale: sale),
                )),
        ],
      ),
    );
  }
}

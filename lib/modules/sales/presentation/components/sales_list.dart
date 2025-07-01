import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_card.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_filter.dart';
import 'package:flutter/material.dart';

class SalesList extends StatelessWidget {
  const SalesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
      itemCount: 5,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
            Text(
              'Histórico de Vendas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SalesFilter(),
            const SizedBox(height: 8),
          ]);
        }

        return const SalesCard();
      },
      separatorBuilder: (context, index) => const SizedBox(height: 4),
    );
  }
}

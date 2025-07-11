import 'package:fiap_hackaton_app/domain/entities/index.dart';
import 'package:fiap_hackaton_app/utils/index.dart';
import 'package:flutter/material.dart';

class SalesCard extends StatelessWidget {
  final Sale sale;
  final void Function(BuildContext context, Sale sale) onDeletePressed;

  const SalesCard({
    super.key,
    required this.sale,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sale.product_name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                Text(formatDate(sale.date)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${sale.product_quantity} vendidos'),
                Text('R\$ ${sale.total_price}'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  onPressed: () {},
                  child: const Text('Editar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    onDeletePressed(context, sale);
                  },
                  child: const Text('Excluir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

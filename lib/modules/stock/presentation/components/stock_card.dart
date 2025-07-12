import 'package:flutter/material.dart';
import 'package:fiap_hackaton_app/domain/entities/index.dart';
import 'package:intl/intl.dart';

class StockCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StockCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatCurrency(int value) {
    final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return format.format(value / 100);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text('${product.quantity} unidades'),
                  avatar: const Icon(Icons.inventory_2_outlined),
                  backgroundColor: Colors.blue.shade100,
                ),
                Chip(
                  label: Text(_formatCurrency(product.price)),
                  avatar: const Icon(Icons.price_change_outlined),
                  backgroundColor: Colors.green.shade100,
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text('Excluir',
                      style: TextStyle(color: Colors.red)),
                  onPressed: onDelete,
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Editar'),
                  onPressed: onEdit,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

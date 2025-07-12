import 'package:fiap_hackaton_app/domain/entities/production.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductionCard extends StatelessWidget {
  final Production item;
  final Function(String newStatus) onUpdateStatus;
  final VoidCallback onEdit;

  const ProductionCard({
    super.key,
    required this.item,
    required this.onUpdateStatus,
    required this.onEdit,
  });

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    bool canEdit = item.status != 'harvested';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.productName,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800]),
                  ),
                ),
                if (canEdit)
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.grey[700]),
                    onPressed: onEdit,
                    tooltip: 'Editar',
                  ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantidade: ${item.quantity}',
                    style: TextStyle(fontSize: 16)),
                Text('Início: ${_formatDate(item.creationDate)}',
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            SizedBox(height: 16),
            _buildActionRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow() {
    if (item.status == 'waiting') {
      return Align(
        alignment: Alignment.centerRight,
        child: FilledButton.icon(
          icon: Icon(Icons.play_arrow),
          label: Text('Iniciar Produção'),
          onPressed: () => onUpdateStatus('in_production'),
          style: FilledButton.styleFrom(backgroundColor: Colors.orange),
        ),
      );
    } else if (item.status == 'in_production') {
      return Align(
        alignment: Alignment.centerRight,
        child: FilledButton.icon(
          icon: Icon(Icons.agriculture),
          label: Text('Colher'),
          onPressed: () => onUpdateStatus('harvested'),
          style: FilledButton.styleFrom(backgroundColor: Colors.green),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerRight,
        child: Chip(
          label: Text('Colhido', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.grey,
          avatar: Icon(Icons.check_circle, color: Colors.white),
        ),
      );
    }
  }
}

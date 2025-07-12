import 'package:fiap_hackaton_app/domain/entities/goal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yy').format(date);
  }

  String _formatValue(num value) {
    if (goal.type == 'sales') {
      final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

      return format.format(value);
    }
    return '${value.toInt()} un';
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        (goal.targetValue > 0) ? goal.currentValue / goal.targetValue : 0.0;
    final bool isSales = goal.type == 'sales';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
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
                    goal.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSales ? Colors.green[800] : Colors.blue[800],
                    ),
                  ),
                ),
                Text(
                  '${_formatDate(goal.startDate)} - ${_formatDate(goal.endDate)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                  isSales ? Colors.green : Colors.blue),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progresso: ${_formatValue(goal.currentValue)}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Meta: ${_formatValue(goal.targetValue)}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                  tooltip: 'Excluir Meta',
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Editar'),
                  onPressed: onEdit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

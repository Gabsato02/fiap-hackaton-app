import 'package:fiap_hackaton_app/modules/sales/domain/entities/index.dart';
import 'package:fiap_hackaton_app/utils/index.dart';
import 'package:flutter/material.dart';

class SalesCard extends StatelessWidget {
  final Sale sale;
  const SalesCard({super.key, required this.sale});

  void _onDeletePressed(BuildContext context) async {
    final confirmed = await showConfirmDialog(
        context, 'Confirmar exclusão', 'Tem certeza que deseja apagar?');

    if (confirmed == true) {
      // usuário confirmou
      print('Excluindo...');
    } else {
      // cancelou ou fechou o modal
      print('Cancelado');
    }
  }

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
                  'Venda',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                Text(sale.date),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${sale.productQuantity} vendidos'),
                Text('R\$ ${sale.totalPrice}'),
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
                    _onDeletePressed(context);
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

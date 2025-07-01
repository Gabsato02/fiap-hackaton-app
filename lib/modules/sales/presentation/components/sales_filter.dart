import 'package:flutter/material.dart';

class SalesFilter extends StatelessWidget {
  const SalesFilter({super.key});

  final List<Map<String, String>> filters = const [
    {'value': 'name', 'label': 'Nome'},
    {'value': 'product_quantity', 'label': 'Quantidade'},
    {'value': 'date', 'label': 'Data'},
    {'value': 'total_price', 'label': 'Valor'},
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Ordenar por',
        border: OutlineInputBorder(),
      ),
      items: filters
          .map(
            (filter) => DropdownMenuItem<String>(
              value: filter['value'],
              child: Text(filter['label']!),
            ),
          )
          .toList(),
      onChanged: (value) {
        debugPrint('Selecionado: $value');
      },
    );
  }
}

import 'package:flutter/material.dart';

class SalesFilter extends StatelessWidget {
  final void Function(String sortBy, bool ascending) onFilterChange;

  const SalesFilter({super.key, required this.onFilterChange});

  @override
  Widget build(BuildContext context) {
    final filters = const [
      {'value': 'name', 'label': 'Nome'},
      {'value': 'product_quantity', 'label': 'Quantidade'},
      {'value': 'date', 'label': 'Data'},
      {'value': 'total_price', 'label': 'Valor'},
    ];

    return _SalesFilterStateful(
        filters: filters, onFilterChange: onFilterChange);
  }
}

class _SalesFilterStateful extends StatefulWidget {
  final List<Map<String, String>> filters;
  final void Function(String, bool) onFilterChange;

  const _SalesFilterStateful({
    required this.filters,
    required this.onFilterChange,
  });

  @override
  State<_SalesFilterStateful> createState() => _SalesFilterStatefulState();
}

class _SalesFilterStatefulState extends State<_SalesFilterStateful> {
  String selectedValue = 'date';
  bool ascending = false;

  void _toggleOrder() {
    setState(() {
      ascending = !ascending;
      widget.onFilterChange(selectedValue, ascending);
    });
  }

  @override
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFilterChange(selectedValue, ascending);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedValue,
              decoration: const InputDecoration(
                labelText: 'Ordenar por',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              items: widget.filters.map((filter) {
                return DropdownMenuItem<String>(
                  value: filter['value'],
                  child: Text(filter['label']!),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedValue = value);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.onFilterChange(value, ascending);
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              ascending ? Icons.arrow_upward : Icons.arrow_downward,
            ),
            tooltip: ascending ? 'Ordem crescente' : 'Ordem decrescente',
            onPressed: _toggleOrder,
          ),
        ],
      ),
    );
  }
}

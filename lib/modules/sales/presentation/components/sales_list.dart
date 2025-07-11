import 'package:fiap_hackaton_app/domain/entities/index.dart';
import 'package:fiap_hackaton_app/modules/sales/infrastructure/repositories/index.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_card.dart';
import 'package:fiap_hackaton_app/modules/sales/presentation/components/sales_filter.dart';
import 'package:fiap_hackaton_app/utils/index.dart';
import 'package:flutter/material.dart';

class SalesList extends StatefulWidget {
  final List<Sale> sales;
  final bool isLoading;
  final Future<void> Function() refreshList;
  final Future<void> Function(BuildContext context, Sale sale) openSalesModal;

  const SalesList({
    super.key,
    required this.sales,
    this.isLoading = false,
    required this.refreshList,
    required this.openSalesModal,
  });

  @override
  State<SalesList> createState() => _SalesListState();
}

class _SalesListState extends State<SalesList> {
  late List<Sale> _sortedSales;

  @override
  void initState() {
    super.initState();
    _sortedSales = List.from(widget.sales);
  }

  @override
  void didUpdateWidget(covariant SalesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sales != oldWidget.sales) {
      _sortedSales = List.from(widget.sales);
    }
  }

  void _onFilterChange(String sortBy, bool ascending) {
    setState(() {
      _sortedSales.sort((a, b) {
        int result;
        switch (sortBy) {
          case 'name':
            result = a.product_name.compareTo(b.product_name);
            break;
          case 'product_quantity':
            result = a.product_quantity.compareTo(b.product_quantity);
            break;
          case 'date':
            result = a.date.compareTo(b.date);
            break;
          case 'total_price':
            result = a.total_price.compareTo(b.total_price);
            break;
          default:
            result = 0;
        }
        return ascending ? result : -result;
      });
    });
  }

  Future<void> _onDeletePressed(BuildContext context, Sale sale) async {
    final confirmed = await showConfirmDialog(
        context, 'Confirmar exclusão', 'Tem certeza que deseja apagar?');

    if (confirmed == true) {
      await FirestoreService.deleteSale(sale.id!);
      await widget.refreshList();
    }
  }

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
          SalesFilter(onFilterChange: _onFilterChange),
          const SizedBox(height: 8),
          if (widget.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (!widget.isLoading && _sortedSales.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('Nenhuma venda encontrada')),
            ),
          if (!widget.isLoading)
            ..._sortedSales.map((sale) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: SalesCard(
                    sale: sale,
                    onDeletePressed: (context, sale) =>
                        _onDeletePressed(context, sale),
                    onEditPressed: (context, sale) =>
                        widget.openSalesModal(context, sale),
                  ),
                )),
        ],
      ),
    );
  }
}

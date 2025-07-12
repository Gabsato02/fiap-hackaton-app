import 'package:fiap_hackaton_app/modules/stock/presentation/components/stock_card.dart';
import 'package:fiap_hackaton_app/modules/stock/presentation/components/stock_chart.dart';
import 'package:fiap_hackaton_app/modules/stock/presentation/components/stock_modal.dart';
import 'package:fiap_hackaton_app/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:fiap_hackaton_app/domain/entities/index.dart';
import 'package:fiap_hackaton_app/modules/sales/infrastructure/repositories/index.dart';
import 'package:intl/intl.dart';

class Stock extends StatefulWidget {
  const Stock({super.key});

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  bool _isLoading = true;
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchStockData();
  }

  Future<void> _fetchStockData() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await FirestoreService.getAllStockProducts();
      final products = snapshot.docs
          .map((doc) => Product.fromJson(doc.id, doc.data()))
          .toList();
      setState(() {
        _products = products;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao buscar estoque: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  int get _totalStockValue {
    if (_products.isEmpty) return 0;
    return _products.map((p) => p.price * p.quantity).reduce((a, b) => a + b);
  }

  String get _formattedTotalStockValue {
    final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return format.format(_totalStockValue / 100);
  }

  void _openStockModal(Product? product) {
    showDialog(
      context: context,
      builder: (_) => StockModal(
        open: true,
        onClose: () => Navigator.of(context).pop(),
        onSave: _handleSaveStock,
        currentProduct: product,
      ),
    );
  }

  Future<void> _handleSaveStock(Map<String, dynamic> data, String? id) async {
    try {
      if (id == null) {
        await FirestoreService.addProduct(data);
      } else {
        await FirestoreService.updateProduct(id, data);
      }
      _fetchStockData();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar produto: $e')));
    }
  }

  Future<void> _handleDeleteStock(String id) async {
    final confirmed = await showConfirmDialog(context, 'Confirmar Exclusão',
        'Tem certeza que deseja remover este produto do catálogo? Esta ação não pode ser desfeita.');

    if (confirmed == true) {
      try {
        await FirestoreService.deleteProduct(id);
        _fetchStockData();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir produto: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openStockModal(null),
        label: const Text('Novo Produto'),
        icon: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchStockData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      color: Colors.green[600],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Valor Total em Estoque',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            Text(_formattedTotalStockValue,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Distribuição por Quantidade',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    StockChart(products: _products),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Itens no Catálogo',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    if (_products.isEmpty)
                      const Center(
                          child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text('Nenhum produto no estoque.')))
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          return StockCard(
                            product: product,
                            onEdit: () => _openStockModal(product),
                            onDelete: () => _handleDeleteStock(product.id),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

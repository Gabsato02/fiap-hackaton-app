import 'package:fiap_hackaton_app/domain/entities/index.dart';
import 'package:fiap_hackaton_app/modules/production/presentation/components/production_card.dart';
import 'package:fiap_hackaton_app/modules/production/presentation/components/production_modal.dart';
import 'package:flutter/material.dart';
import 'package:fiap_hackaton_app/domain/entities/production.dart';
import 'package:fiap_hackaton_app/modules/sales/infrastructure/repositories/index.dart';

class ProductionDashboard extends StatefulWidget {
  const ProductionDashboard({super.key});

  @override
  State<ProductionDashboard> createState() => _ProductionDashboardState();
}

class _ProductionDashboardState extends State<ProductionDashboard> {
  bool _isLoading = true;
  List<Production> _productions = [];
  List<Product> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    setState(() => _isLoading = true);
    try {
      await Future.wait([_fetchProductions(), _fetchProducts()]);
    } catch (e) {
      print("Erro ao buscar dados iniciais: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchProducts() async {
    final snapshot = await FirestoreService.getAllStockProducts();
    final products = snapshot.docs
        .map((doc) => Product.fromJson(doc.id, doc.data()))
        .toList();
    setState(() => _allProducts = products);
  }

  Future<void> _fetchProductions() async {
    final snapshot = await FirestoreService.getProductions();
    final productions =
        snapshot.docs.map((doc) => Production.fromFirestore(doc)).toList();
    setState(() => _productions = productions);
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await _fetchProductions();
    setState(() => _isLoading = false);
  }

  Future<void> _updateProductionStatus(
      Production item, String newStatus) async {
    if (newStatus == 'harvested') {
      await _harvest(item);
    } else {
      await FirestoreService.updateProductionStatus(item.id, newStatus);
    }
    await _fetchProductions();
  }

  Future<void> _handleSaveProduction(
      Map<String, dynamic> data, String? id) async {
    try {
      if (id == null) {
        await FirestoreService.addProduction(data);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produção adicionada com sucesso!')));
      } else {
        await FirestoreService.updateProduction(id, data);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produção atualizada com sucesso!')));
      }
      await _fetchProductions();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
    }
  }

  void _openProductionModal(Production? item) {
    showDialog(
      context: context,
      builder: (_) => ProductionModal(
        open: true,
        onClose: () => Navigator.of(context).pop(),
        onSave: _handleSaveProduction,
        products: _allProducts,
        currentProduction: item,
      ),
    );
  }

  Future<void> _harvest(Production item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Colheita'),
        content: Text(
            'Isso irá mover ${item.quantity} unidade(s) de ${item.productName} para o estoque. Deseja continuar?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Confirmar')),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirestoreService.harvestProduction(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produção colhida e estoque atualizado!')),
        );
        await _fetchProductions();
      } catch (e) {
        print("Erro ao colher: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao realizar a colheita: $e')),
        );
      }
    }
  }

  Widget _buildProductionList(String title, String status) {
    final items = _productions.where((p) => p.status == status).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        if (_isLoading)
          const Center(child: Padding(padding: EdgeInsets.all(20.0)))
        else if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Center(child: Text('Nenhum item nesta categoria.')),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ProductionCard(
                item: item,
                onUpdateStatus: (newStatus) =>
                    _updateProductionStatus(item, newStatus),
                onEdit: () =>
                    _openProductionModal(item), // Passa a função de edição
              );
            },
          ),
        Divider(height: 32),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openProductionModal(null),
        label: const Text('Adicionar Produção'),
        icon: const Icon(Icons.add),
      ),
      body: _isLoading && _productions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 80),
                child: Column(
                  children: [
                    _buildProductionList('🌱 Aguardando Início', 'waiting'),
                    _buildProductionList('🚜 Em Produção', 'in_production'),
                    _buildProductionList('✅ Já Colhido', 'harvested'),
                  ],
                ),
              ),
            ),
    );
  }
}

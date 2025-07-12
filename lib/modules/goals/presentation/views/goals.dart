import 'package:fiap_hackaton_app/domain/entities/goal.dart';
import 'package:fiap_hackaton_app/domain/entities/index.dart';
import 'package:fiap_hackaton_app/modules/goals/presentation/components/goal_card.dart';
import 'package:fiap_hackaton_app/modules/goals/presentation/components/goal_modal.dart';
import 'package:fiap_hackaton_app/modules/sales/infrastructure/repositories/index.dart';
import 'package:fiap_hackaton_app/store/index.dart';
import 'package:fiap_hackaton_app/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  bool _isLoading = true;
  List<Goal> _goals = [];
  String? _userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userId = context.read<GlobalState>().userInfo?.id;
      if (_userId != null) {
        _fetchAndProcessGoals();
      }
    });
  }

  Future<void> _fetchAndProcessGoals() async {
    if (_userId == null) return;
    setState(() => _isLoading = true);

    try {
      final goalsSnapshot = await FirestoreService.getGoals(_userId!);
      final goals =
          goalsSnapshot.docs.map((doc) => Goal.fromFirestore(doc)).toList();

      for (var goal in goals) {
        if (goal.type == 'sales') {
          final salesSnapshot = await FirestoreService.getSalesByDateRange(
              _userId!, goal.startDate, goal.endDate);
          final totalSales = salesSnapshot.docs
              .map((doc) => Sale.fromJson(doc.id, doc.data()))
              .fold<num>(0, (sum, sale) => sum + sale.total_price);
          goal.currentValue = totalSales;
        } else if (goal.type == 'production') {
          final productionsSnapshot =
              await FirestoreService.getHarvestedProductionsByDateRange(
                  goal.startDate, goal.endDate);
          final totalQuantity = productionsSnapshot.docs
              .fold<num>(0, (sum, doc) => sum + (doc.data()['quantity'] ?? 0));
          goal.currentValue = totalQuantity;
        }
      }

      setState(() {
        _goals = goals;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao carregar metas: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _openGoalModal(Goal? goal) {
    showDialog(
      context: context,
      builder: (_) => GoalModal(
        currentGoal: goal,
        onSave: _handleSaveGoal,
      ),
    );
  }

  Future<void> _handleSaveGoal(Map<String, dynamic> data, String? id) async {
    try {
      if (id == null) {
        await FirestoreService.addGoal(data);
      } else {
        await FirestoreService.updateGoal(id, data);
      }
      _fetchAndProcessGoals();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar meta: $e')));
    }
  }

  Future<void> _handleDeleteGoal(String id) async {
    final confirmed = await showConfirmDialog(
        context, 'Confirmar Exclusão', 'Deseja realmente excluir esta meta?');
    if (confirmed == true) {
      try {
        await FirestoreService.deleteGoal(id);
        _fetchAndProcessGoals();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro ao excluir meta: $e')));
      }
    }
  }

  Widget _buildGoalList(String title, String type, IconData icon) {
    final filteredGoals = _goals.where((g) => g.type == type).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.black54),
              const SizedBox(width: 8),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        if (filteredGoals.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(child: Text('Nenhuma meta definida.')),
          )
        else
          ...filteredGoals.map((goal) => GoalCard(
                goal: goal,
                onEdit: () => _openGoalModal(goal),
                onDelete: () => _handleDeleteGoal(goal.id),
              )),
        const Divider(height: 32),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openGoalModal(null),
        label: const Text('Nova Meta'),
        icon: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchAndProcessGoals,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                child: Column(
                  children: [
                    _buildGoalList(
                        'Metas de Vendas', 'sales', Icons.monetization_on),
                    _buildGoalList(
                        'Metas de Produção', 'production', Icons.agriculture),
                  ],
                ),
              ),
            ),
    );
  }
}

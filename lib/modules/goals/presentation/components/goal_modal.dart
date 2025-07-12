import 'package:fiap_hackaton_app/domain/entities/goal.dart';
import 'package:fiap_hackaton_app/store/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GoalModal extends StatefulWidget {
  final Goal? currentGoal;
  final Function(Map<String, dynamic> data, String? id) onSave;

  const GoalModal({super.key, this.currentGoal, required this.onSave});

  @override
  State<GoalModal> createState() => _GoalModalState();
}

class _GoalModalState extends State<GoalModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _targetController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  String _goalType = 'sales';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _targetController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();

    if (widget.currentGoal != null) {
      final goal = widget.currentGoal!;
      _titleController.text = goal.title;
      _targetController.text = goal.targetValue.toString();
      _goalType = goal.type;
      _startDate = goal.startDate;
      _endDate = goal.endDate;
      _updateDateControllers();
    }
  }

  void _updateDateControllers() {
    final format = DateFormat('dd/MM/yyyy');
    if (_startDate != null) {
      _startDateController.text = format.format(_startDate!);
    }
    if (_endDate != null) {
      _endDateController.text = format.format(_endDate!);
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final userId = context.read<GlobalState>().userInfo?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: Usuário não encontrado.')));
      setState(() => _isLoading = false);
      return;
    }

    final data = {
      'title': _titleController.text,
      'type': _goalType,
      'targetValue': int.parse(_targetController.text),
      'startDate': _startDate,
      'endDate': _endDate,
      'userId': userId,
    };

    await widget.onSave(data, widget.currentGoal?.id);

    setState(() => _isLoading = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isSales = _goalType == 'sales';
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.currentGoal == null ? 'Nova Meta' : 'Editar Meta',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título da Meta',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _goalType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Meta',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'sales', child: Text('Vendas')),
                    DropdownMenuItem(
                        value: 'production', child: Text('Produção')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _goalType = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _targetController,
                  decoration: InputDecoration(
                    labelText: isSales
                        ? 'Valor Alvo (em centavos)'
                        : 'Quantidade Alvo',
                    border: const OutlineInputBorder(),
                    prefixText: isSales ? 'R\$ ' : null,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _startDateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Data de Início',
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() {
                              _startDate = date;
                              _updateDateControllers();
                            });
                          }
                        },
                        validator: (v) =>
                            v!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _endDateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Data Final',
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate:
                                _endDate ?? _startDate ?? DateTime.now(),
                            firstDate: _startDate ?? DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() {
                              _endDate = date;
                              _updateDateControllers();
                            });
                          }
                        },
                        validator: (v) =>
                            v!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _isLoading ? null : _handleSave,
                      child: _isLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Salvar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

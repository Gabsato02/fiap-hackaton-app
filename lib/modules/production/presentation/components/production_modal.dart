import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiap_hackaton_app/domain/entities/index.dart';
import 'package:fiap_hackaton_app/domain/entities/production.dart';

class ProductionModal extends StatefulWidget {
  final bool open;
  final VoidCallback onClose;
  final Future<void> Function(Map<String, dynamic> data, String? id) onSave;
  final List<Product> products;
  final Production? currentProduction;

  const ProductionModal({
    super.key,
    required this.open,
    required this.onClose,
    required this.onSave,
    required this.products,
    this.currentProduction,
  });

  @override
  State<ProductionModal> createState() => _ProductionModalState();
}

class _ProductionModalState extends State<ProductionModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  String? _selectedProductId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _populateForm();
  }

  @override
  void didUpdateWidget(covariant ProductionModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentProduction != oldWidget.currentProduction) {
      _populateForm();
    }
  }

  void _populateForm() {
    if (widget.currentProduction != null) {
      _selectedProductId = widget.currentProduction!.productId;
      _quantityController.text = widget.currentProduction!.quantity.toString();
    } else {
      _selectedProductId = null;
      _quantityController.text = '1';
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProductId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um produto.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final selectedProduct =
        widget.products.firstWhere((p) => p.id == _selectedProductId);
    final data = {
      'productId': _selectedProductId,
      'productName': selectedProduct.name,
      'quantity': int.parse(_quantityController.text),
      'status': widget.currentProduction?.status ?? 'waiting',
      'creationDate': widget.currentProduction?.creationDate ?? DateTime.now(),
    };

    await widget.onSave(data, widget.currentProduction?.id);

    setState(() => _isLoading = false);
    widget.onClose();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.open) return const SizedBox.shrink();

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.currentProduction != null
                      ? 'Editar Produção'
                      : 'Adicionar Produção',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: _selectedProductId,
                  decoration: const InputDecoration(
                    labelText: 'Produto',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.products.map((product) {
                    return DropdownMenuItem(
                      value: product.id,
                      child: Text(product.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedProductId = value);
                  },
                  validator: (value) =>
                      value == null ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Campo obrigatório';
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Insira um valor positivo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: widget.onClose,
                        child: const Text('Cancelar')),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _isLoading ? null : _handleSave,
                      child: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
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

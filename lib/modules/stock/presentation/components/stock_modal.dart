import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiap_hackaton_app/domain/entities/index.dart';

class StockModal extends StatefulWidget {
  final bool open;
  final VoidCallback onClose;
  final Future<void> Function(Map<String, dynamic> data, String? id) onSave;
  final Product? currentProduct;

  const StockModal({
    super.key,
    required this.open,
    required this.onClose,
    required this.onSave,
    this.currentProduct,
  });

  @override
  State<StockModal> createState() => _StockModalState();
}

class _StockModalState extends State<StockModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    _populateForm();
  }

  void _populateForm() {
    if (widget.currentProduct != null) {
      _nameController.text = widget.currentProduct!.name;
      _priceController.text = widget.currentProduct!.price.toString();
      _quantityController.text = widget.currentProduct!.quantity.toString();
    } else {
      _nameController.clear();
      _priceController.clear();
      _quantityController.clear();
    }
  }

  @override
  void didUpdateWidget(covariant StockModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentProduct != oldWidget.currentProduct) {
      _populateForm();
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final data = {
      'name': _nameController.text,
      'price': int.parse(_priceController.text),
      'quantity': int.parse(_quantityController.text),
    };

    await widget.onSave(data, widget.currentProduct?.id);

    setState(() => _isLoading = false);
    widget.onClose();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.open) return const SizedBox.shrink();

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
                  widget.currentProduct == null
                      ? 'Adicionar Produto'
                      : 'Editar Produto',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Nome do Produto',
                      border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                      labelText: 'Preço ',
                      border: OutlineInputBorder(),
                      prefixText: 'R\$ '),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                      labelText: 'Quantidade em Estoque',
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
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

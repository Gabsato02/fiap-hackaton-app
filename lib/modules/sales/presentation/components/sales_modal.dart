import 'package:fiap_hackaton_app/modules/sales/domain/entities/index.dart';
import 'package:flutter/material.dart';

class SalesModal extends StatefulWidget {
  final bool open;
  final void Function() onClose;
  final List<Product> products;
  final Sale? currentSale;

  const SalesModal({
    super.key,
    required this.open,
    required this.onClose,
    required this.products,
    this.currentSale,
  });

  @override
  State<SalesModal> createState() => _SalesModalState();
}

class _SalesModalState extends State<SalesModal> {
  String? productId;
  int quantity = 1;
  String date = '';

  @override
  void didUpdateWidget(SalesModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentSale != oldWidget.currentSale ||
        widget.open != oldWidget.open) {
      if (widget.currentSale != null) {
        productId = widget.currentSale!.productId;
        quantity = widget.currentSale!.quantity;
        date = widget.currentSale!.date;
      } else {
        productId = null;
        quantity = 1;
        date = '';
      }
    }
  }

  Product? get selectedProduct =>
      widget.products.firstWhere((p) => p.id == productId,
          orElse: () => Product(id: '', name: '', price: 0));

  double get unitPrice => selectedProduct?.price ?? 0;
  double get totalPrice => unitPrice * quantity;

  void handleSave() {
    debugPrint('Salvar venda');
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.open) return const SizedBox.shrink();

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.currentSale != null
                    ? 'Editar Venda - #${widget.currentSale!.id}'
                    : 'Adicionar Venda',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: 'Produto', border: OutlineInputBorder()),
                value: productId,
                onChanged: (value) => setState(() => productId = value),
                items: widget.products
                    .map((product) => DropdownMenuItem(
                          value: product.id,
                          child: Text(product.name),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Quantidade', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                initialValue: quantity.toString(),
                onChanged: (value) =>
                    setState(() => quantity = int.tryParse(value) ?? 1),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Data da venda', border: OutlineInputBorder()),
                initialValue: date,
                onChanged: (value) => setState(() => date = value),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Valor unitário (R\$)',
                          border: OutlineInputBorder()),
                      enabled: false,
                      initialValue: unitPrice.toStringAsFixed(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Valor total (R\$)',
                          border: OutlineInputBorder()),
                      enabled: false,
                      initialValue: totalPrice.toStringAsFixed(2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onClose,
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: handleSave,
                    child: const Text('Salvar'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

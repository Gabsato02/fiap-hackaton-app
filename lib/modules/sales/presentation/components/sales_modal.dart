import 'package:fiap_hackaton_app/domain/entities/index.dart';
import 'package:fiap_hackaton_app/store/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SalesModal extends StatefulWidget {
  final bool open;
  final void Function() onClose;
  final Future<void> Function(Sale) onSave;
  final List<Product> products;
  final Sale? currentSale;

  const SalesModal({
    super.key,
    required this.open,
    required this.onClose,
    required this.onSave,
    required this.products,
    this.currentSale,
  });

  @override
  State<SalesModal> createState() => _SalesModalState(onSave: onSave);
}

class _SalesModalState extends State<SalesModal> {
  final Future<void> Function(Sale) onSave;

  late TextEditingController _quantityController;
  late TextEditingController _dateController;

  String productId = '';
  int quantity = 1;
  DateTime? selectedDate;
  bool isLoading = false;

  _SalesModalState({required this.onSave});

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: quantity.toString());
    _dateController = TextEditingController(text: '');
    populateFromCurrentSale();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void populateFromCurrentSale() {
    if (widget.currentSale != null) {
      productId = widget.currentSale!.product_id;
      quantity = widget.currentSale!.product_quantity;
      selectedDate = DateTime.tryParse(widget.currentSale!.date);
    } else {
      productId = '';
      quantity = 1;
      selectedDate = null;
    }

    _quantityController.text = quantity.toString();
    _dateController.text = formattedDate;
  }

  @override
  void didUpdateWidget(SalesModal oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentSale != oldWidget.currentSale ||
        widget.open != oldWidget.open) {
      populateFromCurrentSale();
      setState(() {});
    }
  }

  Product? get selectedProduct {
    try {
      return widget.products.firstWhere((p) => p.id == productId);
    } catch (_) {
      return null;
    }
  }

  int get unitPrice => selectedProduct?.price ?? 0;
  int get totalPrice => unitPrice * quantity;

  String get formattedDate {
    if (selectedDate == null) return '';
    final day = selectedDate!.day.toString().padLeft(2, '0');
    final month = selectedDate!.month.toString().padLeft(2, '0');
    final year = selectedDate!.year;
    return '$day/$month/$year';
  }

  Future<void> handleSave() async {
    final userInfo = context.read<GlobalState>().userInfo;

    setState(() => isLoading = true);

    try {
      final payload = Sale(
        product_id: productId,
        product_name: selectedProduct?.name ?? '',
        product_quantity: quantity,
        product_price: unitPrice,
        date: selectedDate?.toIso8601String() ?? '',
        total_price: totalPrice,
        seller_id: userInfo!.id,
        sale_id: widget.currentSale?.id,
      );

      await onSave(payload);
    } catch (e) {
      print('Erro ao salvar: $e');
    } finally {
      setState(() => isLoading = false);
    }
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
              (widget.products.isEmpty)
                  ? const Text('Nenhum produto disponível')
                  : DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Produto',
                        border: OutlineInputBorder(),
                      ),
                      value: widget.products.any((p) => p.id == productId)
                          ? productId
                          : null,
                      onChanged: (value) {
                        setState(() {
                          productId = value!;
                          quantity = 1;
                          _quantityController.text = '1';
                        });
                      },
                      items: widget.products
                          .map((product) => DropdownMenuItem(
                                value: product.id,
                                child: Text(product.name),
                              ))
                          .toList(),
                    ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  int? parsed = int.tryParse(value);

                  if (parsed == null) {
                    setState(() => quantity = 1);
                    return;
                  }

                  final maxQuantity = selectedProduct?.quantity ?? 9999;
                  int corrected = parsed;

                  if (parsed < 1) corrected = 1;
                  if (parsed > maxQuantity) corrected = maxQuantity;

                  if (corrected != parsed) {
                    setState(() {
                      quantity = corrected;
                      _quantityController.text = corrected.toString();
                      _quantityController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: _quantityController.text.length),
                      );
                    });
                  } else {
                    setState(() {
                      quantity = parsed;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                controller: _dateController..text = formattedDate,
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (selected != null) {
                    setState(() {
                      selectedDate = selected;
                      _dateController.text = formattedDate;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Data da venda',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Valor unitário (R\$)',
                        border: OutlineInputBorder(),
                      ),
                      enabled: false,
                      controller: TextEditingController(
                        text: unitPrice.toStringAsFixed(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Valor total (R\$)',
                        border: OutlineInputBorder(),
                      ),
                      enabled: false,
                      controller: TextEditingController(
                        text: totalPrice.toStringAsFixed(2),
                      ),
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
                    onPressed: isLoading ? null : handleSave,
                    child: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(
    BuildContext context, String title, String message) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // cancelar
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true), // confirmar
          child: const Text('Confirmar'),
        ),
      ],
    ),
  );
}

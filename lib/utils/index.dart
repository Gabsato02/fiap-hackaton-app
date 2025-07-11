import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<bool?> showConfirmDialog(
  BuildContext context,
  String title,
  String message,
) {
  bool isLoading = false;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed:
                    isLoading ? null : () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() => isLoading = true);
                        await Future.delayed(
                            Duration(seconds: 2)); // simula processo
                        Navigator.of(context).pop(true);
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Confirmar'),
              ),
            ],
          );
        },
      );
    },
  );
}

String formatDate(String isoDateString) {
  final date = DateTime.parse(isoDateString);
  final formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(date);
}

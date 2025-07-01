import 'package:fiap_hackaton_app/utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  void _onLogoutPress(BuildContext context) async {
    final confirmed = await showConfirmDialog(
        context, 'Deslogar', 'Deseja sair? Você precisará fazer login novamente para acessar o sistema.');

    if (confirmed == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text('FIAP Farms'),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            _onLogoutPress(context);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

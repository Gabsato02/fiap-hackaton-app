import 'package:fiap_hackaton_app/store/notification_provider.dart';
import 'package:fiap_hackaton_app/utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  void _onLogoutPress(BuildContext context) async {
    final confirmed = await showConfirmDialog(context, 'Deslogar',
        'Deseja sair? Você precisará fazer login novamente para acessar o sistema.');
    if (confirmed == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final unreadCount = notificationProvider.unreadCount;

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('FIAP Farms'),
      actions: [
        badges.Badge(
          position: badges.BadgePosition.topEnd(top: 4, end: 4),
          showBadge: unreadCount > 0,
          badgeContent: Text(
            unreadCount.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
            tooltip: 'Notificações',
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            _onLogoutPress(context);
          },
          tooltip: 'Sair',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';

class TabsNavigation extends StatelessWidget {
  const TabsNavigation({super.key});

  static const tabs = [
    {
      'label': 'Vendas',
      'icon': Icons.point_of_sale,
    },
    {
      'label': 'Estoque',
      'icon': Icons.inventory,
    },
    {
      'label': 'Metas',
      'icon': Icons.flag,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabs.map((tab) {
        return Tab(
            icon: Icon(tab['icon'] as IconData), text: tab['label'] as String);
      }).toList(),
      labelColor: Colors.green,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.transparent,
    );
  }
}

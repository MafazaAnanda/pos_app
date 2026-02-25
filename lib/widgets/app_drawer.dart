import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
  
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'POS App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  'POS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                )
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),

          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Product'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          ),

          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text('Checkout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/checkout');
            },
          ),

          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('History'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/history');
            },
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('About Me'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'about');
            },
          ),
        ],
      ),
    );
  }
}
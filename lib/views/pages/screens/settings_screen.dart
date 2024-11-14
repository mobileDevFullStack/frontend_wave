import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Category
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Compte',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('Ajouter un autre compte'),
            onTap: () {
              // Implement navigation or functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Partager un ami à rejoindre wave'),
            onTap: () {
              // Implement navigation or functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: const Text('Vérifier votre plafond'),
            onTap: () {
              // Implement navigation or functionality
            },
          ),

          // Location Category
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Localisation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Trouver les agents à proximité'),
            onTap: () {
              // Implement navigation or functionality
            },
          ),

          // Security Category
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Sécurité',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Modifier votre code secret'),
            onTap: () {
              // Implement navigation or functionality
            },
          ),

          // Logout Option
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Déconnecter',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              // Implement logout functionality
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ScheduledTransfersListScreen extends StatelessWidget {
  ScheduledTransfersListScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> scheduledTransfers = [
    {"recipient": "0123456789", "amount": "1000", "date": "2024-11-08"},
    {"recipient": "0987654321", "amount": "500", "date": "2024-11-10"},
    // Ajoutez d'autres transferts planifiés ici
  ];

  void _cancelTransfer(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Annuler le transfert"),
          content: const Text("Êtes-vous sûr de vouloir annuler ce transfert ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Non"),
            ),
            TextButton(
              onPressed: () {
                // Implémentez la logique pour annuler le transfert ici
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Transfert annulé avec succès"),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text("Oui"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transferts Planifiés"),
      ),
      body: ListView.builder(
        itemCount: scheduledTransfers.length,
        itemBuilder: (context, index) {
          final transfer = scheduledTransfers[index];
          return ListTile(
            leading: const Icon(Icons.schedule_rounded, color: Colors.orange),
            title: Text("Destinataire : ${transfer['recipient']}"),
            subtitle: Text("Montant : ${transfer['amount']} - Date : ${transfer['date']}"),
            trailing: IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () => _cancelTransfer(context, index),
            ),
          );
        },
      ),
    );
  }
}

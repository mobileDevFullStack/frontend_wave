

import 'package:flutter/material.dart';
import 'package:waveflutterapp/views/pages/screens/schedule_transfer_screen.dart';
import 'package:waveflutterapp/views/pages/screens/schedule_transfert_listSreen.dart';
import 'package:waveflutterapp/views/pages/screens/send_money_screen.dart';
// Widget du menu des actions rapides
class QuickActionsMenu extends StatelessWidget {
  const QuickActionsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildQuickAction(
          context,
          // icon: Icons.send_rounded,
          icon: Icons.account_balance_wallet_rounded,
          label: "Crédit",
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SendMoneyScreen()),
            );
          },
        ),
        _buildQuickAction(
          context,
          icon: Icons.schedule_rounded,
          label: "Planifier",
          color: Colors.green,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScheduleTransferScreen()),
            );
          },
        ),
        _buildQuickAction(
          context,
          icon: Icons.list_rounded,
          label: "Transferts Planifiés",
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ScheduledTransfersListScreen()),
            );
          },
        ),
        _buildQuickAction(
          context,
          icon: Icons.receipt_long_rounded,
          label: "Factures",
          color: Colors.purple,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


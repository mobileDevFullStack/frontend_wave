import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waveflutterapp/views/pages/screens/profile_screen.dart';
import 'package:waveflutterapp/views/pages/screens/transfer_selection_screen.dart';
import 'package:waveflutterapp/views/pages/screens/scanner_qrcode_screen.dart';
import 'package:waveflutterapp/views/pages/widgets/menu_widget.dart';
import 'settings_screen.dart';
import '../widgets/walet_widget.dart';
import '../widgets/qr_code_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isBalanceVisible = false;
  int _selectedIndex = 0;

  void toggleBalanceVisibility() {
    setState(() {
      isBalanceVisible = !isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/elzo.jpeg'),
            radius: 16,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserProfileScreen()),
            );
          },

        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // Navigation vers les notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Widget du solde avec animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: WalletWidget(
                isBalanceVisible: isBalanceVisible,
                toggleBalanceVisibility: toggleBalanceVisibility,
                balance: "10,000",
                currency: "F",
              ),
            ),
            
            // Conteneur principal avec coins arrondis
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: const Column(
                  children:  [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: QuickActionsMenu(),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: QRCodeWidget(),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Transactions récentes",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Voir tout",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          if (index == 1) { 
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransferSelectionScreen()),
            );
          } else if (index == 2) { 
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QRScannerScreen()),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: 'Transferts',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner_outlined),
            selectedIcon: Icon(Icons.qr_code_scanner),
            label: 'Scanner',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),
    );
  }
}

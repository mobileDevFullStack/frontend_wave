
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'transfer_money_screen.dart'; // Assurez-vous d'avoir ce fichier

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({Key? key}) : super(key: key);

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoading = true;

  // Structure pour les favoris
  final List<Map<String, String>> _favorites = [
    {
      'name': 'Omar Dia Génie Pétrolier',
      'phone': '77 826 54 08',
    },
    {
      'name': 'Pitô Kara',
      'phone': '77 194 76 55',
    },
    {
      'name': 'Mousco Gning',
      'phone': '77 352 81 38',
    },
    {
      'name': 'Mouhamed ODC rassoul ODC',
      'phone': '78 534 29 48',
    },
    {
      'name': 'Mr Diallo',
      'phone': '78 475 16 39',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchContacts();
    
    _searchController.addListener(() {
      _filterContacts();
    });
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        final name = contact.displayName.toLowerCase();
        final phones = contact.phones.map((p) => p.number).join(' ').toLowerCase();
        return name.contains(query) || phones.contains(query);
      }).toList();
    });
  }

  Future<void> _fetchContacts() async {
    try {
      if (!await FlutterContacts.requestPermission(readonly: true)) {
        setState(() => _isLoading = false);
        return;
      }

      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
      );

      setState(() {
        _contacts = contacts;
        _filteredContacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors de la récupération des contacts: $e');
      setState(() => _isLoading = false);
    }
  }

  void _navigateToTransfer(String name, String phone) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransferMoneyScreen(
          contactName: name,
          phoneNumber: phone,
        ),
      ),
    );
  }

  void _addNewContact() {
    // Logique pour ajouter un nouveau contact
    print("Ajouter un nouveau contact");
  }

  void _scanQRCode() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRViewExample(),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Envoyer de l'Argent"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _addNewContact, // Bouton pour ajouter un contact
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanQRCode, // Bouton pour scanner un QR code
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Rechercher un contact',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: const [
              Tab(text: 'Favoris'),
              Tab(text: 'Contacts'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Section Favoris avec navigation
                ListView.builder(
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final favorite = _favorites[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(favorite['name']!),
                      subtitle: Text(favorite['phone']!),
                      onTap: () => _navigateToTransfer(
                        favorite['name']!,
                        favorite['phone']!,
                      ),
                    );
                  },
                ),
                // Section Contacts
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredContacts.isEmpty
                        ? const Center(child: Text('Aucun contact trouvé'))
                        : ListView.builder(
                            itemCount: _filteredContacts.length,
                            itemBuilder: (context, index) {
                              final contact = _filteredContacts[index];
                              return ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(contact.displayName),
                                subtitle: Text(
                                  contact.phones.isNotEmpty
                                      ? contact.phones.first.number
                                      : 'Pas de numéro'
                                ),
                                onTap: () {
                                  if (contact.phones.isNotEmpty) {
                                    _navigateToTransfer(
                                      contact.displayName,
                                      contact.phones.first.number,
                                    );
                                  }
                                },
                              );
                            },
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Classe QRViewExample pour le scanner QR
class QRViewExample extends StatelessWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scanner QR")),
      body: Center(
        child: Text("Fonctionnalité de scan QR à implémenter ici."),
      ),
    );
  }
}

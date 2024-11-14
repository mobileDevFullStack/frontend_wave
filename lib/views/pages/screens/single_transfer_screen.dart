import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class SingleTransferScreen extends StatefulWidget {
  const SingleTransferScreen({Key? key}) : super(key: key);

  @override
  State<SingleTransferScreen> createState() => _SingleTransferScreenState();
}

class _SingleTransferScreenState extends State<SingleTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();
  Contact? _selectedContact;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestContactsPermission();
  }

  Future<void> _requestContactsPermission() async {
    if (await FlutterContacts.requestPermission()) {
      // Permission granted
    }
  }

  Future<void> _pickContact() async {
    try {
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        final fullContact = await FlutterContacts.getContact(contact.id);
        if (fullContact != null && fullContact.phones.isNotEmpty) {
          setState(() {
            _selectedContact = fullContact;
            _recipientController.text = fullContact.phones.first.number;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'accès aux contacts')),
      );
    }
  }

  Future<void> _handleTransfer() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // Simuler un transfert
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transfert effectué avec succès'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfert Simple'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Montant
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Montant',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un montant';
                }
                if (double.tryParse(value) == null) {
                  return 'Montant invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Destinataire avec sélection de contact
            TextFormField(
              controller: _recipientController,
              decoration: InputDecoration(
                labelText: 'Numéro du destinataire',
                prefixIcon: const Icon(Icons.person_outline),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.contacts),
                  onPressed: _pickContact,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un numéro';
                }
                if (value.length < 8) {
                  return 'Numéro invalide';
                }
                return null;
              },
            ),
            if (_selectedContact != null) ...[
              const SizedBox(height: 10),
              Text(
                'Contact sélectionné: ${_selectedContact!.displayName}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(height: 30),

            // Bouton de transfert
            FilledButton(
              onPressed: _isLoading ? null : _handleTransfer,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Effectuer le transfert',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    super.dispose();
  }
}
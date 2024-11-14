// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';

// class MultiTransferScreen extends StatefulWidget {
//   const MultiTransferScreen({Key? key}) : super(key: key);

//   @override
//   State<MultiTransferScreen> createState() => _MultiTransferScreenState();
// }

// class _MultiTransferScreenState extends State<MultiTransferScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _amountController = TextEditingController();
//   final List<TransferRecipient> _recipients = [];
//   final Set<String> _selectedContactIds = {}; // Pour suivre les contacts déjà sélectionnés
//   bool _isLoading = false;

//   Future<void> _addRecipient() async {
//     try {
//       final contact = await FlutterContacts.openExternalPick();
//       if (contact != null) {
//         // Vérifier si le contact est déjà sélectionné
//         if (_selectedContactIds.contains(contact.id)) {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Ce contact est déjà dans la liste des destinataires'),
//                 backgroundColor: Colors.orange,
//               ),
//             );
//           }
//           return;
//         }

//         final fullContact = await FlutterContacts.getContact(contact.id);
//         if (fullContact != null && fullContact.phones.isNotEmpty) {
//           setState(() {
//             _recipients.add(TransferRecipient(
//               contact: fullContact,
//               phoneNumber: fullContact.phones.first.number,
//               amount: _amountController.text,
//             ));
//             _selectedContactIds.add(contact.id); // Ajouter l'ID au Set
//           });
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Erreur lors de l\'accès aux contacts')),
//         );
//       }
//     }
//   }

//   void _removeRecipient(int index) {
//     final removedContact = _recipients[index];
//     setState(() {
//       _recipients.removeAt(index);
//       _selectedContactIds.remove(removedContact.contact.id); // Retirer l'ID du Set
//     });
//   }

//   Future<void> _handleMultiTransfer() async {
//     if (_formKey.currentState!.validate() && _recipients.isNotEmpty) {
//       setState(() => _isLoading = true);
//       try {
//         // Simuler des transferts multiples
//         await Future.delayed(const Duration(seconds: 2));
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Transferts effectués avec succès'),
//               backgroundColor: Colors.green,
//             ),
//           );
//           Navigator.pop(context);
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Erreur: ${e.toString()}')),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     } else if (_recipients.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Veuillez ajouter au moins un destinataire'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Transfert Multiple'),
//         elevation: 0,
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(20),
//           children: [
//             // Montant par défaut
//             TextFormField(
//               controller: _amountController,
//               decoration: InputDecoration(
//                 labelText: 'Montant par défaut',
//                 prefixIcon: const Icon(Icons.attach_money),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//               ),
//               keyboardType: TextInputType.number,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Veuillez entrer un montant';
//                 }
//                 if (double.tryParse(value) == null) {
//                   return 'Montant invalide';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 20),

//             // Liste des destinataires
//             ..._recipients.asMap().entries.map((entry) {
//               final index = entry.key;
//               final recipient = entry.value;
//               return Card(
//                 margin: const EdgeInsets.only(bottom: 10),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: ListTile(
//                   leading: const CircleAvatar(
//                     child: Icon(Icons.person),
//                   ),
//                   title: Text(recipient.contact.displayName),
//                   subtitle: Text(recipient.phoneNumber),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.remove_circle_outline),
//                     color: Colors.red,
//                     onPressed: () => _removeRecipient(index),
//                   ),
//                 ),
//               );
//             }),

//             const SizedBox(height: 20),

//             // Bouton d'ajout de destinataire
//             OutlinedButton.icon(
//               onPressed: _addRecipient,
//               icon: const Icon(Icons.person_add),
//               label: const Text('Ajouter un destinataire'),
//               style: OutlinedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             // Bouton de transfert
//             FilledButton(
//               onPressed: _isLoading ? null : _handleMultiTransfer,
//               style: FilledButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//               ),
//               child: _isLoading
//                   ? const SizedBox(
//                       height: 20,
//                       width: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     )
//                   : Text(
//                       'Effectuer les transferts (${_recipients.length})',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     super.dispose();
//   }
// }

// class TransferRecipient {
//   final Contact contact;
//   final String phoneNumber;
//   final String amount;

//   TransferRecipient({
//     required this.contact,
//     required this.phoneNumber,
//     required this.amount,
//   });
// }

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ManualContact implements Contact {
  final String id;
  final String displayName;
  final String phoneNumber;

  ManualContact({
    required this.displayName,
    required this.phoneNumber,
  }) : id = 'manual_${DateTime.now().millisecondsSinceEpoch}';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  // Implémentation minimale nécessaire de Contact
  @override
  List<Phone> get phones => [
        Phone(
          phoneNumber,
        )
      ];
}

// Dialogue pour ajouter un contact manuellement
class AddManualContactDialog extends StatefulWidget {
  const AddManualContactDialog({Key? key}) : super(key: key);

  @override
  State<AddManualContactDialog> createState() => _AddManualContactDialogState();
}

class _AddManualContactDialogState extends State<AddManualContactDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un contact'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Numéro de téléphone',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un numéro';
                }
                // validation du numero de telephone
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'Veuillez entrer un numéro valide';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final manualContact = ManualContact(
                displayName: _nameController.text,
                phoneNumber: _phoneController.text,
              );
              Navigator.pop(context, manualContact);
            }
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}

// Mise à jour de ContactSelectionScreen
class ContactSelectionScreen extends StatefulWidget {
  final Set<String> alreadySelectedIds;

  const ContactSelectionScreen({
    Key? key,
    required this.alreadySelectedIds,
  }) : super(key: key);

  @override
  State<ContactSelectionScreen> createState() => _ContactSelectionScreenState();
}

class _ContactSelectionScreenState extends State<ContactSelectionScreen> {
  List<Contact> _contacts = [];
  Set<Contact> _selectedContacts = {};
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        final contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: false,
        );
        setState(() {
          _contacts = contacts;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erreur lors du chargement des contacts')),
        );
      }
    }
  }

  Future<void> _addManualContact() async {
    final manualContact = await showDialog<Contact>(
      context: context,
      builder: (context) => const AddManualContactDialog(),
    );

    if (manualContact != null) {
      setState(() {
        _contacts.add(manualContact);
        _selectedContacts.add(manualContact);
      });
    }
  }

  List<Contact> get _filteredContacts {
    return _contacts.where((contact) {
      final nameMatches = contact.displayName
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final notAlreadySelected =
          !widget.alreadySelectedIds.contains(contact.id);
      return nameMatches && notAlreadySelected && contact.phones.isNotEmpty;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionner des contacts'),
        actions: [
          TextButton.icon(
            onPressed: _selectedContacts.isEmpty
                ? null
                : () {
                    Navigator.pop(context, _selectedContacts.toList());
                  },
            icon: const Icon(Icons.check),
            label: Text(
              'Valider (${_selectedContacts.length})',
              style: const TextStyle(
                  color: Colors.white), // Set label color to white
            ),
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              iconColor: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Rechercher un contact...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: OutlinedButton.icon(
              onPressed: _addManualContact,
              icon: const Icon(Icons.person_add),
              label: const Text('Ajouter un nouveau contact'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(double.infinity, 0),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredContacts[index];
                      final isSelected = _selectedContacts.contains(contact);

                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            contact.displayName[0].toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(contact.displayName),
                        subtitle: Text(
                          contact.phones.first.number,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        trailing: Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value ?? false) {
                                _selectedContacts.add(contact);
                              } else {
                                _selectedContacts.remove(contact);
                              }
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedContacts.remove(contact);
                            } else {
                              _selectedContacts.add(contact);
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Modification de la classe MultiTransferScreen
class MultiTransferScreen extends StatefulWidget {
  const MultiTransferScreen({Key? key}) : super(key: key);

  @override
  State<MultiTransferScreen> createState() => _MultiTransferScreenState();
}

class _MultiTransferScreenState extends State<MultiTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final List<TransferRecipient> _recipients = [];
  final Set<String> _selectedContactIds = {};
  bool _isLoading = false;

  Future<void> _addRecipients() async {
    try {
      final selectedContacts = await Navigator.push<List<Contact>>(
        context,
        MaterialPageRoute(
          builder: (context) => ContactSelectionScreen(
            alreadySelectedIds: _selectedContactIds,
          ),
        ),
      );

      if (selectedContacts != null && selectedContacts.isNotEmpty) {
        setState(() {
          for (final contact in selectedContacts) {
            if (!_selectedContactIds.contains(contact.id) &&
                contact.phones.isNotEmpty) {
              _recipients.add(TransferRecipient(
                contact: contact,
                phoneNumber: contact.phones.first.number,
                amount: _amountController.text,
              ));
              _selectedContactIds.add(contact.id);
            }
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de l\'accès aux contacts'),
        ),
      );
    }
  }

  void _removeRecipient(int index) {
    final removedContact = _recipients[index];
    setState(() {
      _recipients.removeAt(index);
      _selectedContactIds.remove(removedContact.contact.id);
    });
  }

  Future<void> _handleMultiTransfer() async {
    if (_formKey.currentState!.validate() && _recipients.isNotEmpty) {
      setState(() => _isLoading = true);
      try {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transferts effectués avec succès'),
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
    } else if (_recipients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez ajouter au moins un destinataire'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfert Multiple'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Montant par défaut',
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
            ..._recipients.asMap().entries.map((entry) {
              final index = entry.key;
              final recipient = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      recipient.contact.displayName[0].toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(recipient.contact.displayName),
                  subtitle: Text(recipient.phoneNumber),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.red,
                    onPressed: () => _removeRecipient(index),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _addRecipients,
              icon: const Icon(Icons.person_add),
              label: const Text('Sélectionner des destinataires'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 30),
            FilledButton(
              onPressed: _isLoading ? null : _handleMultiTransfer,
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
                  : Text(
                      'Effectuer les transferts (${_recipients.length})',
                      style: const TextStyle(fontSize: 16),
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
    super.dispose();
  }
}

class TransferRecipient {
  final Contact contact;
  final String phoneNumber;
  final String amount;

  TransferRecipient({
    required this.contact,
    required this.phoneNumber,
    required this.amount,
  });
}

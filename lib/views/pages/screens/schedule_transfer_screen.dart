import 'package:flutter/material.dart';

class ScheduleTransferScreen extends StatefulWidget {
  const ScheduleTransferScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleTransferScreen> createState() => _ScheduleTransferScreenState();
}

class _ScheduleTransferScreenState extends State<ScheduleTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _frequency = 'once';
  bool _isLoading = false;
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        // Simuler un délai de traitement
        await Future.delayed(const Duration(seconds: 2));
        
        // Afficher une confirmation
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transfert programmé avec succès'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
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
        title: const Text('Planifier un Transfert'),
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
                  return 'Veuillez entrer un montant valide';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _recipientController,
              decoration: InputDecoration(
                labelText: 'Numéro du destinataire',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              keyboardType: TextInputType.phone,
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
            const SizedBox(height: 30),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date et heure',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (date != null) {
                                setState(() => _selectedDate = date);
                              }
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: _selectedTime,
                              );
                              if (time != null) {
                                setState(() => _selectedTime = time);
                              }
                            },
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fréquence',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'once',
                          label: Text('Une fois'),
                          icon: Icon(Icons.looks_one_outlined),
                        ),
                        ButtonSegment(
                          value: 'daily',
                          label: Text('Quotidien'),
                          icon: Icon(Icons.calendar_today),
                        ),
                        ButtonSegment(
                          value: 'weekly',
                          label: Text('Hebdo'),
                          icon: Icon(Icons.calendar_view_week),
                        ),
                        ButtonSegment(
                          value: 'monthly',
                          label: Text('Mensuel'),
                          icon: Icon(Icons.calendar_month),
                        ),
                      ],
                      selected: {_frequency},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _frequency = newSelection.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            FilledButton(
              onPressed: _isLoading ? null : _handleSubmit,
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
                      'Programmer le transfert',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
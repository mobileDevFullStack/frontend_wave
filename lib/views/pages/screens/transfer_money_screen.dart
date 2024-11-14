import 'package:flutter/material.dart';

class TransferMoneyScreen extends StatefulWidget {
  final String contactName;
  final String phoneNumber;

  const TransferMoneyScreen({
    Key? key,
    required this.contactName,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _TransferMoneyScreenState createState() => _TransferMoneyScreenState();
}

class _TransferMoneyScreenState extends State<TransferMoneyScreen> {
  final _amountController = TextEditingController();
  double? _amountToSend;
  double? _amountToReceive;
  final double _feePercentage = 0.01; // 1%
  final double _maxFee = 5000;

  void _calculateAmountToReceive(String amount) {
    if (amount.isEmpty) {
      setState(() {
        _amountToSend = null;
        _amountToReceive = null;
      });
      return;
    }

    final amountToSend = double.tryParse(amount);
    if (amountToSend != null) {
      final fee = (amountToSend * _feePercentage).clamp(0, _maxFee);
      setState(() {
        _amountToSend = amountToSend;
        _amountToReceive = amountToSend - fee;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Envoyer de l'Argent"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 20),
              child: Text(
                'À',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contactName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '+221 ${widget.phoneNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Montant Envoyé',
                  labelStyle: TextStyle(color: Colors.lightBlue),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                ),
                onChanged: _calculateAmountToReceive,
              ),
            ),
            if (_amountToSend != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Montant Reçu',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${_amountToReceive?.toStringAsFixed(0)}F',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Frais Wave = 1%',
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                    Text(
                      'Frais maximum: ${_maxFee.toStringAsFixed(0)}F',
                      style: const TextStyle(color: Colors.lightBlue),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _amountToSend == null ? null : () {
                    // Implémenter la logique d'envoi
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Envoyer',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

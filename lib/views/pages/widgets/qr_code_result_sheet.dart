import 'package:flutter/material.dart';

class QRCodeResultSheet extends StatelessWidget {
  final String code;
  final VoidCallback onClose;
  final VoidCallback onProcess;

  const QRCodeResultSheet({
    required this.code,
    required this.onClose,
    required this.onProcess,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('QR Code: $code'),
          ElevatedButton(onPressed: onProcess, child: const Text('Process')),
          ElevatedButton(onPressed: onClose, child: const Text('Close')),
        ],
      ),
    );
  }
}

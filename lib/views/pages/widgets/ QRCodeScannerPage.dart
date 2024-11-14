import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({Key? key}) : super(key: key);

  @override
  _QRCodeScannerPageState createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  String? scannedQRCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner le QR Code"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (barcode) {
                final String? code = barcode.barcodes.first.rawValue;
                if (code != null) {
                  setState(() {
                    scannedQRCode = code;
                  });
                  // Fermer le scanner et retourner le résultat
                  Navigator.pop(context, scannedQRCode);
                }
              },
            ),
          ),
          if (scannedQRCode != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'QR Code Scanné: $scannedQRCode',
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}

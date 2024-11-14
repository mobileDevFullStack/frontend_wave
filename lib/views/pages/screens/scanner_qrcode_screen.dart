import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:just_audio/just_audio.dart';
import 'package:waveflutterapp/views/pages/screens/scanner_overlay_shap.dart';
import 'dart:math' as math;

import 'package:waveflutterapp/views/pages/widgets/qr_code_result_sheet.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.unrestricted,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isScanning = false;
  late AnimationController _animationController;
  String? _lastScanned;
  final AudioPlayer _audioPlayer = AudioPlayer();
  CameraFacing currentCameraFacing = CameraFacing.back;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _initAudio();
  }

  Future<void> _initAudio() async {
    await _audioPlayer.setAsset('assets/sounds/beep.mp3');
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playBeepSound() async {
    try {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Erreur lors de la lecture du son: $e');
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanning) return; // Skip detection if already processing
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != _lastScanned) {
        setState(() {
          _isScanning = true;
          _lastScanned = barcode.rawValue;
        });
        _playBeepSound();
        _showQRCodeDetails(barcode.rawValue ?? 'Code invalide');
        break; // Exit after detecting one barcode to avoid duplicates
      }
    }
  }

  void _showQRCodeDetails(String code) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isScrollControlled: true,
      builder: (context) => QRCodeResultSheet(
        code: code,
        onClose: () {
          setState(() => _isScanning = false);
          Navigator.pop(context);
        },
        onProcess: () {
          // Ajouter ici la logique de traitement du QR code
          Navigator.pop(context);
          setState(() => _isScanning = false);
        },
      ),
    ).whenComplete(() => Future.delayed(
        const Duration(seconds: 1), () => setState(() => _isScanning = false)));
  }

  void _toggleCameraFacing() {
    setState(() {
      currentCameraFacing = currentCameraFacing == CameraFacing.back
          ? CameraFacing.front
          : CameraFacing.back;
    });
    controller.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Scanner un QR code',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              controller.torchEnabled ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: Icon(
              currentCameraFacing == CameraFacing.front
                  ? Icons.camera_front
                  : Icons.camera_rear,
              color: Colors.white,
            ),
            onPressed: _toggleCameraFacing,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
          ),
          Container(
            decoration: ShapeDecoration(
              shape: ScannerOverlayShape(
                borderColor: Colors.white,
                borderWidth: 2.0,
                overlayColor: Colors.black.withOpacity(0.5),
                borderRadius: 12,
                borderLength: 30,
                cutOutWidth: 250,
                cutOutHeight: 250,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 230), // Ajuste la position verticale ici
              child: SizedBox(
                width:
                    250, // Fixe la largeur à 250 pour correspondre à la découpe
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        0,
                        math.sin(_animationController.value * 2 * math.pi) *
                            15, // Ajuster l'amplitude ici
                      ),
                            child: Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
                    Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Text(
              'Placez le QR code dans le cadre',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}






  // import 'package:flutter/material.dart';
  // import 'package:otp_text_field/otp_text_field.dart';
  // import 'package:otp_text_field/style.dart';

  // class SmsCodeInputWidget extends StatelessWidget {
  //   final String phoneNumber;
  //   final void Function(String) onCodeEntered;

  //   SmsCodeInputWidget({required this.phoneNumber, required this.onCodeEntered});

  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Colors.white,
          
  //         elevation: 0,
  //         leading: IconButton(
  //           icon: Icon(Icons.arrow_back, color: Colors.black),
  //           onPressed: () {
  //             Navigator.pop(context); // Retourne à l'écran précédent (écran login)
  //           },
  //         ),
  //       ),
  //       backgroundColor: Colors.white,
        
  //       body: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 24.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Text(
  //               "Entrez le code de validation envoyé par\nSMS au $phoneNumber",
  //               textAlign: TextAlign.center,
  //               style: TextStyle(fontSize: 18, color: Colors.black),
  //             ),
  //             const SizedBox(height: 40),
  //             OTPTextField(
  //               length: 4,
  //               width: MediaQuery.of(context).size.width,
  //               fieldWidth: 50,
  //               style: TextStyle(fontSize: 24, color: Colors.black),
  //               textFieldAlignment: MainAxisAlignment.spaceAround,
  //               fieldStyle: FieldStyle.underline,
  //               onCompleted: (pin) {
  //                 onCodeEntered(pin);
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }




import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';

class SmsCodeInputScreen extends StatefulWidget {
  final String phoneNumber;
  final Function(Map<String, dynamic>)? onCodeVerified; // Callback optionnel

  SmsCodeInputScreen({required this.phoneNumber, this.onCodeVerified});

  @override
  _SmsCodeInputScreenState createState() => _SmsCodeInputScreenState();
}

class _SmsCodeInputScreenState extends State<SmsCodeInputScreen> {
  final _smsCodeController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  Future<void> _verifyCode() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final result = await _authService.verifySmsCode(
        widget.phoneNumber,
        _smsCodeController.text.trim(),
      );

      if (result['success'] == true) {
        // Appel du callback si défini
        if (widget.onCodeVerified != null) {
          widget.onCodeVerified!(result);
        }
        Navigator.pop(context, result); // Retourne le résultat à la page précédente
      } else {
        _showErrorSnackBar('Code SMS incorrect. Veuillez réessayer.');
      }
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Code SMS')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Entrez le code SMS envoyé au ${widget.phoneNumber}.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _smsCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Code SMS'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyCode,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Vérifier'),
            ),
          ],
        ),
      ),
    );
  }
}



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
//             Navigator.pop(context);
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
//               style: TextStyle(fontSize: 24),
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
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class SmsCodeInputWidget extends StatelessWidget {
  final String phoneNumber;
  final void Function(String) onCodeEntered;

  SmsCodeInputWidget({required this.phoneNumber, required this.onCodeEntered});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Retourne à l'écran précédent (écran login)
          },
        ),
      ),
      backgroundColor: Colors.white,
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Entrez le code de validation envoyé par\nSMS au $phoneNumber",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 40),
            OTPTextField(
              length: 4,
              width: MediaQuery.of(context).size.width,
              fieldWidth: 50,
              style: TextStyle(fontSize: 24, color: Colors.black),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
              onCompleted: (pin) {
                onCodeEntered(pin);
              },
            ),
          ],
        ),
      ),
    );
  }
}

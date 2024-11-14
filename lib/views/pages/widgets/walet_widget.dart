

// import 'package:flutter/material.dart';

// class BalanceWidget extends StatelessWidget {
//   final bool isBalanceVisible;
//   final VoidCallback toggleBalanceVisibility;

//   const BalanceWidget({
//     required this.isBalanceVisible,
//     required this.toggleBalanceVisibility,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           isBalanceVisible ? "10,000 F" : "........",
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 50,
//             fontWeight: FontWeight.bold,
//             fontFamily: 'Roboto',
//           ),
//         ),
//         const SizedBox(width: 8), // Espace entre le texte et l'icône

//         // Icône œil alignée en bas
//         GestureDetector(
//           onTap: toggleBalanceVisibility,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               const SizedBox(height: 30), // Ajustez la valeur pour placer l'icône plus bas
//               Icon(
//                 isBalanceVisible ? Icons.visibility : Icons.visibility_off,
//                 color: Colors.white,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }



// wallet_widget.dart
import 'package:flutter/material.dart';

class WalletWidget extends StatelessWidget {
  final bool isBalanceVisible;
  final VoidCallback toggleBalanceVisibility;
  final String balance;
  final String currency;

  const WalletWidget({
    Key? key,
    required this.isBalanceVisible,
    required this.toggleBalanceVisibility,
    required this.balance,
    required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Solde disponible",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Text(
                isBalanceVisible ? "$balance $currency" : "• • • • • •",
                key: ValueKey<bool>(isBalanceVisible),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(width: 5),
            IconButton(
              icon: Icon(
                isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.white70,
              ),
              onPressed: toggleBalanceVisibility,
            ),
          ],
        ),
      ],
    );
  }
}
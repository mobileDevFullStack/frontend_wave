import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
import '../widgets/signup_form_widget.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _showPassword = false;
  bool _showSignupForm = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    _phoneController.addListener(() {
      if (_phoneController.text.length == 9) {
        setState(() => _showPassword = true);
      } else {
        setState(() => _showPassword = false);
      }
    });
  }

  Widget _buildWalletLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.account_balance_wallet,
          size: 60,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_phoneController.text.length != 9 || _passwordController.text.isEmpty) {
      _showErrorSnackBar('Veuillez remplir tous les champs correctement');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await _authService.login(
        _phoneController.text,
        _passwordController.text,
      );

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        _showErrorSnackBar('Identifiants incorrects');
      }
    } catch (e) {
      _showErrorSnackBar('Connexion impossible. Vérifiez votre connexion internet.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          counterText: "",
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildWalletLogo(),
          const SizedBox(height: 40),
          Text(
            "Bienvenue sur votre\nportefeuille numérique ",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _buildInputField(
            controller: _phoneController,
            label: 'Numéro de téléphone',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            maxLength: 9,
          ),
          if (_showPassword) ...[
            const SizedBox(height: 20),
            _buildInputField(
              controller: _passwordController,
              label: 'Mot de passe',
              icon: Icons.lock,
              isPassword: true,
            ),
          ],
          const SizedBox(height: 30),
          if (_isLoading)
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            )
          else
            ElevatedButton(
              onPressed: () {
                if (_phoneController.text.length == 9 && _passwordController.text.isNotEmpty) {
                  _login();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: const Text(
                "Se connecter",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => setState(() => _showSignupForm = true),
            child: Text(
              "Pas de compte ? S'inscrire",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: _showSignupForm
                ? SignupFormWidget(
                    onLoginClick: () => setState(() => _showSignupForm = false),
                  )
                : _buildLoginForm(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

















// import 'package:flutter/material.dart';
// import '../../../data/services/auth_service.dart';
// import '../widgets/signup_form_widget.dart';
// import '../widgets/sms_code_input_widget.dart';
// import 'home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _phoneController = TextEditingController();
//   final _secretCodeController = TextEditingController();
//   final AuthService _authService = AuthService();

//   bool _showSecretCode = false;
//   bool _showSmsCodeInput = false;
//   bool _isLoading = false;
//   bool _showSignupForm = false;
//   String _phoneNumber = "";

//   @override
//   void initState() {
//     super.initState();
//     _phoneController.addListener(() {
//       setState(() {
//         _showSecretCode = _phoneController.text.length == 9;
//       });
//     });
//   }

//   Future<void> _handleSecretCodeSubmission() async {
//     if (_phoneController.text.length == 9 && _secretCodeController.text.length == 4) {
//       setState(() {
//         _showSmsCodeInput = true;
//         _phoneNumber = _phoneController.text;
//       });
//       // Call backend to initiate SMS code sending here if needed.
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Veuillez entrer un numéro et un code secret valides")),
//       );
//     }
//   }

//   Widget _buildLoginForm() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text(
//           "Entrez votre numéro de téléphone",
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 20),
//         TextField(
//           controller: _phoneController,
//           keyboardType: TextInputType.phone,
//           maxLength: 9,
//           style: TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.white24,
//             labelText: 'Numéro de téléphone',
//             labelStyle: TextStyle(color: Colors.white),
//             prefixIcon: Icon(Icons.phone, color: Colors.white),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//             counterText: "",
//           ),
//         ),
//         const SizedBox(height: 20),
//         if (_showSecretCode)
//           TextField(
//             controller: _secretCodeController,
//             keyboardType: TextInputType.number,
//             maxLength: 4,
//             obscureText: true,
//             style: TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: Colors.white24,
//               labelText: 'Code secret (4 chiffres)',
//               labelStyle: TextStyle(color: Colors.white),
//               prefixIcon: Icon(Icons.lock, color: Colors.white),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide.none,
//               ),
//               counterText: "",
//             ),
//             onChanged: (value) {
//               if (value.length == 4) _handleSecretCodeSubmission();
//             },
//           ),
//         const SizedBox(height: 20),
//         if (!_showSmsCodeInput)
//           Column(
//             children: [
//               TextButton(
//                 onPressed: () {
//                   setState(() => _showSignupForm = true);
//                 },
//                 child: Text("Pas de compte ? S'inscrire", style: TextStyle(color: Colors.white)),
//               ),
//               TextButton(
//                 onPressed: () { 
//                   // Handle forgotten password logic
//                 },
//                 child: Text("Mot de passe oublié ?", style: TextStyle(color: Colors.white)),
//               ),
//               TextButton(
//                 onPressed: () {
//                   // Handle distributor login logic
//                 },
//                 child: Text("Se connecter en tant que distributeur", style: TextStyle(color: Colors.white)),
//               ),
//             ],
//           ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: _showSignupForm
//               ? SignupFormWidget(
//                   onLoginClick: () {
//                     setState(() => _showSignupForm = false);
//                   },
//                 )
//               : _showSmsCodeInput
//                   ? SmsCodeInputWidget(
//                       phoneNumber: _phoneNumber,
//                       onCodeEntered: (code) async {
//                         final success = await _authService.verifySmsCode(_phoneNumber, code);
//                         if (success) {
//                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Code SMS incorrect")));
//                         }
//                       },
//                     )
//                   : _buildLoginForm(),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _secretCodeController.dispose();
//     super.dispose();
//   }
// }

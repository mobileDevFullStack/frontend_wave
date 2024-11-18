import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
import '../widgets/signup_form_widget.dart';
import '../widgets/sms_code_input_widget.dart';
import 'home_screen.dart';
import 'update_credentials_screen.dart';
import 'transaction_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _secretCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _showSecretCode = false;
  bool _showSignupForm = false;
  bool _isLoading = false;
  bool _isDistributor = false;

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
        setState(() => _showSecretCode = true);
      } else {
        setState(() => _showSecretCode = false);
      }
    });

    _secretCodeController.addListener(() {
      if (_showSecretCode &&
          _phoneController.text.length == 9 &&
          _secretCodeController.text.length == 4) {
        _initiateLogin();
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
          _isDistributor ? Icons.store : Icons.account_balance_wallet,
          size: 60,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildUserTypeSelector() {
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
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isDistributor = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isDistributor
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(15)),
                ),
                child: Text(
                  'Client',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        !_isDistributor ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isDistributor = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isDistributor
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(15)),
                ),
                child: Text(
                  'Distributeur',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isDistributor ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _initiateLogin() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      if (_isDistributor) {
        final loginResult = await _authService.loginDistributor(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (loginResult['success']) {
          if (loginResult['has_updated_credentials']) {
            // Si les identifiants ont déjà été mis à jour, aller directement à TransactionScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TransactionScreen()),
            );
          } else if (loginResult['requires_update']) {
            // Si c'est la première connexion, aller à l'écran de mise à jour
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateCredentialsScreen(
                  email: _emailController.text.trim(),
                  currentPassword: _passwordController.text.trim(),
                ),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TransactionScreen()),
            );
          }
        } else {
          _showErrorSnackBar('Identifiants incorrects. Veuillez réessayer.');
        }
      } else {
        // Le reste du code pour la connexion client reste inchangé
        final loginSuccess = await _authService.login(
          _phoneController.text.trim(),
          _secretCodeController.text.trim(),
        );

        if (loginSuccess) {
          final verificationResult = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(
              builder: (context) => SmsCodeInputScreen(
                phoneNumber: _phoneController.text.trim(),
              ),
            ),
          );

          if (verificationResult != null &&
              verificationResult['success'] == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            _showErrorSnackBar('Code SMS invalide. Veuillez réessayer.');
          }
        } else {
          _showErrorSnackBar('Identifiants incorrects. Veuillez réessayer.');
        }
      }
    } catch (e) {
      _showErrorSnackBar(e.toString());
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
    TextInputType? keyboardType,
    int? maxLength,
    bool isPassword = false,
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
        keyboardType: keyboardType ?? TextInputType.text,
        maxLength: maxLength,
        style: const TextStyle(color: Colors.black87),
        obscureText: isPassword,
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
            _isDistributor
                ? "Espace Distributeur"
                : "Bienvenue sur votre\nportefeuille numérique",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _buildUserTypeSelector(),
          const SizedBox(height: 30),
          if (_isDistributor) ...[
            _buildInputField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _passwordController,
              label: 'Mot de passe',
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _initiateLogin,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text('Se connecter'),
            ),
          ] else ...[
            _buildInputField(
              controller: _phoneController,
              label: 'Numéro de téléphone',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              maxLength: 9,
            ),
            if (_showSecretCode) ...[
              const SizedBox(height: 20),
              _buildInputField(
                controller: _secretCodeController,
                label: 'Code secret',
                icon: Icons.lock,
                keyboardType: TextInputType.number,
                maxLength: 4,
                isPassword: true,
              ),
            ],
          ],
          if (_isLoading && !_isDistributor)
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          if (!_isDistributor) ...[
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
    _secretCodeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

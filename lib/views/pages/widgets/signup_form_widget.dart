import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waveflutterapp/data/services/auth_service.dart';

class SignupFormWidget extends StatefulWidget {
  final VoidCallback onLoginClick;

  const SignupFormWidget({Key? key, required this.onLoginClick})
      : super(key: key);

  @override
  _SignupFormWidgetState createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends State<SignupFormWidget> {
  final _signupRoleController = TextEditingController();
  final _signupPhoneController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupConfirmPasswordController = TextEditingController();
  final _signupSecretCodeController = TextEditingController();
  final _signupAdresseController = TextEditingController();
  final _signupCniController = TextEditingController();
  final _signupFirstnameController = TextEditingController();
  final _signupLastnameController = TextEditingController();
  bool _isLoading = false; // Ajout de la variable _isLoading

  DateTime? _selectedDate;
  File? _imageFile;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(
          color: Colors.black), // Texte en noir pour meilleure lisibilité
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white, // Fond blanc pour un meilleur contraste
        labelText: label,
        labelStyle: TextStyle(
            color: Theme.of(context).primaryColor), // Couleur du texte
        prefixIcon: Icon(icon,
            color: Theme.of(context).primaryColor), // Couleur de l'icône
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Inscription",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _showImageSourceActionSheet(context),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
              backgroundImage:
                  _imageFile != null ? FileImage(_imageFile!) : null,
              child: _imageFile == null
                  ? Icon(Icons.camera_alt,
                      size: 50, color: Theme.of(context).primaryColor)
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(_signupLastnameController, 'Nom', Icons.person),
          const SizedBox(height: 10),
          _buildTextField(
              _signupFirstnameController, 'Prénom', Icons.person_outline),
          const SizedBox(height: 10),
          _buildTextField(_signupRoleController, 'Role', Icons.person_add),
          const SizedBox(height: 10),
          _buildTextField(_signupPhoneController, 'Téléphone', Icons.phone),
          const SizedBox(height: 10),
          _buildTextField(_signupEmailController, 'Email', Icons.email),
          const SizedBox(height: 10),
          _buildTextField(_signupPasswordController, 'Mot de passe', Icons.lock,
              isPassword: true),
          const SizedBox(height: 10),
          _buildTextField(_signupConfirmPasswordController,
              'Confirmer mot de passe', Icons.lock,
              isPassword: true),
          const SizedBox(height: 10),
          _buildTextField(
              _signupSecretCodeController, 'Code secret', Icons.vpn_key),
          const SizedBox(height: 10),
          _buildTextField(
              _signupAdresseController, 'Adresse', Icons.location_on),
          const SizedBox(height: 10),
          _buildTextField(_signupCniController, 'CNI', Icons.credit_card),
          const SizedBox(height: 10),
          const SizedBox(height: 20),
            ElevatedButton(
  onPressed: () async {
    final authService = AuthService();

    try {
      // Validation des champs
      if (_signupPasswordController.text != _signupConfirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Les mots de passe ne correspondent pas.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      // Appel au service d'inscription
      final result = await authService.register(
        firstname: _signupFirstnameController.text.trim(),
        lastname: _signupLastnameController.text.trim(),
        role: _signupRoleController.text.trim(),
        phone: _signupPhoneController.text.trim(),
        email: _signupEmailController.text.trim(),
        password: _signupPasswordController.text,
        adresse: _signupAdresseController.text.trim(),
        cni: _signupCniController.text.trim(),
        secretCode: _signupSecretCodeController.text.trim(),
        photo: _imageFile,
      );

      setState(() => _isLoading = false);

      // Si l'inscription est réussie
      if (result['status'] == 'registered') {
        // Afficher le message de succès
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Inscription réussie'),
            backgroundColor: Colors.green,
          ),
        );

        // Vider les champs du formulaire
        _signupFirstnameController.clear();
        _signupLastnameController.clear();
        _signupRoleController.clear();
        _signupPhoneController.clear();
        _signupEmailController.clear();
        _signupPasswordController.clear();
        _signupConfirmPasswordController.clear();
        _signupAdresseController.clear();
        _signupCniController.clear();
        setState(() {
          _imageFile = null;
        });

        // Attendre que le SnackBar s'affiche avant de rediriger
        await Future.delayed(const Duration(seconds: 2));

        // Rediriger vers la page de connexion
        if (!context.mounted) return;
        widget.onLoginClick();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: Theme.of(context).primaryColor,
    elevation: 5,
  ),
  child: _isLoading
      ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
      : const Text(
          "S'inscrire",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
),
          const SizedBox(height: 20),
          TextButton(
            onPressed: widget.onLoginClick,
            child: Text(
              "Déjà un compte ? Se connecter",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galerie'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Appareil photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _signupRoleController.dispose();
    _signupPhoneController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    _signupSecretCodeController.dispose();
    _signupAdresseController.dispose();
    _signupCniController.dispose();
    _signupLastnameController.dispose();
    _signupFirstnameController.dispose();
    super.dispose();
  }
}





  // InkWell(
  //           onTap: () => _selectDate(context),
  //           child: InputDecorator(
  //             decoration: InputDecoration(
  //               filled: true,
  //               fillColor: Colors.white,
  //               labelText: 'Date de naissance',
  //               labelStyle: TextStyle(color: Theme.of(context).primaryColor),
  //               prefixIcon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //                 borderSide: BorderSide.none,
  //               ),
  //             ),
  //             child: Text(
  //               _selectedDate != null 
  //                   ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
  //                   : "Sélectionner une date",
  //               style: const TextStyle(color: Colors.black),
  //             ),
  //           ),
  //         ),


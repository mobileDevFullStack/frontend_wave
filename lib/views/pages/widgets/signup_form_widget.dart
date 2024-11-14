// import 'package:flutter/material.dart';

// class SignupFormWidget extends StatefulWidget {
//   final VoidCallback onLoginClick;

//   const SignupFormWidget({Key? key, required this.onLoginClick}) : super(key: key);

//   @override
//   _SignupFormWidgetState createState() => _SignupFormWidgetState();
// }

// class _SignupFormWidgetState extends State<SignupFormWidget> {
//   final _signupSurnameController = TextEditingController();
//   final _signupPhoneController = TextEditingController();
//   final _signupEmailController = TextEditingController();
//   final _signupPasswordController = TextEditingController();
//   final _signupCniController = TextEditingController();
//   final _signupNomController = TextEditingController();
//   final _signupPrenomController = TextEditingController();
//   DateTime? _selectedDate;

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label,
//     IconData icon, {
//     bool isPassword = false,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.white24,
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.white),
//         prefixIcon: Icon(icon, color: Colors.white),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Inscription",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 20),
//           _buildTextField(_signupNomController, 'Nom', Icons.person),
//           const SizedBox(height: 10),
//           _buildTextField(_signupPrenomController, 'Prénom', Icons.person_outline),
//           const SizedBox(height: 10),
//           _buildTextField(_signupSurnameController, 'Surname', Icons.person_add),
//           const SizedBox(height: 10),
//           _buildTextField(_signupPhoneController, 'Téléphone', Icons.phone),
//           const SizedBox(height: 10),
//           _buildTextField(_signupEmailController, 'Email', Icons.email),
//           const SizedBox(height: 10),
//           _buildTextField(_signupPasswordController, 'Mot de passe', Icons.lock, isPassword: true),
//           const SizedBox(height: 10),
//           _buildTextField(_signupCniController, 'CNI', Icons.credit_card),
//           const SizedBox(height: 10),
//           InkWell(
//             onTap: () => _selectDate(context),
//             child: InputDecorator(
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.white24,
//                 labelText: 'Date de naissance',
//                 labelStyle: const TextStyle(color: Colors.white),
//                 prefixIcon: const Icon(Icons.calendar_today, color: Colors.white),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               child: Text(
//                 _selectedDate != null 
//                     ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
//                     : "Sélectionner une date",
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               // Logique d'inscription à implémenter
//             },
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               backgroundColor: Colors.white,
//               elevation: 5,
//             ),
//             child: const Text(
//               "S'inscrire",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.blue,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextButton(
//             onPressed: widget.onLoginClick,
//             child: const Text(
//               "Déjà un compte ? Se connecter",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _signupSurnameController.dispose();
//     _signupPhoneController.dispose();
//     _signupEmailController.dispose();
//     _signupPasswordController.dispose();
//     _signupCniController.dispose();
//     _signupNomController.dispose();
//     _signupPrenomController.dispose();
//     super.dispose();
//   }
// }

















// import 'package:flutter/material.dart';

// class SignupFormWidget extends StatefulWidget {
//   final VoidCallback onLoginClick;

//   const SignupFormWidget({Key? key, required this.onLoginClick}) : super(key: key);

//   @override
//   _SignupFormWidgetState createState() => _SignupFormWidgetState();
// }

// class _SignupFormWidgetState extends State<SignupFormWidget> {
//   final _signupSurnameController = TextEditingController();
//   final _signupPhoneController = TextEditingController();
//   final _signupEmailController = TextEditingController();
//   final _signupPasswordController = TextEditingController();
//   final _signupCniController = TextEditingController();
//   final _signupNomController = TextEditingController();
//   final _signupPrenomController = TextEditingController();
//   DateTime? _selectedDate;

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label,
//     IconData icon, {
//     bool isPassword = false,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.white24,
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.white),
//         prefixIcon: Icon(icon, color: Colors.white),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Inscription",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 20),
//           _buildTextField(_signupNomController, 'Nom', Icons.person),
//           const SizedBox(height: 10),
//           _buildTextField(_signupPrenomController, 'Prénom', Icons.person_outline),
//           const SizedBox(height: 10),
//           _buildTextField(_signupSurnameController, 'Surname', Icons.person_add),
//           const SizedBox(height: 10),
//           _buildTextField(_signupPhoneController, 'Téléphone', Icons.phone),
//           const SizedBox(height: 10),
//           _buildTextField(_signupEmailController, 'Email', Icons.email),
//           const SizedBox(height: 10),
//           _buildTextField(_signupPasswordController, 'Mot de passe', Icons.lock, isPassword: true),
//           const SizedBox(height: 10),
//           _buildTextField(_signupCniController, 'CNI', Icons.credit_card),
//           const SizedBox(height: 10),
//           InkWell(
//             onTap: () => _selectDate(context),
//             child: InputDecorator(
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.white24,
//                 labelText: 'Date de naissance',
//                 labelStyle: const TextStyle(color: Colors.white),
//                 prefixIcon: const Icon(Icons.calendar_today, color: Colors.white),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               child: Text(
//                 _selectedDate != null 
//                     ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
//                     : "Sélectionner une date",
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               // Logique d'inscription à implémenter
//             },
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               backgroundColor: Colors.white,
//               elevation: 5,
//             ),
//             child: const Text(
//               "S'inscrire",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.blue,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextButton(
//             onPressed: widget.onLoginClick,
//             child: const Text(
//               "Déjà un compte ? Se connecter",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _signupSurnameController.dispose();
//     _signupPhoneController.dispose();
//     _signupEmailController.dispose();
//     _signupPasswordController.dispose();
//     _signupCniController.dispose();
//     _signupNomController.dispose();
//     _signupPrenomController.dispose();
//     super.dispose();
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupFormWidget extends StatefulWidget {
  final VoidCallback onLoginClick;

  const SignupFormWidget({Key? key, required this.onLoginClick}) : super(key: key);

  @override
  _SignupFormWidgetState createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends State<SignupFormWidget> {
  final _signupSurnameController = TextEditingController();
  final _signupPhoneController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupConfirmPasswordController = TextEditingController();
  final _signupSecretCodeController = TextEditingController();
  final _signupAddressController = TextEditingController();
  final _signupCniController = TextEditingController();
  final _signupNomController = TextEditingController();
  final _signupPrenomController = TextEditingController();
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
      style: const TextStyle(color: Colors.black),  // Texte en noir pour meilleure lisibilité
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,  // Fond blanc pour un meilleur contraste
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),  // Couleur du texte
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),  // Couleur de l'icône
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
              backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
              child: _imageFile == null
                  ? Icon(Icons.camera_alt, size: 50, color: Theme.of(context).primaryColor)
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(_signupNomController, 'Nom', Icons.person),
          const SizedBox(height: 10),
          _buildTextField(_signupPrenomController, 'Prénom', Icons.person_outline),
          const SizedBox(height: 10),
          _buildTextField(_signupSurnameController, 'Surname', Icons.person_add),
          const SizedBox(height: 10),
          _buildTextField(_signupPhoneController, 'Téléphone', Icons.phone),
          const SizedBox(height: 10),
          _buildTextField(_signupEmailController, 'Email', Icons.email),
          const SizedBox(height: 10),
          _buildTextField(_signupPasswordController, 'Mot de passe', Icons.lock, isPassword: true),
          const SizedBox(height: 10),
          _buildTextField(_signupConfirmPasswordController, 'Confirmer mot de passe', Icons.lock, isPassword: true),
          const SizedBox(height: 10),
          _buildTextField(_signupSecretCodeController, 'Code secret', Icons.vpn_key),
          const SizedBox(height: 10),
          _buildTextField(_signupAddressController, 'Adresse', Icons.location_on),
          const SizedBox(height: 10),
          _buildTextField(_signupCniController, 'CNI', Icons.credit_card),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Date de naissance',
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                prefixIcon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              child: Text(
                _selectedDate != null 
                    ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                    : "Sélectionner une date",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Logique d'inscription à implémenter
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 5,
            ),
            child: const Text(
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
    _signupSurnameController.dispose();
    _signupPhoneController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    _signupSecretCodeController.dispose();
    _signupAddressController.dispose();
    _signupCniController.dispose();
    _signupNomController.dispose();
    _signupPrenomController.dispose();
    super.dispose();
  }
}

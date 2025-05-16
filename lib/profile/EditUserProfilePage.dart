import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_mob/models/user.dart';

class EditUserProfilePage extends StatefulWidget {
  final UserModel user;

  const EditUserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.displayName);
    _phoneController = TextEditingController(text: widget.user.phoneNumber ?? '');
  }

  Future<void> _saveProfile() async {
    final updatedName = _nameController.text.trim();
    final updatedPhone = _phoneController.text.trim();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.id)
        .update({
      'displayName': updatedName,
      'phoneNumber': updatedPhone,
    });

    Navigator.pop(context); // Retour au profil
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modifier le profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom complet'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Téléphone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}

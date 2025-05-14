import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dev_mob/models/user.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key, String? userId}) : super(key: key);

  Future<UserModel> _fetchUserProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception('Utilisateur non connecté');
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, doc.id);
    } else {
      throw Exception('Profil utilisateur introuvable');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mon Profil')),
      body: FutureBuilder<UserModel>(
        future: _fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          final user = snapshot.data;

          if (user == null) {
            return const Center(child: Text('Aucun profil trouvé.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    user.photoUrl ?? 'https://www.example.com/default-avatar.png',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.displayName ?? 'Nom inconnu',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Email: ${user.email}'),
                const SizedBox(height: 8),
                Text('Numéro de téléphone: ${user.phoneNumber ?? 'Non fourni'}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Tu pourras ajouter ici un formulaire de modification si tu veux
                  },
                  child: const Text('Modifier le profil'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

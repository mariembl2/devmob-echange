import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_mob/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dev_mob/providers/AuthProvider.dart';
import 'package:dev_mob/widgets/ItemCard.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        actions: [
          // Icône pour accéder au profil de l'utilisateur
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              if (currentUser != null) {
                Navigator.pushNamed(context, '/profile', arguments: currentUser.uid);
              }
            },
          ),
          // Icône pour accéder au dashboard
          IconButton(
            icon: Icon(Icons.dashboard),
            onPressed: () {
              if (currentUser != null) {
                Navigator.pushNamed(context, '/dashboard', arguments: currentUser.uid);
              }
            },
          ),
          // Icône pour accéder à la page des réservations
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              if (currentUser != null) {
                Navigator.pushNamed(context, '/my-reservations');
              }
            },
          ),
          // Icône pour se déconnecter
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
            },
          ),
        ],
      ),
      body: currentUser == null
          ? Center(child: Text('Utilisateur non connecté'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('items')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Aucun objet disponible.'));
                }

                final items = snapshot.data!.docs
                    .map((doc) => ItemModel.fromFirestore(doc))
                    .where((item) => item.ownerId != currentUser.uid)
                    .toList();

                if (items.isEmpty) {
                  return Center(child: Text('Aucun objet ajouté par d\'autres utilisateurs.'));
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ItemCard(item: items[index]);
                  },
                );
              },
            ),
    );
  }
}

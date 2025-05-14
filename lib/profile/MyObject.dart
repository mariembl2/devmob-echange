import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_mob/models/item_model.dart';

class MyObjectPage extends StatelessWidget {
  final String itemId; // ID de l'objet

  const MyObjectPage({Key? key, required this.itemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'objet'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('items')
            .doc(itemId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Objet introuvable.'));
          }

          final itemData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(itemData['imageUrls'][0], height: 200, width: double.infinity, fit: BoxFit.cover),
                SizedBox(height: 16),
                Text(
                  itemData['title'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Description : ${itemData['description'] ?? 'Aucune description'}'),
                SizedBox(height: 8),
                Text('Disponibilité : ${itemData['available'] ? 'Disponible' : 'Indisponible'}'),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Rediriger vers l'édition ou la suppression de l'objet
                      },
                      child: Text('Modifier l\'objet'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance.collection('items').doc(itemId).delete();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Objet supprimé')));
                        Navigator.pop(context);
                      },
                      child: Text('Supprimer l\'objet'),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

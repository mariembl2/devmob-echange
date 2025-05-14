import 'package:dev_mob/views/reservation/ReservationForm.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_mob/models/item_model.dart';


class ItemCard extends StatelessWidget {
  final ItemModel item;

  const ItemCard({Key? key, required this.item}) : super(key: key);

  Future<String> fetchOwnerName(String ownerId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(ownerId).get();
    if (doc.exists) {
      final data = doc.data();
      return data?['name'] ?? data?['email'] ?? 'Inconnu';
    } else {
      return 'Inconnu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(item.description),
            SizedBox(height: 8),
            Text('Catégorie : ${item.category}'),
            Text('Lieu : ${item.location}'),
            Text('Prix : ${item.pricePerDay} €/jour'),
            SizedBox(height: 8),

            // 🔍 Nom du propriétaire
            FutureBuilder<String>(
              future: fetchOwnerName(item.ownerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Chargement du propriétaire...');
                } else if (snapshot.hasError) {
                  return Text('Erreur propriétaire');
                } else {
                  return Text('Propriétaire : ${snapshot.data}');
                }
              },
            ),

            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReservationForm(item: item),
                  ),
                );
              },
              child: Text('Réserver'),
            ),
          ],
        ),
      ),
    );
  }
}

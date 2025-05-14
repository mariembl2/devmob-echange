import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dev_mob/models/reservation.dart';

class MyReservationsPage extends StatelessWidget {
  final String userId; // Ajout d'une variable pour l'userId

  // Ajout du constructeur qui prend l'userId comme argument
  const MyReservationsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mes Réservations')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reservations')
            .where('userId', isEqualTo: userId) // Utilisation de userId pour filtrer
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final reservations = snapshot.data?.docs.map((doc) {
            return Reservation.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList() ?? [];

          if (reservations.isEmpty) {
            return Center(child: Text('Aucune réservation trouvée.'));
          }

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return ListTile(
                title: Text('Réservation de ${reservation.itemId}'),
                subtitle: Text('Du ${reservation.startDate} au ${reservation.endDate}'),
                trailing: Text(reservation.status),
              );
            },
          );
        },
      ),
    );
  }
}

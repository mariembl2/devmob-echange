import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dev_mob/models/reservation.dart';
import 'package:intl/intl.dart';

class OwnerReservationRequestsPage extends StatelessWidget {
  const OwnerReservationRequestsPage({super.key});

  Stream<List<Reservation>> getReservationsForOwner(String ownerId) {
    return FirebaseFirestore.instance
        .collection('reservations')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Reservation.fromMap(data, doc.id);
            }).toList());
  }

  Future<void> updateReservationStatus(String reservationId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservationId)
        .update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Utilisateur non connecté.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Demandes de réservation reçues"),
      ),
      body: StreamBuilder<List<Reservation>>(
        stream: getReservationsForOwner(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          final reservations = snapshot.data ?? [];

          if (reservations.isEmpty) {
            return const Center(child: Text("Aucune demande reçue."));
          }

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final res = reservations[index];
              final start = DateFormat('dd/MM/yyyy').format(res.startDate);
              final end = DateFormat('dd/MM/yyyy').format(res.endDate);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text("Objet ID: ${res.itemId}"),
                  subtitle: Text("Du $start au $end\nStatut: ${res.status}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          updateReservationStatus(res.id, "accepted");
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          updateReservationStatus(res.id, "refused");
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

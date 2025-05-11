import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_mob/models/item.dart';

class OwnerDashboard extends StatelessWidget {
  final String ownerId;

  const OwnerDashboard({Key? key, required this.ownerId}) : super(key: key);

  Stream<List<Map<String, dynamic>>> _fetchReservations() {
    return FirebaseFirestore.instance
        .collection('reservations')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'reservationId': doc.id,
                'itemId': data['itemId'],
                'startDate': (data['startDate'] as Timestamp).toDate(),
                'endDate': (data['endDate'] as Timestamp).toDate(),
                'message': data['message'],
                'status': data['status'],
              };
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord propriétaire'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _fetchReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          final reservations = snapshot.data ?? [];

          if (reservations.isEmpty) {
            return Center(child: Text('Aucune réservation reçue.'));
          }

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Objet ID : ${reservation['itemId']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Dates : ${reservation['startDate']} - ${reservation['endDate']}'),
                      Text('Message : ${reservation['message']}'),
                      Text('Statut : ${reservation['status']}'),
                    ],
                  ),
                  trailing: reservation['status'] == 'pending'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                _updateReservationStatus(
                                    reservation['reservationId'], 'accepted');
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                _updateReservationStatus(
                                    reservation['reservationId'], 'rejected');
                              },
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _updateReservationStatus(
      String reservationId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .update({'status': newStatus});
    } catch (e) {
      print('Erreur lors de la mise à jour du statut : $e');
    }
  }
}
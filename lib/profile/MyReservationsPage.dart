import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyReservationsPage extends StatefulWidget {
  final String userId;

  const MyReservationsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _MyReservationsPageState createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  late Future<List<Map<String, dynamic>>> _reservations;

  // Fonction pour récupérer les réservations
  Future<List<Map<String, dynamic>>> fetchReservations(String userId) async {
    final reservationQuery = await FirebaseFirestore.instance
        .collection('reservations')
        .where('ownerId', isEqualTo: userId) // Filtrer par propriétaire
        .get();

    final renterQuery = await FirebaseFirestore.instance
        .collection('reservations')
        .where('renterId', isEqualTo: userId) // Filtrer par locataire
        .get();

    final ownerReservations = reservationQuery.docs.map((doc) => doc.data()).toList();
    final renterReservations = renterQuery.docs.map((doc) => doc.data()).toList();

    // Combiner les réservations des deux collections
    return [...ownerReservations, ...renterReservations];
  }

  @override
  void initState() {
    super.initState();
    _reservations = fetchReservations(widget.userId); // Récupère les réservations
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes Réservations"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _reservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucune réservation trouvée."));
          }

          // Affichage des réservations
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final reservation = snapshot.data![index];
              final startDate = (reservation['startDate'] as Timestamp).toDate();
              final endDate = (reservation['endDate'] as Timestamp).toDate();
              final message = reservation['message'] ?? 'Aucun message';
              final status = reservation['status'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  title: Text("Réservation du ${startDate.toLocal()} au ${endDate.toLocal()}"),
                  subtitle: Text(message),
                  trailing: Text(status),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

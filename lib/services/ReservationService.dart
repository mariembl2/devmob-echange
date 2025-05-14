// lib/services/reservationservice.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_mob/models/reservation.dart';

class ReservationService {
  final CollectionReference reservationCollection =
      FirebaseFirestore.instance.collection('reservations');

  Stream<List<Reservation>> getReservations() {
    return reservationCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Reservation.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addReservation(Reservation reservation) async {
    await reservationCollection.add(reservation.toMap());
  }

  Future<void> cancelReservation(String reservationId) async {
    await reservationCollection.doc(reservationId).delete();
  }
}

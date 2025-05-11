import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String id; // ID unique de la réservation
  final String itemId; // ID de l'objet réservé
  final String userId; // ID de l'utilisateur qui a fait la réservation
  final DateTime startDate; // Date de début de la réservation
  final DateTime endDate; // Date de fin de la réservation
  final String status; // Statut de la réservation (ex: "pending", "approved", "rejected")
  final String? message; // Message optionnel de l'utilisateur

  Reservation({
    required this.id,
    required this.itemId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.message,
  });

  // Convertir un document Firestore en objet Reservation
  factory Reservation.fromMap(Map<String, dynamic> data, String documentId) {
    return Reservation(
      id: documentId,
      itemId: data['itemId'] ?? '',
      userId: data['userId'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
      message: data['message'],
    );
  }

  // Convertir un objet Reservation en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'userId': userId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status,
      'message': message,
    };
  }
}
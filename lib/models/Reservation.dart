// models/reservation.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String id;
  final String userId;
  final String itemId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String? itemTitle; // <-- Champ optionnel

  Reservation({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.itemTitle,
  });

factory Reservation.fromMap(Map<String, dynamic> data, String documentId) {
  return Reservation(
    id: documentId,
    userId: data['userId'] ?? '',
    itemId: data['itemId'] ?? '',
    startDate: (data['startDate'] as Timestamp).toDate(),
    endDate: (data['endDate'] as Timestamp).toDate(),
    status: data['status'] ?? 'pending',
    itemTitle: data['itemTitle'],
  );
}


  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'itemId': itemId,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
    };
  }

  Reservation copyWith({
    String? id,
    String? userId,
    String? itemId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? itemTitle,
  }) {
    return Reservation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      itemTitle: itemTitle ?? this.itemTitle,
    );
  }
}
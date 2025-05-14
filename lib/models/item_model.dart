import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String ownerId;
  final String title;
  final String description;
  final List<String> imageUrls;
  final double pricePerDay;
  final String category;
  final String location;
  final DateTime createdAt;
  final List<DateTime> reservedDates;

  ItemModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.pricePerDay,
    required this.category,
    required this.location,
    required this.createdAt,
    required this.reservedDates,
  });

  factory ItemModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ItemModel(
      id: documentId,
      ownerId: data['ownerId']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      pricePerDay: (data['pricePerDay'] != null)
          ? double.tryParse(data['pricePerDay'].toString()) ?? 0.0
          : 0.0,
      category: data['category']?.toString() ?? '',
      location: data['location']?.toString() ?? '',
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      reservedDates: data['reservedDates'] != null
          ? List<Timestamp>.from(data['reservedDates'])
              .map((ts) => ts.toDate())
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'pricePerDay': pricePerDay,
      'category': category,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
      'reservedDates': reservedDates.map((d) => Timestamp.fromDate(d)).toList(),
    };
  }
    factory ItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ItemModel.fromMap(data, doc.id);
  }

  bool get isFree => pricePerDay == 0;
}

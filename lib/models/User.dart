import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? address;
  final String? phoneNumber;
  final double rating;
  final int reviewCount;

  UserModel({
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    this.address,
    this.phoneNumber,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  // Créer une instance depuis un Map (Firebase)
  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'],
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      address: data['address'],
      phoneNumber: data['phoneNumber'],
      rating: data['rating'] ?? 0.0,
      reviewCount: data['reviewCount'] ?? 0,
    );
  }

  // Convertir en Map pour Firebase
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'address': address,
      'phoneNumber': phoneNumber,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  // Créer une copie avec des valeurs mises à jour
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? address,
    String? phoneNumber,
    double? rating,
    int? reviewCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}
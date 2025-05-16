import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    _user = firebaseUser;
    if (_user != null) {
      await _createUserDocumentIfNotExists(_user!);
    }
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> register(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> _createUserDocumentIfNotExists(User firebaseUser) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid);
    final doc = await userDoc.get();

    if (!doc.exists) {
      await userDoc.set({
        'displayname': firebaseUser.displayName ?? 'Utilisateur',
        'email': firebaseUser.email,
        'phoneNumber': firebaseUser.phoneNumber ?? '',
        'photoUrl': [firebaseUser.photoURL ?? 'https://www.example.com/default-avatar.png'],
        'rating': 0,
        'reviewCount': 0,
        'address': '',
      });
    }
  }
}
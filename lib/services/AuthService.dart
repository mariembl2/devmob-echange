import 'package:dev_mob/views/auth/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dev_mob/models/user.dart'; // Assurez-vous d'importer votre modèle UserModel
import 'package:flutter/material.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  // Méthode pour convertir un utilisateur Firebase en UserModel
  UserModel? _userFromFirebase(User? user) {
    if (user == null) return null;
    return UserModel(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  // Flux d'état utilisateur en tant que UserModel
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  // Connexion avec Google
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) return await _auth.signInWithPopup(googleProvider);

    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  // Connexion avec email et mot de passe
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Erreur lors de la connexion : ${e.toString()}');
    }
  }

  // Déconnexion avec redirection vers la page de connexion
  Future<void> signOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();

      // Redirection vers la page de connexion après déconnexion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),  // Remplace LoginPage par le nom de ta page de connexion
      );
    } catch (e) {
      print("Erreur lors de la déconnexion : $e");
    }
  }
}

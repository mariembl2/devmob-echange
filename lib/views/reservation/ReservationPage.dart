import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_mob/models/item_model.dart';
import 'package:dev_mob/models/reservation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  final ItemModel item;  // L'objet que l'utilisateur veut réserver

  const ReservationPage({Key? key, required this.item}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  TextEditingController _messageController = TextEditingController();

  // Méthode pour soumettre la réservation
  void _submitReservation() async {
    if (_startDate != null && _endDate != null && _startDate!.isBefore(_endDate!)) {
      final reservationData = {
        'itemId': widget.item.id,
        'ownerId': widget.item.ownerId,
        'startDate': Timestamp.fromDate(_startDate!),
        'endDate': Timestamp.fromDate(_endDate!),
        'message': _messageController.text.trim(),
        'status': 'pending', // Statut initial de la réservation
        'createdAt': Timestamp.now(),
        'userId': FirebaseAuth.instance.currentUser?.uid,  // L'ID de l'utilisateur connecté
      };

      try {
        // Enregistrer la réservation dans Firestore
        await FirebaseFirestore.instance.collection('reservations').add(reservationData);
        
        // Afficher un message de confirmation ou rediriger vers une autre page
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Réservation effectuée !')));
        Navigator.pop(context);  // Ferme la page de réservation après la soumission
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la réservation : $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez sélectionner des dates valides.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Réserver "${widget.item.title}"')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dates de réservation :', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _startDate = selectedDate;
                      });
                    }
                  },
                  child: Text(_startDate == null ? 'Sélectionner la date de début' : 'Début: ${_startDate!.toLocal()}'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _endDate = selectedDate;
                      });
                    }
                  },
                  child: Text(_endDate == null ? 'Sélectionner la date de fin' : 'Fin: ${_endDate!.toLocal()}'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Message (facultatif) :'),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(hintText: 'Ajouter un message...'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReservation,
              child: Text('Confirmer la réservation'),
            ),
          ],
        ),
      ),
    );
  }
}

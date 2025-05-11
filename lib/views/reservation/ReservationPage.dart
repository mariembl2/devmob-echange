import 'package:flutter/material.dart';
import 'package:dev_mob/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationPage extends StatefulWidget {
  final ItemModel item;

  const ReservationPage({Key? key, required this.item}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  void _submitReservation() async {
    if (_formKey.currentState!.validate() && _startDate != null && _endDate != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Ajouter la réservation dans Firestore
        final reservationData = {
          'itemId': widget.item.id,
          'ownerId': widget.item.ownerId,
          'startDate': Timestamp.fromDate(_startDate!),
          'endDate': Timestamp.fromDate(_endDate!),
          'message': _messageController.text.trim(),
          'status': 'pending', // Statut initial : en attente
          'createdAt': Timestamp.now(),
        };

        await FirebaseFirestore.instance.collection('reservations').add(reservationData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Réservation envoyée avec succès !')),
        );

        Navigator.pop(context); // Retour à la page précédente
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner une plage de dates.')),
      );
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réserver ${widget.item.title}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sélection de la plage de dates
              Text(
                'Sélectionnez une plage de dates :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _selectDateRange,
                child: Text(_startDate == null || _endDate == null
                    ? 'Choisir une plage de dates'
                    : 'Du ${_startDate!.toLocal()} au ${_endDate!.toLocal()}'),
              ),
              SizedBox(height: 16),

              // Champ pour le message optionnel
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Message (optionnel)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24),

              // Bouton pour soumettre la réservation
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitReservation,
                      child: Text('Envoyer la demande de réservation'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:dev_mob/models/item_model.dart';
import 'package:dev_mob/providers/AuthProvider.dart';

class ReservationForm extends StatefulWidget {
  final ItemModel item;

  const ReservationForm({Key? key, required this.item}) : super(key: key);

  @override
  _ReservationFormState createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  void _submitReservation(String renterId) async {
    if (_formKey.currentState!.validate() && _startDate != null && _endDate != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final reservationData = {
          'itemId': widget.item.id,
          'ownerId': widget.item.ownerId,
          'renterId': renterId,
          'startDate': Timestamp.fromDate(_startDate!),
          'endDate': Timestamp.fromDate(_endDate!),
          'message': _messageController.text.trim(),
          'status': 'pending',
          'createdAt': Timestamp.now(),
        };

        await FirebaseFirestore.instance.collection('reservations').add(reservationData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Réservation envoyée avec succès !')),
        );

        Navigator.pop(context);
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
    final authProvider = Provider.of<AuthProvider>(context);
    final renter = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Réserver ${widget.item.title}'),
      ),
      body: renter == null
          ? Center(child: Text("Utilisateur non connecté"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Sélectionnez une plage de dates :',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _selectDateRange,
                      child: Text(
                        (_startDate == null || _endDate == null)
                            ? 'Choisir une plage de dates'
                            : 'Du ${DateFormat('dd/MM/yyyy').format(_startDate!)} au ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        labelText: 'Message (optionnel)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 24),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () => _submitReservation(renter.uid),
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
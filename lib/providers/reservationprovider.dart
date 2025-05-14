
// lib/providers/reservationprovider.dart
import 'package:dev_mob/services/ReservationService.dart';
import 'package:flutter/material.dart';
import 'package:dev_mob/models/reservation.dart';


class ReservationProvider with ChangeNotifier {
  final ReservationService _reservationService = ReservationService();

  List<Reservation> _reservations = [];
  List<Reservation> get reservations => _reservations;

  ReservationProvider() {
    _fetchReservations();
  }

  void _fetchReservations() {
    _reservationService.getReservations().listen((data) {
      _reservations = data;
      notifyListeners();
    });
  }

  Future<void> addReservation(Reservation reservation) async {
    await _reservationService.addReservation(reservation);
  }

  Future<void> cancelReservation(String reservationId) async {
    await _reservationService.cancelReservation(reservationId);
  }
}

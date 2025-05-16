# DEVMOB – Échange 📱🔁

Application Flutter permettant aux utilisateurs de proposer et réserver des objets du quotidien, dans une logique de partage et de réutilisation. Ce projet a été réalisé dans le cadre du module DEVMOB.

## ✨ Fonctionnalités principales

- 🔐 Authentification (connexion / inscription)
- 🧾 Ajout, édition et suppression d'objets à louer
- 🗂️ Dashboard personnel (objets publiés par l’utilisateur)
- 📅 Système de réservation avec calendrier et message
- ✅ Acceptation ou refus des réservations par le propriétaire
- 🔍 Page d'accueil avec liste des objets disponibles

## 📷 Gestion des images

- L'ajout d'une image d’objet est **optionnel** via un champ d’URL.

## 🛠️ Technologies utilisées

- **Flutter** (framework frontend)
- **Firebase** (Auth, Firestore)
- **Provider** (gestion d’état)
- **Cloud Firestore** (base de données temps réel)

## 📁 Structure du projet
lib/
├── models/ # User, Item, Reservation, Review
├── services/ # AuthService, ItemService, ReservationService,
NotificationService
├── providers/ # AuthProvider, ItemProvider, ReservationProvider
├── views/
│ ├── auth/ # LoginPage, RegisterPage
│ ├── home/ # HomePage, ItemListView, SearchBar
│ ├── item/ # ItemDetailPage, AddItemPage, EditItemPage
│ ├── reservation/ # ReservationPage, ReservationForm, OwnerDashboard
│ ├── profile/ # UserProfile, MyObjectsPage, MyReservationsPage
│ ├── review/ # LeaveReviewPage, RatingsListPage
├── widgets/ # ItemCard
└── main.dart

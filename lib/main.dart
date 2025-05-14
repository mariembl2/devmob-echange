import 'package:dev_mob/profile/MyReservationsPage.dart';
import 'package:dev_mob/profile/UserProfile.dart';

import 'package:dev_mob/providers/AuthProvider.dart';
import 'package:dev_mob/providers/ReservationProvider.dart';
import 'package:dev_mob/providers/ItemProvider.dart'; // ✅ Ajout de l'import

import 'package:dev_mob/views/reservation/OwnerDashboard.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dev_mob/services/itemservice.dart';
import 'package:dev_mob/models/item_model.dart';

import 'package:dev_mob/views/auth/LoginPage.dart';
import 'package:dev_mob/views/auth/RegisterPage.dart' as views;
import 'package:dev_mob/views/home/HomePage.dart';
import 'package:dev_mob/views/item/AddItemPage.dart';
import 'package:dev_mob/views/item/ItemDetailPage.dart';
import 'package:dev_mob/views/reservation/ReservationPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()), // ✅ Ajout du provider
        StreamProvider<List<ItemModel>>.value(
          value: ItemService().getItems(),
          initialData: const [],
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEVMOB - Échange',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/login': (context) => LoginPage(),
        '/register': (context) => views.RegisterPage(),
        '/home': (context) => HomePage(),
        '/add-item': (context) => AddItemPage(),
        '/my-reservations': (context) => MyReservationsPageWrapper(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/item-detail') {
          final item = settings.arguments as ItemModel?;
          return MaterialPageRoute(builder: (context) => ItemDetailPage(item: item!));
        } else if (settings.name == '/reservation') {
          final item = settings.arguments as ItemModel?;
          return MaterialPageRoute(builder: (context) => ReservationPage(item: item!));
        } else if (settings.name == '/dashboard') {
          final ownerId = settings.arguments as String?;
          if (ownerId != null) {
            return MaterialPageRoute(builder: (context) => OwnerDashboard());
          }
        } else if (settings.name == '/profile') {
          final userId = settings.arguments as String?;
          if (userId != null) {
            return MaterialPageRoute(builder: (context) => UserProfilePage());
          }
        }

        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text("Route inconnue : ${settings.name}")),
          ),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }
}

class MyReservationsPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      return MyReservationsPage(userId: user.uid);
    } else {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}

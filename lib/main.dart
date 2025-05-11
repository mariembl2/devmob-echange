import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dev_mob/services/AuthService.dart' as services;
import 'package:dev_mob/services/itemservice.dart';
import 'package:dev_mob/models/user.dart';
import 'package:dev_mob/models/item.dart';

import 'package:dev_mob/views/auth/LoginPage.dart';
import 'package:dev_mob/views/auth/RegisterPage.dart' as views;
import 'package:dev_mob/views/home/HomePage.dart';
import 'package:dev_mob/views/item/ItemDetailPage.dart';
import 'package:dev_mob/views/item/AddItemPage.dart';
import 'package:dev_mob/views/reservation/ReservationPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        StreamProvider<UserModel?>.value(
          value: services.AuthService().user,
          initialData: null,
        ),
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          secondary: Colors.orange,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/login': (context) => LoginPage(),
        '/register': (context) => views.RegisterPage(),
        '/home': (context) => HomePage(),
        '/add-item': (context) => AddItemPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/item-detail') {
          final ItemModel item = settings.arguments as ItemModel;
          return MaterialPageRoute(
            builder: (context) => ItemDetailPage(item: item),
          );
        } else if (settings.name == '/reservation') {
          final ItemModel item = settings.arguments as ItemModel;
          return MaterialPageRoute(
            builder: (context) => ReservationPage(item: item),
          );
        }
        return null;
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    print('Utilisateur actuel : $user');

    return user == null ? LoginPage() : HomePage();
  }
}

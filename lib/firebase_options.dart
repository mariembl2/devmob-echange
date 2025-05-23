// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyColuCYvUyicYnx112uEDxzKUyar9naD-o',
    appId: '1:869630533762:web:0322c87f5626713353d49b',
    messagingSenderId: '869630533762',
    projectId: 'devmob-echange',
    authDomain: 'devmob-echange.firebaseapp.com',
    storageBucket: 'devmob-echange.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDOhMphUiMhzLisBIWJmrNLXMfzB3TwEZY',
    appId: '1:869630533762:android:f5d4162c7f7d8c9753d49b',
    messagingSenderId: '869630533762',
    projectId: 'devmob-echange',
    storageBucket: 'devmob-echange.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyComzwcWCCarTAhg7NbG6SiNkU04lnpe6A',
    appId: '1:869630533762:ios:143dc21323c73cf353d49b',
    messagingSenderId: '869630533762',
    projectId: 'devmob-echange',
    storageBucket: 'devmob-echange.firebasestorage.app',
    iosClientId: '869630533762-pv6alo1e0445tk5i869qjm04v8iimhcs.apps.googleusercontent.com',
    iosBundleId: 'com.example.devMob',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyComzwcWCCarTAhg7NbG6SiNkU04lnpe6A',
    appId: '1:869630533762:ios:143dc21323c73cf353d49b',
    messagingSenderId: '869630533762',
    projectId: 'devmob-echange',
    storageBucket: 'devmob-echange.firebasestorage.app',
    iosClientId: '869630533762-pv6alo1e0445tk5i869qjm04v8iimhcs.apps.googleusercontent.com',
    iosBundleId: 'com.example.devMob',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyColuCYvUyicYnx112uEDxzKUyar9naD-o',
    appId: '1:869630533762:web:b09c9dc40f8eda2353d49b',
    messagingSenderId: '869630533762',
    projectId: 'devmob-echange',
    authDomain: 'devmob-echange.firebaseapp.com',
    storageBucket: 'devmob-echange.firebasestorage.app',
  );
}

// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAfjAyWRRMK1uiFRDpnCM8Vhf4sIVDcKD0',
    appId: '1:657863146043:web:c1610da68f5331cd743a1e',
    messagingSenderId: '657863146043',
    projectId: 'wodobro-a53c8',
    authDomain: 'wodobro-a53c8.firebaseapp.com',
    storageBucket: 'wodobro-a53c8.appspot.com',
    measurementId: 'G-K0N9WTWFTV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDonDxUaob_Hv06y3TDCOg6yZkSbh4zNi0',
    appId: '1:657863146043:android:6ba1f34318e4e1d4743a1e',
    messagingSenderId: '657863146043',
    projectId: 'wodobro-a53c8',
    storageBucket: 'wodobro-a53c8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsTRIfWA-rFkGsSd5s_gtNB97rhCHJk-8',
    appId: '1:657863146043:ios:b1601098028f96ab743a1e',
    messagingSenderId: '657863146043',
    projectId: 'wodobro-a53c8',
    storageBucket: 'wodobro-a53c8.appspot.com',
    iosClientId: '657863146043-n7ak7bi5khhomucrabvigko64gungi04.apps.googleusercontent.com',
    iosBundleId: 'com.example.wodobro',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAsTRIfWA-rFkGsSd5s_gtNB97rhCHJk-8',
    appId: '1:657863146043:ios:b1601098028f96ab743a1e',
    messagingSenderId: '657863146043',
    projectId: 'wodobro-a53c8',
    storageBucket: 'wodobro-a53c8.appspot.com',
    iosClientId: '657863146043-n7ak7bi5khhomucrabvigko64gungi04.apps.googleusercontent.com',
    iosBundleId: 'com.example.wodobro',
  );
}

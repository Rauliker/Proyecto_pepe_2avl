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
    apiKey: 'AIzaSyBTdsdNNO354-0nnxaiAUkjomym8Td2pcg',
    appId: '1:588633609674:web:ad1c81df1c4b0d56786b33',
    messagingSenderId: '588633609674',
    projectId: 'proyecto-final-raul',
    authDomain: 'proyecto-final-raul.firebaseapp.com',
    storageBucket: 'proyecto-final-raul.firebasestorage.app',
    measurementId: 'G-REFRVXKMZC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkuieWuZBixwASr3DYvi1bwTpvH_J_z_4',
    appId: '1:588633609674:android:adc1a58982d00a8b786b33',
    messagingSenderId: '588633609674',
    projectId: 'proyecto-final-raul',
    storageBucket: 'proyecto-final-raul.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCcN-_xGn_7d5t3PfU9piJZ6DxuQfSYiz0',
    appId: '1:588633609674:ios:3b56429c41fc441c786b33',
    messagingSenderId: '588633609674',
    projectId: 'proyecto-final-raul',
    storageBucket: 'proyecto-final-raul.firebasestorage.app',
    iosBundleId: 'com.example.proyectoRaul',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCcN-_xGn_7d5t3PfU9piJZ6DxuQfSYiz0',
    appId: '1:588633609674:ios:3b56429c41fc441c786b33',
    messagingSenderId: '588633609674',
    projectId: 'proyecto-final-raul',
    storageBucket: 'proyecto-final-raul.firebasestorage.app',
    iosBundleId: 'com.example.proyectoRaul',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBTdsdNNO354-0nnxaiAUkjomym8Td2pcg',
    appId: '1:588633609674:web:53f5acbb2834493c786b33',
    messagingSenderId: '588633609674',
    projectId: 'proyecto-final-raul',
    authDomain: 'proyecto-final-raul.firebaseapp.com',
    storageBucket: 'proyecto-final-raul.firebasestorage.app',
    measurementId: 'G-KZ2EDMCH1N',
  );
}

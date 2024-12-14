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
    apiKey: 'AIzaSyBZIG-393xWrbH5zxAUN1S0a2MaAoFDphQ',
    appId: '1:576410828598:web:3cd4f7b12f0325d65f3d97',
    messagingSenderId: '576410828598',
    projectId: 'proyecto-final-pepe',
    authDomain: 'proyecto-final-pepe.firebaseapp.com',
    storageBucket: 'proyecto-final-pepe.firebasestorage.app',
    measurementId: 'G-LTRV7V4QVR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC7m4QZr9yAwrqk5_KI51weZQTETKpHoic',
    appId: '1:576410828598:android:57c55fce4b79796a5f3d97',
    messagingSenderId: '576410828598',
    projectId: 'proyecto-final-pepe',
    storageBucket: 'proyecto-final-pepe.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCOg1rqaBc5zcsuw0HHYM3LYIMFZ1okxhU',
    appId: '1:576410828598:ios:c2aa3b9fca5859085f3d97',
    messagingSenderId: '576410828598',
    projectId: 'proyecto-final-pepe',
    storageBucket: 'proyecto-final-pepe.firebasestorage.app',
    iosBundleId: 'com.example.proyectoRaul',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCOg1rqaBc5zcsuw0HHYM3LYIMFZ1okxhU',
    appId: '1:576410828598:ios:c2aa3b9fca5859085f3d97',
    messagingSenderId: '576410828598',
    projectId: 'proyecto-final-pepe',
    storageBucket: 'proyecto-final-pepe.firebasestorage.app',
    iosBundleId: 'com.example.proyectoRaul',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBZIG-393xWrbH5zxAUN1S0a2MaAoFDphQ',
    appId: '1:576410828598:web:92b4023a7dcc90065f3d97',
    messagingSenderId: '576410828598',
    projectId: 'proyecto-final-pepe',
    authDomain: 'proyecto-final-pepe.firebaseapp.com',
    storageBucket: 'proyecto-final-pepe.firebasestorage.app',
    measurementId: 'G-KSYEXYRFNM',
  );

}
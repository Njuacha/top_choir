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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCL_NSgPdR5qPqUURmh_nBxWa9QKiokd84',
    appId: '1:837621467675:web:e085f341b4c24b4231c6be',
    messagingSenderId: '837621467675',
    projectId: 'top-choir-project',
    authDomain: 'top-choir-project.firebaseapp.com',
    storageBucket: 'top-choir-project.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDC_vw0BkPwB5b615Uq-Edw9y3HwX-gqYI',
    appId: '1:837621467675:android:2e7106002080736931c6be',
    messagingSenderId: '837621467675',
    projectId: 'top-choir-project',
    storageBucket: 'top-choir-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBzz1EOpRgrJvk_7NoTu1LXWDKm0YVaP_k',
    appId: '1:837621467675:ios:913a7761f8f3186e31c6be',
    messagingSenderId: '837621467675',
    projectId: 'top-choir-project',
    storageBucket: 'top-choir-project.appspot.com',
    iosBundleId: 'com.africaningenuity.topChoir',
  );
}
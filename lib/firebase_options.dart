
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
    apiKey: 'AIzaSyA-e7j29ao3XCBvl51tZgEt31DMt_ZMrBs',
    appId: '1:372304366924:web:572fbbcf95c0f57cc093e9',
    messagingSenderId: '372304366924',
    projectId: 'login-1595a',
    authDomain: 'login-1595a.firebaseapp.com',
    storageBucket: 'login-1595a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCn12hBJqDAwRWlqra_ztMJfolzXqkOrks',
    appId: '1:35309336713:android:c986aa11f3e372e0f72e58',
    messagingSenderId: '35309336713',
    projectId: 'usersigninsignup-ccc20',
    storageBucket: 'usersigninsignup-ccc20.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(

    apiKey: 'AIzaSyD7Orh9eMdbx5VbH8c-IoJbLIFyCLw3SkA',
    appId: '1:35309336713:ios:dfb85e6c6c127937f72e58',
    messagingSenderId: '35309336713',
    projectId: 'usersigninsignup-ccc20',
    storageBucket: 'usersigninsignup-ccc20.appspot.com',
    iosClientId: '372304366924-hdssjdt36o346eqj8n1sjn5raga781rb.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebaseauthsigninsignup',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBKdojowR0tT673a0EE4M2y1t1y9qQh7N4',
    appId: '1:372304366924:ios:9cf71160a10ef6f0c093e9',
    messagingSenderId: '372304366924',
    projectId: 'login-1595a',
    storageBucket: 'login-1595a.appspot.com',
    iosClientId: '372304366924-hdssjdt36o346eqj8n1sjn5raga781rb.apps.googleusercontent.com',
    iosBundleId: 'com.example.googlelogin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA-e7j29ao3XCBvl51tZgEt31DMt_ZMrBs',
    appId: '1:372304366924:web:8bf8fc0b11acc77bc093e9',
    messagingSenderId: '372304366924',
    projectId: 'login-1595a',
    authDomain: 'login-1595a.firebaseapp.com',
    storageBucket: 'login-1595a.appspot.com',
  );

}
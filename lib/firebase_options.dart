import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyBbL70paNE9Aihq7IsF3tuhWaDYDofjX-4',
        appId: '1:32544950004:web:9420b959cc4a620546c0a1',
        messagingSenderId: '32544950004',
        projectId: 'life-manager-e5161',
        authDomain: 'life-manager-e5161.firebaseapp.com',
        storageBucket: 'life-manager-e5161.firebasestorage.app',
        measurementId: 'G-R3W97WNXFC',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'AIzaSyAZbJAWyRETtrFYAfjuxe7bmDYM5DJuSQQ',
          appId: '1:32544950004:android:b75d2ad24e13788246c0a1',
          messagingSenderId: '32544950004',
          projectId: 'life-manager-e5161',
          storageBucket: 'life-manager-e5161.firebasestorage.app',
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: 'AIzaSyCp2EB21iVH2NHxXzeEvB-jB2PJIl7uWVs',
          appId: '1:32544950004:ios:41f72df699e99eb846c0a1',
          messagingSenderId: '32544950004',
          projectId: 'life-manager-e5161',
          storageBucket: 'life-manager-e5161.firebasestorage.app',
          iosBundleId: 'com.example.taskmaster',
        );
      case TargetPlatform.macOS:
        return const FirebaseOptions(
          apiKey: 'AIzaSyCp2EB21iVH2NHxXzeEvB-jB2PJIl7uWVs',
          appId: '1:32544950004:ios:41f72df699e99eb846c0a1',
          messagingSenderId: '32544950004',
          projectId: 'life-manager-e5161',
          storageBucket: 'life-manager-e5161.firebasestorage.app',
          iosBundleId: 'com.example.taskmaster',
        );
      case TargetPlatform.windows:
        return const FirebaseOptions(
          apiKey: 'AIzaSyAZbJAWyRETtrFYAfjuxe7bmDYM5DJuSQQ',
          appId: '1:32544950004:web:d54f6f826d9b6b1e46c0a1',
          messagingSenderId: '32544950004',
          projectId: 'life-manager-e5161',
          authDomain: 'life-manager-e5161.firebaseapp.com',
          storageBucket: 'life-manager-e5161.firebasestorage.app',
        );
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}

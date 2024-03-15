import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class MyFirebaseUtils {
  static final firestoreInstance = getFirebaseFirestoreInstance();
  static final firebaseAuthInstance = getFirebaseAuth();
  static final storageInstance = FirebaseStorage.instance;

  static FirebaseFirestore getFirebaseFirestoreInstance() {
    final instance = FirebaseFirestore.instance;
    /*if (kDebugMode) {
      instance.useFirestoreEmulator('127.0.0.1', 8080);
    }*/
    return instance;
  }

  static FirebaseAuth getFirebaseAuth() {
    final instance = FirebaseAuth.instance;
    /*if (kDebugMode) {
      instance.useAuthEmulator('127.0.0.1', 9099);
    }*/
    return instance;
  }

  static final userId = firebaseAuthInstance.currentUser?.uid;

  static Future<ShortDynamicLink> createDynamicLink(String groupId) =>
      FirebaseDynamicLinks.instance.buildShortLink(DynamicLinkParameters(
        link: Uri.parse("https://topchoir.page.link/$groupId"),
        uriPrefix: "https://topchoir.page.link",
        androidParameters: const AndroidParameters(
            packageName: "com.africaningenuity.top_choir"),
        iosParameters:
            const IOSParameters(bundleId: "com.africaningenuity.top_choir"),
      ));
}

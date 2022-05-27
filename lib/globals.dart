import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
late FirebaseApp firebaseApp;
late FirebaseAuth auth;
late FirebaseFirestore db;
late FirebaseStorage storage;

Future<void> initGlobals() async {
  prefs = await SharedPreferences.getInstance();
  firebaseApp = await Firebase.initializeApp();
  db = FirebaseFirestore.instance;
  auth = FirebaseAuth.instance;
  storage = FirebaseStorage.instance;
}

String? getUid() {
  if (prefs.getString("uid") == null) return null;
  return (prefs.getString("uid"))!;
}

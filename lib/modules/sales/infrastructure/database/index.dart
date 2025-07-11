import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiap_hackaton_app/firebase_options.dart';

late final FirebaseFirestore db;

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  db = FirebaseFirestore.instance;
}

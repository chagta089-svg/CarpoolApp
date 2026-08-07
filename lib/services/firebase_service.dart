import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';


  final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://carpool-app-c6d15-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

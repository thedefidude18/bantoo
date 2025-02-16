import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PresenceService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateUserPresence() {
    final user = _auth.currentUser;
    if (user != null) {
      final userStatusDatabaseRef = _database.child("status/${user.uid}");

      // Set user's status to online when connected.
      _database.child('.info/connected').onValue.listen((event) {
        if (event.snapshot.value == true) {
          userStatusDatabaseRef.set({"state": "online"});
          userStatusDatabaseRef.onDisconnect().set({"state": "offline"});
        }
      });
    }
  }
}

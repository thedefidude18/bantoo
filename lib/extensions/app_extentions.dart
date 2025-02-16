import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/extensions/map_extentions.dart';

extension DocumentReferenceExtention on DocumentReference? {
  Future<bool> doesKeyExist({required String key,required DocumentReference docRef}) async {
    try {
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists && snapshot.data() != null && (snapshot.data() as Map?).getValueOfKey(key)) {
        return true;
      } else {
        return false;
      }
    } catch (error) {

      return false;
    }
  }
}

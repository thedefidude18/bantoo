import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final String? uid;

  UserService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  Future<dynamic> gettingUserData({required String userId}) async {
    var snapshot = await userCollection.doc(userId).get();
    print("snapshot:${snapshot.data()}");
    return snapshot.data();
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

}

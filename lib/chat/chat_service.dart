import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/extensions/app_extentions.dart';
import 'package:flexx_bet/extensions/map_extentions.dart';
import 'package:flexx_bet/extensions/string_extentions.dart';
import 'package:flexx_bet/ui/components/components.dart';

class ChatService {
  final String? uid;

  ChatService({this.uid});

  // reference for our collections
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("chatrooms");
  final about = FirebaseFirestore.instance.collection("about");

  // saving the userdata
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // getting user data
  Future<Map?> getChatAboutData() async {
    var snapshot = await about.doc("chat_about").get();
    if(snapshot.exists && snapshot.data() !=null && snapshot.data() is Map){
      return snapshot.data();
    }
    return null;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  bool ifGroupFullAlready({required Map groupData}) {
    if (groupData.containsKey("membersLimit") &&
        (groupData.getValueOfKey("membersLimit") is int) &&
        groupData.containsKey("members") &&
        (groupData.getValueOfKey("members") is List)) {
      if ((groupData.getValueOfKey("membersLimit") as int) <=
          (groupData.getValueOfKey("members") as List).length) {
        return true;
      }
    }
    return false;
  }

  getUserImage({required String userId}) async {
    var doc = await userCollection.doc(userId).get();
    if (doc.exists) {
      if (doc.data() is Map) {
        return (doc.data() as Map).getValueOfKey("photoUrl");
      }
    }
    return null;
  }

  // creating a group
  Future<DocumentSnapshot?> createGroup(
      {required String userName,
      required String id,
      required String groupName,
      required String description,
      required String category,
        required DateTime startDate,
      required DateTime endDate,
      required int membersLimit,
      required int joinAmount,
        required bool creatorPaid,
      String? coverImage,
      String? rules,
      String? groupType,}) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "description": description,
      "category": category,
      "rules": rules,
      "admin": "${id}_$userName",
      "members": [],
      "groupIcon": coverImage,
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
      "groupType": groupType ?? GroupType.public.name,
      "membersLimit": membersLimit,
      "joinAmount": joinAmount,
      "creatorPaid":creatorPaid,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "endAt": endDate.millisecondsSinceEpoch,
      "startAt": startDate.millisecondsSinceEpoch
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });

    return await groupDocumentReference.get();
  }


  // creating a group
  Future updateGroup(
      {
        required String groupId,
        required String groupName,
        required String description,
        required String category,
        required DateTime startDate,
        required DateTime endDate,
        required int membersLimit,
        required int joinAmount,
        required bool creatorPaid,
        String? coverImage,
        String? rules,
        String? groupType}) async {

    await groupCollection.doc(groupId).update(
      {
        "groupName": groupName,
        "description": description,
        "category": category,
        "rules": rules,
        "groupIcon": coverImage,
        "groupType": groupType ?? GroupType.public.name,
        "membersLimit": membersLimit,
        "joinAmount": joinAmount,
        "creatorPaid":creatorPaid,
        "updateAt": DateTime.now().millisecondsSinceEpoch,
        "endAt": endDate.millisecondsSinceEpoch,
        "startAt": startDate.millisecondsSinceEpoch
      }
    );
  }


  // getting the chats
  Stream<dynamic> getChats(String groupId) {
    return groupCollection.doc(groupId).collection("messages").orderBy("createdAt").snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // search
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // search
  getAllGroup() {
    return groupCollection.get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'] ?? [];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future<DocumentReference?> toggleGroupJoin(
      {required String groupId,
        required String userName,
        required String groupName,
        String? userId}) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(userId ?? uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    // Fetch user document
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    Map<String, dynamic>? userData = documentSnapshot.data() as Map<String, dynamic>?;

    // Ensure 'groups' field is initialized if it doesn't exist
    if (userData == null || !userData.containsKey('groups')) {
      await userDocumentReference.set({"groups": []}, SetOptions(merge: true));
      documentSnapshot = await userDocumentReference.get();
      userData = documentSnapshot.data() as Map<String, dynamic>?;
    }

    // Get the current 'groups' field
    List<dynamic> groups = userData?['groups'] ?? [];

    // Check if the group is already in the user's 'groups' list
    if (groups.contains("${groupId}_$groupName")) {
      // Remove the group from the user's 'groups' list
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });

      // Remove the user from the group's 'members' list
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${userId ?? uid}_$userName"])
      });
    } else {
      // Add the group to the user's 'groups' list
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });

      // Add the user to the group's 'members' list
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${userId ?? uid}_$userName"])
      });
    }

    return groupDocumentReference;
  }


  // send message
  Future<dynamic> sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    return await groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  Future<dynamic> sendJoinRequestMessage(
      {required String groupId,
      required Map<String, dynamic> requestData}) async {
    try {
      showLoadingIndicator();
      var snapshot = await groupCollection
          .doc(groupId)
          .collection("requests")
          .where("uid", isEqualTo: requestData.getValueOfKey("uid"))
          .get();
      if (snapshot.docs.isEmpty) {
        await groupCollection
            .doc(groupId)
            .collection("requests")
            .add(requestData);
      }
      hideLoadingIndicator();
    } catch (e) {
      e.toString().printFailure();
      hideLoadingIndicator();
    }
  }

  Stream<bool> hasAlreadySendRequest(
      {required String groupId, required String userId}) {
    return groupCollection
        .doc(groupId)
        .collection("requests")
        .where("uid", isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.isNotEmpty);
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getRequests(
      {required String groupId}) {
    return groupCollection
        .doc(groupId)
        .collection("requests")
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs);
  }

  Future<dynamic> approvedRequest({
    required String groupId,
    required String userName,
    required String groupName,
    required String requestId,
    required String userId,
  }) async {
    var doc = await groupCollection
        .doc(groupId)
        .collection("requests")
        .doc(requestId)
        .get();
    if (doc.exists) {
      await toggleGroupJoin(
        groupId: groupId,
        userName: userName,
        groupName: groupName,
        userId: userId,
      );
      await doc.reference.delete();
    }
  }
}

enum GroupType {
  private,
  public,
}

enum MessageType {
  image,
  text,
  audio,
  video,
  file,
}

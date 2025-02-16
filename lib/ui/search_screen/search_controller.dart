import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../models/search_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static AuthController to = Get.find<AuthController>();
  Future<List<SearchModel>> searchEvents() async {
    List<SearchModel> searchedItems = [];

    // Fetch events collection
    QuerySnapshot eventsSnapshot = await _db.collection('events').get();
    eventsSnapshot.docs.forEach((eventDoc) {
      Map<String, dynamic> eventData = eventDoc.data() as Map<String, dynamic>;
      searchedItems.add(SearchModel(
        eventData['uid'] ?? '',
        eventData['eventBanner'] ?? '',
        eventData['eventsNames'] ?? '',
        eventData['title'] ?? '',
        eventData['isCancelled'] == false && eventData['isEnded'] == false
            ? "Live"
            : _formatTime(eventData['heldDate']),
        "event",
        eventData['category'] ?? '',
        '',
        0,
        eventData['peopleBetting']
      ));
    });

    // Fetch chatrooms collection
    QuerySnapshot chatRoomSnapshot = await _db.collection('chatrooms').get();
    chatRoomSnapshot.docs.forEach((chatRoomDoc) {
      Map<String, dynamic> chatRoomData = chatRoomDoc.data() as Map<String, dynamic>;

      final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
      if(uid !=  (chatRoomData['admin'] ?? '').toString().split('_').first){
        searchedItems.add(SearchModel(
          chatRoomData['groupId'] ?? '',
          chatRoomData['groupIcon'] ?? '',
          chatRoomData['groupName'] ?? '',
          chatRoomData['description'] ?? '',
          "",
          "chat",
          chatRoomData['category'] ?? '',
          chatRoomData['admin'] ?? '',
          chatRoomData['endAt'] ?? 0,
          chatRoomData['members']
        ));
      }
    });

    return searchedItems;
  }

  String _formatTime(dynamic heldDate) {
    if (heldDate is Timestamp) {
      DateTime dateTime = heldDate.toDate(); // Convert Timestamp to DateTime
      return DateFormat('h:mm a').format(dateTime); // Format the DateTime
    } else if (heldDate is DateTime) {
      return DateFormat('h:mm a').format(heldDate); // Format the DateTime directly
    } else {
      return 'Not Available';
    }
  }
}

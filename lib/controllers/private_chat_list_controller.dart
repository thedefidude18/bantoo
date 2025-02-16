import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/notification_model.dart';
import '../models/private_chat_list_model.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

class PrivateChatListController extends GetxController {
  static PrivateChatListController to = Get.put(PrivateChatListController());
  final Rxn<List<PrivateChatListModel>> privatechatlist =
      Rxn<List<PrivateChatListModel>>();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  AuthController authController = AuthController.to;
  final RxBool isLoading = true.obs;

  @override
  void onReady() {
    privatechatlist.bindStream(fetchData());
    super.onReady();
  }

  void getFriends() {
    final UserModel userModel = authController.userFirestore!;
    final String userId = userModel.uid;

    // Create a list to hold friend request data
    List<Map<String, dynamic>> friendRequests = [];

    _db.collection('friend_requests').snapshots().listen((snapshot) {
      for (var document in snapshot.docs) {
        var data = document.data();
        var from = data['from'];
        var to = data['to'];

        // Check if the logged-in user is either the sender or the receiver
        if (from == userId || to == userId) {
          // Add the matching friend request data to the list
          friendRequests.add(data);
        }
      }

      // Now you can use the friendRequests array as needed
      print("All Friend Requests for User $userId: $friendRequests");
    });
  }

  Stream<List<PrivateChatListModel>> fetchData() {
    final UserModel userModel = authController.userFirestore!;
    Get.log("_streamNotifications");
    isLoading.value = true;

    return _db
        .collection('/notifications')
        .where("id", isEqualTo: userModel.uid)
        .snapshots()
        .map((snapshot) {
      List<PrivateChatListModel> notifications = [];
      for (var doc in snapshot.docs) {
        notifications.add(PrivateChatListModel.fromJson(doc.data()));
      }
      isLoading.value = false;
      // print("HelloHello::${notifications}");
      return notifications;
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

class NotificationController extends GetxController {
  static NotificationController to = Get.find<NotificationController>();
  final Rxn<List<NotificationModel>> notificationsList =
      Rxn<List<NotificationModel>>();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  AuthController authController = AuthController.to;

  @override
  void onReady() {
    notificationsList.bindStream(fetchData());
    super.onReady();
  }

  Future<void> addNotification(NotificationModel notification) async {
    final CollectionReference notificationsCollection =
        _db.collection('notifications');
    notificationsList.refresh();
    try {
      await notificationsCollection.add(notification.toJson());
      print("Notification added successfully!");
    } catch (e) {
      print("Error adding notification: $e");
    }
  }

  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  // Method to delete a notification
  Future<void> deleteNotification(NotificationModel notificationModel) async {
    try {
      // Assuming the document ID is stored in notificationModel.id
      await notificationsCollection.doc(notificationModel.userId).delete();

      print("Notification deleted successfully");
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  Stream<List<NotificationModel>> fetchData() {
    final UserModel userModel = authController.userFirestore!;
    Get.log("_streamNotifications");

    return _db
        .collection('/notifications')
        .where("id", isEqualTo: userModel.uid)
        .snapshots()
        .map((snapshot) {
      List<NotificationModel> notifications = [];
      for (var doc in snapshot.docs) {
        notifications.add(NotificationModel.fromJson(doc.data()));
      }

      return notifications;
    });
  }
}

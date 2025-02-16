import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/models/notification_model.dart';
import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flexx_bet/ui/notifications_and_bethistory/widgets/bet_loss_screen.dart';
import 'package:flexx_bet/ui/notifications_and_bethistory/widgets/bet_won_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/events_controller.dart';
import '../../controllers/notification_controller.dart';
import 'package:awesome_notifications/awesome_notifications.dart' as awesome;

import '../../models/event_model.dart';
import '../wallet/wallet.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationController notificationController = NotificationController.to;
  @override
  void initState() {
    super.initState();
    // Print sorted notifications list with meaningful information
    print(
        "MyList::${notificationController.notificationsList.value!..sort((a, b) => b.creationDate.compareTo(a.creationDate))}");
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    // Sort the notifications list by date and time, latest first
    final sortedNotifications = notificationController.notificationsList.value!
      ..sort((a, b) => b.creationDate.compareTo(a.creationDate));

    // Get the latest notification type
    String latestNotificationType = sortedNotifications.isNotEmpty
        ? sortedNotifications.first.type
        : 'general'; // Default to 'general' if no notifications are present
    final notifications = notificationController.notificationsList.value;
    final uniqueNotifications = filterDuplicates(notifications!);
    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      appBar: const CustomAppBar(
        showBackButton: true,
        showBetCreateButton: false,
        showCreateEvent: false,
      ),
      body: ListView.builder(
        itemCount: uniqueNotifications.length,
        // itemCount: sortedNotifications.length,
        itemBuilder: (context, index) {
          final notification = uniqueNotifications[index];
          print("OKOK::${notification}");

          if (notification.type == "Matched") {
            return matchedNotificaitonTile(context, notification);
          } else if (notification.type == "Money Transferred") {
            return paymentDeductNotificaitonTile(context, notification);
          } else if (notification.type == "Accepted") {
            return requestAcceptNotificaitonTile(context, notification);
          } else if (notification.type == "Rejected") {
            return requestRejectNotificaitonTile(context, notification);
          } else if (notification.type == "Request") {
            return requestSendNotificaitonTile(context, notification);
          } else if (notification.type == "pending") {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(notification.title)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ListTile(title: Text("Loading...")); // Loading state
                }
                final userName = snapshot.data?['name'] ?? "Unknown";

                return ListTile(
                  title: Text("You have sent a friend request to $userName"),
                );
              },
            );
          } else if (notification.type == "Money Deposit") {
            return paymentReceiveNotificaitonTile(context, notification);
          } else if (notification.type == "Win") {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BetWonScreen(notification)));
              },
              child: challengeWonNotificaitonTile(context, notification),
            );
          } else if (notification.type == "Loss") {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BetLossScreen(notification)));
              },
              child: challengeLostNotificaitonTile(context, notification),
            );
          }
          return Container();
        },
      ),
    );
  }

  // void _acceptFriendRequest(NotificationModel notificationModel) async {
  //   final firestore = FirebaseFirestore.instance;

  //   try {
  //     // Assuming the collection for friend requests is 'friend_requests'
  //     final requestRef =
  //         firestore.collection('friend_requests').doc(notificationModel.userId);

  //     // Update the friend request to 'accepted'
  //     await requestRef.update({'status': 'accepted'});

  //     // Assuming you have a collection for users and a 'friends' field to update
  //     final userRef =
  //         firestore.collection('users').doc(notificationModel.userId);

  //     // Add the user to the 'friends' list
  //     await userRef.update({
  //       'friends': FieldValue.arrayUnion(
  //           [notificationModel.userId]), // Adjust this as needed
  //     });
  //     setState(() {});
  //     print('Friend request from ${notificationModel.userId} accepted.');
  //   } catch (e) {
  //     print('Failed to accept friend request: $e');
  //   }
  // }
  void _acceptFriendRequest(NotificationModel notificationModel) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Assuming the collection for friend requests is 'friend_requests'
      final requestRef =
          firestore.collection('friend_requests').doc(notificationModel.userId);

      // Update the friend request to 'accepted'
      await requestRef.update({'status': 'accepted'});

      // Assuming you have a collection for users and a 'friends' field to update
      final userRef =
          firestore.collection('users').doc(notificationModel.userId);

      // Add the user to the 'friends' list
      await userRef.update({
        'friends': FieldValue.arrayUnion(
          [notificationModel.userId], // Adjust this as needed
        ),
      });

      NotificationModel acceptedNotification = NotificationModel(
        userId: notificationModel.userId,
        senderName: notificationModel.senderName ??
            'Unknown User', // Ensure senderName is set
        body: 'Friend request Accepted',
        userImage: notificationModel.userImage,
        currentUserImage: notificationModel.currentUserImage,
        type: 'Accepted',
        creationDate: Timestamp.now(),
        title: 'Friend Request',
        amount: notificationModel.amount, // Adjust this as needed
        selectedOption: 'Accepted',
        eventId: notificationModel.eventId, // Include eventId if necessary
      );

      // Optionally, save this accepted notification to Firestore
      await firestore
          .collection('notifications')
          .add(acceptedNotification.toJson());

      setState(() {});
      print('Friend request from ${acceptedNotification.senderName} accepted.');
    } catch (e) {
      print('Failed to accept friend request: $e');
    }
  }
  // void _acceptFriendRequest(NotificationModel notificationModel) async {
  //   final firestore = FirebaseFirestore.instance;
  //   AuthController authController = AuthController.to;
  //   String currentUserId = authController.userFirestore!.uid!;

  //   try {
  //     // Step 1: Query to check if current user sent a request to other user
  //     final friendRequestQuery = await firestore
  //         .collection('friend_requests')
  //         .where('from', isEqualTo: currentUserId)
  //         .where('to', isEqualTo: notificationModel.userId)
  //         .get();

  //     String? otherUserId;

  //     if (friendRequestQuery.docs.isNotEmpty) {
  //       otherUserId = friendRequestQuery.docs.first.get('to');
  //       print(
  //           "Found friend request: Current user ($currentUserId) to other user ($otherUserId)");
  //     } else {
  //       // Step 2: Reverse Query to check if other user sent a request to current user
  //       final reverseFriendRequestQuery = await firestore
  //           .collection('friend_requests')
  //           .where('from', isEqualTo: notificationModel.userId)
  //           .where('to', isEqualTo: currentUserId)
  //           .get();

  //       if (reverseFriendRequestQuery.docs.isNotEmpty) {
  //         otherUserId = reverseFriendRequestQuery.docs.first.get('from');
  //         print(
  //             "Found friend request: Other user ($otherUserId) to current user ($currentUserId)");
  //       } else {
  //         print(
  //             "Friend request document not found between $currentUserId and ${notificationModel.userId}");
  //         return;
  //       }
  //     }

  //     // Update friend request status to 'accepted' for both users
  //     final currentUserRequestRef =
  //         firestore.collection('friend_requests').doc(currentUserId);
  //     final otherUserRequestRef =
  //         firestore.collection('friend_requests').doc(otherUserId);

  //     await currentUserRequestRef.update({'status': 'accepted'});
  //     await otherUserRequestRef.update({'status': 'accepted'});

  //     // Add users to each other's friends list
  //     final userRef = firestore.collection('users').doc(currentUserId);
  //     final otherUserRef = firestore.collection('users').doc(otherUserId);

  //     await userRef.update({
  //       'friends': FieldValue.arrayUnion([otherUserId]),
  //     });

  //     await otherUserRef.update({
  //       'friends': FieldValue.arrayUnion([currentUserId]),
  //     });

  //     // Save accepted notification to Firestore
  //     NotificationModel acceptedNotification = NotificationModel(
  //       userId: notificationModel.userId,
  //       senderName: notificationModel.senderName ?? 'Unknown User',
  //       body: 'Friend request Accepted',
  //       userImage: notificationModel.userImage,
  //       currentUserImage: notificationModel.currentUserImage,
  //       type: 'Accepted',
  //       creationDate: Timestamp.now(),
  //       title: 'Friend Request',
  //       amount: notificationModel.amount,
  //       selectedOption: 'Accepted',
  //       eventId: notificationModel.eventId,
  //     );

  //     await firestore
  //         .collection('notifications')
  //         .add(acceptedNotification.toJson());

  //     setState(() {});
  //     print('Friend request from ${acceptedNotification.senderName} accepted.');
  //   } catch (e) {
  //     print('Failed to accept friend request: $e');
  //   }
  // }

// Function to reject a friend request
  void _rejectFriendRequest(NotificationModel notificationModel) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Assuming the collection for friend requests is 'friend_requests'
      final requestRef =
          firestore.collection('friend_requests').doc(notificationModel.userId);
// Prepare to create a notification for accepted request
      NotificationModel acceptedNotification = NotificationModel(
        userId: notificationModel.userId,
        senderName: notificationModel.senderName ??
            'Unknown User', // Ensure senderName is set
        body: 'Friend request Rejected',
        userImage: notificationModel.userImage,
        currentUserImage: notificationModel.currentUserImage,
        type: 'Rejected',
        creationDate: Timestamp.now(),
        title: 'Friend Request',
        amount: notificationModel.amount, // Adjust this as needed
        selectedOption: 'Rejected',
        eventId: notificationModel.eventId, // Include eventId if necessary
      );

      // Optionally, save this accepted notification to Firestore
      await firestore
          .collection('notifications')
          .add(acceptedNotification.toJson());
      // Update the friend request to 'rejected'
      await requestRef.update({'status': 'rejected'});
      setState(() {});
      print('Friend request from ${notificationModel.userId} rejected.');
    } catch (e) {
      print('Failed to reject friend request: $e');
    }
  }

  // List<NotificationModel> filterDuplicates(
  //     List<NotificationModel> notifications) {
  //   // A set to keep track of unique sender names
  //   final seenNames = <String>{};
  //   // A new list to hold filtered notifications
  //   final filteredNotifications = <NotificationModel>[];

  //   for (var notification in notifications) {
  //     String uniqueKey = notification.senderName ?? '';
  //     // Only add if the sender name has not been seen before
  //     if (!seenNames.contains(uniqueKey)) {
  //       seenNames.add(uniqueKey);
  //       filteredNotifications.add(notification);
  //     }
  //   }
  //   return filteredNotifications;
  // }
  List<NotificationModel> filterDuplicates(
      List<NotificationModel> notifications) {
    final Map<String, NotificationModel> latestNotifications = {};

    for (var notification in notifications) {
      String uniqueKey = notification.senderName ?? '';

      if (uniqueKey.isEmpty) {
        if (notification.type != 'Accepted' &&
            notification.type != 'Rejected') {
          latestNotifications[uniqueKey] = notification;
        }
      } else {
        if (!latestNotifications.containsKey(uniqueKey) ||
            (latestNotifications[uniqueKey]!
                    .creationDate
                    .compareTo(notification.creationDate) <
                0)) {
          latestNotifications[uniqueKey] = notification;
        }
      }
    }

    // Return the values from the map as a list
    return latestNotifications.values.toList();
  }

  Widget paymentReceiveNotificaitonTile(
      BuildContext context, NotificationModel notificationModel) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: 0.1 * height,
      width: width,
      child: Stack(
        children: [
          const Positioned(
            top: 8,
            left: 8,
            child: CircleAvatar(
              radius: 4,
              backgroundColor: Color(0xffBEFF07),
              // backgroundColor: Color(0xffA19F9F),
            ),
          ),
          Positioned(
            top: 14,
            left: 19,
            right: 13,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 43,
                  height: 39,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 4,
                        child: Image.asset(
                          ImageConstant.avatar3,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SizedBox.square(
                          dimension: 16,
                          child: Image.asset('assets/images/Fill2.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  // Use Expanded here
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'You have received ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '+ ₦${notificationModel.amount} ',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff00BF36),
                                  fontFamily: "Inter"),
                            ),
                            const TextSpan(
                              text: 'from\n',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: '@lexlutherevents',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.pink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        formatDateTime(notificationModel.creationDate),
                        style: TextStyle(
                          color: Color(0xff697386),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget paymentDeductNotificaitonTile(
      BuildContext context, NotificationModel notificationModel) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: 0.1 * height,
      width: width,
      child: Stack(
        children: [
          const Positioned(
            top: 8,
            left: 8,
            child: CircleAvatar(
              radius: 4,
              backgroundColor: Color(0xffBEFF07),
              // backgroundColor: Color(0xffA19F9F),
            ),
          ),
          Positioned(
            top: 14,
            left: 19,
            right: 13,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 43,
                  height: 39,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 4,
                        child: Image.asset(
                          ImageConstant.avatar3,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SizedBox.square(
                          dimension: 16,
                          child: Image.asset('assets/images/Fill.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'You have transferred ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily: "Inter"),
                            ),
                            TextSpan(
                              text: notificationModel.body.contains('money')
                                  ? notificationModel.body.split("money")[1]
                                  : notificationModel.body,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink,
                                  fontFamily: "Inter"),
                            ),
                            const TextSpan(
                              text: 'to\n',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: notificationModel.body.contains('to')
                                  ? notificationModel.body.split("to")[1]
                                  : notificationModel.body,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        formatDateTime(notificationModel.creationDate),
                        style: TextStyle(
                          color: Color(0xff697386),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  Future<void> deleteNotification(NotificationModel notificationModel) async {
    try {
      // Ensure the eventId (or another unique identifier) is used for deletion
      if (notificationModel.userId != null &&
          notificationModel.userId!.isNotEmpty) {
        await notificationsCollection.doc(notificationModel.userId).delete();
        print("Notification deleted successfully");

        // Remove it from the local list
        notificationController.notificationsList.value
            ?.removeWhere((item) => item.userId == notificationModel.userId);
        notificationController.notificationsList.refresh(); // Refresh the UI
      } else {
        print("Error: userId is null or empty");
      }
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  Widget requestSendNotificaitonTile(
      BuildContext context, NotificationModel notificationModel) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: 0.2 * height,
      width: width,
      child: Stack(
        children: [
          Positioned(
            top: 14,
            left: 19,
            right: 13,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 46,
                  height: 42,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(
                              notificationModel.currentUserImage.toString()),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(
                              notificationModel.userImage.toString()),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'You have recieved a new request from @${notificationModel.senderName}\n',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: "Inter",
                              ),
                            ),
                            TextSpan(
                              text: notificationModel.body.contains('money')
                                  ? notificationModel.body.split("money")[1]
                                  : notificationModel.body,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffEE531F),
                                fontFamily: "Inter",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xff7440FF)),
                            ),
                            onPressed: () async {
                              await deleteNotification(notificationModel);
                              // Add a new notification for acceptance
                              await addFriendRequestStatusNotification(
                                  notificationModel,
                                  "Accepted",
                                  notificationModel.currentUserImage.toString(),
                                  notificationModel.userImage.toString());
                              _acceptFriendRequest(notificationModel);
                            },
                            child: const Text(
                              'Accept',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xff8C8C8C)),
                            ),
                            onPressed: () async {
                              await deleteNotification(notificationModel);
                              // Add a new notification for rejection
                              await addFriendRequestStatusNotification(
                                  notificationModel,
                                  "Rejected",
                                  notificationModel.currentUserImage.toString(),
                                  notificationModel.userImage.toString());
                              _rejectFriendRequest(notificationModel);
                            },
                            child: const Text(
                              'Reject',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        formatDateTime(notificationModel.creationDate),
                        style: const TextStyle(
                          color: Color(0xff697386),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget requestAcceptNotificaitonTile(
      BuildContext context, NotificationModel notificationModel) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: 0.14 * height,
      width: width,
      child: Stack(
        children: [
          Positioned(
            top: 14,
            left: 19,
            right: 13,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 46,
                  height: 42,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(
                              notificationModel.currentUserImage.toString()),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(
                              notificationModel.userImage.toString()),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Reqest Accepted \n',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: "Inter",
                              ),
                            ),
                            TextSpan(
                              text: notificationModel.body.contains('money')
                                  ? notificationModel.body.split("money")[1]
                                  : notificationModel.body,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffEE531F),
                                fontFamily: "Inter",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        formatDateTime(notificationModel.creationDate),
                        style: const TextStyle(
                          color: Color(0xff697386),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget requestRejectNotificaitonTile(
      BuildContext context, NotificationModel notificationModel) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: 0.14 * height,
      width: width,
      child: Stack(
        children: [
          Positioned(
            top: 14,
            left: 19,
            right: 13,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 46,
                  height: 42,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(
                              notificationModel.currentUserImage.toString()),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(
                              notificationModel.userImage.toString()),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Request Rejected \n',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: "Inter",
                              ),
                            ),
                            TextSpan(
                              text: notificationModel.body.contains('money')
                                  ? notificationModel.body.split("money")[1]
                                  : notificationModel.body,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffEE531F),
                                fontFamily: "Inter",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        formatDateTime(notificationModel.creationDate),
                        style: const TextStyle(
                          color: Color(0xff697386),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Helper function to add a status notification
  Future<void> addFriendRequestStatusNotification(
      NotificationModel originalNotification,
      String status,
      String userImage,
      String currentUser) async {
    NotificationModel statusNotification = NotificationModel(
      userId: originalNotification.userId,
      body: 'Friend request $status',
      type: "$status",
      userImage: currentUser,
      currentUserImage: userImage,
      creationDate: DateTime.now(),
      title: 'Friend Request',
      amount: originalNotification.amount,
      selectedOption: status,
      eventId: "", // Generate or use a new ID
    );

    await notificationController.addNotification(statusNotification);
  }

  Widget matchedNotificaitonTile(
    BuildContext context,
    NotificationModel notificationModel,
  ) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: 0.10 * height,
      width: width,
      child: Stack(
        children: [
          const Positioned(
            top: 8,
            left: 8,
            child: CircleAvatar(
              radius: 4,
              backgroundColor: Color(0xffBEFF07),
              // backgroundColor: Color(0xffA19F9F),
            ),
          ),
          Positioned(
            top: 14,
            left: 19,
            right: 13,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 45,
                  height: 35,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 27,
                          height: 27,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 2,
                              color: Colors.white,
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/user_one.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 27,
                          height: 27,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 2,
                              color: Colors.white,
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/user_four.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      notificationModel.title != null
                          ? Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "You have matched with",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        " @${notificationModel.body.contains('matched') ? notificationModel.body.split("matched")[1] : notificationModel.body}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: '\nin the event ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: notificationModel.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                      color: ColorConstant.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'You have been matched with ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: notificationModel.title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: '\nin the event ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '“Chelsea will beat Arsenal”.....',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                      color: ColorConstant.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        formatDateTime(notificationModel.creationDate),
                        style: TextStyle(
                          color: Color(0xff697386),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: ColorConstant.gray,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }

  Widget eventPoolNotificaitonTile(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: 0.140 * height,
      width: width,
      child: Stack(
        children: [
          const Positioned(
            top: 8,
            left: 8,
            child: CircleAvatar(
              radius: 4,
              backgroundColor: Color(0xffA19F9F),
              // backgroundColor: Color(0xffA19F9F),
            ),
          ),
          Positioned(
            top: 14,
            left: 19,
            right: 13,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 43,
                  height: 39,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 4,
                        child: Image.asset(
                          ImageConstant.avatar3,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SizedBox.square(
                          dimension: 16,
                          child:
                              Image.asset('assets/images/sports_category.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '@vitalik33  ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffEA8B00),
                              ),
                            ),
                            TextSpan(
                              text: 'just created a new Event in ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '\nPop - Culture',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 28,
                            // width: 160,
                            decoration: BoxDecoration(
                              color: ColorConstant.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                '  Event Pool ₦1.831,000  ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontFamily: "Inter"),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 13,
                          ),
                          Container(
                            height: 28,
                            // width: 83,
                            decoration: BoxDecoration(
                              color: const Color(0xffBEFF07),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                '   Join   ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Friday at 9:42 AM',
                        style: TextStyle(
                          color: Color(0xff697386),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: ColorConstant.gray,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }

  Widget challengeLostNotificaitonTile(
      BuildContext context, NotificationModel notificationModel) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: 0.17 * height,
      width: width,
      child: Stack(
        children: [
          const Positioned(
            top: 8,
            left: 8,
            child: CircleAvatar(
              radius: 4,
              backgroundColor: Color(0xffBEFF07),
              // backgroundColor: Color(0xffA19F9F),
            ),
          ),
          Positioned(
            top: 14,
            left: 19,
            right: 13,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 43,
                  height: 39,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 4,
                        child: Image.asset(
                          ImageConstant.avatar3,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SizedBox.square(
                          dimension: 16,
                          child: Image.asset('assets/images/Fill.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'You have lost the challenge against ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text:
                                  " @${notificationModel.body.contains('against') ? notificationModel.body.split("against")[1] : notificationModel.body} ",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                            const TextSpan(
                              text: 'in the event ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: notificationModel.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                color: ColorConstant.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 36,
                            width: 80,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 7,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 26,
                                    // width: 150,s
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFF2C2C),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '- ₦${notificationModel.amount}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontFamily: "Inter"),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 10,
                                        // width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '  you picked ${notificationModel.selectedOption.toUpperCase()}  ',
                                            style: const TextStyle(
                                              fontSize: 7,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 13,
                          ),
                          Container(
                            height: 26,
                            width: 83,
                            decoration: BoxDecoration(
                              color: const Color(0xff4B648A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageConstant.notification_share,
                                  width: 23.08,
                                  height: 18.99,
                                ),
                                const Text(
                                  'Share',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        formatDateTime(notificationModel.creationDate),
                        style: TextStyle(
                          color: Color(0xff697386),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: ColorConstant.gray,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }

  Widget challengeWonNotificaitonTile(
      BuildContext context, NotificationModel notificationModel) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: 0.17 * height,
      width: width,
      child: Stack(
        children: [
          const Positioned(
            top: 8,
            left: 8,
            child: CircleAvatar(
              radius: 4,
              backgroundColor: Color(0xffBEFF07),
              // backgroundColor: Color(0xffA19F9F),
            ),
          ),
          Positioned(
            top: 14,
            left: 19,
            right: 13,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 43,
                  height: 39,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 4,
                        child: Image.asset(
                          ImageConstant.avatar3,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SizedBox.square(
                          dimension: 16,
                          child: Image.asset('assets/images/Fill2.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    " @${notificationModel.body.contains('against') ? notificationModel.body.split("against")[0] : notificationModel.body}against",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " @${notificationModel.body.contains('against') ? notificationModel.body.split("against")[1] : notificationModel.body}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink,
                                ),
                              ),
                              const TextSpan(
                                text: 'in the event ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: notificationModel.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  color: ColorConstant.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 36,
                            width: 140,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 7,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 26,
                                    // width: 150,s
                                    decoration: BoxDecoration(
                                      color: ColorConstant.lightGreen,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Payout + ₦${notificationModel.amount ?? ""}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontFamily: "Inter"),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 10,
                                        // width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '  you picked YES  ',
                                            style: TextStyle(
                                              fontSize: 7,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 13,
                          ),
                          Container(
                            height: 26,
                            width: 83,
                            decoration: BoxDecoration(
                              color: const Color(0xff4B648A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageConstant.notification_share,
                                  width: 23.08,
                                  height: 18.99,
                                ),
                                const Text(
                                  'Share',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        formatDateTime(notificationModel.creationDate),
                        style: TextStyle(
                          color: Color(0xff697386),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: ColorConstant.gray,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }

  String formatDateTime(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the date to display the day of the week
    String day = DateFormat('EEEE').format(dateTime);

    // Format the time in 'h:mm a' format
    String time = DateFormat('h:mm a').format(dateTime);

    // Combine day and time to get the desired output
    return '$day at $time';
  }
}

/*
class NotificationsScreen extends StatelessWidget {
  NotificationController notificationController = NotificationController.to;
  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: ColorConstant.whiteA700
          ),
          toolbarHeight: 80,
          actions: [
            // Stack(
            //   children: [
            //     InkWell(
            //       onTap: (){
            //         _showPopup(context);
            //       },
            //       child: Container(
            //         height: 30,
            //         width: 125,
            //         decoration: BoxDecoration(
            //             gradient: LinearGradient(
            //                 colors: [ColorConstant.deepPurpleA200,ColorConstant.orange]
            //             ),
            //             shape: BoxShape.rectangle,
            //             borderRadius: const BorderRadius.only(topRight: Radius.circular(18),bottomRight: Radius.elliptical(50,70))

            //         ),
            //         child: Center(child:  Text("Create A Bet",style: TextStyle(color: ColorConstant.whiteA700,fontFamily: "Popins",fontWeight: FontWeight.w600,fontSize: 16),)),
            //       ),
            //     ),
            //     Positioned(
            //         left: 6,
            //         top: 2,
            //         child: SvgPicture.asset(ImageConstant.starIcon))
            //   ],
            // ),
            // const SizedBox(
            //   width: 12,
            // ),
            IconButton(
                onPressed: () {
                  // Get.to(() => NotificationsScreen());
                },
                icon: SvgPicture.asset(ImageConstant.notificationIcon)),
            const SizedBox(
              width: 6,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => WalletScreen());
              },
              child: Container(
                height: 35,
                width: 97,
                margin: const EdgeInsets.only(top: 14, bottom: 14),
                padding: const EdgeInsets.only(left: 18, right: 18),
                decoration: BoxDecoration(
                    color: ColorConstant.whiteA700,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50))),
                child: Center(
                  child: GetBuilder<WalletContoller>(builder: (controller) {
                    return Text(
                      "₦${controller.totalAmount}",
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.primaryColor),
                    );
                  }),
                ),
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.square(50),
            child: Material(
              color: Colors.white,
              elevation: 0,
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      const Tab(text: 'Notofication'),
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                        height: 25,
                        width: 30,
                        decoration: BoxDecoration(
                            color: ColorConstant.pink1,
                            borderRadius: BorderRadius.circular(15)),
                        child: const Center(
                            child: Text(
                              "1",
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Tab(text: 'Event History'),
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                        height: 25,
                        width: 30,
                        decoration: BoxDecoration(
                            color: ColorConstant.lightPurpul,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                              "1",
                              style: TextStyle(color: ColorConstant.black900),
                            )),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.user1,
                              height: 40,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("A new event has been created by",style: TextStyle(
                                    color: ColorConstant.black900,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Popins"
                                ),),
                                Text("@boybet44",style: TextStyle(
                                    color: ColorConstant.red300,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Popins"
                                ),)
                              ],
                            ),

                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomButton(
                              width: 205,
                              height: 45,
                              text: "Event Pool ₦2,000,000",
                              fontStyle: ButtonFontStyle.PoppinsMedium16,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            CustomButton(
                              width: 80,
                              height: 45,
                              text: "Join",
                              fontStyle: ButtonFontStyle.PoppinsMedium16,
                            )
                          ],
                        )
                      ],
                    ),

                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: notificationController.notificationsList.value!.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: Get.width,
                          child: Row(
                            children: [
                              Container(
                                height: 80,
                                width: 10,
                                color: ColorConstant.primaryColor,
                              ),
                              Container(
                                height: 80,
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: ColorConstant.whiteA700,
                                ),
                                child: Row(
                                  children: [
                                    CustomImageView(
                                      imagePath: ImageConstant.user1,
                                      height: 40,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Congrats!",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            CustomImageView(
                                              imagePath: ImageConstant.congratsImage,
                                              height: 30,
                                            ),
                                            Text(
                                              notificationController.notificationsList.value![index].title,
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${takeAmount(index)}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Inter',
                                                  color: ColorConstant.green500,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        RichText(
                                          text:  TextSpan(
                                            style: const TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              const TextSpan(text: ''),
                                              TextSpan(
                                                  text: notificationController.notificationsList.value![index].body,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontStyle: FontStyle.italic,
                                                      fontSize: 12
                                                  )),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: CustomImageView(
                                        imagePath: ImageConstant.categorySportsImage,
                                        height: 25,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: ColorConstant.listBackground,
                ),
                child: ListView.builder(
                  itemCount: 6, // Replace 'itemCount' with the actual number of items
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: ColorConstant.blueGray10096,
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(ImageConstant.beach,width: 10,height: 10,),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "Chelsea will beat Manu",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Popins",
                                            color: ColorConstant.gray90010,
                                          ),
                                        ),
                                        const Spacer(),
                                        Image.asset(ImageConstant.history,height: 12,width: 12,),
                                        Text(
                                          "09:30:54",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Popins",
                                            color: ColorConstant.textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(ImageConstant.profile1,width: 50,height: 50,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Text(
                                                "⏳ Awaiting an opponent.\nPlease kindly wait.....",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Popins",
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorConstant.gray90010,
                                                ),
                                              ),
                                              Text(
                                                "@logosboy23",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Popins",
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorConstant.red300,
                                                ),
                                              ),
                                              Text(
                                                "Picked Yes",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Popins",
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorConstant.textColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2), // Add spacing between the columns
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: ColorConstant.blueGray10096,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorConstant.gray700,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Popins",
                                      ),
                                      children: const <TextSpan>[
                                        TextSpan(
                                          text: 'Staked',
                                        ),
                                        TextSpan(
                                          text: ' ₦5,000',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                 ElevatedButton(onPressed: (){},
                                     style: ButtonStyle(
                                       backgroundColor: MaterialStatePropertyAll(
                                           ColorConstant.primaryColor
                                       ),
                                       fixedSize: MaterialStatePropertyAll(
                                         Size(110,30)
                                       ),
                                       shape: MaterialStatePropertyAll(
                                         RoundedRectangleBorder(
                                           borderRadius: BorderRadius.circular(8)
                                         )
                                       )
                                     ),
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Text("Potential Return",style: TextStyle(
                                           fontSize: 8,
                                           fontFamily: "Popins",
                                           color: ColorConstant.whiteA700
                                         ),),
                                         Text("₦ 10,000",style: TextStyle(
                                             fontSize: 12,
                                             fontFamily: "Popins",
                                             color: ColorConstant.whiteA700
                                         ),)
                                       ],
                                     ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )


          ],
        )
            ),
    );



  }

  takeAmount(int index){
    final String body = notificationController.notificationsList.value![index].body;
    final RegExp regExp = RegExp(r'\d+');
    final Match? match = regExp.firstMatch(body);

    String extractedNumber = '';
    if (match != null) {
      extractedNumber = match.group(0)!;
    }
    return "₦${extractedNumber}";
  }
  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.5),
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 467,
            width: 353,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorConstant.gradiant1, ColorConstant.gradiant2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Please Read Terms.",
                  style: TextStyle(
                      color: ColorConstant.primaryColor, fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Popins"),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Please read and agree to terms before you proceed.\nPlease read and agree to terms before you proceed\nPlease read and agree to terms before you proceed\nPlease read and agree to terms before you proceed\nPlease read and agree to terms before you proceed",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontFamily: "Popins"
                  ),
                ),
                const Spacer(
                ),
                CustomButton(
                  text: "Proceed",
                  fontStyle: ButtonFontStyle.InterSemiBold16,
                  onTap: () {
                    Get.to(const BetScreen());
                  },
                  height: 48,
                  width: 307,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
*/

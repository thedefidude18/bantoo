import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/ui/notifications_and_bethistory/notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX for navigation

class NotificationIcon extends StatefulWidget {
  final String defaultType; // Initial default type
  final Map<String, String> iconPaths; // Map to store icon paths based on types
  final IconData fallbackIcon; // Fallback icon if no type matches
  final VoidCallback? onTap; // Optional onTap callback

  const NotificationIcon({
    required this.defaultType,
    required this.iconPaths,
    required this.fallbackIcon,
    this.onTap, // Add onTap parameter
    Key? key,
  }) : super(key: key);

  @override
  _NotificationIconState createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  String notificationType = ''; // Track the latest notification type

  @override
  void initState() {
    super.initState();
    notificationType = widget.defaultType; // Set the initial default type

    // Listen to the latest notification from Firebase
    FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('creationDate', descending: true)
        .limit(1) // Get the latest notification only
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var latestNotification = snapshot.docs.first.data();
        print("latestNotification:$latestNotification");
        setState(() {
          notificationType = latestNotification['type'] ?? widget.defaultType;
        });
        print("notificationType:$notificationType");
      }
    });
  }

  // Dynamically get the appropriate icon based on the type
  Widget _getNotificationIcon(String type) {
    String? iconPath = widget.iconPaths[type];
    if (iconPath != null) {
      return Image.asset(iconPath, height: 35); // Load custom icon
    } else {
      return Icon(widget.fallbackIcon, size: 35); // Use fallback icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ??
          () {
            // Default onTap behavior if none provided
            Get.to(() => NotificationsScreen());
          },
      child: Container(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child:
              _getNotificationIcon(notificationType)), // Build icon dynamically
    );
  }
}

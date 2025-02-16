import 'package:flexx_bet/ui/notifications_and_bethistory/notifications.dart';
import 'package:flexx_bet/ui/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BetScreen extends StatefulWidget {
  const BetScreen({super.key});

  @override
  State<BetScreen> createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  String notificationType = 'messages'; // Default notification type for testing

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            const SizedBox(width: 50),
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    _showPopup(context);
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepPurple, Colors.orange],
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(18),
                            bottomRight: Radius.elliptical(50, 70))),
                    child: Center(
                        child: Text(
                          "Create Event",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Popins",
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        )),
                  ),
                ),
                Positioned(
                    left: 6,
                    top: 2,
                    child: SvgPicture.asset('assets/images/star.svg'))
              ],
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () {
                Get.to(() => NotificationsScreen());
              },
              icon: _getNotificationIcon(notificationType), // Use the selected notification type
            ),
            const SizedBox(width: 6),
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
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50))),
                child: Center(
                  child: Text(
                    "₦ 1000",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Colors.blue),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Buttons to simulate notification types
            ElevatedButton(
              onPressed: () {
                setState(() {
                  notificationType = 'messages'; // Simulate message notification
                });
              },
              child: Text('Simulate Message Notification'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  notificationType = 'Request'; // Simulate request notification
                });
              },
              child: Text('Simulate Request Notification'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  notificationType = 'Generation'; // Simulate generation notification
                });
              },
              child: Text('Simulate Generation Notification'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get notification icon based on type
  Widget _getNotificationIcon(String notificationType) {
    switch (notificationType) {
      case 'messages':
        return Image.asset('assets/images/messagenoti.png', height: 24);
      case 'Request':
        return Image.asset('assets/images/requestnoti.png', height: 24);
      case 'Generation':
        return Image.asset('assets/images/notification_new.png', height: 24);
      default:
        return Icon(Icons.notifications);
    }
  }

  void _showPopup(BuildContext context) {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.8),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 467,
            width: 500,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.orange],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Please Read Terms",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Please read and agree to terms before you proceed.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Get.to(BetScreen());
                  },
                  child: Text("Proceed"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

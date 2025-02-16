// import 'package:flexx_bet/chat/chat_controller.dart';
// import 'package:flexx_bet/chat/widgets/my_groups.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
//
// import '../../chat/widgets/MyEvents.dart';
// import '../../constants/colors.dart';
// import '../../constants/images.dart';
// import '../../controllers/wallet_controller.dart';
// import '../notifications_and_bethistory/notifications.dart';
// import '../wallet/wallet.dart';
//
// class EarningScreen extends StatefulWidget {
//   const EarningScreen({super.key});
//
//   @override
//   State<EarningScreen> createState() => _EarningScreenState();
// }
//
// class _EarningScreenState extends State<EarningScreen> with SingleTickerProviderStateMixin {
//   var controller = Get.find<ChatController>();
//   late TabController _tabController; // Define TabController
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this); // Initialize TabController
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose(); // Dispose TabController when not needed
//     super.dispose();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         toolbarHeight: 80,
//         title: const Text(
//           "My Events",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 22,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         iconTheme: IconThemeData(color: ColorConstant.whiteA700),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Get.to(() => NotificationsScreen());
//               },
//               icon: SvgPicture.asset(ImageConstant.notificationIcon)),
//           const SizedBox(
//             width: 6,
//           ),
//           GestureDetector(
//             onTap: () {
//               Get.to(() => WalletScreen());
//             },
//             child: Container(
//               height: 35,
//               width: 97,
//               margin: const EdgeInsets.only(top: 14, bottom: 14),
//               padding: const EdgeInsets.only(left: 18, right: 18),
//               decoration: BoxDecoration(
//                   color: ColorConstant.whiteA700,
//                   borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(50),
//                       bottomLeft: Radius.circular(50))),
//               child: Center(
//                 child: GetBuilder<WalletContoller>(builder: (controller) {
//                   return Text(
//                     "₦${controller.totalAmount}",
//                     style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontWeight: FontWeight.w600,
//                         color: ColorConstant.primaryColor),
//                   );
//                 }),
//               ),
//             ),
//           )
//         ],
//         leading: BackButton(
//           onPressed: () {
//             Get.back();
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             color: Colors.white, // Set background color of the TabBar
//             child: TabBar(
//               controller: _tabController,
//               indicatorColor: ColorConstant.primaryColor, // Customize indicator color
//               labelColor: ColorConstant.primaryColor, // Set selected tab text color
//               unselectedLabelColor: ColorConstant.black900C4, // Set unselected tab text color
//               tabs: const [
//                 Tab(text: 'Joined Events'),
//                 Tab(text: 'My Events'),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: const [
//                 MyGroups(), // Replace with your Joined Events widget
//                 MyEvents(), // Replace with your My Events widget
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/chat/chat_controller.dart';
import 'package:flexx_bet/chat/widgets/my_groups.dart';
import 'package:flexx_bet/chat/widgets/notifiactionIcon.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/models/UserDetailModel.dart';
import 'package:flexx_bet/models/user_model.dart';
import 'package:flexx_bet/ui/private%20chat%20user/private_chat_user.dart';
import 'package:flexx_bet/ui/profile/widget/EarningWidget.dart';
import 'package:flexx_bet/ui/wallet/widget/confirm_transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../chat/widgets/MyEvents.dart';
import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../controllers/wallet_controller.dart';
import '../notifications_and_bethistory/notifications.dart';
import '../wallet/wallet.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // Define TabController
  bool isFriend = false;
  int unreadCount = 0;
  String _generateChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '$uid1-$uid2' : '$uid2-$uid1';
  }

  void getFriendsUnreadChatList() async {
    setState(() {
      isFriend = true;
    });

    final FirebaseFirestore _db = FirebaseFirestore.instance;
    AuthController authController = AuthController.to;
    final UserModel userModel = authController.userFirestore!;
    final String userId = userModel.uid;

    _db.collection('friend_requests').snapshots().listen((snapshot) async {
      for (var document in snapshot.docs) {
        var data = document.data();
        var from = data['from'];
        var to = data['to'];
        if (from == userId || to == userId) {
          String friendUid = from == userId ? to : from;

          // Fetch friend's user details
          DocumentSnapshot<Map<String, dynamic>> friendSnapshot =
              await _db.collection('users').doc(friendUid).get();
          UserDetailModel friendData =
              UserDetailModel.fromMap(friendSnapshot.data()!);

          // Fetch latest message in the chat
          String chatId = _generateChatId(from, to);
          QuerySnapshot messageSnapshot = await _db
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .orderBy('timestamp', descending: false)
              .limit(1)
              .get();

          unreadCount = messageSnapshot.docs
              .where((doc) => !doc['isRead'] && doc['senderUid'] != userId)
              .length;
          print("UnReadCont::${unreadCount}");
        }
      }

      // setState(() {
      isFriend = false;
      // });
    });
  }

  @override
  void initState() {
    super.initState();
    getFriendsUnreadChatList();
    _tabController =
        TabController(length: 1, vsync: this); // Initialize TabController
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose TabController when not needed
    super.dispose();
  }

  String formatCurrency(double amount) {
    if (amount >= 1e9) {
      return '₦${(amount / 1e9).toStringAsFixed(2)}B'; // Billion
    } else if (amount >= 1e6) {
      return '₦${(amount / 1e6).toStringAsFixed(2)}M'; // Million
    } else if (amount >= 1e3) {
      return '₦${(amount / 1e3).toStringAsFixed(2)}K'; // Thousand
    } else {
      return '₦${amount.toStringAsFixed(2)}'; // Less than 1000
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
        title: const Text(
          "My Events",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: ColorConstant.whiteA700),
        actions: [
          InkWell(
              onTap: () {
                Get.to(
                  () => PrivateChatUserScreen(),
                );
              },
              child: Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      ImageConstant.headerLogo,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    unreadCount.toString(),
                  ),
                ),
              )),
          const NotificationIcon(
            defaultType: 'messages',
            iconPaths: {
              'messages': ImageConstant.messagenotificationNew,
              'request': ImageConstant.requestnotificationNew,
              'Generation': 'assets/images/notification_new.png',
            },
            fallbackIcon: Icons.notifications, // Fallback icon
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
                  color: ColorConstant.whiteA700,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50))),
              child: Center(
                child: GetBuilder<WalletContoller>(builder: (controller) {
                  return Text(
                    formatCurrency(double.parse("${controller.totalAmount}")),
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
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white, // Set background color of the TabBar
            child: TabBar(
              controller: _tabController,
              indicatorColor:
                  ColorConstant.primaryColor, // Customize indicator color
              labelColor:
                  ColorConstant.primaryColor, // Set selected tab text color
              unselectedLabelColor:
                  ColorConstant.black900C4, // Set unselected tab text color
              tabs: const [
                Tab(text: 'My Earnings'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                // Replace with your My Events widget
                MyEarnings(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

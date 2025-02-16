import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/referral_controller.dart';
import 'package:flexx_bet/models/UserDetailModel.dart';
import 'package:flexx_bet/ui/private%20chat%20user/private_chat_user.dart';
import 'package:flexx_bet/ui/referral/widget/contact_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../chat/widgets/notifiactionIcon.dart';
import '../../controllers/events_controller.dart';
import '../../models/user_model.dart';

class ReferralScreen extends StatefulWidget {
  ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final AuthController authController = AuthController.to;

  final ReferralController _referralController =
      Get.put<ReferralController>(ReferralController());
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
    getFriendsUnreadChatList();
    // TODO: implement initState
    super.initState();
  }

  //final ReferralController _referralController = ReferralController.to;
  Future<List<Contact>?> loadContacts() async {
    try {
      PermissionStatus contactStatus = await Permission.contacts.request();
      if (contactStatus == PermissionStatus.granted) {
        return await FastContacts.getAllContacts();
      } else {
        return [];
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
        print('Failed to get contacts:\n${e.details}');
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = authController.userFirestore!;
    _referralController.getReferrals(userModel);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ColorConstant.whiteA700,
        centerTitle: true,
        title: const Text("Referral"),
        leading: BackButton(
          color: ColorConstant.whiteA700,
          onPressed: () {
            Get.back();
          },
        ),
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
              'messages': 'assets/images/messagenoti.png',
              'request': 'assets/images/requestnoti.png',
              'Generation': 'assets/images/notification_new.png',
            },
            fallbackIcon: Icons.notifications, // Fallback icon
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: Get.height / 1.7,
            color: ColorConstant.primaryColor,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "₦",
                      style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontSize: Get.width / 10),
                    ),
                    Obx(() => Text(
                          "${_referralController.totalReferralAmount.value ?? '0'}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Get.width / 8,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                Obx(
                  () => Text(
                    "Recived from ${_referralController.totalReferrals.value ?? "0"} invites.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: Get.width,
                  height: 120,
                  margin: const EdgeInsets.all(18),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: .2),
                      borderRadius: BorderRadius.circular(20),
                      color: ColorConstant.cardReferralPurple),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          children: [
                            Text(
                              "Next Reward",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              "₦500",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                  fontSize: 24),
                            ),
                            Text(
                              "for next 10 referrals",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 120,
                          color: Colors.white,
                        ),
                        const Column(
                          children: [
                            Text(
                              "Upcoming Reward",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              "₦5000",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                  fontSize: 24),
                            ),
                            Text(
                              "for 50 referrals",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ]),
                ),
                Container(
                  margin: const EdgeInsets.all(14),
                  padding: const EdgeInsets.all(16),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(131, 255, 255, 255),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your referral code is ${(userModel.uid.substring(userModel.uid.length - 5, userModel.uid.length).toUpperCase())}",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          _referralController
                              .createDynamicLink((userModel.uid
                                  .substring(userModel.uid.length - 5,
                                      userModel.uid.length)
                                  .toUpperCase()))
                              .then((value) {
                            Share.share(value,
                                subject:
                                    'Hey, You definitely shouldn’t miss this 🤩 I’m watching Naa on Voot and I love it! Sign up with this link and watch it without Ads 🔥 ');
                          });
                        },
                        child: const Text(
                          "Copy",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Get.height / 3,
              width: Get.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: FutureBuilder(
                future: loadContacts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(24, 16, 24, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Invited Friends"),
                                Text("5/10 Accepted")
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Get.height / 2.7,
                            width: Get.width,
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return ContactItem(
                                    contact: snapshot.data![index]);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.connectionState != ConnectionState.done) {
                    return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Get.width / 2.5,
                            vertical: Get.height / 5.8),
                        child: CircularProgressIndicator(
                          color: ColorConstant.primaryColor,
                        ));
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "You don't have any contacts or you have not allowed contacts permission",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

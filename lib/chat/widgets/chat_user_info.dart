import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/chat/chat_controller.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/extensions/string_extentions.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flexx_bet/models/notification_model.dart' as model;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../models/notification_model.dart';
import '../../models/user_model.dart';
import '../../ui/private chat/PresenceService.dart';
import '../../ui/private chat/private_chat.dart';

class ChatUserInfoCard extends StatefulWidget {
  const ChatUserInfoCard({
    super.key,
  });

  @override
  State<ChatUserInfoCard> createState() => _ChatUserInfoCardState();
}

class _ChatUserInfoCardState extends State<ChatUserInfoCard> {
  final _globelKey = GlobalKey();
  final controller = Get.find<ChatController>();
  var userData = {};
  var groupData = {};
  var name = "";
  var betsLost = [];
  var betsWon = [];
  var followers = [];
  var totalBets = [];
  var rank = 000;
  var image = "";
  var about = "";
  var following = [];
  String? friendRequestStatus;
  bool isDataLoaded = false; // Flag to track data loading

  @override
  void initState() {
    super.initState();
    PresenceService().updateUserPresence();
    if (Get.arguments is Map) {
      controller.getUserData(uid: "${Get.arguments["userId"]}").then((value) {
        if (value is Map) {
          setState(() {
            print("MyValues::${value}");
            userData = value;
            name = value["name"] ?? "User Name";
            betsLost = value["betsLost"] ?? [];
            betsWon = value["betsWon"] ?? [];
            followers = value["followers"] ?? [];
            totalBets = value["allBets"] ?? [];
            rank = value["rank"] ?? 000;
            image = value["photoUrl"] ?? "";
            about = value["about"] ?? "";
            isDataLoaded = true; // Data is loaded
          });
          checkFriendRequestStatus();
        }
      });
      if ((Get.arguments as Map).containsKey("group")) {
        groupData = Get.arguments["group"];
      }
    }
  }

  void _acceptFriendRequest(String currentUserId, String otherUserId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // `currentUser` aur `otherUser` dono taraf friend request update karein
      final currentUserRequestRef =
          firestore.collection('friend_requests').doc(currentUserId);
      final otherUserRequestRef =
          firestore.collection('friend_requests').doc(otherUserId);

      // currentUser ke document mein status ko pending karein
      await currentUserRequestRef.set({
        'from': currentUserId,
        'to': otherUserId,
        'status': 'pending',
        'timestamp': Timestamp.now(),
      }, SetOptions(merge: true));

      // otherUser ke document mein status ko pending karein
      await otherUserRequestRef.set({
        'from': otherUserId,
        'to': currentUserId,
        'status': 'pending',
        'timestamp': Timestamp.now(),
      }, SetOptions(merge: true));
      getFriendRequestStatusStream(currentUserId, otherUserId);
      print("Friend request sent from $currentUserId to $otherUserId.");
    } catch (e) {
      print('Failed to send friend request: $e');
    }
  }

  Stream<String> getFriendRequestStatusStream(
      String currentUser, String otherUser) async* {
    final currentUserDoc = FirebaseFirestore.instance
        .collection('friend_requests')
        .doc(currentUser);
    final otherUserDoc =
        FirebaseFirestore.instance.collection('friend_requests').doc(otherUser);

    // currentUser aur otherUser dono ke documents ko simultaneously observe karte hain
    await for (var currentSnapshot in currentUserDoc.snapshots()) {
      if (currentSnapshot.exists) {
        final currentData = currentSnapshot.data();
        print("HelloMyData::${currentData}");

        if (currentData != null && currentData['status'] == 'rejected') {
          yield 'none';
          return; // Stop the stream as soon as a rejected status is found
        } else if (currentData != null && currentData['status'] == 'accepted') {
          yield 'accepted'; // Agar accepted hai toh yield karke stream end kar do
          return;
        } else if (currentData != null && currentData['status'] == 'pending') {
          yield 'pending'; // Agar accepted hai toh yield karke stream end kar do
          return;
        }
      }

      // otherUser ke document ka snapshot check karo
      await for (var otherSnapshot in otherUserDoc.snapshots()) {
        if (otherSnapshot.exists) {
          final otherData = otherSnapshot.data();
          print("HelloOtherData::${otherData}");

          if (otherData != null && otherData['status'] == 'rejected') {
            yield 'none';
            return; // Stop the stream as soon as a rejected status is found
          } else if (otherData != null && otherData['status'] == 'accepted') {
            yield 'accepted';
            return;
          } else if (otherData != null && otherData['status'] == 'pending') {
            yield 'pending';
            return;
          }
        }
      }

      // Agar dono mein se koi bhi accepted ya rejected nahi mila toh 'none' return karo
      yield 'none';
    }
  }

  String _getButtonLabel(String status) {
    switch (status) {
      case 'accepted':
        return "Send Message 💬";
      // return "Friends ✅";
      case 'rejected':
      case 'default':
        return "Send a chat request";
      case 'pending':
        return "Request Sent";
      default:
        return "Send a chat request";
    }
  }

  Future<void> checkFriendRequestStatus() async {
    final currentUser = controller.uid;
    final otherUser = userData['uid'];

    try {
      final friendRequestSnapshot = await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc(currentUser)
          .get();

      if (friendRequestSnapshot.exists) {
        final data = friendRequestSnapshot.data();
        print("Data::${data}");

        if (data != null) {
          if (data['to'] == currentUser) {
            setState(() {
              friendRequestStatus = data['status'];
            });
          } else {
            setState(() {
              friendRequestStatus = 'none';
            });
          }
        } else {
          setState(() {
            friendRequestStatus = 'none';
          });
        }
      } else {
        setState(() {
          friendRequestStatus = 'none';
        });
      }
    } catch (e) {
      print("Error fetching friend request status: $e");
      setState(() {
        friendRequestStatus = 'none';
      });
    }
  }

  Future<void> _sendNotification(
      String userId, String image, String userName) async {
    AuthController authController = AuthController.to;
    final UserModel userModel = authController.userFirestore!;
    String currentUserImage = userModel.photoUrl ?? '';
    String username = userModel.name ?? '';

    model.NotificationModel notificationModel = model.NotificationModel(
      userId: userId,
      body: '@${username} has sent a request',
      type: "Request",
      userImage: currentUserImage,
      currentUserImage: image,
      creationDate: DateTime.now(),
      title: 'Title',
      amount: '10',
      selectedOption: "",
      senderName: username,
      eventId: "",
    );

    await notificationController.addNotification(notificationModel);
  }

  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

  final NotificationController notificationController =
      Get.put<NotificationController>(NotificationController());

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded || controller.uid == null) {
      // Data is not yet available, show a loading indicator
      return Center(child: CircularProgressIndicator());
    }

    return RepaintBoundary(
      key: _globelKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: Get.height / 1.75,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: Get.height,
                      width: Get.width / 1.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: <Color>[
                              Color.fromRGBO(215, 200, 255, 1),
                              Color.fromRGBO(239, 239, 239, 1)
                            ],
                          )),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, top: 30, bottom: 10),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 85,
                                    width: 85,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(5.0),
                                          child: Image.network(
                                            image,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                ImageConstant
                                                    .unsplash, // Your fallback image
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                        if (userData['uid'] ==
                                            (groupData["admin"] as String)
                                                .getFirstValueAfterUnderscore())
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: SizedBox(
                                                height: 40.0,
                                                width: 40.0,
                                                child: Image.asset(
                                                  ImageConstant.iconAdmin,
                                                  fit: BoxFit.cover,
                                                )),
                                          )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "@$name🏆",
                                        style: const TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        ColorConstant.fromHex(
                                                            "#5d4599"),
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: Text(
                                              "Rank",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: ColorConstant.fromHex(
                                                      "#5d4599")),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "#$rank",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: Get.width / 2.3,
                                        child: Text(
                                          about,
                                          style: TextStyle(
                                            fontSize: 13,
                                            shadows: [
                                              Shadow(
                                                color: const Color(0x00000000)
                                                    .withOpacity(0.3),
                                                offset: const Offset(.5, 1),
                                                blurRadius: 0,
                                              )
                                            ],
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: 14, left: 14, right: 14, top: 8),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: Colors.white.withAlpha(125),
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 55,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${followers.length}",
                                          style: TextStyle(
                                              color: ColorConstant.fromHex(
                                                  "#000094"),
                                              fontSize: 20),
                                        ),
                                        Text("Followers",
                                            style: TextStyle(
                                                color:
                                                    ColorConstant.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11))
                                      ]),
                                ),
                                SizedBox(
                                  width: 55,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${totalBets.length}",
                                          style: TextStyle(
                                              color: ColorConstant.fromHex(
                                                  "#000094"),
                                              fontSize: 20),
                                        ),
                                        Text("Total events",
                                            style: TextStyle(
                                                color:
                                                    ColorConstant.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11))
                                      ]),
                                ),
                                SizedBox(
                                  width: 55,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${betsWon.length}",
                                          style: TextStyle(
                                              color: ColorConstant.fromHex(
                                                  "#000094"),
                                              fontSize: 20),
                                        ),
                                        Text("Wins",
                                            style: TextStyle(
                                                color:
                                                    ColorConstant.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11))
                                      ]),
                                ),
                                SizedBox(
                                  width: 55,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${betsLost.length}",
                                          style: TextStyle(
                                              color: ColorConstant.fromHex(
                                                  "#000094"),
                                              fontSize: 20),
                                        ),
                                        Text("Loses",
                                            style: TextStyle(
                                                color:
                                                    ColorConstant.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11))
                                      ]),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            width: Get.width / 1.5,
                            color: ColorConstant.gray500,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: ColorConstant.fromHex("#0500cd"))),
                              child: Text(
                                "No badge yet",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: ColorConstant.fromHex("#0500cd")),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          StreamBuilder<String>(
                            stream: getFriendRequestStatusStream(
                                controller.uid!, userData['uid']),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox(); // Handle loading state or return a default widget
                              }

                              String friendRequestStatus =
                                  snapshot.data ?? 'none';
                              print("FriendRequests::${snapshot.data}");

                              return userData["uid"] == controller.uid
                                  ? SizedBox()
                                  : CustomButton(
                                      width: Get.width / 1.3,
                                      height: 49,
                                      variant: ButtonVariant.FillGray90051,
                                      padding: ButtonPadding.PaddingAll4,
                                      fontStyle:
                                          ButtonFontStyle.PoppinsSemiBold18,
                                      text:
                                          _getButtonLabel(friendRequestStatus),
                                      onTap: () async {
                                        if (friendRequestStatus == 'accepted') {
                                          Get.to(() => PrivateChatScreen(
                                                userImage: image,
                                                userUid: userData['uid'],
                                                userName: userData['name'],
                                              ));
                                        } else if (friendRequestStatus ==
                                                'rejected' ||
                                            friendRequestStatus == 'default' ||
                                            friendRequestStatus == 'none') {
                                          _acceptFriendRequest(
                                              controller.uid!, userData['uid']);
                                          awesomeNotifications
                                              .createNotification(
                                            content: NotificationContent(
                                              id: 10,
                                              channelKey: 'basic_channel',
                                              actionType: ActionType.Default,
                                              title: 'Friend Request',
                                              body:
                                                  'You have sent a friend request to @${userData['name']}',
                                            ),
                                          );
                                          await _sendNotification(
                                              userData['uid'],
                                              image,
                                              userData['name']);
                                        } else if (friendRequestStatus ==
                                            'pending') {
                                          print('Request already sent.');
                                        }
                                      },
                                    );
                            },
                          ),
                          if (userData["uid"] != controller.uid)
                            friendRequestStatus == 'accepted'
                                ? CustomButton(
                                    width: Get.width / 1.3,
                                    height: 49,
                                    onTap: () async {},
                                    padding: ButtonPadding.PaddingAll4,
                                    fontStyle:
                                        ButtonFontStyle.PoppinsSemiBold18,
                                    text: "Following      |         ",
                                    suffixWidget: CustomImageView(
                                        height: 18,
                                        width: 20,
                                        imagePath: ImageConstant.followMeIcon),
                                  )
                                : CustomButton(
                                    width: Get.width / 1.3,
                                    height: 40,
                                    onTap: () async {},
                                    padding: ButtonPadding.PaddingAll4,
                                    fontStyle:
                                        ButtonFontStyle.PoppinsSemiBold18,
                                    text: "Follow Me       |         ",
                                    suffixWidget: CustomImageView(
                                        height: 18,
                                        width: 20,
                                        imagePath: ImageConstant.followMeIcon),
                                  ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(.9, -1.1),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: ColorConstant.red500,
                          borderRadius: BorderRadius.circular(100)),
                      child: Transform.rotate(
                          angle: 45 * math.pi / 180,
                          child: Icon(
                            Icons.add,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> captureAndShareScreenshot(
      GlobalKey<State<StatefulWidget>> globalKey) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        String fileName = 'screenshot.png';
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/$fileName').create();
        await file.writeAsBytes(pngBytes);
        await Share.shareFiles([file.path], text: 'Check out this profile');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error capturing screenshot: $e');
      }
    }
  }
}

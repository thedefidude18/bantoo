// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flexx_bet/chat/chat_controller.dart';
import 'package:flexx_bet/chat/chat_service.dart';
import 'package:flexx_bet/chat/widgets/chat_user_info.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/extensions/map_extentions.dart';
import 'package:flexx_bet/extensions/string_extentions.dart';
import 'package:flexx_bet/models/event_model.dart';
import 'package:flexx_bet/ui/bets_screens/join_bet_screen.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/utils/file_utils.dart';
import 'package:flexx_bet/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  var controller = Get.find<ChatController>();
  var msgController = TextEditingController();
  bool isMessageNotEmpty =
      false; // Flag to control the visibility of the send button
  final _scrollController = ScrollController();
  final EventsController _eventsController = EventsController.to;
  RxDouble eventCardHeight = 80.00.obs;
  bool isLoading = false;
  bool isAnswered = false;
  bool emojiShowing = false;
  final FocusNode _focusNode = FocusNode();
  Duration _remainingDuration = Duration.zero;
  Timer? _timer;
  // final _footerScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print("CurrentGroup::${controller.currentGroup.value?.data()}");
    getCount();
    _updateRemainingTime(controller.currentGroup.value?.get("endAt"));
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateRemainingTime(controller.currentGroup.value?.get("endAt"));
    });
    msgController.addListener(() {
      setState(() {
        isMessageNotEmpty = msgController.text.trim().isNotEmpty;
      });
    });
    _scrollController.addListener(_scrollListener);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          emojiShowing = false; // Hide emoji picker when keyboard is opened
        });
      }
    });
  }

  @override
  void dispose() {
    msgController.dispose();
    _scrollController.dispose();
    _focusNode.dispose(); // Dispose of the FocusNode
    _timer?.cancel();
    super.dispose();
  }

  void _updateRemainingTime(int endAt) {
    DateTime now = DateTime.now();
    DateTime endDateTime = DateTime.fromMillisecondsSinceEpoch(endAt);
    _remainingDuration = endDateTime.difference(now);

    // Ensure the timer stops when the end time is reached
    if (_remainingDuration.isNegative) {
      _timer?.cancel();
      _remainingDuration = Duration.zero;
    }

    setState(() {});
  }

  final GlobalKey _globalKey = GlobalKey();

  void _scrollListener() {
    if (_scrollController.offset > 0) {
      eventCardHeight.value = 80;
    } else {
      eventCardHeight.value = 80;
    }
  }

  String formatAmount(String joinAmount) {
    try {
      // Parse the string to a number
      int amount = int.parse(joinAmount);

      if (amount >= 1000) {
        // Convert to 'k' format with one decimal if necessary
        double formattedAmount = amount / 1000;
        return formattedAmount
                .toStringAsFixed(formattedAmount % 1 == 0 ? 0 : 1) +
            "k";
      } else {
        // Return the original value if it's less than 1000
        return amount.toString();
      }
    } catch (e) {
      // Handle invalid input
      print("Error parsing joinAmount: $e");
      return joinAmount; // Return the original value if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textColor =
        _remainingDuration == Duration.zero ? Colors.grey : Colors.black;
    String days = _remainingDuration.inDays.toString().padLeft(2, '0');
    String hours = (_remainingDuration.inHours % 24).toString().padLeft(2, '0');
    String minutes =
        (_remainingDuration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds =
        (_remainingDuration.inSeconds % 60).toString().padLeft(2, '0');
    return RepaintBoundary(
      key: _globalKey,
      child: Column(
        children: [
          eventCard(),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: ColorConstant.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Event Pool",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "₦ ${formatAmount(controller.currentGroup.value!.get("joinAmount").toString())}",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 7),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      color: ColorConstant.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: days,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          TextSpan(
                            text: " D  ",
                            style: TextStyle(
                              fontSize: 9,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w200,
                              color: textColor,
                            ),
                          ),
                          TextSpan(
                            text: hours,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          TextSpan(
                            text: " H  ",
                            style: TextStyle(
                              fontSize: 9,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w200,
                              color: textColor,
                            ),
                          ),
                          TextSpan(
                            text: minutes,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          TextSpan(
                            text: " M  ",
                            style: TextStyle(
                              fontSize: 9,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w200,
                              color: textColor,
                            ),
                          ),
                          TextSpan(
                            text: seconds,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          TextSpan(
                            text: " S  ",
                            style: TextStyle(
                              fontSize: 9,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w200,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // Obx(() =>
          //     eventCardHeight.value == 80 ? subTitleBar() : SizedBox.shrink()),
          messageBox(),
          sendMessageTile(),
        ],
      ),
    );
  }

  Widget subTitleBar() {
    return SizedBox(
      height: 43,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: 43,
          //   width: 41,
          //   child: Stack(
          //     children: [
          //       Positioned(
          //         top: 5,
          //         right: 3,
          //         child: CircleAvatar(
          //           radius: 19,
          //           child: Image.asset(
          //             ImageConstant.unsplash2,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       ),
          //       Positioned(
          //         top: 0,
          //         right: 0,
          //         child: Container(
          //           width: 16,
          //           height: 16,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(5),
          //             color: ColorConstant.primaryColor,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(
          //   width: 4,
          // ),
          // Text(
          //   "Please abide to the rules!",
          //   style:
          //       TextStyle(color: ColorConstant.gray500, fontFamily: "Popins"),
          // ),
          // const SizedBox(
          //   width: 4,
          // ),
          // Image.asset(
          //   ImageConstant.pushpin,
          //   height: 20,
          //   width: 20,
          // ),
        ],
      ),
    );
  }

  Widget messageBox() {
    return Expanded(
        child: StreamBuilder(
      stream: controller.chatService
          .getChats(controller.currentGroup.value?.id ?? ""),
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                controller: _scrollController,
                itemCount: snapshot.data.docs.length + 1,
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 5),
                separatorBuilder: (_, i) => const SizedBox(
                  height: 10,
                ),
                itemBuilder: (context, index) {
                  if (index == snapshot.data.docs.length) {
                    return Center(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0Xff6F6F87),
                                offset: Offset(0, 0),
                                spreadRadius: -4,
                                blurRadius: 8,
                              )
                            ]),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '@johdoe ',
                                style: TextStyle(
                                  fontFamily: "Popins",
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstant.primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: 'just joined the group',
                                style: TextStyle(
                                  fontFamily: "Popins",
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.dialog(const ChatUserInfoCard(), arguments: {
                              "userId": snapshot.data.docs[index]['senderId'],
                              "group": controller.currentGroup.value?.data(),
                            });
                          },
                          child: SizedBox(
                            height: 38,
                            width: 42,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    height: 38,
                                    width: 38,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: FutureBuilder(
                                          future: controller.chatService
                                              .getUserImage(
                                                  userId: snapshot.data
                                                      .docs[index]['senderId']),
                                          builder: (context, data) {
                                            if (data.hasData &&
                                                data.data != null &&
                                                data.data is String &&
                                                (data.data as String)
                                                    .isNotEmpty) {
                                              return SizedBox(
                                                height: 38,
                                                width: 38,
                                                child: Image.network(
                                                  "${data.data!}",
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                      ImageConstant
                                                          .unsplash, // Your fallback image
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                                // FadeInImage(
                                                //   fit: BoxFit.cover,
                                                //   placeholder: const AssetImage(
                                                //       ImageConstant.unsplash),
                                                //   imageErrorBuilder: (context,
                                                //       obj, stacktrace) {
                                                //     return Image.asset(
                                                //       ImageConstant.unsplash,
                                                //       fit: BoxFit.cover,
                                                //     );
                                                //   },
                                                //   image: NetworkImage(
                                                //       "${data.data!}"),
                                                // ),
                                              );
                                            } else {
                                              return SizedBox(
                                                  height: 30.0,
                                                  width: 30.0,
                                                  child: Image.asset(
                                                    ImageConstant.unsplash,
                                                    fit: BoxFit.cover,
                                                  ));
                                            }
                                          }),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    height: 12,
                                    width: 12,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xff1BF631),
                                          Color(0xff00AE11),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data.docs[index]['sender']
                                      .toString(),
                                  style: TextStyle(
                                    fontFamily: "Popins",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                if (snapshot.data.docs[index]['senderId'] ==
                                    ((controller.currentGroup.value!.data()
                                            as Map)["admin"] as String)
                                        .getFirstValueAfterUnderscore())
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: Image.asset(
                                        ImageConstant.iconAdmin2,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 1,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0X40FFC700),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: (snapshot.data.docs[index]['type'] ==
                                          MessageType.image.name)
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.network(
                                            "${snapshot.data.docs[index]['image'] ?? ""}",
                                            width: 150,
                                          ),
                                        )
                                      : Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.6,
                                          ),
                                          child: Text(
                                            snapshot.data.docs[index]
                                                    ['message'] ??
                                                "",
                                            style: TextStyle(
                                              fontFamily: "Popins",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Image.asset(
                                    'assets/images/faceplus.png',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFCCCCCC),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "😀 ${formatCount('0')}",
                                    style: TextStyle(
                                      fontFamily: "Popins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFCCCCCC),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "🔥  ${formatCount('0')}",
                                    style: TextStyle(
                                      fontFamily: "Popins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              convertTimestamp(
                                  snapshot.data.docs[index]['createdAt']),
                              style: TextStyle(
                                fontFamily: "Popins",
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff9191A8),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  }
                },
              )
            : Container();
      },
    ));
  }

  Widget eventCard() {
    return Obx(() {
      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: eventCardHeight.value,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  ColorConstant.black900,
                  ColorConstant.blackLight,
                ],
              )),
          child: Stack(fit: StackFit.expand, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                "${controller.getGroupBanner(groupData: controller.currentGroup.value?.data() as Map?)}",
                fit: BoxFit.cover,
                height: 200,
                width: 150,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    ImageConstant.staticJoinBet, // Your fallback image
                    fit: BoxFit.cover,
                    height: 200,
                    width: 150,
                  );
                },
              ),
              // child: Image.asset(
              //   ImageConstant.staticJoinBet,
              //   fit: BoxFit.cover,
              // )
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:
                    Colors.black.withOpacity(0.5), // Adjust opacity as needed
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 7,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: SizedBox(
                          width: 100,
                          child: Text(
                            // 'Omah Lay will drop a new Album this weekend.',
                            "${controller.getGroupDescription(groupData: controller.currentGroup.value?.data() as Map?)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Spacer(),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 60,
                                  width: 70,
                                  child: Stack(
                                    alignment: Alignment.bottomLeft,
                                    children: [
                                      InkWell(
                                        onTap: isAnswered
                                            ? null
                                            : () {
                                                setState(() {
                                                  isLoading = true;
                                                });

                                                Future.delayed(const Duration(
                                                        seconds: 1))
                                                    .then((value) async {
                                                  var data = {
                                                    'selectedOutCome': 'No',
                                                    'userId': controller.uid,
                                                    // Add more key-value pairs as needed
                                                  };

                                                  await controller
                                                      .addOutcomeToGroup(
                                                          "chatrooms",
                                                          controller
                                                                  .currentGroup
                                                                  .value
                                                                  ?.id ??
                                                              "",
                                                          data,
                                                          controller.uid);

                                                  getCount();
                                                });
                                              },
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          margin:
                                              const EdgeInsets.only(left: 10.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,

                                            color: isAnswered
                                                ? ColorConstant.gray
                                                : ColorConstant.red1,
                                            // borderRadius:
                                            //     BorderRadius.circular(30),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "NO",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 27,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Popins",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0,
                                        ),
                                        width: 21,
                                        margin:
                                            const EdgeInsets.only(bottom: 5.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Text(
                                          formatCount(
                                            controller.noCount.toString(),
                                          ),
                                          // controller.noCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Popins",
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                SizedBox(
                                  height: 60,
                                  width: 70,
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      InkWell(
                                        onTap: isAnswered
                                            ? null
                                            : () async {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                Future.delayed(const Duration(
                                                        seconds: 1))
                                                    .then((value) async {
                                                  var data = {
                                                    'selectedOutCome': 'Yes',
                                                    'userId': controller.uid,
                                                    // Add more key-value pairs as needed
                                                  };

                                                  await controller
                                                      .addOutcomeToGroup(
                                                          "chatrooms",
                                                          controller
                                                                  .currentGroup
                                                                  .value
                                                                  ?.id ??
                                                              "",
                                                          data,
                                                          controller.uid);

                                                  getCount();
                                                });
                                              },
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,

                                            color: isAnswered
                                                ? ColorConstant.gray
                                                : ColorConstant.greenLight,
                                            // borderRadius:
                                            //     BorderRadius.circular(30),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "YES",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 27,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Popins",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 21,
                                          maxHeight: 25,
                                        ),
                                        margin:
                                            const EdgeInsets.only(bottom: 5.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Text(
                                          formatCount(
                                            controller.yesCount.toString(),
                                          ),
                                          // controller.noCount.toString() ,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Popins",
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                )
                              ],
                            ),
                      /*   Container(
                              height: 7,
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstant.red1,
                                    ColorConstant.greenLight1,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                ),
                              ),
                            ),*/
                    ],
                  ),
                  Container()
                ],
              ),
            )
          ]),
        ),
      );
    });
  }

  Future<void> captureAndShareScreenshot(
      GlobalKey<State<StatefulWidget>> globalKey) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        // Specify a filename for the shared image
        String fileName = 'screenshot.png';
        // Save the image to the device's temporary directory
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/$fileName').create();
        await file.writeAsBytes(pngBytes);
        _eventsController
            .createDynamicLink("DataAmSending")
            .then((value) async {
          await Share.shareFiles([file.path], text: value);
        });
      }
    } catch (e) {
      print('Error capturing screenshot: $e');
    }
  }

  Widget sendMessageTile() {
    return Column(
      children: [
        SizedBox(
          height: 50.0,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: msgController,
                  focusNode: _focusNode,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        showAlertDialog(
                          titleText: 'Choose an option',
                          infoText:
                              "Choose one of the options from the following to continue",
                          extraDetails: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    FileUtils.getImageFromCamera()
                                        .then((value) async {
                                      if (value != null) {
                                        var url =
                                            await controller.uploadChatImage(
                                                context: context,
                                                groupId: controller.currentGroup
                                                        .value?.id ??
                                                    "",
                                                image: value);
                                        controller
                                            .sendMessage(
                                                groupId: controller.currentGroup
                                                        .value?.id ??
                                                    "",
                                                message: msgController.text,
                                                messageType:
                                                    MessageType.image.name,
                                                senderId: controller.uid,
                                                senderName: controller
                                                        .currentUserData.value
                                                        .getValueOfKey(
                                                            "name") ??
                                                    "",
                                                image: url)
                                            .then((value) {
                                          msgController.clear();
                                          Get.back();
                                          Future.delayed(
                                              const Duration(seconds: 1),
                                              () async {
                                            _scrollController.animateTo(
                                              _scrollController
                                                  .position.maxScrollExtent,
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              curve: Curves.easeOut,
                                            );
                                          });
                                        });
                                      }
                                    });
                                  },
                                  child: Image.asset(
                                    ImageConstant.iconCamera,
                                    height: 60.0,
                                  ),
                                ),
                                const SizedBox(
                                  width: 40.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FileUtils.getImageFromGallery()
                                        .then((value) async {
                                      if (value != null) {
                                        var url =
                                            await controller.uploadChatImage(
                                                context: context,
                                                groupId: controller.currentGroup
                                                        .value?.id ??
                                                    "",
                                                image: value);
                                        controller
                                            .sendMessage(
                                                groupId: controller.currentGroup
                                                        .value?.id ??
                                                    "",
                                                message: msgController.text,
                                                messageType:
                                                    MessageType.image.name,
                                                senderId: controller.uid,
                                                senderName: controller
                                                        .currentUserData.value
                                                        .getValueOfKey(
                                                            "name") ??
                                                    "",
                                                image: url)
                                            .then((value) {
                                          msgController.clear();
                                          Get.back();
                                          Future.delayed(
                                              const Duration(seconds: 1),
                                              () async {
                                            _scrollController.animateTo(
                                              _scrollController
                                                  .position.maxScrollExtent,
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              curve: Curves.easeOut,
                                            );
                                          });
                                        });
                                      }
                                    });
                                  },
                                  child: Image.asset(
                                    ImageConstant.iconGallery,
                                    height: 60.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/Actions.png',
                          width: 22,
                          height: 18,
                        ),
                      ),
                    ),
                    prefixIcon: GestureDetector(
                      onTap: () {
                        if (emojiShowing) {
                          setState(() {
                            emojiShowing = false;
                          });
                          FocusScope.of(context)
                              .requestFocus(_focusNode); // Open the keyboard
                        } else {
                          FocusScope.of(context)
                              .unfocus(); // Close the keyboard
                          setState(() {
                            emojiShowing = true;
                          });
                        }
                      },
                      child: emojiShowing == true
                          ? Icon(
                              Icons.keyboard_alt_outlined,
                              color: ColorConstant.black900C4,
                              size: 30,
                            )
                          : Icon(
                              Icons.emoji_emotions,
                              color: ColorConstant.primaryColor,
                              size: 30,
                            ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    isDense: true,
                    hintText: "Send a message",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  if (msgController.text.trim() != "") {
                    controller
                        .sendMessage(
                      groupId: controller.currentGroup.value?.id ?? "",
                      message: msgController.text,
                      messageType: MessageType.text.name,
                      senderId: controller.uid,
                      senderName: controller.currentUserData.value
                              .getValueOfKey("name") ??
                          "",
                    )
                        .then((value) {
                      msgController.clear();
                      Future.delayed(const Duration(seconds: 1), () async {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeOut,
                        );
                      });
                    });
                  }
                },
                child: isMessageNotEmpty
                    ? SizedBox(
                        height: 36.0,
                        width: 36.0,
                        child: Image.asset(
                          'assets/images/Group 1171275130 (1).png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(),
              ),
              const SizedBox(
                width: 12.0,
              ),
            ],
          ),
        ),
        Visibility(
          visible: emojiShowing,
          child: SizedBox(
            height: 256, // Set a fixed height for the EmojiPicker
            child: EmojiPicker(
              textEditingController: msgController,
              config: Config(
                checkPlatformCompatibility: true,
                emojiViewConfig: EmojiViewConfig(
                  emojiSizeMax: 28 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.2
                          : 1.0),
                ),
                skinToneConfig: const SkinToneConfig(),
                categoryViewConfig: const CategoryViewConfig(),
                bottomActionBarConfig: const BottomActionBarConfig(),
                searchViewConfig: const SearchViewConfig(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String image() {
    var category = controller.getGroupCategory(
        groupData: controller.currentGroup.value?.data() as Map?);
    return controller.getCategoryImage(category);
  }

  Future<void> getCount() async {
    await controller.getOutcomeCount(controller.currentGroup.value?.id ?? "");
    isAnswered = await controller.checkMemberAnswered(
        "chatrooms", controller.currentGroup.value?.id ?? "", controller.uid);

    setState(() {
      isLoading = false;
    });
  }

  String formatCount(String count) {
    if (count.isEmpty) {
      return '';
    }
    try {
      int _count = int.parse(count);
      if (_count > 99) {
        return '99+';
      } else {
        return count;
      }
    } catch (e) {
      return '';
    }
  }

  String convertTimestamp(timeStamp) {
    // The given timestamp in milliseconds
    int timestamp = timeStamp;

    // Convert the timestamp to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Format the DateTime object to the desired string format
    String formattedDate = DateFormat('EEEE h:mma').format(dateTime);

    // Output the formatted date
    return formattedDate; // Example output: "Friday 5:50PM"
  }
}

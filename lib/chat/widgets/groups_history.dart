import 'dart:developer';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexx_bet/chat/chat_controller.dart';
import 'package:flexx_bet/chat/chat_service.dart';
import 'package:flexx_bet/chat/widgets/my_groups.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/extensions/map_extentions.dart';
import 'package:flexx_bet/extensions/string_extentions.dart';
import 'package:flexx_bet/ui/bets_screens/create_bet_screen.dart';
import 'package:flexx_bet/ui/bets_screens/join_bet_screen.dart';
import 'package:flexx_bet/ui/components/components.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/utils/bet_styles.dart';
import 'package:flexx_bet/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../controllers/wallet_controller.dart';
import '../../ui/wallet/wallet.dart';

class GroupHistory extends StatefulWidget {
  final Function()? onJoin;
  String id;
  GroupHistory(this.id, {super.key, this.onJoin});
  @override
  State<GroupHistory> createState() => _GroupHistoryState();
}

class _GroupHistoryState extends State<GroupHistory> {
  var controller = Get.find<ChatController>();

  var walletController = Get.find<WalletContoller>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      // controller.groupHistory.value = await controller.getGroups();
      controller.getGroupsStream();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Color getRandomColor() {
    Random random = Random();
    // Generate colors with higher average RGB values for lighter colors
    return Color.fromARGB(
      255,
      200 + random.nextInt(56), // Red component (200 to 255)
      200 + random.nextInt(56), // Green component (200 to 255)
      200 + random.nextInt(56), // Blue component (200 to 255)
    );
  }
  bool isExpired(int timestamp) {
    // Convert milliseconds to DateTime
    DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Get the current date and time
    DateTime currentDate = DateTime.now();

    // Check if the expiration date is in the past
    return expirationDate.isBefore(currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffEDEDED),
      // color: ColorConstant.blueGray10096,
      child: Column(
        children: [
          SizedBox(
            height: 92,
            child: showCategories(context),
          ),
          const Divider(
            color: Color(0X2B8D98AD),
            height: 1,
          ),
          Expanded(child: showEvents())
        ],
      ),
    );
  }

  Widget showCategories(BuildContext context) {
    final List<String> labels = [
      'Create an event',
      'Pop Culture',
      'Sports',
      'Music',
      'Games',
      'Crypto',
    ];
    final List<String> icons = [
      ImageConstant.activeAddIcon,
      ImageConstant.newPopCulture,
      ImageConstant.newSport,
      ImageConstant.newMusic,
      ImageConstant.newGaming,
      ImageConstant.newBitCoin,
    ];
    return ListView.separated(
      itemCount: labels.length,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(6),
      itemBuilder: (_, i) => Obx(() {
        return categoryBox(context,
            label: labels[i],
            icon: icons[i],
            isPrimary: i == 0,
            isSelected:
                controller.sortByCategory.value == labels[i].toLowerCase());
      }),
      separatorBuilder: (_, i) => const SizedBox(
        width: 12,
      ),
    );
  }

  Widget categoryBox(
    BuildContext context, {
    required String label,
    required String icon,
    required bool isPrimary,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: isPrimary
          ? () {
              Get.to(CreateBetScreen())?.then((value) {
                if (value == true) {
                  controller.getGroups();
                }
              });
              /* }
              });*/
            }
          : () {
              controller.setSortBy(label.toLowerCase());
            },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 72,
            width: 72,
            padding: const EdgeInsets.all(1),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffBEFF07), Color(0xff7440FF)],
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected ? ColorConstant.primaryColor : Colors.white),
              child: Image.asset(
                icon,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              decoration: BoxDecoration(
                color: isPrimary ? ColorConstant.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(12.5),
              ),
              child: Text(
                label,
                // 'Create an event',
                style: TextStyle(
                  color: isPrimary ? Colors.white : Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showEvents() {
    return Obx(() {
      print("unjoined list size------------>${controller.unJoinedGroups.length}");

      final reversedList = controller.unJoinedGroups.reversed.toList();

      // Apply the category filter here to remove items that do not match the selected category
      final filteredList = reversedList.where((item) {
        var category = item['category']?.toString()?.toLowerCase() ?? "";
        return controller.sortByCategory.value.isEmpty ||
            controller.sortByCategory.value.toLowerCase() == category;
      }).toList();

      // Implement scrolling to a specific group if needed
      Future.delayed(const Duration(seconds: 2)).then((value) {
        if (widget.id.isNotEmpty) {
          final index =
          filteredList.indexWhere((item) => item['groupId'] == widget.id);

          if (index != -1 && _scrollController.hasClients) {
            // Calculate the offset based on the index and item height
            double offset = index * 218.14; // Height of each card

            // Ensure the offset doesn't exceed the scroll extent
            offset = offset > _scrollController.position.maxScrollExtent
                ? _scrollController.position.maxScrollExtent
                : offset;

            // Scroll to the calculated offset with animation
            _scrollController.animateTo(
              offset,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      });

      if (filteredList.isNotEmpty) {
        return ListView.builder(
          controller: _scrollController, // Ensure _scrollController is initialized
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final item = filteredList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: SizedBox(
                height: 218.14,
                width: 422,
                child: unjoinedEventTileUI(item),
              ),
            );
          },
        );
      } else {
        return const Center(
          child: Text("No event available"),
        );
      }
    });
  }


  int calculateCrossAxisCellCount(int index) {
    return 2; // As per the provided pattern, the cross axis count is always 2
  }

// Helper function to calculate main axis cell count
  int calculateMainAxisCellCount(int index) {
    if (index % 2 != 0) {
      return 3; // Tall tile
    } else {
      return 2; // Short tile
    }
  }

  Widget unjoinedEventTileUI(doc) {
    var data = doc.data();
    var desc = (data as Map).getValueOfKey("groupName") ?? "";
    var category = data.getValueOfKey("category") ?? "";
    var expireDateAndTime = data.getValueOfKey("endAt") ?? "";
    var categoryImage = categoriesNewList.firstWhere((element) =>
            "${element["name"]}".toLowerCase() ==
            "$category".toLowerCase())["imagePath"] ??
        ImageConstant.beach;
    var admin =
        "${"${data.getValueOfKey("admin") ?? ""}".getLastValueAfterUnderscore()}";
    var members = data.getValueOfKey("members");
    var joinAmount = data.getValueOfKey("joinAmount");
    // print('category $category');

    return Obx(() {
      return controller.sortByCategory.value.isNotEmpty &&
              controller.sortByCategory.value.toLowerCase() !=
                  category.toString().toLowerCase()
          ? const SizedBox.shrink()
          : Stack(

              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      "${controller.getGroupBanner(groupData: data as Map?)}",
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
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [


                    Container(

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),

                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF111111).withOpacity(0.7), // 0% opacity
                            Color(0xFF111111).withOpacity(0), // 100% opacity
                          ],
                            stops: [0.0, 1.0], // Abrupt transition at 64%
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isExpired(expireDateAndTime)
                              ? Container(
                            width: 66,
                            height: 25,
                            margin: const EdgeInsets.only(top: 2, left: 7),
                            child: Image.asset(
                              ImageConstant.endedBadge,
                            ),
                          )
                          //  const Padding(
                          //     padding: EdgeInsets.all(8.0),
                          //     child: Text(
                          //       "Event Ended",
                          //       style: TextStyle(color: Colors.red),
                          //     ),
                          //   )
                              : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Image.asset(
                              ImageConstant.liveButton,
                              width: 60,
                            ),
                          ),
                          Container(
                            width:240,
                            margin: const  EdgeInsets.only(left:8.0,right: 8.0,top: 0.0,bottom: 0.0),
                            padding: const EdgeInsets.only(left:0.0,right: 0.0,top: 0.0,bottom: 0.0),

                            child: Text(
                              "${desc.toString().capitalize}",
                              maxLines: 2,
                              textAlign:TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: FlexxBetStyles.textStyle.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Center(
                            child:FittedBox(
                              child: Container(
                                margin: const EdgeInsets.only(top: 7, right: 7),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.20),
                                    borderRadius: BorderRadius.circular(14)
                                ),
                                child: Padding(
                                  padding:admin!=""? const EdgeInsets.only(right:8.0):const EdgeInsets.only(right:0.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        getParticipantsAvatar(),
                                        height: 14,
                                      ),
                                      const SizedBox(width: 4.0,),
                                      SizedBox(
                                        width: 35,
                                        child: Text(admin,
                                          textAlign: TextAlign.center,
                                          style: FlexxBetStyles.textStyle.copyWith(
                                              color:const  Color(0xFF46FF90),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 10),
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )



                  ],

                ),


                Positioned(
                  bottom: 40,
                  left: 12,
                  child: Text(
                    "Event Pool",
                    style: FlexxBetStyles.textStyle.copyWith(
                        fontSize: 18.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    height: 20,
                    width: 80,
                    decoration: BoxDecoration(
                        color: const Color(0xffE9E9E9),
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        " ₦ ${controller.getGroupMember(
                          groupData: data,
                        ) ?? "0"}",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Popins",
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 94,
                  bottom: 12,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Image.asset(
                          getParticipantsAvatar(),
                          height: 23.79,
                        ),
                      ),
                      Positioned(
                        right: 1,
                        child: Container(
                          height: 23.79,
                          width:23.37,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (members is List)
                                  ? "+${members.length.toString()}"
                                  : "+1",
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Popins",
                                fontSize: 7,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right:10,
                  bottom: 4,
                  child: StreamBuilder(
                    stream: controller.chatService.hasAlreadySendRequest(
                      groupId: doc.id,
                      userId: controller.uid,
                    ),
                    builder: (context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data == false &&
                          doc.data() is Map &&
                          controller.chatService.ifGroupFullAlready(
                            groupData: doc.data() as Map,
                          )) {
                        return const Text(
                          "Group Capacity\nreached",
                          style: TextStyle(
                            fontFamily: "Popins",
                            color: Colors.green,
                            fontSize: 9
                          ),
                          textAlign: TextAlign.center,
                        );
                      }
                      if (snapshot.hasData && snapshot.data == true) {
                        return const Text(
                          "Awaiting\nApproval",
                          style: TextStyle(
                            fontFamily: "Popins",
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }
                      return ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          fixedSize: const MaterialStatePropertyAll(
                            const Size(121,48)
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            ColorConstant.yellowGreen,
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.all(10.0),
                          ),
                        ),
                        onPressed: () {
                          if (controller.checkIfGroupPrivate(obj: doc.data())) {
                            showAlertDialog(
                              titleText: "Private Group",
                              infoText:
                                  "You need admin approval before joining this group. Click on below button to send joining request to group admin",
                              buttonText: "Send Joining Request",
                              buttonTextStyle:
                                  const TextStyle(color: Colors.white),
                              onPressed: () {
                                controller.chatService.sendJoinRequestMessage(
                                  groupId: doc.id,
                                  requestData: {
                                    "uid": controller.uid,
                                    "name": controller.currentUserData.value
                                            .getValueOfKey("name") ??
                                        "",
                                    "createdAt":
                                        DateTime.now().millisecondsSinceEpoch,
                                    //"joinAmount":controller.,
                                  },
                                ).then((value) {
                                  Get.back();
                                  "Request has been sent to the group admin"
                                      .showSnackbar(
                                    isSuccess: true,
                                  );
                                });
                              },
                            );
                          } else {
                            _showPopupProfile(
                              context,
                              groupDetails: doc.data() as Map,
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: controller.checkIfGroupPrivate(obj: doc.data())?MainAxisAlignment.center:MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            if (controller.checkIfGroupPrivate(obj: doc.data()))
                              Image.asset(
                                ImageConstant.lock,
                                height: 40,
                                width: 40,
                              ),
                            Text(
                              "Join",
                              style: FlexxBetStyles.textStyle.copyWith(
                                color: ColorConstant.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 23,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
    });
  }

  void _showPopupProfile(BuildContext context, {required Map groupDetails}) {
    showDialog(
      barrierColor: ColorConstant.black900.withOpacity(0.87),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 420,
            width: 335,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorConstant.gradiant1, ColorConstant.gradiant2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(children: [
                    Container(
                      height: 128,
                      width: 128,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(69),
                        border: GradientBoxBorder(
                          gradient: LinearGradient(colors: [
                            ColorConstant.deepPurpleA2007a,
                            ColorConstant.gradiant3
                          ]),
                          width: 4,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60.0),
                          child: FutureBuilder(
                              future: controller.chatService.getUserImage(
                                  userId: (groupDetails["admin"].toString())
                                          .getFirstValueAfterUnderscore() ??
                                      ""),
                              builder: (context, data) {
                                if (data.hasData &&
                                    data.data != null &&
                                    data.data is String &&
                                    (data.data as String).isNotEmpty) {
                                  return

                                    Image.network(
                                      "${data.data!}",
                                      fit: BoxFit.cover,

                                      // errorBuilder: (context, error, stackTrace) {
                                      //   return Image.asset(
                                      //     ImageConstant.profile1, // Your fallback image
                                      //     fit: BoxFit.cover,
                                      //
                                      //   );
                                      // },
                                    );
                                  //   FadeInImage(
                                  //
                                  //
                                  //   fit: BoxFit.cover,
                                  //   placeholder: const AssetImage(
                                  //       ImageConstant.profile1),
                                  //   imageErrorBuilder:
                                  //       (context, obj, stacktrace) {
                                  //     return Image.asset(
                                  //       ImageConstant.profile1,
                                  //       fit: BoxFit.cover,
                                  //     );
                                  //   },
                                  //   image: NetworkImage("${data.data!}"),
                                  // );
                                }
                                else {
                                  return const Loading();
                                }
                              }),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: 108,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: ColorConstant.greenLight,
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    )
                  ]),
                  const SizedBox(
                    height: 12,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorConstant.black900,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Popins"),
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Welcome to',
                        ),
                        TextSpan(
                          text:
                              ' @${"${groupDetails["admin"]}".getLastValueAfterUnderscore()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const TextSpan(
                          text: ' events.',
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Please kindly read the rules before",
                    style: TextStyle(
                        fontSize: 16,
                        color: ColorConstant.black900,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Popins"),
                  ),
                  Center(
                    child: Text(
                      "joining.",
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorConstant.black900,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Popins"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 3,
                        width: 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        "${groupDetails["rules"]}",
                        style: TextStyle(
                            fontSize: 14,
                            color: ColorConstant.gray80001,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Popins"),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 3,
                        width: 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        groupDetails["joinAmount"] == null
                            ? "Join amount not available"
                            : "Join amount ₦${groupDetails["joinAmount"]}",
                        style: TextStyle(
                            fontSize: 14,
                            color: ColorConstant.gray80001,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Popins"),
                      )
                    ],
                  ),
                  const Spacer(),
                  CustomButton(
                    text: "Enter event",
                    fontStyle: ButtonFontStyle.InterSemiBold16,
                    suffixWidget: Image.asset(
                      ImageConstant.appLogo1,
                    ),
                    onTap: () {
                      joinBetFunction(groupDetails);
                    },
                    height: 48,
                    width: 307,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void joinBetFunction(Map<dynamic, dynamic> groupDetails) {
    //first check wallet amount

    controller
        .groupEventJoinEligibilityCheck(
            controller: walletController,
            groupJoinAmount: groupDetails["joinAmount"] ?? 0)
        .then((value) {
      if (value == false) {
        showAlertDialog(
            titleText: "Group Event Join failure",
            infoText:
                "You've not enough balance in your wallet. N1000 balance is required to join a group event. please fund your wallet & continue",
            buttonText: "Go to wallet",
            buttonTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            buttonBackgroundColor: ColorConstant.primaryColor,
            onPressed: () {
              Get.back(result: true);
            }).then((value) {
          if (value == true) {
            Get.to(() => WalletScreen());
          }
        });
      } else {
        // join group function
        controller
            .joinExitGroup(
                context: context,
                groupId: groupDetails['groupId'] ?? "",
                groupName: groupDetails['groupName'] ?? "",
                userName:
                    controller.currentUserData.value.getValueOfKey("name") ??
                        "",
                walletContoller: walletController,
                amount: groupDetails["joinAmount"] ?? 0)
            .then((value) {
          if (value == true) {
            Get.back();
            Get.to(const JoinBetScreen());
          }
        });
      }
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/chat/chat_controller.dart';
import 'package:flexx_bet/chat/widgets/notifiactionIcon.dart';
import 'package:flexx_bet/chat/widgets/shimmer.dart';
import 'package:flexx_bet/chat/widgets/terms_conditions_widget.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/landing_page_controller.dart';
import 'package:flexx_bet/controllers/wallet_controller.dart';
import 'package:flexx_bet/models/message_model.dart';
import 'package:flexx_bet/ui/bets_screens/create_bet_screen.dart';
import 'package:flexx_bet/ui/bets_screens/created_bet_history.dart';
import 'package:flexx_bet/ui/private%20chat%20user/private_chat_user.dart';
import 'package:flexx_bet/ui/wallet/wallet.dart';
import 'package:flexx_bet/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../models/UserDetailModel.dart';
import '../../models/user_model.dart';
import '../leaderboard/leaderboard.dart';
import '../notifications_and_bethistory/notifications.dart';
import '../search_screen/search_screen.dart';
import 'custom_button.dart';
import 'custom_image_view.dart';
import 'package:flutter_html/flutter_html.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.showBackButton,
    this.showBetCreateButton,
    this.showCreateEvent = true,
    this.showSearchBar,
    this.showSearchButton,
    this.searchAction,
  });
  final bool? showBackButton;
  final bool showCreateEvent;
  final bool? showBetCreateButton;
  final bool? showSearchBar;
  final bool? showSearchButton;
  final Function? searchAction;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
  @override
  Size get preferredSize => Size.fromHeight(
      Get.height / 12 > kToolbarHeight ? Get.height / 11 : kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final LandingPageController _landingPageController = LandingPageController.to;
  TextEditingController _searchController = TextEditingController();
  final controller = Get.find<ChatController>();
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
    _searchController.addListener(() {
      setState(() {}); // Update the state whenever the text changes
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
    final bool shouldShowBackbutton = (Get.currentRoute != "/" ||
            Get.currentRoute != "/LandingPage" ||
            Get.currentRoute != "/landing-page") &&
        _landingPageController.tabIndex.value != 0;
    return AppBar(
      iconTheme: IconThemeData(color: ColorConstant.whiteA700),
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: ColorConstant.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      toolbarHeight: Get.height * 2,
      actions: [
        if (widget.showCreateEvent)
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
                      gradient: LinearGradient(colors: [
                        ColorConstant.deepPurpleA200,
                        ColorConstant.orange
                      ]),
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(18),
                          bottomRight: Radius.elliptical(50, 70))),
                  child: Center(
                      child: Text(
                    MyConstant.createEventTitle,
                    style: TextStyle(
                        color: ColorConstant.whiteA700,
                        fontFamily: "Popins",
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  )),
                ),
              ),
              Positioned(
                  left: 6,
                  top: 2,
                  child: SvgPicture.asset(ImageConstant.starIcon))
            ],
          ),
        if (widget.showSearchBar ?? false)
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 8),
            child: Container(
              height: 30,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                  border: InputBorder.none,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      ImageConstant.search1,
                      width: 17,
                      height: 17,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Image.asset(ImageConstant.close1),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onChanged: (value) {
                  widget.searchAction!(value);
                },
              ),
            ),
          ),
        if (widget.showSearchButton ?? false)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SearchScreen()));
                },
                child: Image.asset(
                  ImageConstant.search2,
                  height: 38,
                  width: 38,
                )),
          ),

        // const NotificationIcon(
        //   defaultType: 'messages',
        //   iconPaths: {
        //     'messages': 'assets/images/messagenoti.png',
        //     'request': 'assets/images/requestnoti.png',
        //     'Generation': 'assets/images/notification_new.png',
        //   },
        //   fallbackIcon: Icons.notifications, // Fallback icon
        // ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => LeaderBoardScreen()));
              },
              child: Image.asset(
                ImageConstant.leader_icon,
                height: 30,
                width: 30,
              )),
        ),

        // if (widget.showBackButton ?? shouldShowBackbutton)
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
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
        ),

        // GestureDetector(
        //     onTap: () {
        //       Get.to(() =>  NotificationsScreen());
        //     },
        //     child: Center(
        //       child: badges.Badge(
        //           position: badges.BadgePosition.topEnd(top: -1, end: -1),
        //           badgeAnimation: const badges.BadgeAnimation.slide(),
        //           badgeStyle: const badges.BadgeStyle(
        //             padding: EdgeInsets.all(8),
        //             badgeColor: Colors.red,
        //           ),
        //           child: const Icon(
        //             Icons.notifications,
        //             size: 28,
        //           )),
        //     )),
        // const SizedBox(
        //   width: 15,
        // ),
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
      leading: (widget.showBackButton ?? shouldShowBackbutton)
          ? BackButton(
              onPressed: () {
                setState(() {
                  _landingPageController.changeTabIndex(0);
                });
              },
            )
          : GestureDetector(
              onTap: () {
                // Get.to(
                //   () => PrivateChatUserScreen(),
                // );
              },
              child: Container(
                padding: EdgeInsets.only(top: 20, bottom: 20, right: 90),
                height: 20, // Set the desired height
                width: 20, // Set the desired width
                child: Image.asset(
                  ImageConstant.headerLogoMain,
                  height: 20, // Adjust the height
                  width: 20, // Adjust the width
                  fit: BoxFit
                      .contain, // Ensure the logo maintains its aspect ratio
                ),
                // child: Image.asset(
                //   ImageConstant.headerLogo,
                //   height: 20, // Adjust the height
                //   width: 20, // Adjust the width
                //   fit: BoxFit
                //       .contain, // Ensure the logo maintains its aspect ratio
                // ),
              ),
            ),

      /*CustomImageView(
              imagePath: ImageConstant.appLogo,
              fit: BoxFit.contain,
            ),*/
      leadingWidth: (widget.showBackButton ?? shouldShowBackbutton)
          ? Get.width / 7.5
          : Get.width / 2.5,
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.5),
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: Get.height / 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorConstant.gradiant1, ColorConstant.gradiant2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(20.0),
            child: TermsConditions(
              onPressed: () {
                controller.termsConditionsAccepted.value = true;
                Get.off(CreatedBetHistory(""));
              },
            ),

            /*child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Expanded(
                  child: FutureBuilder(
                      future: controller.getChatAbout(),
                      builder: (context, data) {
                        if(data.connectionState == ConnectionState.done && data.hasData && data.data!=null && data.data is Map && (data.data as Map).isNotEmpty){
                          return SingleChildScrollView(
                            child: SizedBox(
                              width: Get.width - (20*2),
                              child: Html(
                                  data: "${data.data!["terms_conditions"]}",
                              ),
                            ),
                          );
                          return Text("${data.data!["terms_conditions"]}");
                        }else if(data.connectionState == ConnectionState.waiting){
                          return Shimmer.fromColors(
                            baseColor: ColorConstant.shimmerBaseColor,
                            highlightColor: ColorConstant.shimmerHighlightColor,
                            child: const Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",style: TextStyle(backgroundColor: Colors.white),),
                          );
                        }else{
                          return const Center(child: Text("No content found."));
                        }
                      }),
                ),
                */ /*Text(
                  "Please Read Terms.",
                  style: TextStyle(
                      color: ColorConstant.primaryColor, fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Popins"),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Spacer(
                ),*/ /*
                const SizedBox(height: 10.0,),
                CustomButton(
                  text: "Proceed",
                  fontStyle: ButtonFontStyle.InterSemiBold16,
                  onTap: () {
                    // Get.to(const BetScreen());
                    Get.to(const CreatedBetHistory());
                  },
                  height: 48,
                  width: 307,
                )
              ],
            ),*/
          ),
        );
      },
    );
  }
}

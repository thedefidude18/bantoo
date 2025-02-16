import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flexx_bet/chat/chat_controller.dart';
import 'package:flexx_bet/chat/screens/events_screen.dart';
import 'package:flexx_bet/chat/widgets/MyEvents.dart';
import 'package:flexx_bet/chat/widgets/groups_history.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/landing_page_controller.dart';
import 'package:flexx_bet/ui/bets_screens/created_bet_history.dart';
import 'package:flexx_bet/ui/components/navigation_bar.dart';
import 'package:flexx_bet/ui/events/detailed_event_screen.dart';
import 'package:flexx_bet/ui/home/home_ui.dart';
import 'package:flexx_bet/ui/leaderboard/leaderboard.dart';
import 'package:flexx_bet/ui/notifications_and_bethistory/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bets_screens/new_my_bets_screen.dart';

class LandingPage extends StatefulWidget {
  LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey stackKey = GlobalKey();

  final tabScreens = [
    DetailedEventScreen(""),
    CreatedBetHistory(""),
    Container(),
    // const LeaderBoardScreen(),
    // NewMyBetsScreen(),
    Container(),
    Container()
  ];

  final _messagingService = MessagingService();

  @override
  void initState() {
    super.initState();
    _messagingService.init(context).then((value) {
      saveFCMToken();
    });
    initDynamicLinks();
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    var data = await FirebaseDynamicLinks.instance.getInitialLink();
    var deepLink = data;

    /// When app is killed state
    if (deepLink != null) {
      print("Dataaaaa");
      print(deepLink.link.queryParameters['invitedCode'] ?? '');
      print("Dataaaaa");
    } else {
      print("nullllllll");
    }

    /// When app is live and background state
    dynamicLinks.onLink.listen((dynamicLinkData) {
      print("Dataaaaa");
      print(dynamicLinkData.link.queryParameters['invitedCode'] ?? '');
      print("Dataaaaa");
    }).onError((error) {
      print(error.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    final LandingPageController landingPageController =
        Get.put(LandingPageController(), permanent: false);
    final AuthController authController = Get.put(AuthController.to);
    Get.put(ChatController(uid: FirebaseAuth.instance.currentUser?.uid ?? ""));
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: buildBottomNavigationMenu(
        context,
        authController.userFirestore?.photoUrl,
      ),
      body: Obx(() => tabScreens[landingPageController.tabIndex.value]),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       SizedBox(
      //         height: Get.height / 1.130,
      //         width: Get.width,
      //         child: Stack(
      //           key: stackKey,
      //           children: [
      //             Obx(() => IndexedStack(
      //                   index: landingPageController.tabIndex.value,
      //                   children: [
      //                     const HomeScreen(),
      //                     DetailedEventScreen(),
      //                     // const EventsScreen(),
      //                     const Padding(
      //                       padding: EdgeInsets.only(bottom: 50.0),
      //                       child: CreatedBetHistory(),
      //                     ),
      //                     const LeaderBoardScreen(),
      //                     Container()
      //                   ],
      //                 )),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    ));
  }

  void saveFCMToken() {
    final AuthController authController = AuthController.to;
    authController.updateFCMToken();
  }
}

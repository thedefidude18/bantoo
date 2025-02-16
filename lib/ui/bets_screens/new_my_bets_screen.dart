import 'package:flexx_bet/chat/chat_controller.dart';
import 'package:flexx_bet/chat/widgets/my_groups.dart';

import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flexx_bet/ui/notifications_and_bethistory/widgets/bet_history_page.dart';
import 'package:flexx_bet/ui/profile/widget/EarningWidget.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../chat/widgets/MyEvents.dart';
import '../../constants/colors.dart';

import '../../controllers/landing_page_controller.dart';

class NewMyBetsScreen extends StatefulWidget {
  const NewMyBetsScreen({super.key});

  @override
  State<NewMyBetsScreen> createState() => _NewMyBetsScreenState();
}

class _NewMyBetsScreenState extends State<NewMyBetsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var controller = Get.find<ChatController>();
  final LandingPageController _landingPageController = LandingPageController.to;

  @override
  void initState() {
    super.initState();
    print("HelloHello::${controller.uid}");
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String formatCurrency(double amount) {
    if (amount >= 1e9) {
      return '₦${(amount / 1e9).toStringAsFixed(2)}B';
    } else if (amount >= 1e6) {
      return '₦${(amount / 1e6).toStringAsFixed(2)}M';
    } else if (amount >= 1e3) {
      return '₦${(amount / 1e3).toStringAsFixed(2)}K';
    } else {
      return '₦${amount.toStringAsFixed(2)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   toolbarHeight: 80,
      //   title: const Text(
      //     "My Events",
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 22,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   iconTheme: IconThemeData(color: ColorConstant.whiteA700),
      //   actions: [
      //     const NotificationIcon(
      //       defaultType: 'messages',
      //       iconPaths: {
      //         'messages': 'assets/images/messagenoti.png',
      //         'request': 'assets/images/requestnoti.png',
      //         'Generation': 'assets/images/notification_new.png',
      //       },
      //       fallbackIcon: Icons.notifications, // Fallback icon
      //     ),
      //     const SizedBox(width: 6),
      //     GestureDetector(
      //       onTap: () {
      //         Get.to(() => WalletScreen());
      //       },
      //       child: Container(
      //         height: 35,
      //         width: 97,
      //         margin: const EdgeInsets.only(top: 14, bottom: 14),
      //         padding: const EdgeInsets.only(left: 18, right: 18),
      //         decoration: BoxDecoration(
      //             color: ColorConstant.whiteA700,
      //             borderRadius: const BorderRadius.only(
      //                 topLeft: Radius.circular(50),
      //                 bottomLeft: Radius.circular(50))),
      //         child: Center(
      //           child: GetBuilder<WalletContoller>(builder: (controller) {
      //             return Text(
      //               formatCurrency(double.parse("${controller.totalAmount}")),
      //               style: TextStyle(
      //                   fontFamily: 'Inter',
      //                   fontWeight: FontWeight.w600,
      //                   color: ColorConstant.primaryColor),
      //             );
      //           }),
      //         ),
      //       ),
      //     )
      //   ],
      //   leading: BackButton(
      //     onPressed: () {
      //       Get.back();
      //     },
      //   ),
      // ),
      appBar: CustomAppBar(
        showBackButton: true,
        showSearchButton: true,
        showCreateEvent: false,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: ColorConstant.primaryColor,
              labelColor: ColorConstant.primaryColor,
              unselectedLabelColor: ColorConstant.black900C4,
              tabs: const [
                Tab(text: "Event History"),
                Tab(
                  text: 'Joined Events',
                ),
                Tab(text: 'My Events'),
                Tab(text: "My Earning"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BetHistoryPage(),
                MyGroups(),
                MyEvents(),
                MyEarnings(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

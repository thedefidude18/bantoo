import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/landing_page_controller.dart';
import 'package:flexx_bet/controllers/leaderboard_controller.dart';
import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flexx_bet/ui/components/loader.dart';
import 'package:flexx_bet/ui/leaderboard/widget/person_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  final ScrollController controller = ScrollController();
  final leaderboardController = LeaderboardController.to;
  final AuthController authController = Get.put(AuthController.to);

  final LandingPageController landingPageController = LandingPageController.to;

  @override
  void initState() {
    super.initState();
    leaderboardController.enterOrUpdateLeaderboard();
    // leaderboardController.fetchFirstLeaderboardList();
    // leaderboardController
    //     .loadLeaderboardUserModel(authController.userFirestore?.uid ?? '');

    controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      await showLoader(
        () async {
          await leaderboardController.loadFifteenNextLeaderboardUsers();
        },
      );
    }
  }

  // final List<CategoryWidget> categories = [
  //   const CategoryWidget(
  //       singleLine: true,
  //       name: "Sports",
  //       active: true,
  //       imagePath: ImageConstant.categorySportsImage),
  //   const CategoryWidget(
  //       singleLine: true,
  //       name: "Music",
  //       imagePath: ImageConstant.categoryMusicImage),
  //   const CategoryWidget(
  //       singleLine: true,
  //       name: "Crypto",
  //       imagePath: ImageConstant.categoryCryptoImage),
  //   const CategoryWidget(
  //       singleLine: true,
  //       name: "All",
  //       imagePath: ImageConstant.categoryCryptoImage),
  // ];

  @override
  Widget build(BuildContext context) {
    // landingPageController.onChange = () async {
    //   Get.log("LandingPageController onChnaged updated");
    //   if (landingPageController.tabIndex.value == 3) {
    //     await showLoader(
    //       () async {
    //         await leaderboardController.fetchFirstLeaderboardList();
    //       },
    //     );
    //     if (mounted) {
    //       setState(() {});
    //     }
    //   }
    // };

    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: true,
        showCreateEvent: false,
      ),
      body: GetBuilder<LeaderboardController>(builder: (controller) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Leaderboard",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.2),
                            borderRadius: BorderRadius.circular(6)),
                        child: const Text(
                          "Your rank",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        " #${controller.currentUserRank}",
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.leaderboardIcon,
                    height: 30,
                  )
                ],
              ),
            ),
            // SizedBox(
            //   height: Get.height / 16,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: categories,
            //   ),
            // ),
            SizedBox(
              height: Get.height / 1.65,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.fifteenNextLeaderBoardModels.length,
                itemBuilder: (context, index) {
                  return PersonCard(
                    image: AuthController.to.usersPresent
                        .elementAt(index)!
                        .photoUrl,
                    userId:
                        controller.fifteenNextLeaderBoardModels[index].userId,
                    rank: index + 1,
                    name: controller
                        .fifteenNextLeaderBoardModels[index].nameOfUser,
                    bets: controller
                        .fifteenNextLeaderBoardModels[index].betsToday,
                  );
                },
              ),
            )
          ],
        );
      }),
    );
  }
}

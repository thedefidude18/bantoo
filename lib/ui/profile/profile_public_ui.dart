import 'package:badges/badges.dart' as badges;
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/image_picker_contoller.dart';
import 'package:flexx_bet/controllers/landing_page_controller.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flexx_bet/ui/components/participated_event_card.dart';
import 'package:flexx_bet/ui/profile/edit_profile_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PublicProfileScreen extends StatelessWidget {
  PublicProfileScreen({super.key});

  final ImageController imageController = Get.put(ImageController());

  final bool isUserVerified = true;
  final int followers = 3000;
  final int following = 2000;
  final int rank = 452;
  final int bets = 200;
  final String userName = "@guyh20";
  final String userImage = ImageConstant.user3;
  final String userAbout = "Lets bet on anything! Im taking your money";

  final LandingPageController landingPageController =
      Get.put(LandingPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.whiteA700,
        leading: BackButton(
          color: ColorConstant.black900,
          onPressed: () {
            landingPageController.tabIndex.value = 0;
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(ImageConstant.user4),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    badges.Badge(
                      position: badges.BadgePosition.topEnd(top: 10, end: -25),
                      showBadge: isUserVerified,
                      badgeStyle: badges.BadgeStyle(
                          badgeColor: ColorConstant.primaryColor),
                      badgeContent: Icon(
                        Icons.check,
                        size: 10,
                        color: ColorConstant.whiteA700,
                      ),
                      child: Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        CustomButton(
                          onTap: () {
                            Get.log("To EditProfileScreen");
                            Get.to(() => const EditProfileScreen());
                          },
                          padding: ButtonPadding.PaddingAll4,
                          width: 100,
                          text: "Edit Profile ",
                          height: 30,
                          suffixWidget: CustomImageView(
                            imagePath: ImageConstant.userProfileIcon,
                            height: 15,
                          ),
                          fontStyle: ButtonFontStyle.PoppinsMedium12WhiteA700,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomButton(
                          padding: ButtonPadding.PaddingT4,
                          width: 110,
                          text: "Following $following",
                          height: 30,
                          fontStyle: ButtonFontStyle.PoppinsMedium12WhiteA700,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              userAbout,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: ColorConstant.black900,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorConstant.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.followersImage,
                            height: 45,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Followers",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "$followers",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstant.gray500),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.rankImage,
                            fit: BoxFit.fill,
                            height: 60,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Rank",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "#$rank",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstant.gray500),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.betsImage,
                            height: 45,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Events",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "$bets",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstant.gray500),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                        labelColor: Colors.black,
                        indicatorColor: ColorConstant.primaryColor,
                        tabs: const [
                          Tab(
                            text: "Recent bets",
                          ),
                          Tab(text: "Badges")
                        ]),
                    SizedBox(
                        height: Get.height / 2.2,
                        child: TabBarView(children: [
                          ListView(
                            children: [
                              ParticipatedEventCard(
                                profit: -20,
                                title: "Chelsea will beat Arsenal",
                                imagePath: ImageConstant.liveEvent1,
                                subTitle: "UEFA League",
                                eventHeldDate: DateTime.now().subtract(
                                  const Duration(days: 20),
                                ),
                              ),
                              ParticipatedEventCard(
                                profit: 200,
                                title: "Chelsea will beat Arsenal",
                                imagePath: ImageConstant.liveEvent1,
                                subTitle: "UEFA League",
                                eventHeldDate: DateTime.now().subtract(
                                  const Duration(days: 20),
                                ),
                              ),
                              ParticipatedEventCard(
                                profit: 200,
                                title: "Chelsea will beat Arsenal",
                                imagePath: ImageConstant.liveEvent1,
                                subTitle: "UEFA League",
                                eventHeldDate: DateTime.now().subtract(
                                  const Duration(days: 20),
                                ),
                              ),
                              ParticipatedEventCard(
                                profit: 200,
                                title: "Chelsea will beat Arsenal",
                                imagePath: ImageConstant.liveEvent1,
                                subTitle: "UEFA League",
                                eventHeldDate: DateTime.now().subtract(
                                  const Duration(days: 20),
                                ),
                              ),
                              ParticipatedEventCard(
                                profit: 200,
                                title: "Chelsea will beat Arsenal",
                                imagePath: ImageConstant.liveEvent1,
                                subTitle: "UEFA League",
                                eventHeldDate: DateTime.now().subtract(
                                  const Duration(days: 20),
                                ),
                              ),
                              ParticipatedEventCard(
                                profit: -200,
                                title: "Chelsea will beat Arsenal",
                                imagePath: ImageConstant.liveEvent1,
                                subTitle: "UEFA League",
                                eventHeldDate: DateTime.now().subtract(
                                  const Duration(days: 20),
                                ),
                              ),
                            ],
                          ),
                          Container()
                        ]))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

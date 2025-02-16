import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum BadgeType { amateur, chief, master }

void badgePopup(BadgeType badge) {
  late String image;
  late Color shapeColor;
  late num points;
  late num swipes;
  late num swipesCompleted;
  switch (badge) {
    case BadgeType.amateur:
      {
        image = ImageConstant.ameteurBadge;
        shapeColor = Colors.blue;
        points = 50;
        swipes = 1;
        swipesCompleted = 5;
      }
    case BadgeType.chief:
      {
        image = ImageConstant.chiefBadge;
        shapeColor = Colors.brown[600]!;
        points = 150;
        swipes = 3;
        swipesCompleted = 25;
      }
    case BadgeType.master:
      {
        image = ImageConstant.masterBadge;
        shapeColor = ColorConstant.primaryColor;
        points = 300;
        swipes = 5;
        swipesCompleted = 50;
      }
  }

  Get.dialog(
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 600,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                    image: AssetImage(ImageConstant.badgeCardBackground),
                    fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 45,
                  ),
                  Text(
                    "Congratulations!",
                    style: TextStyle(
                        color: ColorConstant.primaryColor, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "You have earned a badge for completing",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: ColorConstant.primaryColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "$swipesCompleted Swipes",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  CustomImageView(
                    imagePath: image,
                    width: 200,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.badgeSwipeShape,
                              width: 80,
                              color: shapeColor,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "+$swipes",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                const Text(
                                  "Swipes",
                                  style: TextStyle(
                                      color: Colors.white,
                                      height: 1,
                                      fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.badgeTrophy,
                        width: 40,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "+$points points",
                      style: const TextStyle(color: Colors.brown, fontSize: 12),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    padding: ButtonPadding.PaddingAll8,
                    text: "Claim Reward",
                    onTap: () {
                      Get.back();
                    },
                    width: Get.width / 1.5,
                    fontStyle: ButtonFontStyle.InterSemiBold16,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Share"),
                      IconButton(
                        onPressed: () {},
                        iconSize: 30,
                        icon: Image.asset(
                          ImageConstant.facebook,
                        ),
                        color: Colors.blue,
                      ),
                      IconButton(
                        onPressed: () {},
                        iconSize: 33,
                        icon: Image.asset(
                          ImageConstant.apple,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        iconSize: 30,
                        icon: Image.asset(
                          ImageConstant.twitter,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        iconSize: 30,
                        icon: const Icon(Icons.share),
                        color: ColorConstant.primaryColor,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

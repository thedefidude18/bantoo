import 'package:carousel_slider/carousel_slider.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/helpers/size.dart';
import 'package:flexx_bet/ui/auth/signup_singin_choice_ui.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/onboarding_button.dart';

// ignore: must_be_immutable
class OnboardingScreen extends StatelessWidget {
  final CarouselSliderController carouselController =
      CarouselSliderController(); // Updated to CarouselSliderController
  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        body: CarouselSlider(
          carouselController: carouselController,
          items: [
            SizedBox(
              width: getHorizontalSize(420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.upperOnboardingImage,
                    height: getVerticalSize(450),
                    fit: BoxFit.fill,
                    width: Get.width,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                            "Play and bet with\nyour friends\nagainst anything! ",
                            style: TextStyle(fontSize: 24)),
                        OnboardingButton(
                          onTap: () {
                            carouselController.animateToPage(1);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: getHorizontalSize(420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 100, 24, 0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Meet new pals,\nchat and socialize.",
                              style: TextStyle(fontSize: 24)),
                          OnboardingButton(
                            onTap: () {
                              Get.off(() => const SignupSignInChoiceScreen());
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  ClipRect(
                    child: CustomImageView(
                      imagePath: ImageConstant.bottomOnboardingImage,
                      height: getVerticalSize(420),
                      fit: BoxFit.fill,
                      width: Get.width,
                    ),
                  ),
                ],
              ),
            ),
          ],
          options: CarouselOptions(
              autoPlay: false,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
              height: getVerticalSize(1000)),
        ));
  }
}

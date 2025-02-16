import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/bet_controller.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/notification_controller.dart';

void betConfirmationSuccess(bool betStarted) {
  BetsController betsController = BetsController.to;
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
              height: 600,
              width: Get.width / 1.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                      image: AssetImage(ImageConstant.successCard),
                      fit: BoxFit.cover),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Congratulations,",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: "Syne",
                          color: ColorConstant.primaryColor,
                          fontSize: 15),
                    ),
                    Text(
                      betStarted ? "it’s a match!" : "you joined event",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: "Syne",
                          color: ColorConstant.primaryColor,
                          fontSize: 40),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      betStarted
                          ? "Challenge @${betsController.currentBet.value!.firstUsername} for the bet accepted."
                          : "Wait for another user to join",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          wordSpacing: 1,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Syne",
                          color: ColorConstant.gray80003,
                          fontSize: 11),
                    ),
                    Text(
                      betStarted
                          ? "You can sit back and wait for the results"
                          : "So system can match and start bet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          wordSpacing: 1,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Syne",
                          color: ColorConstant.gray80003,
                          fontSize: 11),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      width: Get.width / 1.3,
                      text: "Close",
                      padding: ButtonPadding.PaddingAll4,
                      fontStyle: ButtonFontStyle.PoppinsSemiBold16,
                      onTap: () {
                        Get.log("bet confirmation success");
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/landing_page_controller.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class SuccessDialog {
  const SuccessDialog();
  static show(String page) {
    Get.dialog(Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: Get.height / 6,
        ),
        Container(
          height: 120,
          width: Get.width / 1.1,
          decoration: BoxDecoration(
              color: ColorConstant.green500,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                  alignment: Alignment.centerLeft,
                  image: AssetImage(ImageConstant.successImage))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: Get.width / 4),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$page changed\nsuccesfully!",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: ColorConstant.whiteA700),
                      ),
                      Text(
                        "Continue using Flexx Bet app",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            decoration: TextDecoration.none,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: ColorConstant.whiteA700),
                      ),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.log("Success Dialog exact file");
                        Get.back();
                      },
                      child: Transform.rotate(
                          angle: 45 * math.pi / 180,
                          child: Icon(
                            Icons.add,
                            color: ColorConstant.whiteA700,
                          )),
                    )),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 0,
        ),
        CustomButton(
          height: 50,
          width: Get.width / 1.1,
          padding: ButtonPadding.PaddingAll4,
          text: "Home",
          fontStyle: ButtonFontStyle.PoppinsMedium16,
          onTap: () {
            LandingPageController.to.changeTabIndex(0);
          },
        ),
        const SizedBox(
          height: 0,
        ),
      ],
    ));
  }
}

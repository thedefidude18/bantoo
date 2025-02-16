import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.gray100,
      body: Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: CustomImageView(
              imagePath: ImageConstant.noInternetBanner,
            ),
          ),
          Text(
            "503",
            style: TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.bold,
                color: ColorConstant.primaryColor),
          ),
          const Text(
            "No Internet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "No internet connection found. Please refresh app to try again.",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: Get.height / 10,
          ),
          CustomButton(
            width: Get.width / 2,
            fontStyle: ButtonFontStyle.PoppinsSemiBold14WhiteA700,
            text: "Home",
          )
        ]),
      ),
    );
  }
}

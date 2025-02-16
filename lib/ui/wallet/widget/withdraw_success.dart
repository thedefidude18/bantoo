import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/landing_page_controller.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/components/custom_image_view.dart';

void withdrawSuccess(num amount) {
  Get.bottomSheet(
    Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      width: Get.width,
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.transferAndTopupSuccess,
                  width: Get.width / 1.8,
                ),
                const Text(
                  "Withdraw Success",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  "You have successfully withdraw ₦$amount from your wallet.",
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: Colors.grey, fontFamily: 'Inter'),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: "Back to Home",
                  fontStyle: ButtonFontStyle.PoppinsMedium16,
                  padding: ButtonPadding.PaddingAll8,
                  onTap: () {
                    LandingPageController.to.changeTabIndex(0);
                  },
                )
              ],
            ),
          )),
    ),
  );
}

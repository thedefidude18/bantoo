import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/landing_page_controller.dart';
import 'package:flexx_bet/helpers/size.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSuccessScreen extends StatelessWidget {
  const AccountSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 10), () {
      LandingPageController.to.changeTabIndex(0);
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstant.whiteA700,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              SizedBox(
                height: Get.height / 2,
              ),
              Container(
                height: Get.height / 2.5,
                width: Get.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      ImageConstant.successBanner,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: Get.width / 4,
                child: Container(
                    height: 190,
                    width: 190,
                    decoration: BoxDecoration(
                      color: ColorConstant.whiteA700,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: CustomImageView(
                        svgPath: ImageConstant.doneIcon,
                      ),
                    )),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                getHorizontalSize(15), 0, getHorizontalSize(15), 0),
            child: const Column(
              children: [
                Text(
                  "Congratulations!",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Your account is ready to use. You will be redirected to the home page in a few seconds.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 65,
                ),
              ],
            ),
          ),
          SizedBox(height: Get.height / 10),
          Container(
            margin: EdgeInsets.fromLTRB(
                getHorizontalSize(15), 0, getHorizontalSize(15), 30),
            child: CustomButton(
              variant: ButtonVariant.FillDeeppurpleA200,
              fontStyle: ButtonFontStyle.PoppinsMedium16,
              height: getVerticalSize(60),
              onTap: () {
                LandingPageController.to.changeTabIndex(0);
              },
              text: "Back to Home".toUpperCase(),
            ),
          ),
        ],
      ),
    );
  }
}

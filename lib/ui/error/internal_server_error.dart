import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternalServerErrorScreen extends StatelessWidget {
  const InternalServerErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.gray100,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: CustomImageView(
            imagePath: ImageConstant.internalServerErrorBanner,
          ),
        ),
        Text(
          "500",
          style: TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.bold,
              color: ColorConstant.primaryColor),
        ),
        const Text(
          "Internal Server Error",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text("Sorry! There was a problem with your request."),
        SizedBox(
          height: Get.height / 10,
        ),
        CustomButton(
          width: Get.width / 2,
          fontStyle: ButtonFontStyle.PoppinsSemiBold14WhiteA700,
          text: "Home",
        )
      ]),
    );
  }
}

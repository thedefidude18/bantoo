import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/helpers/size.dart';
import 'package:flexx_bet/ui/auth/residency_proof_ui.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IdentityVerficationScreen extends StatelessWidget {
  const IdentityVerficationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: const BackButton(color: Colors.black),
            backgroundColor: ColorConstant.whiteA700,
          ),
          backgroundColor: ColorConstant.whiteA700,
          body: SingleChildScrollView(
            child: SizedBox(
              //height: Get.height,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    getHorizontalSize(15), 10, getHorizontalSize(15), 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "\nLet's verify your\nidentity",
                              style: TextStyle(
                                  fontSize: HEADING_SIZE,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                            "We are required to verify your identity before you\ncan use the application. Your information will be\nencrpyted and stored securely."),
                        const SizedBox(
                          height: 65,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.identityVerfication,
                              height: getVerticalSize(180),
                            ),
                          ],
                        ),
                      ],
                    ),
                    CustomButton(
                      variant: ButtonVariant.FillDeeppurpleA200,
                      fontStyle: ButtonFontStyle.PoppinsMedium16,
                      height: getVerticalSize(60),
                      onTap: () {
                        Get.log("TO ResidencyProofScreen");
                        Get.to(() => ResidencyProofScreen());
                      },
                      text: "Verify Identity".toUpperCase(),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

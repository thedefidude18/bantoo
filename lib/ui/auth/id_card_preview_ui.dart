import 'package:camera/camera.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/landing_page_controller.dart';
import 'package:flexx_bet/helpers/size.dart';
import 'package:flexx_bet/ui/auth/choose_profile_picture_ui.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:get/get.dart';

class PreviewIDCardScreen extends StatelessWidget {
  PreviewIDCardScreen({Key? key, required this.picture}) : super(key: key);
  final AuthController authController = AuthController.to;

  final XFile picture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        leading: BackButton(color: ColorConstant.black900),
      ),
      body: Center(
        child: SizedBox(
          width: Get.width / 1.1,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Photo Id card",
                        style: TextStyle(fontSize: HEADING_SIZE),
                      ),
                      Text(
                        "Please point the camera at the ID card",
                        style: TextStyle(),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: Get.height / 3,
                  width: Get.width / 1.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(
                        File(picture.path),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      variant: ButtonVariant.FillGray90051,
                      fontStyle: ButtonFontStyle.Disabled,
                      text: "Try Again",
                      height: 40,
                      padding: ButtonPadding.PaddingAll8,
                      width: Get.width / 2.3,
                      onTap: () {
                        Get.log("Try Again");
                        Get.back();
                      },
                    ),
                    CustomButton(
                      padding: ButtonPadding.PaddingAll8,
                      height: 40,
                      fontStyle: ButtonFontStyle.PoppinsMedium16,
                      width: Get.width / 2.3,
                      text: "Continue",
                      onTap: () async {
                        await authController
                            .setUserVerificationApplied(File(picture.path));
                        if (authController.userFirestore!.photoUrl ==
                            AuthController.defaultPicture) {
                          Get.offAll(() => ChooseProfilePictureScreen());
                        } else {
                          LandingPageController.to.changeTabIndex(0);
                        }
                      },
                    )
                  ],
                )
              ]),
        ),
      ),
    );
  }
}

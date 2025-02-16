import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/selection_controller.dart';
import 'package:flexx_bet/helpers/size.dart';
import 'package:flexx_bet/models/verification_request_model.dart';
import 'package:flexx_bet/ui/auth/choose_profile_picture_ui.dart';
import 'package:flexx_bet/ui/auth/id_card_ui.dart';
import 'package:flexx_bet/ui/auth/widgets/verification_radio_button.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

enum VerficationMethod {
  nationalIdentity,
  passport,
  driverLicense,
}

class ResidencyProofScreen extends StatelessWidget {
  ResidencyProofScreen({super.key});
  final AuthController authController = AuthController.to;
  final TextEditingController emailController = TextEditingController();
  final SelectionController verificationMethodController = Get.put(
      SelectionController<VerficationMethod>(
          VerficationMethod.nationalIdentity));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: ColorConstant.whiteA700,
        ),
        backgroundColor: ColorConstant.whiteA700,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                getHorizontalSize(15), 10, getHorizontalSize(15), 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Proof of Residency",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: HEADING_SIZE,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "Nationality",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(28, 28, 20, 28),
                      decoration: BoxDecoration(
                          color: ColorConstant.blueGray100,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.usFlag,
                                  height: getVerticalSize(30),
                                ),
                                SizedBox(
                                  width: getHorizontalSize(20),
                                ),
                                const Text(
                                  "United States",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Text(
                              "Change",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: ColorConstant.primaryColor),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                  ],
                ),
                const Text(
                  "Verification Method",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 20,
                ),
                const VerificationRadioButton(
                  name: "National Identity Card",
                  value: VerficationMethod.nationalIdentity,
                ),
                const SizedBox(
                  height: 10,
                ),
                const VerificationRadioButton(
                  name: "Passport",
                  value: VerficationMethod.passport,
                ),
                const SizedBox(
                  height: 10,
                ),
                const VerificationRadioButton(
                  name: "Driver License",
                  value: VerficationMethod.driverLicense,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      variant: ButtonVariant.FillGray90051,
                      fontStyle: ButtonFontStyle.Disabled,
                      height: getVerticalSize(50),
                      width: Get.width / 2.5,
                      onTap: () {
                        Get.offAll(() => ChooseProfilePictureScreen());
                      },
                      text: "Skip".toUpperCase(),
                    ),
                    CustomButton(
                      variant: ButtonVariant.FillDeeppurpleA200,
                      fontStyle: ButtonFontStyle.PoppinsMedium16,
                      height: getVerticalSize(50),
                      width: Get.width / 2.5,
                      onTap: () async {
                        String verificationType = "none";
                        if (verificationMethodController.selection ==
                            VerficationMethod.nationalIdentity) {
                          verificationType = "nationalIdentity";
                        }
                        if (verificationMethodController.selection ==
                            VerficationMethod.driverLicense) {
                          verificationType = "driverLicense";
                        }
                        if (verificationMethodController.selection ==
                            VerficationMethod.passport) {
                          verificationType = "passport";
                        }
                        authController.verificationRequest =
                            VerificationRequestModel.initialize(
                                uid: authController.userFirestore!.uid,
                                verificationType: verificationType);

                        await availableCameras()
                            .then((value) => Get.off(() => PhotoIDCardScreen(
                                  cameras: value,
                                )));
                      },
                      text: "Continue".toUpperCase(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}

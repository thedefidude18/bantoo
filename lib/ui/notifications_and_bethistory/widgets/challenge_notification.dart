import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChallengeNotification extends StatelessWidget {
  final VoidCallback? onTap; // Add this line

  const ChallengeNotification({super.key, this.onTap}); // Update constructor

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Wrap the content in GestureDetector
      onTap: onTap, // Trigger the callback on tap
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: Get.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: 10,
                color: ColorConstant.primaryColor,
              ),
              Container(
                height: 120,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: ColorConstant.whiteA700,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.user1,
                      height: 50,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "You have a new challenge ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₦1850",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Inter',
                                  color: ColorConstant.green500,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: Get.width / 1.6,
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '@Jhonedo23 is challenging you on the event, '),
                                TextSpan(
                                    text: 'Chelsea will beat Arsenal',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            CustomButton(
                              width: Get.width / 5,
                              height: 6,
                              variant: ButtonVariant.FillGreen700,
                              fontStyle:
                                  ButtonFontStyle.PoppinsSemiBold14WhiteA700,
                              padding: ButtonPadding.PaddingAll4,
                              text: "Accept",
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            CustomButton(
                              text: "Decline",
                              variant: ButtonVariant.FillRed50001,
                              fontStyle:
                                  ButtonFontStyle.PoppinsSemiBold14WhiteA700,
                              padding: ButtonPadding.PaddingAll4,
                              width: Get.width / 5,
                              height: 6,
                            )
                          ],
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: CustomImageView(
                        imagePath: ImageConstant.categorySportsImage,
                        height: 25,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

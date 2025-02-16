import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BetResultNotification extends StatelessWidget {
  const BetResultNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: Get.width,
        child: Row(
          children: [
            Container(
              height: 80,
              width: 10,
              color: ColorConstant.primaryColor,
            ),
            Container(
              height: 80,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: ColorConstant.whiteA700,
              ),
              child: Row(
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
                            "Congrats!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.congratsImage,
                            height: 30,
                          ),
                          const Text(
                            "You just won ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "₦850",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Inter',
                                color: ColorConstant.green500,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'from the event, '),
                            TextSpan(
                                text: 'Chelsea will beat Arsenal',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic)),
                          ],
                        ),
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
    );
  }
}

import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/landing_page_controller.dart';
import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventResultWonScreen extends StatelessWidget {
  const EventResultWonScreen({
    super.key,
    required this.title,
    required this.categoryImage,
    required this.categoryName,
    required this.subtitle,
  });

  final String title;
  final String categoryImage;
  final String categoryName;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(children: [
        Container(
          height: Get.height / 1.5,
          margin: const EdgeInsets.all(14),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorConstant.whiteA700,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(3, 1),
                  spreadRadius: -7,
                  blurRadius: 15,
                  color: Color.fromRGBO(0, 0, 0, 1),
                )
              ]),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$categoryName | $subtitle",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        CustomImageView(
                          imagePath: categoryImage,
                          height: 40,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: Get.height / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.betWon,
                            height: Get.height / 6,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("You won the bet against "),
                                  Text(
                                    "@janedoe22",
                                    style: TextStyle(
                                        color: ColorConstant.purpleA400),
                                  )
                                ],
                              ),
                              const Text("Challenge more friends to win more."),
                            ],
                          ),
                          Text(
                            "-₦ 1,000",
                            style: TextStyle(
                              color: ColorConstant.green500,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Container(
                            height: 35,
                            width: 85,
                            decoration: BoxDecoration(
                                color: ColorConstant.green500,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                                child: Row(
                              children: [
                                const Icon(
                                  Icons.arrow_drop_up,
                                  color: Colors.white,
                                ),
                                Text(
                                  "+13.25%",
                                  style:
                                      TextStyle(color: ColorConstant.whiteA700),
                                ),
                              ],
                            )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: Get.width,
                      height: 1,
                      color: ColorConstant.gray500,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Participated:'),
                        SizedBox(
                          width: 40,
                          child: Stack(
                            children: [
                              Align(
                                alignment: const Alignment(0, 0),
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorConstant.whiteA700),
                                    borderRadius: BorderRadius.circular(20),
                                    image: const DecorationImage(
                                      image: AssetImage(ImageConstant.user1),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: const Alignment(1.4, 0),
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorConstant.whiteA700),
                                    borderRadius: BorderRadius.circular(20),
                                    image: const DecorationImage(
                                      image: AssetImage(ImageConstant.user2),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: const Alignment(2.8, 0),
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorConstant.whiteA700),
                                    borderRadius: BorderRadius.circular(20),
                                    image: const DecorationImage(
                                      image: AssetImage(ImageConstant.user3),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
              width: Get.width / 2.5,
              text: "Try more games",
              fontStyle: ButtonFontStyle.PoppinsMedium16,
              padding: ButtonPadding.PaddingAll4,
              onTap: () {
                LandingPageController.to.changeTabIndex(0);
              },
            ),
            CustomButton(
              width: Get.width / 2.5,
              text: "Cashout  ",
              fontStyle: ButtonFontStyle.PoppinsMedium16,
              padding: ButtonPadding.PaddingAll4,
              suffixWidget: CustomImageView(
                imagePath: ImageConstant.cashout,
                height: 25,
              ),
              onTap: () {
                //wallet
              },
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text("Event has ended")
      ]),
    );
  }
}

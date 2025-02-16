import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpBonusCard extends StatelessWidget {
  const SignUpBonusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 450,
            width: 280,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 19, top: 19),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hey, welcome.",
                        style: TextStyle(
                            fontFamily: "Syne",
                            color: Colors.black,
                            fontSize: 10),
                      ),
                      Row(
                        children: [
                          const Text(
                            "You have received ",
                            style: TextStyle(
                                fontFamily: "Syne",
                                letterSpacing: -1,
                                color: Colors.black,
                                fontSize: 18),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: ColorConstant.fromHex("#D2F700"),
                            ),
                            child: const Text(
                              "₦ 1,000",
                              style: TextStyle(
                                  fontFamily: "Inter", color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      const Text(
                        "welcome bonus for signing up.",
                        style: TextStyle(
                            fontFamily: "Syne",
                            letterSpacing: -1,
                            color: Colors.black,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.fromHex("#D2F700"),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18)),
                    ),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Image.asset(ImageConstant.signUpBonus)),
                  ))
            ]),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomButton(
          width: 280,
          text: "Claim",
          padding: ButtonPadding.PaddingAll8,
          fontStyle: ButtonFontStyle.SyneRegular18,
          onTap: () {
            Get.back();
          },
        )
      ],
    );
  }
}

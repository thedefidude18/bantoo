import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void ongoingBet() {
  Get.dialog(
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: Get.height / 1.6,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: Get.height / 2.5,
              width: Get.width / 1.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "The event is ongoing, please check back for results.",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          "Event will end in:",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          child: TweenAnimationBuilder<Duration>(
                              duration: const Duration(minutes: 1),
                              tween: Tween(
                                  begin: const Duration(minutes: 1),
                                  end: Duration.zero),
                              onEnd: () {},
                              builder: (BuildContext context, Duration value,
                                  Widget? child) {
                                final minutes = value.inMinutes;
                                final seconds = value.inSeconds % 60;
                                return Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        height: 180,
                                        width: 180,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 12,
                                          color: ColorConstant.primaryColor,
                                          value: (((minutes * 60) + seconds) /
                                              (1 * 60)),
                                          backgroundColor:
                                              ColorConstant.blue100,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: Get.height / 12),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text('$minutes:$seconds',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30)),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        CustomButton(
                          width: Get.width / 2,
                          text: "Close",
                          padding: ButtonPadding.PaddingAll4,
                          fontStyle: ButtonFontStyle.PoppinsSemiBold16,
                          onTap: () {
                            Get.log("ongoing bet");
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

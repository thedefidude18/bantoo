import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/helpers/size.dart';
import 'package:flexx_bet/ui/auth/success_screen_ui.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountCheckingScreen extends StatefulWidget {
  const AccountCheckingScreen({super.key});

  @override
  State<AccountCheckingScreen> createState() => _AccountCheckingScreenState();
}

class _AccountCheckingScreenState extends State<AccountCheckingScreen> {
  int secondsToWait = 10;
  bool isTimerEnded = false;
  @override
  Widget build(BuildContext context) {
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
                      ImageConstant.accCheckBanner,
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
                    padding: const EdgeInsets.all(40.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: TweenAnimationBuilder<Duration>(
                          duration: Duration(seconds: secondsToWait),
                          tween: Tween(
                              begin: Duration(seconds: secondsToWait),
                              end: Duration.zero),
                          onEnd: () {
                            setState(() {
                              isTimerEnded = true;
                            });
                          },
                          builder: (BuildContext context, Duration value,
                              Widget? child) {
                            final minutes = value.inMinutes;
                            final seconds = value.inSeconds % 60;
                            return Stack(
                              children: [
                                SizedBox(
                                  height: 180,
                                  width: 180,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 12,
                                    color: ColorConstant.primaryColor,
                                    value: 1 -
                                        (((minutes * 60) + seconds) /
                                            (secondsToWait * 60)),
                                    backgroundColor: ColorConstant.blue100,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text('$minutes:$seconds',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30)),
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                getHorizontalSize(15), 0, getHorizontalSize(15), 0),
            child: const Column(
              children: [
                Text(
                  "Checking! Please wait...",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Your account is being checked before ready to use.",
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
              variant: isTimerEnded
                  ? ButtonVariant.FillDeeppurpleA200
                  : ButtonVariant.Disabled,
              fontStyle: isTimerEnded
                  ? ButtonFontStyle.PoppinsMedium16
                  : ButtonFontStyle.Disabled,
              height: getVerticalSize(60),
              onTap: () {
                isTimerEnded
                    ? Get.off(() => const AccountSuccessScreen())
                    : Get.snackbar(
                        "Checking account", "Please wait until timer is ended");
              },
              text: "Continue".toUpperCase(),
            ),
          ),
        ],
      ),
    );
  }
}

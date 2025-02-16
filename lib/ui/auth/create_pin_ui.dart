import 'dart:async';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/landing_page_controller.dart';
import 'package:flexx_bet/helpers/size.dart';
import 'package:flexx_bet/ui/auth/widgets/sign_up_bonus.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final AuthController _authController = AuthController.to;
  late StreamController<ErrorAnimationType>? errorController;

  String currentText = "";

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController?.close();
    super.dispose();
  }

  bool isComplete = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.whiteA700,
        ),
        backgroundColor: ColorConstant.whiteA700,
        body: SizedBox(
          height: Get.height,
          child: Padding(
            padding: EdgeInsets.fromLTRB(getHorizontalSize(15), 10, getHorizontalSize(15), 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Create new PIN",
                      style: TextStyle(
                          fontSize: HEADING_SIZE, fontWeight: FontWeight.w600),
                    ),
                    const Text(
                        "Add a PIN number to make your account more secure and easy to sign in."),
                    const SizedBox(
                      height: 80,
                    ),
                    PinCodeTextField(
                      appContext: context,
                      length: 4,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        activeFillColor: ColorConstant.blueGray100,
                        activeColor: ColorConstant.gray200,
                        selectedFillColor: ColorConstant.blueGray100,
                        selectedColor: ColorConstant.blue400,
                        inactiveFillColor: ColorConstant.blueGray100,
                        inactiveColor: ColorConstant.gray200,
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: Get.height / 12,
                        fieldWidth: Get.width / 5,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: const TextInputType.numberWithOptions(),
                      errorAnimationController: errorController,
                      controller: _authController.pinTextController,
                      onChanged: (value) {
                        setState(() {
                          isComplete = !(value.length < 4);
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                    ),
                  ],
                ),
                CustomButton(
                  variant: isComplete
                      ? ButtonVariant.FillDeeppurpleA200
                      : ButtonVariant.Disabled,
                  fontStyle: isComplete
                      ? ButtonFontStyle.PoppinsMedium16
                      : ButtonFontStyle.Disabled,
                  height: getVerticalSize(60),
                  onTap: () async {
                    if (isComplete && context.mounted) {
                      await _authController.updateUserPin();
                      LandingPageController.to.changeTabIndex(0);
                      if (_authController.firstTimeUser == true) {
                        Get.dialog(const SignUpBonusCard());
                      }
                    }
                  },
                  text: "Submit".toUpperCase(),
                ),
              ],
            ),
          ),
        ));
  }
}

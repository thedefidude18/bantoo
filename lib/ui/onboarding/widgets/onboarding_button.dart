import 'package:flexx_bet/constants/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OnboardingButton extends StatelessWidget {
  void Function()? onTap;
  OnboardingButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: ColorConstant.primaryColor, width: 2),
        ),
        child: SizedBox(
          height: 80,
          width: 80,
          child: Container(
            decoration: BoxDecoration(
                color: ColorConstant.onboardingButtonColor,
                borderRadius: const BorderRadius.all(Radius.circular(100))),
            child: Icon(
              Icons.arrow_forward,
              color: ColorConstant.black900,
            ),
          ),
        ),
      ),
    );
  }
}

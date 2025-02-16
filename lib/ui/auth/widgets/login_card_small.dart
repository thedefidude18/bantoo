import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/helpers/size.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';

class LoginCardSmall extends StatelessWidget {
  final String imagePath;
  const LoginCardSmall({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: ColorConstant.gray200, width: 2)),
      child: CustomImageView(
        imagePath: imagePath,
        height: getVerticalSize(40),
      ),
    );
  }
}

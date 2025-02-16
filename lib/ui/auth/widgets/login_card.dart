import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/helpers/size.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewLoginCard extends StatelessWidget {
  final String text;
  final Color color;
  final String imagePath;
  final TextStyle? textStyle;

  const NewLoginCard({
    super.key,
    required this.text,
    required this.color,
    required this.imagePath,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      width: 301,
      // padding: const EdgeInsets.fromLTRB(30, 15, 10, 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            47,
          ),
        ),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 20,
              child: imagePath.contains('svg')
                  ? SvgPicture.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(
              width: getHorizontalSize(13),
            ),
            Text(
              text,
              style: textStyle ??
                  TextStyle(
                    color: ColorConstant.whiteA700,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    letterSpacing:-0.32 
                  ),
            )
          ]),
    );
  }
}

class LoginCard extends StatelessWidget {
  final String text;
  final Color color;
  final String imagePath;
  final TextStyle textStyle;

  const LoginCard(
      {super.key,
      required this.text,
      required this.color,
      required this.imagePath,
      required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 325,
      padding: const EdgeInsets.fromLTRB(30, 15, 10, 15),
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(40))),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImageView(
              imagePath: imagePath,
              height: getVerticalSize(50),
            ),
            SizedBox(
              width: getHorizontalSize(10),
            ),
            Text(
              text,
              style: textStyle,
            )
          ]),
    );
  }
}

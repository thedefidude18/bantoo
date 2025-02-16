import 'package:flexx_bet/chat/widgets/btn_primary.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> showAlertDialog({Function()? onPressed,
  String? titleText,
  EdgeInsetsGeometry? titlePadding,
  String? infoText,
  String? buttonText,
  bool isCancelable = true,
  Widget? icon,
  Widget? extraDetails,
  TextStyle? titleStyle,
  TextStyle? infoTextStyle,
  EdgeInsetsGeometry? contentPadding,
  TextStyle? buttonTextStyle,
  Color? buttonBackgroundColor,
}) async {
  var result = await Get.dialog(
    barrierColor: ColorConstant.blueGray10096.withOpacity(0.6),
    barrierDismissible: isCancelable,
    PopScope(
      canPop: isCancelable,
      child: SimpleDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        contentPadding: contentPadding ?? const EdgeInsets.all(15),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
            side: const BorderSide(width: 2, color: Colors.white)),
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 2000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) icon,
                if (titleText != null)Padding(
                  padding: titlePadding ?? const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    titleText,
                    textAlign: TextAlign.center,
                    style: titleStyle ?? const TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
                  ),
                ),
                if (infoText != null)Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 5.0),
                  child: Text(
                    infoText,
                    style: infoTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (extraDetails != null) extraDetails,
                if (onPressed != null) Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: PrimaryButton(
                    minHeight: 56,
                    onPressed: onPressed,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                    titleStyle: buttonTextStyle,
                    borderRadius: 12,
                    borderColor: Colors.transparent,
                    backgroundColor: buttonBackgroundColor ?? ColorConstant.primaryColor,
                    title: buttonText ?? "Verify",
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
  return result;
}



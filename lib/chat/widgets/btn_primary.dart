import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimaryButton extends StatelessWidget {

  final Function()? onPressed;
  final String title;
  final double? titleSize;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final Color? textColor;
  final bool? isLeading;
  final String? imageLeadingPath;
  final Color? imageLeadingColor;
  final bool? isLeadingPng;
  final Color borderColor;
  final Widget? leadingChild;
  final Widget? trailingChild;
  final Widget? showNearToText;
  final double? addSpaceBetweenLeadingAndText;
  final bool enabled;
  final double? borderRadius;
  final double? minHeight;
  final double? borderWidth;
  final double? topPadding;
  final double? bottomPadding;
  final double? leftPadding;
  final double? rightPadding;
  final List<BoxShadow>? boxShadow;
  final MainAxisAlignment? mainAxisAlignment;

  const PrimaryButton({
    super.key,
    required this.title,
    this.titleSize = 18.0,
    this.onPressed,
    this.imageLeadingPath,
    this.imageLeadingColor,
    this.titleStyle,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.isLeading = false,
    this.enabled = true,
    this.borderColor = Colors.black,
    this.leadingChild,
    this.trailingChild,
    this.borderRadius, this.topPadding, this.bottomPadding, this.boxShadow, this.minHeight, this.leftPadding, this.rightPadding, this.borderWidth, this.mainAxisAlignment, this.addSpaceBetweenLeadingAndText, this.showNearToText,
   this.isLeadingPng,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: boxShadow),
      child: RawMaterialButton(
        fillColor: enabled ? backgroundColor : Colors.white.withOpacity(0.5),
        elevation: 0.0,
        focusElevation: 0.0,
        highlightElevation: 0.0,
        hoverElevation: 0.0,
        shape: RoundedRectangleBorder(
          side: (borderColor == null)
              ? const BorderSide(color: Colors.transparent, width: 0)
              : BorderSide(color: borderColor, width: borderWidth ?? 0),
          borderRadius: BorderRadius.circular(borderRadius ?? 6.0),
        ),
        onPressed: enabled ? onPressed : null,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(minHeight: minHeight ?? 0.0, minWidth: 0.0),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leadingChild != null) leadingChild!,
              SizedBox(
                width: addSpaceBetweenLeadingAndText ?? 0.0,
              ),
              Text(
                title,
                style: titleStyle,
              ),

              if(showNearToText!=null)showNearToText!,

              if (trailingChild != null)
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: trailingChild!,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

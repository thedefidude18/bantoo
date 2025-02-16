// ignore_for_file: constant_identifier_names
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/helpers/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown(
      {super.key,
      this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.width,
      this.margin,
      this.focusNode,
      this.hintText,
      this.prefix,
      this.prefixConstraints,
      required this.items,
      this.hintTextStyle,
      this.onChanged,
      this.validator});

  final DropDownShape? shape;
  final DropDownPadding? padding;
  final DropDownVariant? variant;
  final DropDownFontStyle? fontStyle;
  final Alignment? alignment;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final FocusNode? focusNode;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final List<String> items;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildDropDownWidget(),
          )
        : _buildDropDownWidget();
  }

  _buildDropDownWidget() {
    return Container(
      width: getHorizontalSize(width ?? 0),
      margin: margin,
      child: DropdownButtonFormField(
        value: items[0],
        isExpanded: true,
        focusNode: focusNode,
        icon: const Icon(
          Icons.arrow_drop_down,
        ),
        style: _setFontStyle(),
        decoration: _buildDecoration(),
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (value) {
          onChanged != null ? onChanged!(value.toString()) : () {};
        },
        validator: validator,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: hintTextStyle,
      border: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      fillColor: _setFillColor(),
      filled: _setFilled(),
      isDense: false,
      contentPadding: _setPadding(),
    );
  }

  _setFontStyle() {
    switch (fontStyle) {
      default:
        return TextStyle(
          color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[800],
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w400,
        );
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case DropDownVariant.OutlineGray101:
        return OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorConstant.primaryColor,
            width: 1,
          ),
        );
      default:
        return OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorConstant.primaryColor,
            width: 1,
          ),
        );
    }
  }

  _setFillColor() {
    return ColorConstant.whiteA700;
  }

  _setFilled() {
    switch (variant) {
      default:
        return true;
    }
  }

  _setPadding() {
    switch (padding) {
      case DropDownPadding.PaddingAll20:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 26);
      case DropDownPadding.PaddingAll30:
        return const EdgeInsets.symmetric(horizontal: 30, vertical: 36);
      default:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 16);
    }
  }
}

enum DropDownShape {
  RoundedBorder16,
}

enum DropDownPadding {
  PaddingAll14,
  PaddingAll20,
  PaddingAll30,
}

enum DropDownVariant {
  OutlineGray101,
}

enum DropDownFontStyle {
  InterSemiBold16,
}

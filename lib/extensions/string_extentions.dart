import 'dart:convert';

import 'package:flexx_bet/constants/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';

extension StringExtention on String {

  Map<String, dynamic>? toJson(){
    try{
      return json.decode(this);
    } catch(e){
      return null;
    }
  }


  String replaceCharAtIndex(int index, String replacementChar) {
    if (index < 0 || index >= length) {
      return this;
    }
    List<String> characters = split('');
    characters[index] = replacementChar;
    return characters.join('');
  }

  bool isValidEmail() {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(this);
  }

  DateTime? toDate() {
    try {
      DateTime dateTime = DateTime.parse(this);
      if (kDebugMode) {
        print(dateTime);
      } // Output: 2023-01-15 12:30:00.000
      return dateTime;
    } catch (e) {
      if (kDebugMode) {
        print("Error parsing date: $e");
      }
      return null;
    }
  }

}

extension NullableStringExtention on String? {


  showSnackbar({
    Color? bgColor,
    IconData? icon,
    Color? iconColor,
    TextAlign? textAlign,
    SnackPosition? snackPosition,
    int? seconds,
    Color? textColor,
    Color? backgroundColor,
    Color? borderColor,
    Widget? image,
    bool isSuccess = false,
    trailingImage
  }) {
    if(this == null) return;
    Get.snackbar(
      "",
      "",
      padding: EdgeInsets.zero,
      duration: seconds != null ? Duration(seconds: seconds) : const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 8,
      titleText: const Text("", style: TextStyle(height: 0),),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 10, top: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if(!isSuccess)
              image??Icon(
                Icons.info,
                color: ColorConstant.orangeRedColor,
                size: 20,
              ),
            if(!isSuccess) const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                this!,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            if(!isSuccess) trailingImage ?? Icon(
              Icons.clear,
              color: iconColor ??ColorConstant.orangeRedColor,
              size: 15,
            ),
          ],
        ),
      ),
      backgroundColor: (){
        if(isSuccess) {
          return ColorConstant.snackbarSuccessBackground;
        }
        else {
          return backgroundColor ?? ColorConstant.snackbarFailureBackground;
        }
      }(),
      colorText: textColor ?? ColorConstant.whiteA700,
      borderWidth: 1,
      borderColor:(){
        if(isSuccess) {
          return ColorConstant.snackbarSuccessBorder;
        }
        else {
          return borderColor??ColorConstant.snackbarFailureBorder;
        }
      }(),
      snackPosition: snackPosition ?? SnackPosition.TOP,
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
    );
  }

  String? getLastValueAfterUnderscore() {
    if(this == null) return null;
    List<String> parts = this!.split('_');
    if (parts.length > 1) {
      String lastPart = parts.last;
      return lastPart;
      // List<String> values = lastPart.split(' ');
      // if (values.isNotEmpty) {
      //   return values.last;
      // }
    }
    return null;
  }
  String? getFirstValueAfterUnderscore() {
    if(this == null) return null;
    List<String> parts = this!.split('_');
    if (parts.isNotEmpty) {
      String lastPart = parts.first;
      return lastPart;
      // List<String> values = lastPart.split(' ');
      // if (values.isNotEmpty) {
      //   return values.last;
      // }
    }
    return null;
  }

  String? removePlus() {
    if(this == null) return null;

    try {
      var data =  this?.replaceFirst("+", "");
      return data;
    } catch (e) {
      if (kDebugMode) {
        print("Error parsing date: $e");
      }
    }
    return null;
  }

  String? maskString() {
    if(this == null) return null;
    if (this!.length <= 5) return this!;
    String masked = this!.substring(this!.length - 5).padLeft(this!.length, '*');
    return masked;
  }

  printSuccess() {
    if (kDebugMode) {
      log("\uD83C\uDF89 \uD83C\uDF89 \uD83C\uDF89 🙌 Response success Type: $this 🙌 \uD83C\uDF89 \uD83C\uDF89 \uD83C\uDF89");
    }
  }

  printFailure() {
    if (kDebugMode) {
      log("❌ ☠️ ☠️ Response Failed Type: $this ☠️ ☠️ ❌");
    }
  }

  Map? getParamsFromUrl(){
    if(this == null) return null;
      Uri uri = Uri.parse(this!);
      Map<String, String> queryParams = uri.queryParameters;
      return queryParams;
  }
}
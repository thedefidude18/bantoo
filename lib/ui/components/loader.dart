import 'package:flexx_bet/ui/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future showLoader(Future<dynamic> Function() asyncFunction) {
  if (loaderShown) {
    return asyncFunction();
  } else {
    return Get.showOverlay(
        asyncFunction: asyncFunction,
        loadingWidget: const SizedBox(
          child: Center(
            child: SizedBox(
                width: 40, height: 40, child: CircularProgressIndicator()),
          ),
        ),
        opacity: 0);
  }
}

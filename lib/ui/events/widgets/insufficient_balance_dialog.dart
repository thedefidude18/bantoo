import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void insufficientBalanceDialog(num eventAmount) {
  Get.dialog(
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 300,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 200,
              width: Get.width / 1.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "You do not have sufficient \nbalance to challenge. Please kindly fund \nyour wallet with current event amount\nof ₦$eventAmount to proceed.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: "Inter", color: Colors.black),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          ImageConstant.sadEmoji,
                          height: 80,
                          width: 80,
                        )
                      ],
                    ),
                    CustomButton(
                      width: Get.width / 2,
                      text: "Fund Wallet",
                      padding: ButtonPadding.PaddingAll4,
                      fontStyle: ButtonFontStyle.PoppinsSemiBold16,
                      onTap: () {
                        Get.back();
                        Get.to(() => WalletScreen());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

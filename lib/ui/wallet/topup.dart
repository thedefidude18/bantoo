import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/selection_controller.dart';
import 'package:flexx_bet/ui/wallet/widget/payment_bottom_sheet.dart';
import 'package:flexx_bet/ui/wallet/widget/topup_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../ui/components/custom_button.dart';

class TopupScreen extends StatelessWidget {
  TopupScreen({super.key});
  final SelectionController selectionController =
      Get.put(SelectionController("matsrecard"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.white),
        title: const Text(
          "Topup",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8, 0, 8),
            child: Text(
              "Bank Transfer",
              style: TextStyle(
                  color: ColorConstant.primaryColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const TopupCard(
            subtitle: "**** **** **** 1121",
            name: "Matsrecard",
            value: "matsrecard",
            image: ImageConstant.masterCard,
          ),
          const TopupCard(
            name: "Visa",
            subtitle: "**** **** **** 1564",
            value: "visa",
            image: ImageConstant.visa,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8, 0, 8),
            child: Text(
              "Other",
              style: TextStyle(
                  color: ColorConstant.primaryColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const TopupCard(
            name: "Paypal",
            subtitle: "Easy payment",
            value: "papal",
            image: ImageConstant.paypal,
          ),
          const TopupCard(
            name: "Payfast",
            value: "payfast",
            subtitle: "Easy payment",
            image: ImageConstant.payfast,
          ),
          const TopupCard(
            name: "Western Union",
            value: "western",
            subtitle: "Easy payment",
            image: ImageConstant.westernUnion,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: "Submit",
                fontStyle: ButtonFontStyle.PoppinsMedium16,
                width: Get.width / 1.2,
                height: 50,
                onTap: () {
                  paymentBottomSheet(1);
                },
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          )
        ]),
      ),
    );
  }
}

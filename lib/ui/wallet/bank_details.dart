import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/helpers/helpers.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flexx_bet/ui/wallet/widget/withdraw_confirmation.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/custom_text_field.dart';
import 'package:flexx_bet/ui/wallet/withdraw_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';

class BankDetailsScreen extends StatelessWidget {
  BankDetailsScreen({super.key, required this.selectedCard});
  final Map<String, dynamic> selectedCard;
  final TextEditingController accController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.white),
        title: const Text(
          "Bank Details",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(26, 0, 26, 26),
          width: Get.width,
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          decoration: BoxDecoration(
              color: ColorConstant.whiteA700,
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: CustomImageView(
                      imagePath: ImageConstant.visa,
                    ),
                  ),
                  SizedBox(
                    width: getHorizontalSize(20),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedCard["name"],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: CustomTextField(
              label: "Account Number",
              controller: accController,
              textInputType: TextInputType.number),
        ),
        const Padding(
          padding: EdgeInsets.all(18.0),
          child: Text(
            "Please check your details carefully to avoid sending money to the wrong account.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 32),
          child: CustomButton(
            text: "Continue",
            fontStyle: ButtonFontStyle.PoppinsMedium16,
            padding: ButtonPadding.PaddingAll4,
            onTap: () {
              banksController.account = accController.text;
              withdrawConfirmation();
            },
          ),
        )
      ]),
    );
  }
}

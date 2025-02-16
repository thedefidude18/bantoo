import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/wallet_controller.dart';
import 'package:flexx_bet/ui/wallet/transfer_user_selection.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class TransferScreen extends StatelessWidget {
  TransferScreen({super.key});
  final AuthController _authController = AuthController.to;
  final WalletContoller _walletContoller = WalletContoller.to;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = 3 * Get.width / 12;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.white),
        title: const Text(
          "Transfer",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
          height: 130,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(16),
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: CachedNetworkImageProvider(
                    _authController.userFirestore!.photoUrl),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _authController.userFirestore!.name,
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    "@${_authController.userFirestore!.name}",
                    style: const TextStyle(color: Colors.grey, fontSize: 18),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0, left: 8),
                child: Transform.rotate(
                    angle: 270 * math.pi / 180,
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 12,
                      color: Colors.black,
                    )),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "₦",
              style: TextStyle(
                  fontFamily: 'Inter',
                  color: ColorConstant.primaryColor,
                  fontSize: 15),
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return SizedBox(
                  width: width,
                  child: TextFormField(
                    controller: controller,
                    onChanged: (value) {
                      setState(
                        () {
                          width = value.isNotEmpty
                              ? value.length * (Get.width / 12) >
                                      Get.width / 1.3
                                  ? Get.width / 1.3
                                  : value.length * (Get.width / 12)
                              : Get.width / 12;
                        },
                      );
                    },
                    style: TextStyle(
                        fontSize: Get.width / 8.5,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      hintText: "500",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        Text(
          "Current Balance is ₦${_walletContoller.totalAmount.value!}",
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        const SizedBox(
          height: 40,
        ),
        Text(
          "0% Fees",
          style: TextStyle(color: ColorConstant.primaryColor, fontSize: 20),
        ),
        const SizedBox(
          height: 40,
        ),
        CustomButton(
          width: Get.width / 1.3,
          text: "Continue",
          fontStyle: ButtonFontStyle.PoppinsMedium16,
          padding: ButtonPadding.PaddingAll4,
          height: 50,
          onTap: () async {
            num amount = num.parse(controller.text);
            if (amount > _walletContoller.userWallet.value!.currentAmount) {
              Get.showSnackbar(const GetSnackBar(
                duration: Duration(seconds: 2),
                title: "Unable to withdraw",
                message:
                    "Insufficient balance, The amount you entered is more than your current balance",
              ));
            } else {
              await _authController.fetchFirstUserList();
              Get.to(() => TransferUserSelectionScreen(
                    amount: amount,
                  ));
            }
          },
        )
      ]),
    );
  }
}

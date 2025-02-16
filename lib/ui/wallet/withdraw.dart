import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/bank_controller.dart';
import 'package:flexx_bet/controllers/selection_controller.dart';
import 'package:flexx_bet/controllers/wallet_controller.dart';
import 'package:flexx_bet/ui/wallet/withdraw_to.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class WithdrawScreen extends StatelessWidget {
  WithdrawScreen({super.key});
  final num currentUserAmount =
      WalletContoller.to.userWallet.value!.currentAmount;
  final TextEditingController controller = TextEditingController(
      text: (WalletContoller.to.userWallet.value!.currentAmount * .25)
          .toString());


  String formatCurrency(double amount) {
    if (amount >= 1e9) {
      return '${(amount / 1e9).toStringAsFixed(2)}B'; // Billion
    } else if (amount >= 1e6) {
      return '${(amount / 1e6).toStringAsFixed(2)}M'; // Million
    } else if (amount >= 1e3) {
      return '${(amount / 1e3).toStringAsFixed(2)}K'; // Thousand
    } else {
      return '${amount.toStringAsFixed(2)}'; // Less than 1000
    }
  }
  @override
  Widget build(BuildContext context) {
    double width = 3 * Get.width / 12;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.white),
        title: const Text(
          "Withdraw",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 35,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "₦",
                style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.grey,
                    fontSize: Get.width / 10),
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
                          fontSize: Get.width / 12.5,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none),
                    ),
                  );
                },
              ),
            ],
          ),
          Text(
            "Current Balance is ₦ ${formatCurrency(double.parse("$currentUserAmount"))}",
            style: const TextStyle(fontFamily: 'Inter'),
          ),
          const SizedBox(
            height: 20,
          ),
          GetBuilder(
            init: SelectionController<String>("25%"),
            builder: (selectionController) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectionController.setSelection("25%");

                        controller.text = formatCurrency(double.parse("${currentUserAmount*0.25}")).toString();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: selectionController.selection == "25%"
                              ? ColorConstant.teal400
                              : Colors.white,
                        ),
                        child: Text(
                          "25%",
                          style: TextStyle(
                              color: selectionController.selection == "25%"
                                  ? Colors.white
                                  : ColorConstant.primaryColor),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        selectionController.setSelection("50%");
                        controller.text = formatCurrency(double.parse("${currentUserAmount*0.5}")).toString();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: selectionController.selection == "50%"
                              ? ColorConstant.teal400
                              : Colors.white,
                        ),
                        child: Text(
                          "50%",
                          style: TextStyle(
                              color: selectionController.selection == "50%"
                                  ? Colors.white
                                  : ColorConstant.primaryColor),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        selectionController.setSelection("75%");
                        controller.text = formatCurrency(double.parse("${currentUserAmount*0.75}")).toString();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: selectionController.selection == "75%"
                              ? ColorConstant.teal400
                              : Colors.white,
                        ),
                        child: Text(
                          "75%",
                          style: TextStyle(
                              color: selectionController.selection == "75%"
                                  ? Colors.white
                                  : ColorConstant.primaryColor),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        selectionController.setSelection("100%");
                        controller.text =formatCurrency(double.parse("$currentUserAmount")).toString();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: selectionController.selection == "100%"
                              ? ColorConstant.teal400
                              : Colors.white,
                        ),
                        child: Text(
                          "100%",
                          style: TextStyle(
                              color: selectionController.selection == "100%"
                                  ? Colors.white
                                  : ColorConstant.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 40,
          ),
          CustomButton(
            width: Get.width / 1.3,
            text: "Withdraw",
            fontStyle: ButtonFontStyle.PoppinsMedium16,
            padding: ButtonPadding.PaddingAll4,
            onTap: () {
              BanksController.to.amount = num.parse(controller.text);
              Get.to(() => const WithdrawToScreen());
            },
          )
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/bank_controller.dart';
import 'package:flexx_bet/controllers/wallet_controller.dart';
import 'package:flexx_bet/models/transaction_model.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flexx_bet/ui/wallet/DepositScreen.dart';
import 'package:flexx_bet/ui/wallet/transfer.dart';
import 'package:flexx_bet/ui/wallet/widget/payment_bottom_sheet.dart';
import 'package:flexx_bet/ui/wallet/widget/transaction_history_card.dart';
import 'package:flexx_bet/ui/wallet/withdraw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../constants/images.dart';
import '../components/custom_appbar.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletContoller _walletContoller = WalletContoller.to;
  double nairaRate = 0;

  @override
  void initState() {
    super.initState();
    fetchNairaRate("USDT");
  }

  String formatCurrency(double amount) {
    if (amount >= 1e9) {
      return '₦${(amount / 1e9).toStringAsFixed(2)}B'; // Billion
    } else if (amount >= 1e6) {
      return '₦${(amount / 1e6).toStringAsFixed(2)}M'; // Million
    } else if (amount >= 1e3) {
      return '₦${(amount / 1e3).toStringAsFixed(2)}K'; // Thousand
    } else {
      return '₦${amount.toStringAsFixed(2)}'; // Less than 1000
    }
  }

  Future<double> fetchNairaRate(String currency) async {
    const String baseUrl = 'https://api.coinbase.com/v2/exchange-rates?currency=';
    final String url = '$baseUrl$currency';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          nairaRate = double.parse(data['data']['rates']['NGN']);
        });

        print("Failed to fetch the exchange rate $nairaRate.");
        return nairaRate;
      } else {
        print("Failed to fetch the exchange rate.");
        return 0;
      }
    } catch (e) {
      print("Error: $e");
      return 0;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: true,
        showCreateEvent: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: Get.width,
              height: 15,
            ),
            Text(
              "Wallet Balance",
              style: TextStyle(
                  color: ColorConstant.gray500,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            GetBuilder<WalletContoller>(builder: (controller) {
              return Column(
                children: [
                  Text(
                    formatCurrency(double.parse("${controller.totalAmount}")),
                    style: const TextStyle(
                        fontFamily: 'inter',
                        fontSize: 40,
                        fontWeight: FontWeight.w500),
                  ),
                  if (nairaRate > 0) // Show the conversion if the rate is available
                    Container(
                      margin: EdgeInsets.all(8.0),
                      padding:EdgeInsets.all(4.0),
                      decoration:  BoxDecoration(
                        borderRadius:const BorderRadius.all(Radius.circular(8.0)),
                        color:Colors.grey[700],
                      ),


                      child:Text(
                        "≈ \$${(controller.totalAmount.value! / nairaRate).toStringAsFixed(2)} USDT",
                        style:const  TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),

                ],
              );
            }),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    Get.to(() => DepositScreen());
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(
                          Icons.arrow_downward,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("Deposit")
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => TransferScreen());
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12)),
                        child: CustomImageView(
                          imagePath: ImageConstant.sendIcon,
                          height: 35,
                          width: 35,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("Transfer")
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (_walletContoller.userWallet.value!.currentAmount == 0) {
                      Get.showSnackbar(const GetSnackBar(
                        duration: Duration(seconds: 2),
                        title: "Unable to withdraw",
                        message:
                        "Insufficient balance, The amount you currently have is for in-app use only",
                      ));
                    } else {
                      await Get.put(BanksController()).getAllBanks();
                      Get.to(() => WithdrawScreen());
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12)),
                        child: CustomImageView(
                          imagePath: ImageConstant.withdrawIcon,
                          height: 35,
                          width: 35,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("Withdraw")
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              child: GetBuilder<WalletContoller>(builder: (walletContoller) {
                List transactions =
                    _walletContoller.userWallet.value!.transactions;
                return ListView.builder(
                  itemCount: transactions.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    TransactionModel currentTransaction =
                    TransactionModel.fromMap(transactions[index]);
                    num amount = num.parse(currentTransaction.amount);

                    if (currentTransaction.action == "withdraw" ||
                        currentTransaction.action == "transfer" ||
                        currentTransaction.action == "bet") {
                      amount = amount * -1;
                    }

                    return TransactionHistoryCard(
                      amount: amount,
                      title: "You ${currentTransaction.narration}",
                      imagePath: ImageConstant.betIcon,
                      subTitle: currentTransaction.account.isEmpty
                          ? currentTransaction.concerned
                          : currentTransaction.account,
                      eventHeldDate:
                      DateTime.parse(currentTransaction.dateAndTime),
                    );
                  },
                );
              }),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}


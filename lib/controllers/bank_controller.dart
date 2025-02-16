import 'dart:convert';
import 'package:flexx_bet/constants/constants.dart';
import 'package:flexx_bet/controllers/wallet_controller.dart';
import 'package:flexx_bet/models/transaction_model.dart';
import 'package:flexx_bet/ui/components/loader.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class BanksController extends GetxController {
  static final BanksController to = Get.find<BanksController>();
  num amount = 0;
  String account = "";
  bool transferSuccessful = false;
  final Rxn<List> banks = Rxn<List>();
  Rxn<Map<String, dynamic>> currentSelectedBank = Rxn<Map<String, dynamic>>();
  bool isError = false;

  Future getAllBanks() async {
    try {
      await showLoader(() async {
        http.Response data = await http.get(
            Uri.parse("https://api.flutterwave.com/v3/banks/NG"),
            headers: {"Authorization": Globals.flutterWaveSecretKey});
        if (data.statusCode == 200) {
          isError = false;
          Map<String, dynamic> jsonData = jsonDecode(data.body);
          banks.value = jsonData["data"];
          currentSelectedBank.value = banks.value![0];
        } else {
          isError = true;
        }
      });
    } catch (e) {
      isError = true;
      Get.log(e.toString());
    }
  }

  Future initiateWithdraw() async {
    WalletContoller walletContoller = WalletContoller.to;
    await showLoader(() async {
      try {
        TransactionModel transactionModel =
            walletContoller.generateTransactionHistory(
                walletAction: WalletActions.Withdraw,
                concerned: currentSelectedBank.value!["code"],
                amount: "$amount",
                account: account);

        http.Response data = await http.post(
            Uri.parse("https://api.flutterwave.com/v3/transfers"),
            body: jsonEncode(transactionModel.toJsonForFlutterWave()),
            headers: {
              "Authorization": Globals.flutterWaveSecretKey,
              'Content-Type': 'application/json; charset=UTF-8',
            });
        Map<String, dynamic> jsonData = jsonDecode(data.body);
        if (jsonData["status"] == "success") {
          isError = false;
          transferSuccessful = true;
          await walletContoller.decreaseRealWalletAmount(
              amount, transactionModel);
        } else {
          isError = true;
        }
      } catch (e) {
        isError = true;
        Get.log(e.toString());
      }
    });
  }
}

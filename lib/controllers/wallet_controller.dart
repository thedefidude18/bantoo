import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/extensions/string_extentions.dart';
import 'package:flexx_bet/models/models.dart';
import 'package:flexx_bet/models/transaction_model.dart';
import 'package:flexx_bet/models/wallet_model.dart';
import 'package:flexx_bet/ui/components/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

// ignore: constant_identifier_names
enum WalletActions { Transfer, Receive, Deposit, Withdraw, Bet, groupCreation }

class WalletContoller extends GetxController {
  static WalletContoller to = Get.find<WalletContoller>();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Rxn<num> totalAmount = Rxn<num>();

  Rxn<WalletModel> userWallet = Rxn<WalletModel>();

  Future setupUserWallet(UserModel? user) {
    if (kDebugMode) {
      Get.log('setupUserWallet()');
    }

    var walletStream =
        _db.doc('/wallet/${user?.uid}').snapshots().map((snapshot) {
      if (snapshot.data() != null) {
        WalletModel wallet = WalletModel.fromMap(snapshot.data()!);
        totalAmount.value =
            wallet.currentAmount + wallet.onlyInAppUseableAmount;
        return wallet;
      } else if (user != null) {
        WalletModel newWallet = WalletModel(
            userId: user.uid,
            transactions: [
              generateTransactionHistory(
                walletAction: WalletActions.Receive,
                concerned: "Flexxbet",
                amount: "1000",
                account: "",
              ).toJson()
            ],
            currentAmount: 0,
            onlyInAppUseableAmount: 1000,
            currency: "NGN");
        totalAmount.value =
            newWallet.currentAmount + newWallet.onlyInAppUseableAmount;
        _createWallet(newWallet);
        return newWallet;
      }
    });
    userWallet.bindStream(walletStream);
    var firstValueReceived = Completer<void>();
    userWallet.listen((val) {
      if (!firstValueReceived.isCompleted) {
        firstValueReceived.complete();
      }
    });
    return firstValueReceived.future;
  }


  Future incrementRealWalletAmount(
      num incrementBy, TransactionModel transactionModel) async {
    try {
      "My Details-------------> ${incrementBy.toString()}".printSuccess();
      var transaction = transactionModel.toJson();
      WalletModel incrementedWallet = WalletModel(
          userId: userWallet.value!.userId,
          transactions: [transaction, ...userWallet.value!.transactions],
          onlyInAppUseableAmount: userWallet.value!.onlyInAppUseableAmount,
          currentAmount: userWallet.value!.currentAmount + incrementBy,
          currency: "NGN");
      await _updateWallet(incrementedWallet);
      update();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future decreaseRealWalletAmount(
      num decreaseBy, TransactionModel transactionModel) async {
    try {
      var transaction = transactionModel.toJson();
      if (userWallet.value!.currentAmount > decreaseBy) {
        WalletModel incrementedWallet = WalletModel(
            userId: userWallet.value!.userId,
            transactions: [transaction, ...userWallet.value!.transactions],
            onlyInAppUseableAmount: userWallet.value!.onlyInAppUseableAmount,
            currentAmount: userWallet.value!.currentAmount - decreaseBy,
            currency: "NGN");
        await _updateWallet(incrementedWallet);
      }
      update();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  WalletModel? decreaseWalletAmount(
      num decreaseBy, TransactionModel transactionModel) {
    num onlyInAppUseableAmount =
        userWallet.value!.onlyInAppUseableAmount - decreaseBy;
    if (onlyInAppUseableAmount.isNegative) {
      num realMoney = userWallet.value!.currentAmount + onlyInAppUseableAmount;
      if (realMoney.isNegative) {
        return null;
      }

      return WalletModel(
          userId: userWallet.value!.userId,
          transactions: [
            transactionModel.toJson(),
            ...userWallet.value!.transactions
          ],
          onlyInAppUseableAmount: 0,
          currentAmount: realMoney,
          currency: "NGN");
    } else {
      return WalletModel(
          userId: userWallet.value!.userId,
          transactions: [
            transactionModel.toJson(),
            ...userWallet.value!.transactions
          ],
          onlyInAppUseableAmount: onlyInAppUseableAmount,
          currentAmount: userWallet.value!.currentAmount,
          currency: "NGN");
    }
  }

  Future<WalletModel?> groupCreation(num amount, String eventName) async {
    try {
      TransactionModel transactionModel = generateTransactionHistory(
          account: "",
          amount: "$amount",
          concerned: eventName,
          walletAction: WalletActions.groupCreation);

      WalletModel? decrementedWallet =
          decreaseWalletAmount(amount, transactionModel);
      if (decrementedWallet != null) {
        await _updateWallet(decrementedWallet);
      }

      update();
      return decrementedWallet;
    } catch (e) {
      Get.log(e.toString(), isError: true);
      return null;
    }
  }

  Future<WalletModel?> joinGroupEvent(num amount, String eventName) async {
    try {
      TransactionModel transactionModel = generateTransactionHistory(
          account: "",
          amount: "$amount",
          concerned: eventName,
          walletAction: WalletActions.Bet);

      WalletModel? decrementedWallet =
      decreaseWalletAmount(amount, transactionModel);
      if (decrementedWallet != null) {
        await _updateWallet(decrementedWallet);
      }

      update();
      return decrementedWallet;
    } catch (e) {
      Get.log(e.toString(), isError: true);
      return null;
    }
  }

  Future bet(num amount, String eventName) async {
    try {
      TransactionModel transactionModel = generateTransactionHistory(
          account: "",
          amount: "$amount",
          concerned: eventName,
          walletAction: WalletActions.Bet);

      WalletModel? decrementedWallet =
      decreaseWalletAmount(amount, transactionModel);
      if (decrementedWallet != null) {
        await _updateWallet(decrementedWallet);
      }

      update();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future transferMoney(num amount) async {
    await showLoader(() async {
      try {
        AuthController authController = AuthController.to;

        WalletModel otherUserWallet =
            await _getWallet(authController.otherUser!.uid);

        TransactionModel currentUserTransaction = generateTransactionHistory(
            walletAction: WalletActions.Transfer,
            concerned: authController.otherUser!.username,
            amount: "$amount",
            account: "");

        TransactionModel otherUserTransaction = generateTransactionHistory(
            walletAction: WalletActions.Receive,
            concerned: authController.userFirestore!.username,
            amount: "$amount",
            account: "");
        WalletModel incrementedOtherUserWallet = WalletModel(
            userId: otherUserWallet.userId,
            transactions: [
              otherUserTransaction.toJson(),
              ...otherUserWallet.transactions
            ],
            onlyInAppUseableAmount: otherUserWallet.onlyInAppUseableAmount,
            currentAmount: otherUserWallet.currentAmount + amount,
            currency: "NGN");

        await _updateWallet(incrementedOtherUserWallet);

        WalletModel decrementedCurrentUserWallet = WalletModel(
            userId: userWallet.value!.userId,
            transactions: [
              currentUserTransaction.toJson(),
              ...userWallet.value!.transactions
            ],
            onlyInAppUseableAmount: userWallet.value!.onlyInAppUseableAmount,
            currentAmount: userWallet.value!.currentAmount - amount,
            currency: "NGN");

        await _updateWallet(decrementedCurrentUserWallet);

        update();
      } catch (e) {
        Get.log(e.toString(), isError: true);
      }
    });
  }

  Future incrementInAppUsableWalletAmount(
      num incrementBy, TransactionModel transactionModel) async {
    try {
      WalletModel incrementedWallet = WalletModel(
          userId: userWallet.value!.userId,
          transactions: [
            transactionModel.toJson(),
            ...userWallet.value!.transactions
          ],
          onlyInAppUseableAmount:
              userWallet.value!.onlyInAppUseableAmount + incrementBy,
          currentAmount: userWallet.value!.currentAmount,
          currency: "NGN");
      await _updateWallet(incrementedWallet);
      update();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future incrementInAppAmountByReferral(
      num incrementBy, TransactionModel transactionModel, String userId) async {
    try {

      _db.collection("wallet").doc(userId).get().then((snapshot) async {
        if (snapshot.data() != null) {
          WalletModel wallet = WalletModel.fromMap(snapshot.data()!);

          WalletModel incrementedWallet = WalletModel(
              userId: userId,
              transactions: [
                transactionModel.toJson(),
                ...wallet.transactions
              ],
              onlyInAppUseableAmount:
              wallet.onlyInAppUseableAmount + incrementBy,
              currentAmount: wallet.currentAmount,
              currency: "NGN");
          await _updateWallet(incrementedWallet);
        }
      });

    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future _createWallet(WalletModel wallet) async {
    Get.log("_createWallet");
    await _db.doc('/wallet/${wallet.userId}').set(wallet.toJson());
    update();
  }

  Future<WalletModel> _getWallet(String userId) async {
    Get.log("_getWallet");
    return WalletModel.fromMap(
        (await _db.doc('/wallet/$userId').get()).data()!);
  }

  Future<WalletModel> getWalletData(String userId) async {
    Get.log("_getWallet");
    return WalletModel.fromMap(
        (await _db.doc('/wallet/$userId').get()).data()!);
  }

  Future _updateWallet(WalletModel wallet) async {
    Get.log("_updateWallet");
    await _db.doc('/wallet/${wallet.userId}').update(wallet.toJson());
    update();
  }

//possible actions: witdrw depsit trnsfr betted recive
  TransactionModel generateTransactionHistory(
      {required WalletActions walletAction,
      required String concerned,
      required String amount,
      required String account}) {
    String reference = "";
    String narration = "";
    String action = "";
    DateTime time = DateTime.now();
    switch (walletAction) {
      case WalletActions.Transfer:
        reference = "trnsfr-₦${amount.toString()}_$time"
            .replaceAll(":", "-")
            .replaceAll(".", "-");
        narration = "transferred ₦${amount.toString()} to";
        action = "transfer";
      case WalletActions.Bet:
        reference = "bet-₦${amount.toString()}_$time"
            .replaceAll(":", "-")
            .replaceAll(".", "-");
        narration = "betted ₦${amount.toString()} to";
        action = "bet";

      case WalletActions.Deposit:
        reference = "depsit-₦${amount.toString()}_$time"
            .replaceAll(":", "-")
            .replaceAll(".", "-");
        narration = "deposited ₦${amount.toString()} from";
        action = "deposit";

      case WalletActions.Receive:
        reference = "reciv-₦${amount.toString()}_$time"
            .replaceAll(":", "-")
            .replaceAll(".", "-");
        narration = "received ₦${amount.toString()} from";
        action = "receive";

      case WalletActions.Withdraw:
        reference = "witdrw-₦${amount.toString()}_$time"
            .replaceAll(":", "-")
            .replaceAll(".", "-");
        narration = "withdrew ₦${amount.toString()} from";
        action = "withdraw";

      case WalletActions.groupCreation:
        reference = "group-₦${amount.toString()}_$time"
            .replaceAll(":", "-")
            .replaceAll(".", "-");
        narration = "spent ₦${amount.toString()} on";
        action = "group";
    }

    return TransactionModel(
        concerned: concerned,
        account: account,
        action: action,
        dateAndTime: time.toString(),
        amount: amount,
        reference: reference,
        narration: narration,
        currency: "NGN");
  }

  //possible actions: withdrew deposited transferred betted recieved
}

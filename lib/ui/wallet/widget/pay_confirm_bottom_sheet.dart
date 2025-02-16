import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/notification_controller.dart';
import 'package:flexx_bet/controllers/wallet_controller.dart';
import 'package:flexx_bet/models/transaction_model.dart';
import 'package:flexx_bet/ui/components/loader.dart';
import 'package:flexx_bet/ui/wallet/widget/PaymentWebView.dart';
import 'package:flexx_bet/ui/wallet/widget/topup_success_bottom_sheet.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/globals.dart';
import '../../../models/notification_model.dart' as model;
import '../../../models/user_model.dart';

Future paymentConfirmBottomSheet(var topupBalance, int selectedIndex,nairaRate,selectedCrypto) async {
  AuthController authController = AuthController.to;
  final UserModel userModel = authController.userFirestore!;
  WalletContoller walletContoller = WalletContoller.to;
  final NotificationController notificationController =
  Get.put<NotificationController>(NotificationController());
  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
print(selectedCrypto);
  await Get.bottomSheet(
    Container(
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Top up balance",
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                        selectedIndex==1 && selectedCrypto!="ETH"?
                        Text("\$ $topupBalance",
                            style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            )):selectedIndex==1 && selectedCrypto=="ETH"?Text("Ξ $topupBalance",
                            style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            )):
                        Text("₦$topupBalance",
                            style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Fee",
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                        selectedIndex==1 && selectedCrypto!="ETH"?Text("\$ ${0}",
                            style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            )):selectedIndex==1 && selectedCrypto=="ETH"?Text("Ξ ${0}",
                            style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            )):
                        Text("₦3",
                            style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: Get.width,
                      height: 1,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        selectedIndex==1 && selectedCrypto!="ETH"?
                        Text("\$ ${topupBalance + 0}",
                            style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            )):selectedIndex==1 && selectedCrypto=="ETH"?Text("Ξ ${topupBalance + 0}",
                            style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            )):
                        Text("₦${topupBalance + 3}",
                            style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    CustomButton(
                      text: "Confirm Topup",
                      fontStyle: ButtonFontStyle.PoppinsMedium16,
                      padding: ButtonPadding.PaddingAll4,
                      height: 50,
                      onTap: () async {
                        var user = AuthController.to.userFirestore!;
                        if (user.number == "") {
                          Get.back();
                          Get.showSnackbar(const GetSnackBar(
                            title: "No phone number",
                            duration: Duration(seconds: 2),
                            message:
                            "Please add phone number to your profile to deposit",
                          ));
                          return;
                        }

                        if (selectedIndex == 1) {
                          Customer customer = Customer(
                              name: user.name,
                              phoneNumber: user.number,
                              email: user.email);
                          await handleCoinbasePayment(topupBalance,selectedCrypto ,customer,context);
                        } else {
                          Customer customer = Customer(
                              name: user.name,
                              phoneNumber: user.number,
                              email: user.email);
                          TransactionModel transactionModel =
                          walletContoller.generateTransactionHistory(
                              walletAction: WalletActions.Deposit,
                              amount: "$topupBalance",
                              account: "",
                              concerned: "Flutterwave");

                          Flutterwave flutterwave = Flutterwave(
                              context: context,
                              publicKey: Globals.flutterWavePublicKey,
                              currency: "NGN",
                              redirectUrl: "/",
                              txRef: transactionModel.reference,
                              amount: "${topupBalance + 3}",
                              customer: customer,
                              paymentOptions:
                              "ussd, card, barter, payattitude",
                              customization: Customization(
                                title: "Top up",
                                logo: ImageConstant.appLogo,
                              ),
                              isTestMode: true);
                          await showLoader(() async {
                            ChargeResponse response =
                            await flutterwave.charge();
                            if (response.success != null &&
                                response.success!) {
                              Get.back();
                              await handleFlutterwaveSuccess(
                                  topupBalance, userModel, transactionModel);
                            }
                          });
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

// Function to handle Coinbase payment
Future<void> handleCoinbasePayment(var topupBalance,String selectedCrypto, Customer customer,BuildContext context) async {
  const String apiUrl = 'https://api.commerce.coinbase.com/charges';
  const String apiKey = '3649d0d8-b37e-4535-8bc4-03c7f5c05ca7'; // Use your API Key

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'X-CC-Api-Key': apiKey,
      'X-CC-Version': '2018-03-22',
    },
    body: jsonEncode({
      "name": "Topup",
      "description": "Topup of ₦$topupBalance",
      "local_price": {
        "amount": "$topupBalance",
        "currency": selectedCrypto,
      },
      "pricing_type": "fixed_price",
      "metadata": {
        "customer_id": "${customer.email}",
        "customer_name": "${customer.name}",
      },
      "redirect_url": "myapp://payment-success",
      "cancel_url": "myapp://payment-cancel"
    }),
  );

  if (response.statusCode == 201) {
    final responseBody = jsonDecode(response.body);
    final hostedUrl = responseBody['data']['hosted_url'];
    // openPaymentPage(context,hostedUrl);
    _launchUrl(hostedUrl);
  } else {
    print('Coinbase payment failed: ${response.body}');
  }
}


Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $url');
  }
}
// Function to open Coinbase payment URL
void openPaymentPage(BuildContext context, String url) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => PaymentWebView(url: url),
    ),
  );
}

// Handle success after payment via Flutterwave
Future<void> handleFlutterwaveSuccess(int topupBalance, UserModel userModel,
    TransactionModel transactionModel) async {
  final notificationController = NotificationController.to;
  final walletContoller = WalletContoller.to;
  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

  awesomeNotifications.createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        actionType: ActionType.Default,
        title: 'Money Added',
        body: 'You have successfully added ₦$topupBalance',
      ));

  model.NotificationModel notificationModel = model.NotificationModel(
      userId: userModel.uid,
      body: 'You have successfully added ₦$topupBalance',
      type: "Money Deposit",
      creationDate: DateTime.now(),
      title: "Money Added",
      amount: "",
      selectedOption: "",
      eventId: "");
  await notificationController.addNotification(notificationModel);
  await walletContoller.incrementRealWalletAmount(topupBalance, transactionModel);
  topupSuccess();
}

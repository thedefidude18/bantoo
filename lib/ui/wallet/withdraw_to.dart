import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/bank_controller.dart';
import 'package:flexx_bet/ui/wallet/bank_details.dart';
import 'package:flexx_bet/ui/wallet/widget/withdraw_card.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

class WithdrawToScreen extends StatefulWidget {
  const WithdrawToScreen({super.key});

  @override
  State<WithdrawToScreen> createState() => _WithdrawToScreenState();
}

BanksController banksController = BanksController.to;

class _WithdrawToScreenState extends State<WithdrawToScreen> {
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Withdraw to",
                    style: TextStyle(
                        color: ColorConstant.primaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      banksController.currentSelectedBank.value =
                          await showSearch<Map<String, dynamic>>(
                        context: context,
                        delegate: CustomDelegate(),
                      );
                      banksController.update();
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 40),
                  height: Get.height * .8,
                  width: Get.width,
                  child: ListView(
                    shrinkWrap: true,
                    children: banksController.banks.value!
                        .map((e) => WithdrawCard(
                              currentBank: e,
                              image: ImageConstant.visa,
                            ))
                        .toList(),
                  ),
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
                        Get.to(() => BankDetailsScreen(
                              selectedCard:
                                  banksController.currentSelectedBank.value!,
                            ));
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDelegate extends SearchDelegate<Map<String, dynamic>> {
  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.chevron_left),
      onPressed: () =>
          close(context, banksController.currentSelectedBank.value!));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    List? listToShow;
    if (query.isNotEmpty) {
      listToShow = banksController.banks.value
          ?.where(
              (e) => e["name"].contains(query) && e["name"].startsWith(query))
          .toList();
    } else {
      listToShow = banksController.banks.value;
    }

    return ListView.builder(
      itemCount: listToShow?.length ?? 0,
      itemBuilder: (_, i) {
        var noun = listToShow?[i]["name"];
        return ListTile(
          title: Text(noun),
          onTap: () => close(context, listToShow?[i]),
        );
      },
    );
  }
}

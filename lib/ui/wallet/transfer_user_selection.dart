import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/ui/wallet/widget/confirm_transfer.dart';
import 'package:flexx_bet/ui/wallet/widget/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:get/get.dart';

class TransferUserSelectionScreen extends StatelessWidget {
  TransferUserSelectionScreen({super.key, required this.amount});
  final num amount;
  final AuthController _authController = AuthController.to;
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(
      () {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          _authController.loadFiveNextUsers();
        }
      },
    );
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
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 18, 0, 0),
          child: Text(
            "Choose Recipient",
            style: TextStyle(color: ColorConstant.primaryColor, fontSize: 15),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(18),
          padding: const EdgeInsets.all(6),
          width: Get.width / 1.4,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(14)),
          child: TextFormField(
            cursorColor: ColorConstant.primaryColor,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search Users",
                prefixIconColor: ColorConstant.primaryColor,
                prefixIcon: const Icon(Icons.search)),
          ),
        ),
        SizedBox(
          height: 140,
          child: GetBuilder<AuthController>(builder: (controller) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.usersPresent.length,
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return UserCard(
                    onTap: () {
                      controller.otherUser = controller.usersPresent.elementAt(index);
                      confirmTransfer(amount);
                    },
                    photoUrl: controller.usersPresent.elementAt(index)!.photoUrl,
                    userName: controller.usersPresent.elementAt(index)!.username);
              },
            );
          }),
        ),
        const SizedBox(
          height: 70,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     CustomButton(
        //       width: Get.width / 1.2,
        //       text: "Continue",
        //       fontStyle: ButtonFontStyle.PoppinsMedium16,
        //       padding: ButtonPadding.PaddingAll4,
        //       height: 50,
        //       onTap: () {
        //         confirmTransfer();
        //       },
        //     ),
        //   ],
        // ),
      ]),
    );
  }
}

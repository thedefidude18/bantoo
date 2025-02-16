import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/ui/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math' as math;
import 'custom_button.dart';
import 'custom_image_view.dart';

class UserInfoCard extends StatefulWidget {
  const UserInfoCard({
    super.key,
  });

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  final AuthController _authController = AuthController.to;
  @override
  Widget build(BuildContext context) {
    final name = _authController.otherUser!.name;
    final betsLost = _authController.otherUser!.betsLost.length;
    final betsWon = _authController.otherUser!.betsWon.length;
    final followers = _authController.otherUser!.followers.length;
    final totalBets = _authController.otherUser!.allBets.length;
    const rank = 000;
    final image = _authController.otherUser!.photoUrl;
    final about = _authController.otherUser!.about;
    GlobalKey _globelKey = GlobalKey();
    return RepaintBoundary(
      key:_globelKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: Get.height / 1.75,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: Get.height ,
                      width: Get.width / 1.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: <Color>[
                              Color.fromRGBO(215, 200, 255, 1),
                              Color.fromRGBO(239, 239, 239, 1)
                              //add more color here.
                            ],
                          )),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, top: 30, bottom: 10),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 85,
                                    width: 85,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: image,
                                          imageBuilder: (context, imageProvider) =>
                                              Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(100)),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            child: Container(
                                                width: 25,
                                                height: 25,
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: ColorConstant.primaryColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.check,
                                                  color: ColorConstant.whiteA700,
                                                  size: 13,
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "@$name🏆",
                                        style: const TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ColorConstant.fromHex(
                                                        "#5d4599"),
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: Text(
                                              "Rank",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: ColorConstant.fromHex(
                                                      "#5d4599")),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          const Text(
                                            "#$rank",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: Get.width / 2.3,
                                        child: Text(
                                          about,
                                          style: TextStyle(
                                            fontSize: 13,
                                            shadows: [
                                              Shadow(
                                                color: const Color(0x00000000)
                                                    .withOpacity(0.3),
                                                offset: const Offset(.5, 1),
                                                blurRadius: 0,
                                              )
                                            ],
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: 14, left: 14, right: 14, top: 8),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: Colors.white.withAlpha(125),
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 55,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "$followers",
                                          style: TextStyle(
                                              color: ColorConstant.fromHex(
                                                  "#000094"),
                                              fontSize: 20),
                                        ),
                                        Text("Followers",
                                            style: TextStyle(
                                                color: ColorConstant.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11))
                                      ]),
                                ),
                                SizedBox(
                                  width: 55,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "$totalBets",
                                          style: TextStyle(
                                              color: ColorConstant.fromHex(
                                                  "#000094"),
                                              fontSize: 20),
                                        ),
                                        Text("Total events",
                                            style: TextStyle(
                                                color: ColorConstant.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11))
                                      ]),
                                ),
                                SizedBox(
                                  width: 55,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "$betsWon",
                                          style: TextStyle(
                                              color: ColorConstant.fromHex(
                                                  "#000094"),
                                              fontSize: 20),
                                        ),
                                        Text("Wins",
                                            style: TextStyle(
                                                color: ColorConstant.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11))
                                      ]),
                                ),
                                SizedBox(
                                  width: 55,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "$betsLost",
                                          style: TextStyle(
                                              color: ColorConstant.fromHex(
                                                  "#000094"),
                                              fontSize: 20),
                                        ),
                                        Text("Loses",
                                            style: TextStyle(
                                                color: ColorConstant.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11))
                                      ]),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            width: Get.width / 1.5,
                            color: ColorConstant.gray500,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: ColorConstant.fromHex("#0500cd"))),
                              child: Text(
                                "No badge yet",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: ColorConstant.fromHex("#0500cd")),
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          _authController.otherUser!.uid ==
                                  _authController.userFirestore!.uid
                              ? const SizedBox(
                                  height: 49,
                                )
                              : CustomButton(
                                  width: Get.width / 1.3,
                                  height: 49,
                                  variant: ButtonVariant.FillGray90051,
                                  padding: ButtonPadding.PaddingAll4,
                                  fontStyle: ButtonFontStyle.PoppinsSemiBold18,
                                  text: "Challenge me to a bet!  🤑",
                                  onTap: () {
                                    // Get.put(LandingPageController()).changeTabIndex(2);
                                    // Get.back();
                                    // Get.off(() => LandingPage());
                                  },
                                ),
                          const SizedBox(
                            height: 9,
                          ),
                          _authController.otherUser!.uid ==
                                  _authController.userFirestore!.uid
                              ? const SizedBox(
                                  height: 49,
                                )
                              : _authController.userFirestore!.following
                                      .contains(_authController.otherUser!.uid)
                                  ? CustomButton(
                                      width: Get.width / 1.3,
                                      height: 49,
                                      onTap: () async {
                                        await showLoader(() async {
                                          await _authController.removeFollow();
                                          //reloading other user
                                          await _authController
                                              .loadAnotherUserData(
                                                  _authController.otherUser!.uid);
                                        });

                                        setState(() {});
                                        captureAndShareScreenshot(_globelKey);
                                      },
                                      padding: ButtonPadding.PaddingAll4,
                                      fontStyle:
                                          ButtonFontStyle.PoppinsSemiBold18,
                                      text: "Following      |         ",
                                      suffixWidget: CustomImageView(
                                          height: 18,
                                          width: 20,
                                          imagePath: ImageConstant.followMeIcon),
                                    )
                                  : CustomButton(
                                      width: Get.width / 1.3,
                                      height: 40,
                                      onTap: () async {
                                        await showLoader(() async {
                                          await _authController
                                              .followAnotherUser();
                                          await _authController
                                              .loadAnotherUserData(
                                                  _authController.otherUser!.uid);
                                        });
                                        setState(() {});
                                        captureAndShareScreenshot(_globelKey);
                                      },
                                      padding: ButtonPadding.PaddingAll4,
                                      fontStyle:
                                          ButtonFontStyle.PoppinsSemiBold18,
                                      text: "Follow Me       |         ",
                                      suffixWidget: CustomImageView(
                                          height: 18,
                                          width: 20,
                                          imagePath: ImageConstant.followMeIcon),
                                    )
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(.9, -1.1),
                  child: GestureDetector(
                    onTap: () {
                      Get.log("user info card");
                      Get.back();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: ColorConstant.red500,
                          borderRadius: BorderRadius.circular(100)),
                      child: Transform.rotate(
                          angle: 45 * math.pi / 180,
                          child: Icon(
                            Icons.add,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> captureAndShareScreenshot(GlobalKey<State<StatefulWidget>> globalKey) async {
    try {
      RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        // Specify a filename for the shared image
        String fileName = 'screenshot.png';
        // Save the image to the device's temporary directory
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/$fileName').create();
        await file.writeAsBytes(pngBytes);
        // Share the image file
        await Share.shareFiles([file.path], text: 'Check out this profile');
      }
    } catch (e) {
      print('Error capturing screenshot: $e');
    }
  }
}

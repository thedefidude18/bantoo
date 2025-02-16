import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/loader.dart';
import 'package:flexx_bet/ui/components/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonCard extends StatelessWidget {
  const PersonCard(
      {super.key,
      required this.rank,
      required this.userId,
      required this.image,
      required this.name,
      required this.bets});
  final int rank;
  final String name;
  final String image;
  final String userId;
  final num bets;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal:
                    BorderSide(color: ColorConstant.whiteA700, width: 3))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Column(children: [
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        rank % 2 == 0
                            ? ColorConstant.fromHex("#BD616E")
                            : const Color.fromRGBO(254, 210, 84, 1),
                        const Color.fromRGBO(253, 204, 255, 1)
                        //add more color here.
                      ],
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: Text(
                      "$rank",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text("$rank"),
                ]),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    AuthController authController = AuthController.to;
                    await showLoader(
                      () async {
                        await authController.loadAnotherUserData(userId);
                      },
                    );
                    Get.dialog(const UserInfoCard());
                  },
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CachedNetworkImage(
                          height: 60,
                          width: 60,
                          imageUrl: image,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                            ),
                          ),
                        ),
                        rank > 3
                            ? const SizedBox()
                            : Align(
                                alignment: const Alignment(1.2, 1.5),
                                child: GestureDetector(
                                  child: const SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Text(
                                      "🏆",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    Text("$bets🏆")
                  ],
                ),
              ],
            ),
            IgnorePointer(
              child: CustomButton(
                width: Get.width / 4,
                text: "₦1000",
                fontStyle: ButtonFontStyle.InterSemiBold16,
              ),
            )
          ],
        ),
      ),
    );
  }
}

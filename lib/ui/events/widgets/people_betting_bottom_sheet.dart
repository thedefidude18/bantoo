import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/models/models.dart';
import 'package:flexx_bet/ui/events/widgets/opponent_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PeopleBettingBottomSheet extends StatelessWidget {
  const PeopleBettingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: Get.height / 1.1,
      width: Get.width,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 248, 248, 248),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(
        children: [
          Container(
            width: Get.width / 4,
            height: 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorConstant.gray600),
          ),
          SizedBox(
            height: Get.height / 1.9,
            child: ListView.builder(
              itemCount: AuthController.to.usersPresent.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                if (AuthController.to.usersPresent.isNotEmpty) {
                  UserModel user =
                      AuthController.to.usersPresent.elementAt(index)!;
                  return OpponentCard(
                    eventHeldDate:
                        EventsController.to.getCurrentEvent!.heldDate,
                    minimumBet: 500,
                    picked: "yes",
                    eventName: EventsController.to.getCurrentEvent!.title,
                    username: user.username,
                    image: user.photoUrl,
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

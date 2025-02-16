import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/ui/components/badge_popup.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/profile/activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          CustomButton(
            onTap: () async {
              Get.offAllNamed('/');
              AuthController.to
                  .handleAuthChanged(await AuthController.to.getUser);
            },
            text: "Continue App",
          ),
          CustomButton(
            onTap: () {
              badgePopup(BadgeType.master);
            },
            text: "badge master test",
          ),
          CustomButton(
            onTap: () {
              badgePopup(BadgeType.chief);
            },
            text: "badge chief test",
          ),
          CustomButton(
            onTap: () {
              badgePopup(BadgeType.amateur);
            },
            text: "badge Pamateur test",
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
                width: Get.width / 1.1,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.1),
                      offset: const Offset(18, 6),
                      blurRadius: 20,
                      spreadRadius: -10,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    badgeContainer("Amateur", "Complete 5 swipes and profile.",
                        ImageConstant.ameteurBadge, Colors.blue[400], 15),
                    badgeContainer(
                        "Chief",
                        "Complete 30 swipes and referrals 20 users.",
                        ImageConstant.chiefBadge,
                        Colors.yellow[400],
                        13),
                    badgeContainer("Master", "All the above + 50 swipes",
                        ImageConstant.masterBadge, Colors.orange[400], 20),
                  ],
                )),
          )
        ],
      ),
    );
  }
}

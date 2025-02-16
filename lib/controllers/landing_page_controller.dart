import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexx_bet/chat/chat_controller.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/ui/banter/banter.dart';
import 'package:flexx_bet/ui/bets_screens/create_bet_screen.dart';
import 'package:flexx_bet/ui/bets_screens/first_time_create_bet.dart';
import 'package:flexx_bet/ui/home/landing_page_ui.dart';
import 'package:flexx_bet/ui/profile/profile_ui.dart';
import 'package:flexx_bet/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/bets_screens/new_my_bets_screen.dart';

class LandingPageController extends GetxController {
  var tabIndex = 0.obs;
  static LandingPageController to = Get.find();

  Function onChange = () {
    Get.log("LandingPageController onChanged");
  };

  Future changeTabIndex(int index) async {
    Get.log("changeTabIndex");
    if (Get.currentRoute != "/" ||
        Get.currentRoute != "/landing-page" ||
        Get.currentRoute != "/LandingPage") {
      if (index != 2) {
        tabIndex.value = index;
      }
      Get.back();
    }

    if (index == 0) {
      tabIndex.value = index;
      Get.offAll(() => LandingPage());
    }
    if (index == 0) {
      EventsController eventsController = EventsController.to;
      eventsController.categoryName.value = null;
      eventsController.userFilteredAmount.value = null;
      await eventsController.fetchFirstEventsList(null);
    }

    // if (index == 2) {
    // Get.to(() => const BanterScreen());
    // } else
    if (index == 2) {
      showAlertDialog(
          titleText: "Group Creation Fees",
          infoText:
              "N200 fee will be charged from you wallet for group creation",
          buttonText: "Continue",
          buttonTextStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          buttonBackgroundColor: ColorConstant.primaryColor,
          onPressed: () {
            Get.back(result: true);
          }).then((value) {
        if (value == true) {
          checkUserCreatedAnyEvent();
        }
      });
    } else if (index == 3) {
      Get.to(() => NewMyBetsScreen());
    } else if (index == 4) {
      Get.to(() => ProfileScreen());
    } else {
      tabIndex.value = index;
    }
    onChange();
  }

  bool hasCreatedEvent = false;
  String? userId;

  Future<void> checkUserCreatedAnyEvent() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      userId = user.uid;
      String userPrefix = userId!.split('_').first;

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('chatrooms').get();

      bool hasCreatedEvent = false;

      for (var doc in querySnapshot.docs) {
        String admin = doc['admin'];
        if (admin.split('_').first == userPrefix) {
          hasCreatedEvent = true;
          break;
        }
      }

      if (hasCreatedEvent) {
        Get.to(() => CreateBetScreen())?.then((value) {});
      } else {
        Get.to(() => FirstTimeUserCreateGroup())?.then((value) {});
      }
    }
  }
}

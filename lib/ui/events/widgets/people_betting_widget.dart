import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/models/event_model.dart';
import 'package:flexx_bet/ui/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'people_betting_bottom_sheet.dart';

class ShowPeopleBetting extends StatelessWidget {
  ShowPeopleBetting({super.key});

  final EventsController _eventController = EventsController.to;
  final AuthController _authController = AuthController.to;

  @override
  Widget build(BuildContext context) {
    EventModel eventModel = _eventController.getCurrentEvent!;
    onTap() async {
      await showLoader(
        () async {
          await _authController.loadUsersPresent(eventModel.peopleBetting);
        },
      );
      Get.log("usersInEvent :${_authController.usersPresent.length}");
      Get.bottomSheet(const PeopleBettingBottomSheet());
    }

    if (eventModel.peopleBetting.length == 1) {
      return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 100,
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(-1.2, 0),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: ColorConstant.whiteA700),
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      opacity: 0.9,
                      image: AssetImage(ImageConstant.user1),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (eventModel.peopleBetting.length == 2) {
      return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 100,
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(-1.2, 0),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: ColorConstant.whiteA700),
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      opacity: 0.9,
                      image: AssetImage(ImageConstant.user1),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, 0),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: ColorConstant.whiteA700),
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      opacity: 0.9,
                      image: AssetImage(ImageConstant.user2),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (eventModel.peopleBetting.length >= 4) {
      return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 100,
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(-1.2, 0),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: ColorConstant.whiteA700),
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      opacity: 0.9,
                      image: AssetImage(ImageConstant.user1),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, 0),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: ColorConstant.whiteA700),
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      opacity: 0.9,
                      image: AssetImage(ImageConstant.user2),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(1.2, 0),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: ColorConstant.whiteA700),
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      opacity: 0.9,
                      image: AssetImage(ImageConstant.user3),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (eventModel.peopleBetting.length == 3) {
      return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 100,
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(-1.2, 0),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: ColorConstant.whiteA700),
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      opacity: 0.9,
                      image: AssetImage(ImageConstant.user1),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, 0),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: ColorConstant.whiteA700),
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      opacity: 0.9,
                      image: AssetImage(ImageConstant.user2),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(1.2, 0),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: ColorConstant.whiteA700),
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      opacity: 0.9,
                      image: AssetImage(ImageConstant.user3),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(2.4, 0),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 2, color: ColorConstant.whiteA700),
                      borderRadius: BorderRadius.circular(20),
                      color: ColorConstant.primaryColor),
                  child: Center(
                    child: Text(
                      "${eventModel.peopleBetting.length - 3}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: ColorConstant.whiteA700),
          borderRadius: BorderRadius.circular(20),
          color: ColorConstant.primaryColor),
      child: const Center(
        child: Text(
          "0",
          style: TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

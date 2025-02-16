import 'package:badges/badges.dart' as badges;
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/controllers/landing_page_controller.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../models/event_model.dart';

Obx? buildBottomNavigationMenu(context, [String? img]) {
  LandingPageController landingPageController = LandingPageController.to;

  return Obx(() => landingPageController.tabIndex.value == 1
      ? const SizedBox.shrink()
      : Container(
          padding: const EdgeInsets.only(left: 0, bottom: 0, right: 0, top: 2),
          // height: 91,
          child: Container(
            padding: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(1),
                    offset: const Offset(0, 2),
                    blurRadius: 0,
                    spreadRadius: 1,
                  ),
                ],
                color: ColorConstant.primaryColor),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,

              showUnselectedLabels: false,
              showSelectedLabels: false,
              // showSelectedLabels: true,
              onTap: landingPageController.changeTabIndex,
              elevation: 0,
              backgroundColor: Colors.transparent,
              currentIndex: landingPageController.tabIndex.value,
              selectedItemColor: Colors.white,
              // selectedFontSize: 10,
              unselectedLabelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              selectedLabelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              // unselectedFontSize: 12,
              items: [
                // customNavigationBarItem(
                //     label: "Home",
                //     height: 18,
                //     width: 18,
                //     imagePath: ImageConstant.homeIcon1),
                customNavigationBarItem(
                    label: "Games",
                    width: 30,
                    height: 30,
                    imagePath: ImageConstant.activeBetIcon,
                    isBagedIcon: true),
                customNavigationBarItem(
                    width: 35,
                    height: 35,
                    label: "Events",
                    imagePath: ImageConstant.event_icon,
                    isBagedIcon: true),
                customNavigationBarItem(
                  label: "",
                  imagePath: ImageConstant.activeAddIcon,
                  height: 49,
                  width: 49,
                ),
                customNavigationBarItem(
                  label: "MyEvents",
                  imagePath: ImageConstant.activeRankIcon,
                  height: 30,
                  width: 30,
                ),
                customNavigationBarItem(
                  label: "Profile",
                  width: 37,
                  height: 35,
                  imagePath: '',
                  icon: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    backgroundImage: img != null && img.isNotEmpty
                        ? NetworkImage(img)
                        : null,
                    child: img == null || img.isEmpty
                        ? Image.asset(
                            ImageConstant.avatar3,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ));
}

EventsController eventsController = EventsController.to;
final Rxn<List<EventModel>> featuredEvents = Rxn<List<EventModel>>();
BottomNavigationBarItem customNavigationBarItem({
  required String imagePath,
  Widget? icon,
  required String label,
  bool isBagedIcon = false,
  int numberOfMessages = 100,
  required double height,
  required double width,
}) {
  return BottomNavigationBarItem(
    activeIcon: icon ??
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: -8),
              badgeAnimation: const badges.BadgeAnimation.slide(),
              showBadge: isBagedIcon,
              badgeStyle: const badges.BadgeStyle(
                padding: EdgeInsets.all(3),
                badgeColor: Colors.red,
              ),
              badgeContent: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(
                    eventsController.featuredEvents.value?.length.toString() ??
                        "",
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
              child: CustomImageView(
                imagePath: imagePath,
                fit: BoxFit.contain,
                height: height,
                width: width,
              ),
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(
                height: 5,
              ),
              Text(
                label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              )
            ]
            // const SizedBox(
            //   height: 8,
            // ),
            // Container( TODO Active Indicator
            //   decoration: BoxDecoration(
            //       color: Colors.white, borderRadius: BorderRadius.circular(60)),
            //   height: 2,
            //   width: 7,
            // )
          ],
        ),
    icon: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        icon ??
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: -8, end: -14),
              badgeAnimation: const badges.BadgeAnimation.slide(),
              showBadge: isBagedIcon,
              badgeStyle: const badges.BadgeStyle(
                padding: EdgeInsets.all(4),
                badgeColor: Colors.red,
              ),
              badgeContent: Text(
                numberOfMessages > 100 ? "100+" : numberOfMessages.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 8),
              ),
              child: CustomImageView(
                imagePath: imagePath,
                height: height,
                width: width,
              ),
            ),
        if (label.isNotEmpty) ...[
          const SizedBox(
            height: 5,
          ),
          Text(
            label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 10,
                fontWeight: FontWeight.bold),
          )
        ]
      ],
    ),
    label: label,
    backgroundColor: ColorConstant.whiteA700,
  );
}

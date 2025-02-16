import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/ui/banter/banter_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';

class StoryWidget extends StatelessWidget {
  const StoryWidget(
      {super.key,
      required this.image,
      required this.username,
      this.onTap,
      this.isLive = false});
  final String image;
  final void Function()? onTap;
  final String username;
  final bool isLive;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Get.to(() => BanterVideoScreen());
          },
      child: Column(
        children: [
          isLive
              ? badges.Badge(
                  badgeContent: Text(
                    "Live",
                    style:
                        TextStyle(color: ColorConstant.whiteA700, fontSize: 10),
                  ),
                  position: badges.BadgePosition.bottomEnd(end: 25, bottom: 1),
                  badgeStyle: badges.BadgeStyle(
                      borderRadius: BorderRadius.circular(12),
                      shape: badges.BadgeShape.square,
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2)),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    padding: const EdgeInsets.all(2),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: ColorConstant.red500,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(backgroundImage: AssetImage(image)),
                  ),
                )
              : Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  padding: const EdgeInsets.all(2),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: ColorConstant.blue400,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(image),
                    backgroundColor: Colors.grey[400],
                  ),
                ),
          Text(username)
        ],
      ),
    );
  }
}

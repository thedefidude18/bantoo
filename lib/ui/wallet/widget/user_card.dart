import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.photoUrl,
    required this.userName,
    this.onTap,
  });

  final String photoUrl;
  final void Function()? onTap;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width / 3.2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(photoUrl),
                radius: 25,
              ),
              Text(
                userName,
                style:
                    TextStyle(color: ColorConstant.primaryColor, fontSize: 10),
              )
            ]),
      ),
    );
  }
}

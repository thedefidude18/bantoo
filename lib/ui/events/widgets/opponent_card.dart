import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OpponentCard extends StatelessWidget {
  const OpponentCard({
    super.key,
    required this.username,
    required this.image,
    required this.eventHeldDate,
    required this.picked,
    required this.minimumBet,
    required this.eventName,
  });

  final String username;
  final String picked;
  final String image;
  final int minimumBet;
  final String eventName;
  final Timestamp eventHeldDate;

  @override
  Widget build(BuildContext context) {
    final String formattedtime =
        DateFormat("hh:mm a").format(eventHeldDate.toDate());
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.categorySportsImage,
                      height: 20,
                    ),
                    Text(eventName),
                  ],
                ),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(
                    Icons.timer_sharp,
                    size: 16,
                  ),
                  Text(
                    formattedtime,
                    style: const TextStyle(fontSize: 15),
                  )
                ]),
              ],
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
            leading: SizedBox(
              height: 40,
              width: 40,
              child: CachedNetworkImage(
                imageUrl: image,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                  radius: 30,
                ),
              ),
            ),
            title: Text(
              username,
              style: TextStyle(color: ColorConstant.pinkA400),
            ),
            subtitle: Row(
              children: [
                const Text("Picked "),
                Text(
                  picked,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            trailing: SizedBox(
              height: 50,
              child: CustomButton(
                text: "₦ $minimumBet",
                fontStyle: ButtonFontStyle.InterSemiBold16,
                variant: ButtonVariant.FillGray90051,
                onTap: () {},
                width: Get.width / 4.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

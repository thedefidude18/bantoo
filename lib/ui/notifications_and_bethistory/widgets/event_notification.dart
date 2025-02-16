import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class EventNotification extends StatelessWidget {
  final VoidCallback? onTap; // Add this line

  const EventNotification(
      {super.key, required this.image, required this.heading, this.sideImage, this.onTap}); // Update constructor

  final String image;
  final String heading;
  final String? sideImage;

  @override
  Widget build(BuildContext context) {
    final fifteenAgo = DateTime.now().subtract(const Duration(days: 4));
    return GestureDetector( // Wrap the content in GestureDetector
      onTap: onTap, // Trigger the callback on tap
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 14, 8, 14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(image),
              radius: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: sideImage != null ? Get.width / 1.8 : Get.width / 1.3,
                  child: Text(
                    heading,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(timeago.format(fifteenAgo))
              ],
            ),
            CustomImageView(
              imagePath: sideImage,
              height: 45,
            )
          ],
        ),
      ),
    );
  }
}
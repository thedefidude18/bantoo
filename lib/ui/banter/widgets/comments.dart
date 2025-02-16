import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get/get.dart';

class CommentsWidget extends StatelessWidget {
  const CommentsWidget(
      {super.key,
      required this.username,
      required this.image,
      required this.comment,
      required this.postedOn});

  final String username;
  final String image;
  final String comment;
  final DateTime postedOn;

  @override
  Widget build(BuildContext context) {
    String formattedTIme = timeago.format(postedOn);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
                child: CircleAvatar(
                  backgroundImage: AssetImage(image),
                  radius: 25,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width / 1.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          username,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        Text(
                          formattedTIme,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: Get.width / 1.5,
                    child: Text(comment),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: Get.width,
            color: Colors.grey,
            height: .4,
          )
        ],
      ),
    );
  }
}

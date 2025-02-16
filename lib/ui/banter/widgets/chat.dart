import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/banter/comments_screen.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget(
      {super.key,
      required this.username,
      required this.comment,
      required this.commentNumber,
      required this.image,
      required this.likes,
      required this.watched});

  final String username;
  final String comment;
  final String commentNumber;
  final String likes;
  final String watched;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // Get.dialog(UserInfoCard(
                //   name: "Chocoball",
                //   rank: 44,
                //   betsLost: 23,
                //   betsWon: 21,
                //   followers: 2,
                //   following: 1,
                //   totalBets: 3,
                //   image: ImageConstant.user1,
                //   about: "Sent by the pros here",
                // ));
              },
              child: CircleAvatar(
                backgroundImage: AssetImage(image),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Get.dialog(UserInfoCard(
                      //   name: "Chocoball",
                      //   rank: 44,
                      //   betsLost: 23,
                      //   betsWon: 21,
                      //   followers: 2,
                      //   following: 1,
                      //   totalBets: 3,
                      //   image: ImageConstant.user1,
                      //   about: "Sent by the pros here",
                      // ));
                    },
                    child: Text(
                      "$username ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const Text(". 15m")
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0),
                        spreadRadius: -17,
                        blurRadius: 16,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100))),
                child: Text(
                  comment,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.likes,
                        height: 25,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(likes)
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const CommentScreen());
                    },
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.comments,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(commentNumber)
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.watched,
                        height: 25,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(watched)
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: CustomImageView(
                      imagePath: ImageConstant.followMeIcon,
                      height: 20,
                      color: Colors.grey,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

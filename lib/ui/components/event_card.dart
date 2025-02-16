import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/landing_page_controller.dart';

class EventCard extends StatelessWidget {
  EventCard({
    super.key,
    required this.eventId,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.categoryImage,
    required this.category,
    required this.eventHeldDate,
  });
  final String eventId;
  final String imagePath;
  final String title;
  final String subtitle;
  final String category;
  final String categoryImage;
  final DateTime eventHeldDate;

  final List<Color> usernameColors = [Colors.green, Colors.orange, Colors.pink];
  final rng = Random();

  @override
  Widget build(BuildContext context) {
    final String formattedtime = DateFormat("hh:mm a").format(eventHeldDate);
    return Container(
        height: Get.height / 10,
        width: Get.width / 1.1,
        margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: ColorConstant.gray300,
            borderRadius: BorderRadius.circular(15)),
        child: GestureDetector(
          onTap: () async {
            await EventsController.to.setupDetailedEventPage(eventId);
            Get.log("To DetailedEventScreen");
            LandingPageController.to.tabIndex.value = 1;
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: imagePath,
                    imageBuilder: (context, imgProvider) => Container(
                      height: Get.height / 6,
                      width: Get.width / 4.5,
                      decoration: BoxDecoration(
                        color: ColorConstant.black900,
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          opacity: 0.9,
                          image: imgProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => SizedBox(
                        height: Get.height / 6,
                        width: Get.width / 4.5,
                        child:
                            const Center(child: CircularProgressIndicator())),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, top: 6, bottom: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          textAlign:TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12.5,
                              letterSpacing: 0.1,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              subtitle,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstant.gray400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 50,
                    child: Stack(
                      children: [
                        Align(
                          alignment: const Alignment(-1.4, 0),
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorConstant.whiteA700),
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
                          alignment: const Alignment(-.5, 0),
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorConstant.whiteA700),
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
                          alignment: const Alignment(.4, 0),
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorConstant.whiteA700),
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
                          alignment: const Alignment(1.3, 0),
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorConstant.whiteA700),
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                opacity: 0.9,
                                image: AssetImage(ImageConstant.user4),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                        size: 16,
                      ),
                      Text(
                        formattedtime,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            letterSpacing: 0.05,
                            wordSpacing: 0.05),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}

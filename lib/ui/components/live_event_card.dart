import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/controllers/landing_page_controller.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LiveEventCard extends StatelessWidget {
  LiveEventCard(
      {super.key,
      required this.eventId,
      required this.title,
      required this.subtitle,
      required this.imagePath,
      required this.categoryImage,
      required this.categoryName,
      required this.eventHeldDate,
      required this.peopleWaiting});
  final String imagePath;
  final String eventId;
  final String categoryImage;
  final String title;
  final String subtitle;
  final int peopleWaiting;
  final String categoryName;
  final DateTime eventHeldDate;

  final EventsController _eventController = EventsController.to;

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat("dd MMM yy").format(eventHeldDate);
    final String formattedtime = DateFormat("hh:mm a").format(eventHeldDate);
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: ColorConstant.whiteA700,
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 0),
              spreadRadius: -2,
              blurRadius: 6,
              color: Colors.grey,
            )
          ]),
      child: GestureDetector(
        onTap: () async {
          await _eventController.setupDetailedEventPage(eventId);
          LandingPageController.to.tabIndex.value = 1;
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: imagePath,
                      placeholder: (context, url) => SizedBox(
                          height: Get.height / 6,
                          width: Get.width / 1.5,
                          child:
                              const Center(child: CircularProgressIndicator())),
                      imageBuilder: (context, imageProvider) => Container(
                        height: Get.height / 6,
                        width: Get.width / 1.5,
                        decoration: BoxDecoration(
                          color: ColorConstant.black900,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          image: DecorationImage(
                            opacity: 0.9,
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              title,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: ColorConstant.whiteA700,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: Get.height / 15,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.grey,
                              ),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                color: Colors.grey,
                              ),
                              Text(
                                formattedtime,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  height: 1,
                  color: ColorConstant.gray400,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18.0, right: 18.0, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 40,
                        child: Stack(
                          children: [
                            Align(
                              alignment: const Alignment(0, 0),
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorConstant.whiteA700),
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                    image: AssetImage(ImageConstant.user1),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(1.4, 0),
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorConstant.whiteA700),
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                    image: AssetImage(ImageConstant.user2),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(2.8, 0),
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorConstant.whiteA700),
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                    image: AssetImage(ImageConstant.user3),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(4.6, 0),
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorConstant.whiteA700),
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                    image: AssetImage(ImageConstant.user4),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      peopleWaiting > 0
                          ? Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: ColorConstant.liveEventWaitlistColor),
                              child: Text(
                                "$peopleWaiting players waiting",
                                style: TextStyle(
                                    fontSize: 12, color: ColorConstant.blue400),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 10, top: 10),
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                decoration: BoxDecoration(
                    color: ColorConstant.whiteA700,
                    borderRadius: BorderRadius.circular(100)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    categoryImage.isURL
                        ? Image.network(
                            categoryImage,
                            height: 25,
                          )
                        : CustomImageView(
                            imagePath: categoryImage,
                            height: 25,
                          ),
                    Text(
                      categoryName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

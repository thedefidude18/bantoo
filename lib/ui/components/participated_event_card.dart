import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/helpers/duration_difference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParticipatedEventCard extends StatelessWidget {
  const ParticipatedEventCard({
    super.key,
    required this.title,
    required this.profit,
    required this.imagePath,
    required this.subTitle,
    required this.eventHeldDate,
  });
  final String imagePath;
  final String title;
  final int profit;

  final String subTitle;
  final DateTime eventHeldDate;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Get.height / 10,
        width: Get.width / 1.1,
        margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: ColorConstant.gray300,
            borderRadius: BorderRadius.circular(15)),
        child: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: Get.height / 6,
                    width: Get.width / 4.5,
                    decoration: BoxDecoration(
                      color: ColorConstant.black900,
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        opacity: 0.9,
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, top: 6, bottom: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12.5,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          subTitle,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.gray400),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.grey,
                              size: 16,
                            ),
                            Text(
                              "${durationBetween(DateTime.now(), eventHeldDate).inDays * -1} days ago | Ended",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  letterSpacing: 0.05,
                                  wordSpacing: 0.05),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    profit > 0 ? "+\$$profit " : "-\$${profit * -1}",
                    style: TextStyle(
                        color: profit > 0 ? Colors.green : Colors.red),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: profit > 0 ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_drop_up,
                          color: Colors.white,
                        ),
                        Text(
                          "+13.25% ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

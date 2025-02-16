import 'package:flexx_bet/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TransactionHistoryCard extends StatelessWidget {
  const TransactionHistoryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.imagePath,
    required this.subTitle,
    required this.eventHeldDate,
  });
  final String imagePath;
  final String title;
  final num amount;

  final String subTitle;
  final DateTime eventHeldDate;

  @override
  Widget build(BuildContext context) {
    String time = eventHeldDate.toString().split(' ')[1].split('.')[0];
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
                    height: 60,
                    width: 30,
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, top: 6, bottom: 6),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: Get.width * 0.45),
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.black,
                                  fontFamily: "Inter",
                                  letterSpacing: 0.1,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: Get.width * 0.6),
                            child: Text(
                              subTitle,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstant.gray600),
                            ),
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
                                "${eventHeldDate.timeAgo()} | $time",
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
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: amount > 0 ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 1.0),
                          child: Text(
                            amount > 0 ? "+₦$amount " : "-₦${amount * -1}",
                            style: const TextStyle(
                                color: Colors.white, fontFamily: "Inter"),
                          ),
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

extension DateTimeExtension on DateTime {
  String timeAgo({bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}

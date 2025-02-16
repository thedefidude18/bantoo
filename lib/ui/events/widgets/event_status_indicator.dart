import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flutter/material.dart';

class EventStatusIndictor extends StatelessWidget {
  const EventStatusIndictor(
      {super.key,
      required this.isLive,
      required this.isCancelled,
      required this.isEnded});

  final bool isLive;
  final bool isCancelled;
  final bool isEnded;
  @override
  Widget build(BuildContext context) {
    return isCancelled
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.6),
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Image.asset(
                  ImageConstant.liveCircles,
                  color: Colors.red,
                  height: 10,
                  width: 10,
                ),
                const Text(
                  " Cancelled",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          )
        : isEnded
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.6),
                  border: Border.all(color: Colors.yellow),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      ImageConstant.liveCircles,
                      color: Colors.yellow,
                      height: 10,
                      width: 10,
                    ),
                    const Text(
                      " Ended",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              )
            : isLive
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    decoration: BoxDecoration(
                      color: ColorConstant.liveEventIndicator.withOpacity(0.6),
                      border:
                          Border.all(color: ColorConstant.liveEventIndicator),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          ImageConstant.liveCircles,
                          height: 10,
                          width: 10,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        const Text( 
                          "LIVE",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.6),
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          ImageConstant.liveCircles,
                          color: Colors.blue,
                          height: 10,
                          width: 10,
                        ),
                        const Text(
                          " Upcoming",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  );
  }
}

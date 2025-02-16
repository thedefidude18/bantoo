import 'dart:io';

import 'package:flexx_bet/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventList extends StatelessWidget {
  const EventList(
      {super.key,
      required this.events,
      required this.heading,
      required this.fullHeight,
      required this.trailing});

  final List<Widget>? events;
  final String heading;
  final Widget trailing;
  final bool fullHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            color: ColorConstant.whiteA700,
            borderRadius: BorderRadius.circular(15)),
        width: Get.width / 1.05,
        height: fullHeight ? Get.height : Get.height / 1.5,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      heading,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing
                  ],
                ),
              ),
              SizedBox(
                width: Get.width / 1.05,
                height: 450,
                child: ListView(
                  physics: Platform.isIOS
                      ? const ClampingScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  children: events ??
                      [
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

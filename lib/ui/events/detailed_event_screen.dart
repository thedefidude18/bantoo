import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/models/event_model.dart';
import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/events/widgets/swipe_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../bets_screens/bets_screen.dart';

class DetailedEventScreen extends StatefulWidget {
  String id;
  DetailedEventScreen(this.id, {super.key});

  @override
  State<DetailedEventScreen> createState() => _DetailedEventScreenState();
}

class _DetailedEventScreenState extends State<DetailedEventScreen> {
  @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: false,
        showBetCreateButton: false,
        showCreateEvent: false,
        showSearchButton: true,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<EventsController>(builder: (controller) {
          EventModel? eventModel = controller.getCurrentEvent;
          bool isLive = false;
          if (eventModel != null) {
            isLive = eventModel.heldDate.microsecondsSinceEpoch <
                    Timestamp.now().microsecondsSinceEpoch &&
                !eventModel.isEnded &&
                !eventModel.isCancelled;
          }
          return Builder(builder: (context) {
            if (eventModel != null) {
              //  final String formattedtime = DateFormat("hh:mm:ss a").format(eventModel!.heldDate.toDate());
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.745, child: EventSwiper(widget.id)),

                ],
              );
            } else {
              return Container();
            }
          });
        }),
      ),
    );
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    var data = await FirebaseDynamicLinks.instance.getInitialLink();
    var deepLink = data;

    /// When app is killed state
    if (deepLink != null) {
      deepLink.link.queryParameters['invitedCode'] ?? '';
      print(deepLink.link.queryParameters['invitedCode'] ?? '');
    }

    /// When app is live and background state
    dynamicLinks.onLink.listen((dynamicLinkData) {
      dynamicLinkData.link.queryParameters['invitedCode'] ?? '';
      print(dynamicLinkData.link.queryParameters['invitedCode'] ?? '');
    }).onError((error) {
      print(error.message);
    });
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.5),
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 467,
            width: 353,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorConstant.gradiant1, ColorConstant.gradiant2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Please Read Terms.",
                  style: TextStyle(
                      color: ColorConstant.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Popins"),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Please read and agree to terms before you proceed.\nPlease read and agree to terms before you proceed\nPlease read and agree to terms before you proceed\nPlease read and agree to terms before you proceed\nPlease read and agree to terms before you proceed",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontFamily: "Popins"),
                ),
                const Spacer(),
                CustomButton(
                  text: "Proceed",
                  fontStyle: ButtonFontStyle.InterSemiBold16,
                  onTap: () {
                    Get.to(const BetScreen());
                  },
                  height: 48,
                  width: 307,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

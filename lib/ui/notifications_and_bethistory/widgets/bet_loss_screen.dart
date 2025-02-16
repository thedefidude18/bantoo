import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flexx_bet/models/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../components/custom_appbar.dart';

class BetLossScreen extends StatefulWidget {
  NotificationModel notificationModel;
   BetLossScreen(this.notificationModel, {super.key});

  @override
  State<BetLossScreen> createState() => _BetLossScreenState();
}

class _BetLossScreenState extends State<BetLossScreen> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  bool isLoading = false;
  GlobalKey _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      appBar: const CustomAppBar(
        showBackButton: true,
        showBetCreateButton: false,
        showCreateEvent: false,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RepaintBoundary(
            key: _globalKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(ImageConstant.event_loss_image),
                    const Positioned(
                      top: 12,
                      left: 30,
                      child: Text(
                        'YOU LOST!',
                        style: TextStyle(
                            fontSize: 55,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Popins",
                            color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 70,
                      child: RichText(
                        text:  TextSpan(
                            text: "You lost the challenge against ",
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: "Popins"),
                            children: [
                              TextSpan(
                                text: " @${
                                    widget.notificationModel.body.contains('against')
                                        ? widget.notificationModel.body
                                        .split("against")[1]
                                        : widget.notificationModel.body
                                } ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.lightGreenAccent,
                                    fontSize: 13,
                                    fontFamily: "Popins"),
                              ),
                              TextSpan(
                                text: '\n                   in the event'
                                    '\n${widget.notificationModel.title}',
                              ),
                            ]),
                      ),
                    ),
                    Positioned(
                        top: 170,
                        left: 100,
                        child: Image.asset(
                          ImageConstant.bet_loss_emoji,
                          width: 165,
                          height: 167,
                        )),
                    Positioned(
                        top: 400,
                        left: 80,
                        child:Container(
                          width: 202,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(21),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8,right: 8),
                            child: Row(
                              children: [
                                Image.asset(ImageConstant.star_icon,width: 16,height: 15,),
                                const SizedBox(
                                  width: 14,
                                ),
                                 Text("EVENT ID - #${widget.notificationModel.eventId.substring(widget.notificationModel.eventId.length - 6).toUpperCase()}",style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: "Popins"),)
                              ],
                            ),
                          ),
                        )
                    ),
                    Positioned(
                        top: 450,
                        left: 100,
                        child: Row(
                          children: [
                            const Text(
                              "Staked",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "Popins"),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                             Text(
                              "₦${widget.notificationModel.amount}|",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "Popins"),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Container(
                              height: 19,
                              width: 78,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(31)),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.arrow_drop_up,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "-13.25%",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: "Popins"),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                    Positioned(
                        top: 470,
                        left: 110,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "₦",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontFamily: "Popins"),
                            ),
                            Text(
                              widget.notificationModel.amount,
                              style: GoogleFonts.changa(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 70,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size(175, 48)),
                            backgroundColor: MaterialStateProperty.all(
                                ColorConstant.primaryColor),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                        onPressed: () {},
                        child: const Text(
                          "Join more events",
                          style: TextStyle(
                              fontFamily: "Popins",
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        )),
                    ElevatedButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                              const Size(170, 48),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                ColorConstant.primaryColor),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                        onPressed: () {},
                        child: InkWell(
                          onTap: (){
                            captureAndShareScreenshot(_globalKey);
                          },
                          child: Row(
                            children: [
                             isLoading?const Center(child: CircularProgressIndicator(),) :Image.asset(
                                ImageConstant.event_share_icon,
                                height: 19,
                                width: 19,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              const Text(
                                "Share",
                                style: TextStyle(
                                    fontFamily: "Popins",
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )),
                  ],
                )
              ],
            ),
          )),
    );
  }
  Future<void> captureAndShareScreenshot(GlobalKey<State<StatefulWidget>> globalKey) async {
    // Ensure the widget is fully painted before capturing the screenshot
    await WidgetsBinding.instance.endOfFrame;

    setState(() {
      isLoading = true;
    });
    try {
      RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 0.5);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/screenshot.png').create();
        await file.writeAsBytes(pngBytes);
        final dynamicLink = await createDynamicLink("DataAmSending");
        await Share.shareFiles([file.path], text: dynamicLink);
      }
    } catch (e) {
      print('Error capturing screenshot: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<String> createDynamicLink(String eventId) async {
    String code = eventId;
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://flexxbet.page.link',
      link: Uri.parse(
        'https://flexxbet.page.link/betLoss',
      ),
      androidParameters: const AndroidParameters(
        packageName: 'com.flexxbet.app',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.flexxbet.app',
      ),
      socialMetaTagParameters: const SocialMetaTagParameters(
        title: 'Hey I have Loss this event !!',
        //description: 'Refer and earn points',
      ),
    );

    final ShortDynamicLink shortDynamicLink = await dynamicLinks.buildShortLink(
      dynamicLinkParameters,
    );
    final Uri dynamicUrl = shortDynamicLink.shortUrl;
    print(dynamicUrl.toString());
    return dynamicUrl.toString();
  }
}

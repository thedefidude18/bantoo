import 'dart:io';
import 'dart:ui' as ui;

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flexx_bet/controllers/achievements_controller.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/controllers/wallet_controller.dart';
import 'package:flexx_bet/models/event_model.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/events/widgets/event_join_massages_popup.dart';
import 'package:flexx_bet/ui/events/widgets/event_status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flexx_bet/ui/components/loader.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/bet_controller.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/events/widgets/bet_confirmation.dart';
import 'package:flexx_bet/ui/events/widgets/filter_bottom_sheet.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flexx_bet/models/notification_model.dart' as model;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../controllers/notification_controller.dart';
import '../../../models/user_model.dart';
import 'bet_confirmation_success.dart';
import 'insufficient_balance_dialog.dart';

class EventSwiper extends StatefulWidget {
  String id;
  EventSwiper(this.id, {super.key});

  @override
  State<EventSwiper> createState() => _EventSwiperState();
}

class _EventSwiperState extends State<EventSwiper>
    with SingleTickerProviderStateMixin {
  final BetsController _betsController = BetsController.to;

  final AchievementController _achievementController = AchievementController.to;

  final EventsController _eventsController = EventsController.to;

  final WalletContoller _walletController = WalletContoller.to;

  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;
  int amount = 0;
  String eventSearchId = '';

  final AppinioSwiperController appinioSwiperController =
      AppinioSwiperController();

  final NotificationController notificationController =
      Get.put<NotificationController>(NotificationController());

  @override
  void initState() {
    super.initState();
    eventSearchId = widget.id;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _colorAnimation1 =
        ColorTween(begin: Colors.green.shade100, end: Colors.green.shade200)
            .animate(_animationController);

    _colorAnimation2 =
        ColorTween(begin: Colors.red.shade100, end: Colors.red.shade200)
            .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventsController>(builder: (eventsController) {
      if (eventsController.fiveNextEvents.isEmpty) {
        return  Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withOpacity(0.87),
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            content:Container(
              decoration:  BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xffEFEFEF),
                        Color(0xffD7C8FF)
                      ]
                  ),
                  borderRadius: BorderRadius.circular(28)
              ),
              height: 398,
              width: MediaQuery.of(context).size.width,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset(ImageConstant.timer_icon,height: 79,width: 78,),
                const SizedBox(
                  height: 40,
                ),
                const Text("Event are currently being\n updated for this amount",style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Inter"
                ),),
              const SizedBox(
                height: 100,
              ),
                CustomButton(
                  width: 307,
                  height: 48,
                  text: "Check other events   ",
                  fontStyle:ButtonFontStyle.PoppinsMedium16,
                  suffixWidget: Image.asset(
                      ImageConstant.filter_icon
                  ),
                  onTap: () async {
                    await Get.bottomSheet(const BottomFilterSheet(),
                        isScrollControlled: true, persistent: true);
                  },
                ),
              ]),
            ),


          ),
        );
      } else {
        Future.delayed(const Duration(milliseconds: 1)).then((value) async {
          if (eventSearchId != "") {
            final index = eventsController.fiveNextEvents
                .indexWhere((item) => item.uid == widget.id);

            if (index != -1) {
              _eventsController.eventFilterUserId.value = eventSearchId;
              eventSearchId = "";
              await showLoader(() async =>
                  await _eventsController.fetchFirstEventsList(null));
            }
          }
        });
      }

      return Stack(
        children: [
          GestureDetector(
            onHorizontalDragUpdate: (details) {},
            child: AppinioSwiper(
              cardCount: eventsController.fiveNextEvents.length,
              controller: appinioSwiperController,
              loop: true,
              swipeOptions: const SwipeOptions.only(),
              //onSwipeEnd: onCardSwiped,
              threshold: 100,
              cardBuilder: (BuildContext context, int index) {
                EventModel listEvent = eventsController.fiveNextEvents[index];
                bool isLive = listEvent.heldDate.microsecondsSinceEpoch <
                        Timestamp.now().microsecondsSinceEpoch &&
                    !listEvent.isEnded &&
                    !listEvent.isCancelled;
                GlobalKey _globalKey = GlobalKey();
                return Padding(
                  padding: const EdgeInsets.only(top: 6, left: 6, right: 6),
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: CachedNetworkImage(
                      imageUrl: listEvent.eventBanner,
                      imageBuilder: (context, imageProvider) => Container(
                          padding: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              // opacity: 0.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await Get.bottomSheet(
                                          const BottomFilterSheet(),
                                          isScrollControlled: true);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Image.asset(
                                        ImageConstant.newfilterButton,
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(),
                                  InkWell(
                                      onTap: () {
                                        captureAndShareScreenshot(
                                            _globalKey, listEvent);
                                      },
                                      child: isLoading
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                strokeAlign: 1,
                                              ),
                                            )
                                          : Container(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              decoration:
                                                  BoxDecoration(boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.54),
                                                  offset: const Offset(-2, 4),
                                                  blurRadius: 12,
                                                  spreadRadius: -3,
                                                )
                                              ]),
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.black,
                                                child: SvgPicture.asset(
                                                  'assets/images/Subtract.svg',
                                                ),
                                              ),
                                            )),
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 7),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        EventStatusIndictor(
                                          isCancelled: listEvent.isCancelled,
                                          isEnded: listEvent.isEnded,
                                          isLive: isLive,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          height: 23,
                                          width: 79,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                right: 54,
                                                top: 0,
                                                bottom: 0,
                                                child: CircleAvatar(
                                                  radius: 11,
                                                  child: Image.asset(
                                                    ImageConstant.avatar1,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 37,
                                                top: 0,
                                                bottom: 0,
                                                child: CircleAvatar(
                                                  radius: 11,
                                                  child: Image.asset(
                                                    ImageConstant.avatar2,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 21,
                                                child: CircleAvatar(
                                                  radius: 11,
                                                  child: Image.asset(
                                                    ImageConstant.avatar3,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                child: CircleAvatar(
                                                  radius: 11,
                                                  child: Text(
                                                    "+${listEvent.peopleWaiting.length}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: -2.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 220,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(0xD6000000),
                                            Color(0xFF000000),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: Get.width / 1.2,
                                              child: Text(
                                                listEvent.title,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                _showPriceBottomSheet(context);
                                              },
                                              child: Container(
                                                /*height: 30,
                                                width: 100,*/
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 1,
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                  color: ColorConstant
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  "₦ ${listEvent.amount}",
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Inter",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      appinioSwiperController
                                                          .swipeLeft();
                                                      onCardSwiped(index, true);
                                                      // playSlideSound();
                                                    },
                                                    child: const CircleAvatar(
                                                      radius: 34,
                                                      backgroundColor:
                                                          Color(0xffFF4040),
                                                      child: Text(
                                                        "NO",
                                                        style: TextStyle(
                                                          fontSize: 27,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 1,
                                                  ),
                                                  Text(
                                                    "Swipe left for NO",
                                                    style: TextStyle(
                                                      color: ColorConstant
                                                          .whiteA700,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      appinioSwiperController
                                                          .swipeRight();
                                                      onCardSwiped(index, false);
                                                      // playSlideSound();
                                                    },
                                                    child: const CircleAvatar(
                                                      radius: 34,
                                                      backgroundColor:
                                                          Color(0xff0BBB77),
                                                      child: Text(
                                                        "YES",
                                                        style: TextStyle(
                                                          fontSize: 27,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white,
                                                          fontFamily: 'Poppins',
                                                          shadows: [
                                                            Shadow(
                                                              color: Color(
                                                                  0X40000000),
                                                              offset:
                                                                  Offset(0, 0),
                                                              blurRadius: 8,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 1,
                                                  ),
                                                  Text(
                                                    "Swipe right for YES",
                                                    style: TextStyle(
                                                      color: ColorConstant
                                                          .whiteA700,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  void onCardSwiped(int index, bool isNo) async {
    Get.log("Swiped event");
    AuthController authController = AuthController.to;
    final UserModel userModel = authController.userFirestore!;
    List events = _eventsController.fiveNextEvents;
    EventModel event = events[index];
    Get.log("length: ${events.length}");
    Get.log("index: ${index}");

    if (isNo) {
      await _achievementController.addSwipe();
      if (!_betsController.isBetLive) {
        EventJoinMassagesPopup.showEventEndPopup(context);
      } else if (_walletController.totalAmount.value! < event.amount) {
        insufficientBalanceDialog(event.amount);
      } else if (_betsController.isJoinBetPossible) {
        await showLoader(() async {
          await _betsController.joinBet();
          await _walletController.bet(event.amount, event.title);
        });
        awesomeNotifications.createNotification(
            content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          actionType: ActionType.Default,
          title: 'Hurrah you joined event successfully',
          body:
              'Your bet for "${event.title}" is started please wait for the results',
        ));
        betConfirmationSuccess(true);
        AuthController authController = AuthController.to;
        final UserModel userModel = authController.userFirestore!;
        model.NotificationModel notificationModel = model.NotificationModel(
          userId: userModel.uid,
          body:
              'You have successfully matched ${_betsController.currentBet.value?.firstUsername}',
          type: "Matched",
          creationDate: DateTime.now(),
          title: event.title,
          amount: event.amount.toString(),
          selectedOption: "",
          eventId: ""
        );
        await notificationController.addNotification(notificationModel);


      } else if (_betsController.isNewBetPossible) {
        await Get.dialog(BetConfirmation(eventData: event));
        if(event.peopleWaiting.length > 1){
          EventJoinMassagesPopup.showPositionPopup(context,event);
          AuthController authController = AuthController.to;
          final UserModel userModel = authController.userFirestore!;
          model.NotificationModel notificationModel = model.NotificationModel(
            userId: userModel.uid,
            body:' There are over ${event.peopleWaiting.length} players\ncurrently betting',
            type: "Waiting_Number",
            creationDate: DateTime.now(),
            title: 'You have chosen the event "${event.title}"',
            amount: event.amount.toString(),
            selectedOption: "",
            eventId: ""
          );
          await notificationController.addNotification(notificationModel);
        }else{
          EventJoinMassagesPopup.showOpponentPopup(context,event);
          AuthController authController = AuthController.to;
          final UserModel userModel = authController.userFirestore!;
          model.NotificationModel notificationModel = model.NotificationModel(
            userId: userModel.uid,
            body:' There are over ${event.peopleWaiting.length} players\ncurrently betting',
            type: "Waiting",
            creationDate: DateTime.now(),
            title: 'You have chosen the event "${event.title}"',
            amount: event.amount.toString(),
            selectedOption: "",
            eventId: ""
          );
          await notificationController.addNotification(notificationModel);
        }

        await showLoader(() async {
          await _walletController.bet(event.amount, event.title);
        });
        awesomeNotifications.createNotification(
            content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          actionType: ActionType.Default,
          title: 'You have chosen the event "${event.title}"',
          body:' There are over ${event.peopleWaiting.length} players\ncurrently betting',
        ));

      } else {
        Get.showSnackbar(const GetSnackBar(
            duration: Duration(seconds: 2),
            title: "Event Not Possible",
            message: "You are already in event",
            snackPosition: SnackPosition.BOTTOM));
      }
    }
    Get.log("-------------Current event operations completed-----------");
    Get.log("-------------Next event handle-----------");
    await showLoader(() async {
      if (index == events.length - 1) {
        await _eventsController.loadFiveNextEvents();
      }
      _eventsController.setCurrentEvent(events[index]);
      await _betsController.getBetWithRequirements();
      setState(() {});
    });
    Get.log("-----------");
  }

  bool isLoading = false;

  Future<void> captureAndShareScreenshot(
      GlobalKey<State<StatefulWidget>> globalKey, EventModel listEvent) async {
    setState(() {
      isLoading = true;
    });
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // Adjust pixel ratio if high resolution is not required
      ui.Image image = await boundary.toImage(pixelRatio: 0.5);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        // Save the image to the device's temporary directory
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/screenshot.png').create();
        await file.writeAsBytes(pngBytes);
        final dynamicLink =
            await _eventsController.createDynamicLink("DataAmSending");
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

  void _showPriceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withAlpha(200),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      builder: (BuildContext context) {
        TextEditingController _amountController = TextEditingController();

        void _setAmount(int increment) {
          String amountText = _amountController.text;

          // Extracting only numeric characters and currency symbols
          String numericAmount = amountText.replaceAll(RegExp(r'[^\d₦]'), '');

          int currentAmount = int.tryParse(numericAmount) ?? 0;
          currentAmount += increment;

          // Set the amount back to the text field
          _amountController.text = "₦ $currentAmount";
        }

        return Center(
          child: Container(
            height: 275,
            width: 352,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorConstant.gradiant1,
                  ColorConstant.gradiant2,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
                bottomRight: Radius.circular(28),
                bottomLeft: Radius.circular(28),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _setAmount(100),
                        child: Container(
                          width: 84,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: ColorConstant.primaryColor,
                          ),
                          child: const Center(
                            child: Text(
                              "₦ 100",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Popins",
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _setAmount(200),
                        child: Container(
                          width: 84,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: ColorConstant.primaryColor,
                          ),
                          child: const Center(
                            child: Text(
                              "₦ 200",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Popins",
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _setAmount(500),
                        child: Container(
                          width: 84,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: ColorConstant.blueGray40002,
                          ),
                          child: Center(
                            child: Text(
                              "₦ 500",
                              style: TextStyle(
                                color: ColorConstant.whiteA700,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Popins",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter Event amount",
                    style: TextStyle(
                      fontSize: 15,
                      color: ColorConstant.blueGray400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (amount > 10) amount = amount - 10;
                                _amountController.text = "$amount";
                              });
                            },
                            icon: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(70)),
                              child: const Center(
                                  child: Text(
                                "-",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                            )),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "₦",
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Inter",
                                fontSize: 20),
                          ),
                          SizedBox(
                            width: Get.width / 3,
                            child: TextField(
                              controller: _amountController,
                              decoration: const InputDecoration.collapsed(
                                hintText: "100",
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (val) {
                                amount = val.isNotEmpty ? int.parse(val) : 0;
                              },
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontFamily: "Inter",
                                  fontSize: 50),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                amount = amount + 10;
                                _amountController.text = "$amount";
                              });
                            },
                            icon: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(70)),
                              child: const Center(
                                  child: Text(
                                "+",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    height: 48,
                    width: 307,
                    text: "Proceed to swipe Yes or No",
                    fontStyle: ButtonFontStyle.InterSemiBold16,
                    onTap: () async {
                      _eventsController.userFilteredAmount.value = amount;
                      Get.back();
                      await showLoader(() async =>
                          await _eventsController.fetchFirstEventsList(null));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



}

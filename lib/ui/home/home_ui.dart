import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/models/event_model.dart';
import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flexx_bet/ui/components/event_card.dart';
import 'package:flexx_bet/ui/components/event_list.dart';
import 'package:flexx_bet/ui/components/live_event_card.dart';
import 'package:flexx_bet/ui/components/scroll_parent.dart';
import 'package:flexx_bet/ui/events/all_featured_events.dart';
import 'package:flexx_bet/ui/events/all_live_events.dart';
import 'package:flexx_bet/ui/events/widgets/swipe_widget.dart';
import 'package:flexx_bet/ui/home/widgets/home_banner_slider.dart';
import 'package:flexx_bet/ui/home/widgets/single_banner.dart';
import 'package:flexx_bet/ui/home/widgets/single_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../events/detailed_event_screen.dart';
import '../notifications_and_bethistory/push_notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventsController _eventsController = EventsController.to;

  final List<dynamic> categoriesNewList = [
    {
      "name":"Games",
      "category": "game",
      "imagePath": ImageConstant.gamepadImage,
      "gradiant":[Color(0xff7440FF), Color(0xff04010E)]
    },
    {
      "name":"Sports",
      "category": "sports",
      "imagePath": ImageConstant.categorySportsImage,
      "gradiant":[Color(0xff1B24FF), Color(0xff04010E)]
    },{
    "name":"Music",
      "category": "music",
      "imagePath": ImageConstant.djSetup,
      "gradiant":[Color(0xff34C759), Color(0xffFD495E)]
    },
    {
      "name":"Crypto",
      "category": "crypto",
      "imagePath": ImageConstant.bitCoinImage,
      "gradiant":[Color(0xffFF9900), Color(0xff7440FF)]
    },
    {
      "name":"Movies/TV",
      "category": "movies/tv",
      "imagePath": ImageConstant.popCornBoxImage,
      "gradiant":[Color(0xffFF2C2C), Color(0xff080742)]
    },
    {
      "name":"Pop Culture",
      "category": "pop culture",
      "imagePath": ImageConstant.popCultureImage,
      "gradiant":[Color(0xff6B0CFF), Color(0xff266939)]
    },
    {
      "name":"Forex",
      "category": "forex",
      "imagePath": ImageConstant.forex,
      "gradiant":[Color(0xff00A3FF), Color(0xff64EA25)]
    },
    {
      "name":"Politics",
      "category": "politics",
      "imagePath": ImageConstant.politicsImage,
      "gradiant":[Color(0xffFFBF66), Color(0xff7440FF)]
    },


  ];

  final _messagingService =
  MessagingService();


  @override
  void initState() {
    super.initState();
    _messagingService
        .init(context).then((value){
      saveFCMToken();
    });
    initDynamicLinks();

  }


  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    var data = await FirebaseDynamicLinks.instance.getInitialLink();
    var deepLink = data;

    /// When app is killed state
    if (deepLink != null) {
      print("Dataaaaa");
      print(deepLink.link.queryParameters['invitedCode'] ?? '');
      print("Dataaaaa");
    }else{
      print("nullllllll");
    }

    /// When app is live and background state
    dynamicLinks.onLink.listen((dynamicLinkData) {
      print("Dataaaaa");
         print(dynamicLinkData.link.queryParameters['invitedCode'] ?? '') ;
      print("Dataaaaa");
    }).onError((error) {
      print(error.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final List<SingleBanner> banners = [
      const SingleBanner(
          imagePath: ImageConstant.homeSlideBanner1,
          subTitle: "Becoming Street Smarter",
          title: "Becoming Street",
        url: "https://flexxbet-1.gitbook.io/flexxbet/",
      ),
      const SingleBanner(
        imagePath: ImageConstant.homeSlideBanner2,
        subTitle: "",
        title: "",
        url: "https://flexxbet-1.gitbook.io/flexxbet/",
        showOverlay: false,
      )
    ];

    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 2,
            ),
            HomeBannerSlider(
              banners: banners,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: Get.height / 5,
              child: ListView.builder(
                itemCount: categoriesNewList.length,
                itemBuilder: (context, index) {
                return GestureDetector(
                  onTap:() async {
                    _eventsController.categoryName.value = categoriesNewList[index]['category'];
                    await _eventsController.fetchFirstEventsList(null);
                    Get.to(() =>  DetailedEventScreen(""));
                  },
                  child: CategoryWidget(
                    name: categoriesNewList[index]['name'],
                    imagePath: categoriesNewList[index]['imagePath'],
                    gradientColors: categoriesNewList[index]['gradiant'],
                  ),
                );
                },
                scrollDirection: Axis.horizontal,

              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Live events 🔥",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.log("To AllLiveEventsScreen");
                      Get.to(() => const AllLiveEventsScreen());
                    },
                    child: const Text(
                      "Show all",
                    ),
                  ),
                ],
              ),
            ),
            CarouselSlider.builder(
              itemCount: _eventsController.liveEvents.value?.length ?? 0,
              itemBuilder: (context, index, realIndex) {
                if (_eventsController.liveEvents.value != null) {
                  EventModel e = _eventsController.liveEvents.value![index];
                  return LiveEventCard(
                    eventId: e.uid,
                    subtitle: e.subtitle,
                    title: e.title,
                    categoryName: e.category,
                    eventHeldDate: e.heldDate.toDate(),
                    categoryImage: ImageConstant.categorySportsImage,
                    imagePath: e.eventBanner,
                    peopleWaiting: e.peopleWaiting.length,
                  );
                } else {
                  return const SizedBox();
                }
              },
              options: CarouselOptions(
                enableInfiniteScroll: false,
                viewportFraction: .7,
                disableCenter: true,
                autoPlay: true,
                padEnds: false,
                height: Get.height / 2.8,
              ),
            ),
            ScrollParent(
              controller: scrollController,
              child: EventList(
                events: _eventsController.featuredEvents.value?.map((e) {
                  return EventCard(
                    eventId: e.uid,
                    subtitle: e.subtitle,
                    categoryImage: ImageConstant.categorySportsImage,
                    eventHeldDate: e.heldDate.toDate(),
                    category: e.category,
                    imagePath: e.eventBanner,
                    title: e.title,
                  );
                }).toList(),
                heading: "Featured Events",
                fullHeight: false,
                trailing: GestureDetector(
                  child: const Text("see all"),
                  onTap: () {
                    Get.log("To AllFeaturedEventsScreen");
                    Get.to(() => const AllFeaturedEventsScreen());
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveFCMToken() {
    final AuthController authController = AuthController.to;
    authController.updateFCMToken();
  }
}

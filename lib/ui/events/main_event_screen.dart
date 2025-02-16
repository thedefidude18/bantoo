import 'package:carousel_slider/carousel_slider.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/models/event_model.dart';
import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flexx_bet/ui/components/event_card.dart';
import 'package:flexx_bet/ui/components/event_list.dart';
import 'package:flexx_bet/ui/components/live_event_card.dart';
import 'package:flexx_bet/ui/components/scroll_parent.dart';
import 'package:flexx_bet/ui/events/all_live_events.dart';
import 'package:flexx_bet/ui/events/all_upcoming_events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventScreen extends StatelessWidget {
  EventScreen({super.key});
  final EventsController _eventsController = EventsController.to;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 8, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Categories",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: ColorConstant.gray400,
                      ),
                      Text(
                        "Search event",
                        style: TextStyle(
                            fontSize: 15, color: ColorConstant.gray400),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: Get.height / 16,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: categories,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 8, 12, 12),
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
                events: _eventsController.upcomingEvents.value?.map((e) {
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
                heading: "Upcoming Events",
                fullHeight: false,
                trailing: GestureDetector(
                  child: const Text("see all"),
                  onTap: () {
                    Get.log("To AllUpcomingEventsScreen");
                    Get.to(() => const AllUpcomingEventsScreen());
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

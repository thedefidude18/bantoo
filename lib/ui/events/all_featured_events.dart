import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flexx_bet/ui/components/event_card.dart';
import 'package:flexx_bet/ui/components/event_list.dart';
import 'package:flutter/material.dart';

class AllFeaturedEventsScreen extends StatelessWidget {
  const AllFeaturedEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //such that these events are called from backend
    EventsController eventsController = EventsController.to;

    return Scaffold(
        backgroundColor: ColorConstant.gray200,
        appBar: const CustomAppBar(
        ),
        body: EventList(
          fullHeight: true,
          heading: "Featured Events",
          events: eventsController.featuredEvents.value?.map((e) {
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
          trailing: Row(
            children: [
              Icon(
                Icons.search,
                color: ColorConstant.gray400,
              ),
              Text(
                "Search event",
                style: TextStyle(fontSize: 15, color: ColorConstant.gray400),
              ),
            ],
          ),
        ));
  }
}

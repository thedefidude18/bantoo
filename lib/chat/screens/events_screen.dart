import 'package:flexx_bet/chat/widgets/groups_history.dart';
import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flutter/material.dart';


class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        appBar: CustomAppBar(
          showBackButton: true,
          showSearchButton: true,
          //showSearchBar: false,

        ),
        body: GroupHistory(""));
  }
}

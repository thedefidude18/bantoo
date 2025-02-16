//User Model
// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  static const String UID = "uid";
  static const String TITLE = "title";
  static const String SUBTITLE = "subtitle";
  static const String FEATURED = "featured";
  static const String AMOUNT = "amount";
  static const String EVENT_BANNER = "eventBanner"; // Adjusted field
  static const String CATEGORY = "category";
  static const String IS_ENDED = "isEnded";
  static const String IS_CANCELLED = "isCancelled";
  static const String HELD_DATE = "heldDate";
  static const String PEOPLE_WAITING = "peopleWaiting";
  static const String PEOPLE_BETTING = "peopleBetting";
  static const String CREATED_AT = "createdAt"; // New field
  static const String EVENTS_NAMES = "eventsNames"; // New field
  static const String SWIPE_GAME_NAME = "swipeGameName"; // New field

  final String uid;
  final String title;
  final String subtitle;
  final String eventBanner;
  final String category;
  final num amount;
  final Timestamp heldDate;
  final List peopleBetting;
  final List peopleWaiting;
  final bool featured;
  final bool isEnded;
  final bool isCancelled;
  final int createdAt;
  final String eventsNames;
  final String swipeGameName;

  EventModel({
    required this.uid,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.eventBanner,
    required this.featured,
    required this.isEnded,
    required this.isCancelled,
    required this.heldDate,
    required this.category,
    required this.peopleWaiting,
    required this.peopleBetting,
    required this.createdAt,
    required this.eventsNames,
    required this.swipeGameName,
  });

  factory EventModel.fromMap(Map<String, dynamic> data) {
    return EventModel(
      uid: data[UID] ?? '',
      title: data[TITLE] ?? '',
      subtitle: data[SUBTITLE] ?? '',
      amount: data[AMOUNT] ?? 0,
      eventBanner: data[EVENT_BANNER] ?? '',
      featured: data[FEATURED] ?? false,
      isEnded: data[IS_ENDED] ?? false,
      isCancelled: data[IS_CANCELLED] ?? false,
      category: data[CATEGORY] ?? '',
      heldDate: data[HELD_DATE] ?? Timestamp.now(),
      peopleBetting: data[PEOPLE_BETTING] ?? [],
      peopleWaiting: data[PEOPLE_WAITING] ?? [],
      createdAt: data[CREATED_AT] ?? 0,
      eventsNames: data[EVENTS_NAMES] ?? '',
      swipeGameName: data[SWIPE_GAME_NAME] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    UID: uid,
    TITLE: title,
    EVENT_BANNER: eventBanner,
    SUBTITLE: subtitle,
    IS_ENDED: isEnded,
    IS_CANCELLED: isCancelled,
    CATEGORY: category,
    AMOUNT: amount,
    FEATURED: featured,
    PEOPLE_WAITING: peopleWaiting,
    PEOPLE_BETTING: peopleBetting,
    HELD_DATE: heldDate,
    CREATED_AT: createdAt,
    EVENTS_NAMES: eventsNames,
    SWIPE_GAME_NAME: swipeGameName,
  };
}

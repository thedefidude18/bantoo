import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/bet_controller.dart';
import 'package:flexx_bet/models/event_model.dart';
import 'package:flexx_bet/ui/components/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class EventsController extends GetxController {
  static EventsController to = Get.find<EventsController>();
  final BetsController _betsController = Get.put(BetsController());
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Rxn<List<EventModel>> featuredEvents = Rxn<List<EventModel>>();
  final Rxn<List<EventModel>> liveEvents = Rxn<List<EventModel>>();
  List<EventModel> fiveNextEvents = [];
  final Rxn<List<EventModel>> upcomingEvents = Rxn<List<EventModel>>();
  final Rxn<EventModel> _currentEvent = Rxn<EventModel>();
  Rxn<int> userFilteredAmount = Rxn<int>();
  Rxn<String> eventFilterUserId = Rxn<String>();
  Rxn<String> categoryName = Rxn<String>();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> documentList = [];
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;


  @override
  void onReady() {
    liveEvents.bindStream(_streamLiveEvents());
    upcomingEvents.bindStream(_streamUpcomingEvents());
    featuredEvents.bindStream(_streamFeaturedEvents());
    super.onReady();
  }

  setCurrentEvent(EventModel event) {
    _currentEvent.value = event;
    update();
  }

  EventModel? get getCurrentEvent => _currentEvent.value;

  Stream<List<EventModel>> _streamLiveEvents() {
    Get.log("_streamLiveEvents");

    return _db
        .collection('/events')
        .where("heldDate", isLessThan: Timestamp.now())
        .where("isEnded", isEqualTo: false)
        .where("isCancelled", isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      List<EventModel> events = [];
      for (var doc in snapshot.docs) {
        events.add(EventModel.fromMap(doc.data()));
      }
      return events;
    });
  }

  Future fetchFirstEventsList(String? eventId) async {
    Get.log("fetchFirstEventsList");
    try {
      if (userFilteredAmount.value != null) {
        Get.log("userFilteredAmount.value not null");
        documentList = (await _db
                .collection('/events')
                .where("amount", isEqualTo: userFilteredAmount.value)
                .limit(5)
                .get())
            .docs;
      } else if (categoryName.value != null) {
        Get.log("userFilteredCategory.value not null");
        documentList = (await _db
                .collection('/events')
                .where("category", isEqualTo: categoryName.value).limit(5)
                .get())
            .docs;
        categoryName.value = null;
      }else if (eventFilterUserId.value != null) {
        Get.log("eventFilterUserId.value not null");
        documentList = (await _db
                .collection('/events')
                .where("uid", isEqualTo: eventFilterUserId.value).limit(5)
                .get())
            .docs;
        eventFilterUserId.value = null;
      } else if (eventId != null) {
        Get.log("event Id not null");
        documentList = (await _db
                .collection('/events')
                .where("uid", isGreaterThanOrEqualTo: eventId)
                .limit(5)
                .get())
            .docs;
      } else {
        Get.log("event Id and userFilteredAmount.value are null");
        documentList = (await _db.collection('/events').limit(5).get()).docs;
      }
      List<EventModel> events = [];
      for (var value in documentList) {
        events.add(EventModel.fromMap(value.data()));
      }
      fiveNextEvents = events;

      Get.log("fiveNextEvents ${fiveNextEvents.length}");
      update();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future loadFiveNextEvents() async {
    Get.log("loadFiveNextEvents");
    try {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> newDocumentList =
          (await _db
                  .collection('/events')
                  .where("amount", isEqualTo: userFilteredAmount.value)
                  .orderBy("uid", descending: false)
                  .startAfterDocument(documentList[documentList.length - 1])
                  .limit(5)
                  .get())
              .docs;
      documentList = newDocumentList;
      for (var value in documentList) {
        fiveNextEvents.add(EventModel.fromMap(value.data()));
      }
      Get.log("${fiveNextEvents.length}");
      update();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future addUserToEventPeopleWaiting() async {
    Get.log("addUserToEventPeopleWaiting");
    AuthController authController = AuthController.to;
    try {
      String userId = authController.userFirestore!.uid;
      if (!getCurrentEvent!.peopleWaiting.contains(userId)) {
        EventModel newEvent = updateEventFieldsAsWanted(getCurrentEvent!,
            peopleWaiting: [...getCurrentEvent!.peopleWaiting, userId]);
        await _updateEvent(newEvent, getCurrentEvent!.uid);
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future addUsersToEventPeopleBetting() async {
    Get.log("addUserToEventPeopleBetting");
    AuthController authController = AuthController.to;
    try {
      if (!getCurrentEvent!.peopleBetting
              .contains(authController.userFirestore) &&
          !getCurrentEvent!.peopleBetting.contains(authController.otherUser)) {
        EventModel newEvent =
            updateEventFieldsAsWanted(getCurrentEvent!, peopleBetting: [
          ...getCurrentEvent!.peopleBetting,
          authController.userFirestore,
          authController.otherUser
        ]);
        await _updateEvent(newEvent, getCurrentEvent!.uid);
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future removeUserFromEventPeopleWaiting() async {
    Get.log("removeUserToEventPeopleWaiting");
    try {
      String userId = AuthController.to.otherUser!.uid;
      List updatedPeopleWaiting = getCurrentEvent!.peopleWaiting;
      if (updatedPeopleWaiting.remove(userId)) {
        EventModel newEvent = updateEventFieldsAsWanted(getCurrentEvent!,
            peopleWaiting: updatedPeopleWaiting);
        await _updateEvent(newEvent, getCurrentEvent!.uid);
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Stream<List<EventModel>> _streamUpcomingEvents() {
    Get.log("_streamUpcomingEvents");

    return _db
        .collection('/events')
        .where("heldDate", isGreaterThan: Timestamp.now())
        .snapshots()
        .map((snapshot) {
      List<EventModel> events = [];
      for (var doc in snapshot.docs) {
        events.add(EventModel.fromMap(doc.data()));
      }
      return events;
    });
  }

  Stream<List<EventModel>> _streamFeaturedEvents() {
    Get.log("_streamFeaturedEvents");

    return _db
        .collection('/events')
        .where('featured', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      List<EventModel> events = [];
      for (var doc in snapshot.docs) {
        events.add(EventModel.fromMap(doc.data()));
      }
      return events;
    });
  }

  Future setupDetailedEventPage(String? eventId) async {
    Get.log("loadEventById");
    try {
      if (eventId != null) {
        Get.log("event ID provided loading wrt with it");
        await showLoader(() async {
          userFilteredAmount.value = null;
          categoryName.value = null;
          await fetchFirstEventsList(eventId);
        });
      } else {
        Get.log("event ID not provided loading random events");
        await fetchFirstEventsList(null);
      }
      setCurrentEvent(fiveNextEvents.first);
      await _betsController.getBetWithRequirements();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future<EventModel?> _getEvent(String eventId) {
    Get.log("_getEvent");

    return _db.doc('/events/$eventId').get().then((documentSnapshot) =>
        documentSnapshot.data() == null
            ? null
            : EventModel.fromMap(documentSnapshot.data()!));
  }

  Future _updateEvent(EventModel event, String eventId) async {
    Get.log("_updateEvent");
    await _db.doc('/events/$eventId').update(event.toJson());
  }

  EventModel updateEventFieldsAsWanted(
    EventModel prevEventModel, {
    String? uid,
    String? title,
    String? subtitle,
    String? image,
    num? amount,
    String? category,
    Timestamp? heldDate,
    List? peopleBetting,
    List? peopleWaiting,
    bool? featured,
    bool? isEnded,
    bool? isCancelled,
  }) {
    return EventModel(
      createdAt: prevEventModel.createdAt,
      eventsNames: title ?? prevEventModel.title,
      swipeGameName: title ?? prevEventModel.title,
      uid: uid ?? prevEventModel.uid,
      title: title ?? prevEventModel.title,
      subtitle: subtitle ?? prevEventModel.subtitle,
      amount: amount ?? prevEventModel.amount,
      eventBanner: image ?? prevEventModel.eventBanner,
      category: category ?? prevEventModel.category,
      heldDate: heldDate ?? prevEventModel.heldDate,
      peopleBetting: peopleBetting ?? prevEventModel.peopleBetting,
      peopleWaiting: peopleWaiting ?? prevEventModel.peopleWaiting,
      featured: featured ?? prevEventModel.featured,
      isEnded: isEnded ?? prevEventModel.isEnded,
      isCancelled: isCancelled ?? prevEventModel.isCancelled,
    );
  }

  Future<String> createDynamicLink(String eventId) async {
    String code = eventId;
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://flexxbet.page.link',
      link: Uri.parse(
        'https://flexxbet.page.link/Event',
      ),
      androidParameters: const AndroidParameters(
        packageName: 'com.flexxbet.app',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.flexxbet.app',
      ),
      socialMetaTagParameters: const SocialMetaTagParameters(
        title: 'Hey check out this event',
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

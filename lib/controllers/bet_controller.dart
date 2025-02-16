import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/controllers/leaderboard_controller.dart';
import 'package:flexx_bet/models/bet_model.dart';
import 'package:flexx_bet/models/event_model.dart';
import 'package:flexx_bet/models/models.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../models/notification_model.dart' as model;
import 'notification_controller.dart';

class BetsController extends GetxController {
  static BetsController to = Get.find<BetsController>();
  final LeaderboardController _leaderbardController =
      Get.put(LeaderboardController());

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool isNewBetPossible = false;
  bool isJoinBetPossible = false;
  bool isBetLive = false;
  final Rxn<String> userSelectedOption = Rxn<String>();
  Rxn<BetModel> currentBet = Rxn<BetModel>();



  var uuid = const Uuid();

  Future getBetWithRequirements() async {
    Get.log("_getBetWithRequirements of event");
    EventsController eventsController = EventsController.to;
    AuthController authController = AuthController.to;
    currentBet.value = null;

    try {
      EventModel event = eventsController.getCurrentEvent!;
      bool isUpcoming = event.heldDate.microsecondsSinceEpoch >
          Timestamp.now().microsecondsSinceEpoch;
      isBetLive = !isUpcoming && !event.isCancelled && !event.isEnded;
      String userId = authController.userFirestore!.uid;

      if (isBetLive) {
        if (!event.peopleBetting.contains(userId)) {
          currentBet.value = await _db
              .collection('/bets')
              .where(BetModel.FIRST_USER,
                  isNotEqualTo: AuthController.to.userFirestore!.uid)
              .where(BetModel.STATUS, isEqualTo: BetModel.BetStatus.WAITING)
              .where(BetModel.SECOND_USER, isEqualTo: "")
              .where(BetModel.EVENT_ID, isEqualTo: event.uid)
              .get()
              .then((snapshot) {
            if (snapshot.docs.isNotEmpty) {
              return BetModel.fromMap(snapshot.docs.first.data());
            } else {
              return null;
            }
          });
        }
        if (currentBet.value != null) {
          userSelectedOption.value = currentBet.value!.secondUserSelectedOption;
          isJoinBetPossible = true;
          isNewBetPossible = false;
        } else if (!event.peopleWaiting.contains(userId)) {
          isNewBetPossible = true;
          isJoinBetPossible = false;
        } else {
          isNewBetPossible = false;
          isJoinBetPossible = false;
        }
      } else {
        isNewBetPossible = false;
        isJoinBetPossible = false;
      }
      Get.log("isBetLive: $isBetLive");
      Get.log("isJoinBetPossible: $isJoinBetPossible");
      Get.log("isNewBetPossible: $isNewBetPossible");
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future createEntirelyNewBet() async {
    EventsController eventsController = EventsController.to;
    AuthController authController = AuthController.to;
    try {
      EventModel currentEvent = eventsController.getCurrentEvent!;
      UserModel currentUser = authController.userFirestore!;
      String secondUserOption =
          userSelectedOption.value! == "yes" ? "no" : "yes";

      BetModel bet = BetModel(
        uid: uuid.v1(),
        status: BetModel.BetStatus.WAITING,
        eventId: currentEvent.uid,
        firstUser: currentUser.uid,
        firstUsername: currentUser.username,
        firstUserAmount: currentEvent.amount,
        firstUserSelectedOption: userSelectedOption.value!,
        secondUser: "",
        secondUsername: "",
        secondUserAmount: currentEvent.amount,
        secondUserSelectedOption: secondUserOption,
        correctOption: "to be decided",
        userWonId: "",
      );

      await eventsController.addUserToEventPeopleWaiting();
      await _createBet(bet);
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future joinBet() async {
    Get.log("joinBet");
    EventsController eventsController = EventsController.to;
    AuthController authController = AuthController.to;
    try {
      BetModel bet = currentBet.value!;
      await authController.loadAnotherUserData(bet.firstUser);
      UserModel currentUser = authController.userFirestore!;

      BetModel updatedBet = BetModel(
          uid: bet.uid,
          status: BetModel.BetStatus.STARTED,
          eventId: bet.eventId,
          firstUsername: bet.firstUsername,
          firstUser: bet.firstUser,
          firstUserAmount: bet.firstUserAmount,
          firstUserSelectedOption: bet.firstUserSelectedOption,
          secondUser: currentUser.uid,
          secondUsername: currentUser.username,
          secondUserAmount: bet.secondUserAmount,
          secondUserSelectedOption: bet.secondUserSelectedOption,
          correctOption: bet.correctOption,
          userWonId: bet.userWonId);

      await _leaderbardController.enterOrUpdateLeaderboard();
      await eventsController.removeUserFromEventPeopleWaiting();
      await eventsController.addUsersToEventPeopleBetting();
      await authController.addBetInUserRecord(updatedBet.uid);
       final NotificationController notificationController =
        Get.put<NotificationController>(NotificationController());
      final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

      await _updateBet(updatedBet);
      if(bet.userWonId == currentUser.uid){
        awesomeNotifications.createNotification(
            content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              actionType: ActionType.Default,
              title: 'You won a bet',
              body:
              'You have won this bet from ${authController.otherUser!.name}',
            ));

        model.NotificationModel  notificationModel = model.NotificationModel(
          userId: currentUser.uid,
          body: 'You have won this bet from ${authController.otherUser!.name}',
          type: "Bet Won",
          creationDate: DateTime.now(),
          title:  "You won a bet",
          amount: "",
          selectedOption: "",
          eventId: ""
        );
        await notificationController.addNotification(notificationModel);
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future _createBet(BetModel bet) async {
    Get.log("_createBet");
    await _db.doc('/bets/${bet.uid}').set(bet.toJson());
    update();
  }

  Future _updateBet(BetModel bet) async {
    Get.log("_updateBet");
    await _db.doc('/bets/${bet.uid}').update(bet.toJson());
    update();
  }
}

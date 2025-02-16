import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/models/achievement_model.dart';
import 'package:flexx_bet/models/models.dart';
import 'package:flexx_bet/ui/components/badge_popup.dart';
import 'package:flexx_bet/ui/components/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'dart:math';

class AchievementController extends GetxController {
  static AchievementController to = Get.find<AchievementController>();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final num firstLevel = 150;
  final num commonRatio = 2;

  double logCustomRatio(num x) => log(x) / log(commonRatio);

  Rxn<AchievementModel> userAchievements = Rxn<AchievementModel>();
  int level = 0;
  int nextLevelPoints = 150;
  double progress = 0;

  Future setupUserAchievements(UserModel? user) {
    if (kDebugMode) {
      Get.log('setupUserAchievements()');
    }

    var achievementStream =
        _db.doc('/achievement/${user?.uid}').snapshots().map((snapshot) {
      if (snapshot.data() != null) {
        AchievementModel achievementModel =
            AchievementModel.fromMap(snapshot.data()!);
        if (achievementModel.points != 0) {
          late double answer;
          if (achievementModel.points < firstLevel) {
            answer =
                (logCustomRatio(achievementModel.points / firstLevel) + 1) * -1;
            level = 0;
            nextLevelPoints = firstLevel.toInt();
          } else {
            answer = (logCustomRatio(achievementModel.points / firstLevel) + 1);
            level = answer.truncate();
            nextLevelPoints = (firstLevel * pow(commonRatio, level)).toInt();
          }
        }
        progress = achievementModel.points / nextLevelPoints;

        return achievementModel;
      } else if (user != null) {
        AchievementModel newAchveModel = AchievementModel(
            points: 0,
            userId: user.uid,
            swipes: 0,
            badges: [],
            profileCompleted: false);
        level = 0;
        progress = 0;
        nextLevelPoints = firstLevel.toInt();
        _createAchievement(newAchveModel);
        return newAchveModel;
      }
    });
    userAchievements.bindStream(achievementStream);
    var firstValueReceived = Completer<void>();
    userAchievements.listen((val) {
      if (!firstValueReceived.isCompleted) {
        firstValueReceived.complete();
      }
    });
    return firstValueReceived.future;
  }

  Future _addBadge(String badgeName, num points) async {
    try {
      await showLoader(() async {
        AchievementModel currentAchievement = userAchievements.value!;
        AchievementModel updatedAchievement = AchievementModel(
            userId: currentAchievement.userId,
            points: currentAchievement.points + points,
            swipes: currentAchievement.swipes,
            badges: [badgeName, ...currentAchievement.badges],
            profileCompleted: currentAchievement.profileCompleted);
        _updateAchievement(updatedAchievement);
      });
      update();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future profileIsCompleted() async {
    try {
      await showLoader(() async {
        AchievementModel currentAchievement = userAchievements.value!;
        AchievementModel updatedAchievement = AchievementModel(
            userId: currentAchievement.userId,
            points: currentAchievement.points,
            swipes: currentAchievement.swipes,
            badges: currentAchievement.badges,
            profileCompleted: true);
        await _updateAchievement(updatedAchievement);
        await checkAndAddBadge();
      });
      update();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future addPoints(num points) async {
    try {
      await showLoader(() async {
        AchievementModel currentAchievement = userAchievements.value!;
        AchievementModel updatedAchievement = AchievementModel(
            userId: currentAchievement.userId,
            points: currentAchievement.points + points,
            swipes: currentAchievement.swipes,
            badges: currentAchievement.badges,
            profileCompleted: currentAchievement.profileCompleted);
        _updateAchievement(updatedAchievement);
      });
      update();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  // int counter = 0;
  Future addSwipe() async {
    try {
      // counter += 1;
      await showLoader(() async {
        AchievementModel currentAchievement = userAchievements.value!;
        AchievementModel updatedAchievement = AchievementModel(
            userId: currentAchievement.userId,
            points: currentAchievement.points,
            swipes: currentAchievement.swipes + 1,
            badges: currentAchievement.badges,
            profileCompleted: currentAchievement.profileCompleted);
        await _updateAchievement(updatedAchievement);
        // if (counter == 5) {
        //   counter = 0;
        await checkAndAddBadge();
        // }
      });
      update();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future checkAndAddBadge() async {
    Get.log("checkAndAddBadge");
    try {
      AchievementModel currentAchievement = userAchievements.value!;
      if (currentAchievement.profileCompleted) {
        await showLoader(() async {
          if (!currentAchievement.badges.contains("chief") &&
              currentAchievement.badges.contains("master") &&
              currentAchievement.swipes >= 25) {
            await _addBadge("chief", 500);
            badgePopup(BadgeType.chief);
          } else if (!currentAchievement.badges.contains("master") &&
              currentAchievement.badges.contains("amateur") &&
              currentAchievement.swipes >= 20) {
            await _addBadge("master", 200);
            badgePopup(BadgeType.master);
          } else if (
              // await _usersReferred(currentAchievement.userId) > 0 &&
              currentAchievement.swipes > 5 &&
                  !currentAchievement.badges.contains("amateur")) {
            await _addBadge("amateur", 50);
            badgePopup(BadgeType.amateur);
          }
        });
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

// to get users referred by current user we will count the users with useRef = current user Ids
  Future<int?> _usersReferred(String currUserId) async {
    return (await _db
            .collection('/users')
            .where("userRef", isEqualTo: currUserId)
            .count()
            .get())
        .count;
  }

  Future _createAchievement(AchievementModel achievement) async {
    Get.log("_createAchievement");
    await _db
        .doc('/achievement/${achievement.userId}')
        .set(achievement.toJson());
    update();
  }

  Future _updateAchievement(AchievementModel achievement) async {
    Get.log("_updateAchievement");
    await _db
        .doc('/achievement/${achievement.userId}')
        .update(achievement.toJson());
    update();
  }

  //possible actions: withdrew deposited transferred betted recieved
}

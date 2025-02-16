import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/models/leaderboard_user_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeaderboardController extends GetxController {
  static LeaderboardController to = Get.find<LeaderboardController>();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> documentList = [];
  int currentUserRank = 0;
  List<LeaderboardUserModel> fifteenNextLeaderBoardModels = [];
  Rxn<LeaderboardUserModel> fetchedLeaderboardUserModel =
      Rxn<LeaderboardUserModel>();
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());

  Future enterOrUpdateLeaderboard() async {
    Get.log("enterOrUpdateLeaderboard");
    AuthController authController = AuthController.to;
    try {
      await loadLeaderboardUserModel(authController.userFirestore!.uid);
      if (fetchedLeaderboardUserModel.value != null) {
        Get.log("fetchedLeaderboardUserModel not null");
        LeaderboardUserModel newModel = LeaderboardUserModel(
            userId: authController.userFirestore!.uid,
            betsToday: fetchedLeaderboardUserModel.value!.betsToday + 1,
            nameOfUser: fetchedLeaderboardUserModel.value!.nameOfUser,
            userJoinedApp: fetchedLeaderboardUserModel.value!.userJoinedApp);
        await _updateNewLeaderboardUser(newModel);
      } else {
        Get.log("fetchedLeaderboardUserModel is null");
        LeaderboardUserModel newleaderboardUserModel = LeaderboardUserModel(
            userJoinedApp: authController.userFirestore!.userJoinedAt,
            nameOfUser: authController.userFirestore!.name,
            userId: authController.userFirestore!.uid,
            betsToday: 1);
        await _createNewLeaderboardUser(newleaderboardUserModel);
      }
      Get.log("enterOrUpdateLeaderboard second step");

      if (authController.otherUser?.uid != null) {
        await loadLeaderboardUserModel(authController.otherUser!.uid);

        if (fetchedLeaderboardUserModel.value != null) {
          Get.log("fetchedLeaderboardUserModel not null");
          LeaderboardUserModel newModel = LeaderboardUserModel(
              userId: authController.otherUser!.uid,
              betsToday: fetchedLeaderboardUserModel.value!.betsToday + 1,
              nameOfUser: fetchedLeaderboardUserModel.value!.nameOfUser,
              userJoinedApp: fetchedLeaderboardUserModel.value!.userJoinedApp);
          await _updateNewLeaderboardUser(newModel);
        } else {
          Get.log("fetchedLeaderboardUserModel is null");
          await authController
              .loadAnotherUserData(authController.otherUser!.uid);
          final opponentUser = authController.otherUser!;
          LeaderboardUserModel leaderboardUserModel = LeaderboardUserModel(
              userId: authController.otherUser!.uid,
              betsToday: 1,
              nameOfUser: opponentUser.name,
              userJoinedApp: opponentUser.userJoinedAt);

          await _createNewLeaderboardUser(leaderboardUserModel);
        }
      }
      await fetchFirstLeaderboardList();
      update();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future fetchFirstLeaderboardList() async {
    Get.log("fetchFirstLeaderboardList");
    AuthController authController = AuthController.to;

    try {
      List<LeaderboardUserModel> newLeaderboard = [];
      documentList = (await _db
              .collection('/leaderboard')
              .doc('/$date')
              .collection('/users')
              .orderBy('betsToday')
              .orderBy('userJoinedApp')
              .limit(15)
              .get())
          .docs;
      for (var value in documentList) {
        LeaderboardUserModel newLeaderBoardFromFirestore =
            LeaderboardUserModel.fromMap(value.data());
        newLeaderboard.add(newLeaderBoardFromFirestore);
        await authController
            .loadAnotherUserData(newLeaderBoardFromFirestore.userId);
        authController.usersPresent.add(authController.otherUser);
      }
      fifteenNextLeaderBoardModels = newLeaderboard;
      update();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future loadFifteenNextLeaderboardUsers({String? userId}) async {
    Get.log("loadFiveNextLeaderboardUsers");
    try {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> newDocumentList =
          (await _db
                  .collection('/leaderboard')
                  .doc('/$date')
                  .collection('/users')
                  .orderBy('betsToday')
                  .orderBy('userJoinedApp')
                  .startAfterDocument(documentList.last)
                  .limit(15)
                  .get())
              .docs;
      documentList = newDocumentList;
      for (var value in newDocumentList) {
        fifteenNextLeaderBoardModels
            .add(LeaderboardUserModel.fromMap(value.data()));
      }
      update();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future loadLeaderboardUserModel(String userId) async {
    Get.log("loadLeaderboardUserModel");
    await _db
        .collection('/leaderboard')
        .doc('/$date')
        .collection('/users')
        .doc(userId)
        .get()
        .then(
      (value) => value.data() == null
          ? null
          : fetchedLeaderboardUserModel.value =
              LeaderboardUserModel.fromMap(value.data()!),
      onError: (e) {
        Get.log("Error completing: $e");
      },
    );
    await _db
        .collection('/leaderboard')
        .doc('/$date')
        .collection('/users')
        .where("betsToday",
            isGreaterThan: fetchedLeaderboardUserModel.value?.betsToday ?? 0)
        .count()
        .get()
        .then(
      (res) => currentUserRank = (res.count! + 1),
      onError: (e) {
        Get.log("Error completing: $e");
      },
    );

    update();
  }

  Future _createNewLeaderboardUser(LeaderboardUserModel leaderboardUserModel) {
    Get.log("_createNewLeaderboardUser");
    return _db
        .collection('/leaderboard')
        .doc('/$date')
        .collection('/users')
        .doc(leaderboardUserModel.userId)
        .set(leaderboardUserModel.toJson());
  }

  Future _updateNewLeaderboardUser(LeaderboardUserModel leaderboardUserModel) {
    Get.log("_updateNewLeaderboardUser");
    return _db
        .collection('/leaderboard')
        .doc('/$date')
        .collection('/users')
        .doc(leaderboardUserModel.userId)
        .update(leaderboardUserModel.toJson());
  }
}

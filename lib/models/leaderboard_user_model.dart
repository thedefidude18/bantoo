// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardUserModel {
  static const String USER_ID = "userId";
  static const String NAME_OF_USER = "nameOfUser";
  static const String BETS_TODAY = "betsToday";
  static const String USER_JOINED_APP = "userJoinedApp";

  final String userId;
  final String nameOfUser;
  final Timestamp userJoinedApp;
  final num betsToday;

  LeaderboardUserModel({
    required this.userId,
    required this.betsToday,
    required this.nameOfUser,
    required this.userJoinedApp,
  });

  factory LeaderboardUserModel.fromMap(Map data) {
    return LeaderboardUserModel(
      userId: data[USER_ID],
      nameOfUser: data[NAME_OF_USER],
      userJoinedApp: data[USER_JOINED_APP],
      betsToday: data[BETS_TODAY],
    );
  }

  Map<String, dynamic> toJson() => {
        NAME_OF_USER: nameOfUser,
        USER_ID: userId,
        USER_JOINED_APP: userJoinedApp,
        BETS_TODAY: betsToday,
      };
}

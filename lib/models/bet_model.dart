//User Model
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class BetModelStatus {
  const BetModelStatus();
  num get WAITING => 0;
  num get STARTED => 1;
  num get ENDED => 2;
}

class BetModel {
  static const BetModelStatus BetStatus = BetModelStatus();
  static const String UID = "uid";
  static const String EVENT_ID = "eventId";
  static const String FIRST_USER = "firstUser";
  static const String FIRST_USERNAME = "firstUsername";
  static const String FIRST_USER_AMOUNT = "firstUserAmount";
  static const String FIRST_USER_SELECTED_OPTION = "firstUserSelectedOption";
  static const String SECOND_USER = "secondUser";
  static const String SECOND_USERNAME = "secondUsername";
  static const String SECOND_USER_AMOUNT = "secondUserAmount";
  static const String SECOND_USER_SELECTED_OPTION = "secondUserSelectedOption";
  static const String CORRECT_OPTION = "correctOption";
  static const String USER_WON_ID = "userWonId";
  static const String STATUS = "status";

  final String uid;
  final num status;
  final String eventId;
  final String firstUser;
  final String firstUsername;
  final num firstUserAmount;
  final String firstUserSelectedOption;
  final String secondUser;
  final String secondUsername;
  final num secondUserAmount;
  final String secondUserSelectedOption;
  final String correctOption;
  final String userWonId;

  BetModel({
    required this.uid,
    required this.status,
    required this.eventId,
    required this.firstUser,
    required this.firstUsername,
    required this.firstUserAmount,
    required this.firstUserSelectedOption,
    required this.secondUser,
    required this.secondUsername,
    required this.secondUserAmount,
    required this.secondUserSelectedOption,
    required this.correctOption,
    required this.userWonId,
  });

  factory BetModel.fromMap(Map data) {
    return BetModel(
      status: data[STATUS],
      uid: data[UID],
      eventId: data[EVENT_ID],
      firstUser: data[FIRST_USER],
      firstUsername: data[FIRST_USERNAME],
      firstUserAmount: data[FIRST_USER_AMOUNT],
      firstUserSelectedOption: data[FIRST_USER_SELECTED_OPTION],
      secondUser: data[SECOND_USER],
      secondUsername: data[SECOND_USERNAME],
      secondUserAmount: data[SECOND_USER_AMOUNT],
      secondUserSelectedOption: data[SECOND_USER_SELECTED_OPTION],
      correctOption: data[CORRECT_OPTION],
      userWonId: data[USER_WON_ID],
    );
  }

  Map<String, dynamic> toJson() => {
        UID: uid,
        STATUS: status,
        EVENT_ID: eventId,
        FIRST_USER: firstUser,
        FIRST_USERNAME: firstUsername,
        FIRST_USER_AMOUNT: firstUserAmount,
        FIRST_USER_SELECTED_OPTION: firstUserSelectedOption,
        SECOND_USER: secondUser,
        SECOND_USERNAME: secondUsername,
        SECOND_USER_AMOUNT: secondUserAmount,
        SECOND_USER_SELECTED_OPTION: secondUserSelectedOption,
        CORRECT_OPTION: correctOption,
        USER_WON_ID: userWonId,
      };
}

//User Model
// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const String UID = "uid";
  static const String EMAIL = "email";
  static const String NAME = "name";
  static const String USERNAME = "username";
  static const String ABOUT = "about";
  static const String COUNTRY = "country";
  static const String COUNTRY_CODE = "countryCode";
  static const String USER_JOINED_AT = "userJoinedAt";
  static const String ADDRESS = "address";
  static const String NUMBER = "number";
  static const String PIN = "pin";
  static const String USER_REF = "userRef";
  static const String PHOTO_URL = "photoUrl";
  static const String LIKES = "likes";
  static const String BETS_WON = "betsWon";
  static const String BETS_LOST = "betsLost";
  static const String ALL_BETS = "allBets";
  static const String APPLIED_FOR_VERIFICATION = "appliedForVerification";
  static const String FOLLOWERS = "followers";
  static const String FOLLOWING = "following";
  final String uid;
  final String email;
  final String name;
  final String username;
  final String about;
  final String country;
  final String countryCode;
  final String address;
  final String number;
  final String pin;
  final String? userRef;
  final String photoUrl;
  final Timestamp userJoinedAt;
  final List likes;
  final List betsLost;
  final List allBets;
  final List betsWon;
  final bool appliedForVerification;
  final List followers;
  final List following;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.userRef,
    required this.username,
    required this.userJoinedAt,
    required this.about,
    required this.country,
    required this.address,
    required this.number,
    required this.pin,
    required this.countryCode,
    required this.photoUrl,
    required this.likes,
    required this.allBets,
    required this.betsWon,
    required this.betsLost,
    required this.appliedForVerification,
    required this.followers,
    required this.following,
  });

  factory UserModel.newUser(
      {required String uid,
      required String name,
      required String userRef,
      required String email,
      required String country,
      required String countryCode,
      required String username,
      required String photoUrl, required String phone}) {
    return UserModel(
      uid: uid,
      email: email,
      name: name,
      username: username,
      about: "",
      country: country,
      countryCode: countryCode,
      address: "",
      number: phone,
      userRef: userRef,
      photoUrl: photoUrl,
      pin: "",
      likes: [],
      betsWon: [],
      betsLost: [],
      allBets: [],
      userJoinedAt: Timestamp.now(),
      appliedForVerification: false,
      followers: [],
      following: [],
    );
  }

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data[UID],
      email: data[EMAIL] ?? "",
      name: data[NAME] ?? "",
      username: data[USERNAME] ?? "",
      about: data[ABOUT] ?? "",
      country: data[COUNTRY] ?? "",
      countryCode: data[COUNTRY_CODE] ?? "",
      address: data[ADDRESS] ?? "",
      number: data[NUMBER] ?? "",
      pin: data[PIN] ?? "",
      photoUrl: data[PHOTO_URL] ?? "",
      userRef: data[USER_REF] ?? "",
      likes: data[LIKES] ?? "",
      userJoinedAt: data[USER_JOINED_AT] ?? "",
      betsWon: data[BETS_WON] ?? [],
      allBets: data[ALL_BETS] ?? [],
      betsLost: data[BETS_LOST] ?? [],
      appliedForVerification: data[APPLIED_FOR_VERIFICATION] ?? false,
      followers: data[FOLLOWERS] ?? [],
      following: data[FOLLOWING] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        UID: uid,
        EMAIL: email,
        NAME: name,
        USERNAME: username,
        ABOUT: about,
        COUNTRY: country,
        COUNTRY_CODE: countryCode,
        ADDRESS: address,
        USER_REF: userRef,
        NUMBER: number,
        USER_JOINED_AT: userJoinedAt,
        PIN: pin,
        PHOTO_URL: photoUrl,
        LIKES: likes,
        BETS_WON: betsWon,
        BETS_LOST: betsLost,
        ALL_BETS: allBets,
        APPLIED_FOR_VERIFICATION: appliedForVerification,
        FOLLOWERS: followers,
        FOLLOWING: following
      };

// User Modal updateImmutable
  UserModel updateImmutable({
    String? uid,
    String? email,
    String? name,
    String? username,
    String? about,
    String? country,
    String? photoUrl,
    String? number,
    String? address,
    String? countryCode,
    String? pin,
    String? userRef,
    String? photoURl,
    List? likes,
    List? betsWon,
    List? betsLost,
    List? allBets,
    bool? appliedForVerification,
    List? followers,
    List? following,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      about: about ?? this.about,
      country: country ?? this.country,
      userJoinedAt: userJoinedAt,
      address: address ?? this.address,
      userRef: userRef ?? this.userRef,
      number: number ?? this.number,
      countryCode: countryCode ?? this.countryCode,
      pin: pin ?? this.pin,
      photoUrl: photoUrl ?? this.photoUrl,
      likes: likes ?? this.likes,
      betsWon: betsWon ?? this.betsWon,
      allBets: allBets ?? this.allBets,
      betsLost: betsLost ?? this.betsLost,
      appliedForVerification:
          appliedForVerification ?? this.appliedForVerification,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}

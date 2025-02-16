// ignore_for_file: constant_identifier_names

class AchievementModel {
  static const String USER_ID = "userId";
  static const String SWIPES = "swipes";
  static const String POINTS = "points";
  static const String BADGES = "badges";
  static const String PROFILE_COMPLETED = "profileCompleted";

  final String userId;
  final num points;
  final num swipes;
  final List badges;
  final bool profileCompleted;

  AchievementModel({
    required this.userId,
    required this.swipes,
    required this.points,
    required this.badges,
    required this.profileCompleted,
  });

  factory AchievementModel.fromMap(Map data) {
    return AchievementModel(
      userId: data[USER_ID],
      swipes: data[SWIPES],
      points: data[POINTS],
      badges: data[BADGES],
      profileCompleted: data[PROFILE_COMPLETED],
    );
  }

  Map<String, dynamic> toJson() => {
        USER_ID: userId,
        SWIPES: swipes,
        POINTS: points,
        BADGES: badges,
        PROFILE_COMPLETED: profileCompleted,
      };
}

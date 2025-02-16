class UserDetailModel {
  final String uid;
  final String photoUrl;
  final String name;

  UserDetailModel({
    required this.uid,
    required this.photoUrl,
    required this.name,
  });

  factory UserDetailModel.fromMap(Map<String, dynamic> data) {
    return UserDetailModel(
      uid: data['uid'],
      photoUrl: data['photoUrl'] ?? '', // default to empty if no URL
      name: data['name'] ?? 'Unknown', // default name if none provided
    );
  }
}

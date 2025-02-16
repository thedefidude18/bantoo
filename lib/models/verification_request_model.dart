// ignore_for_file: non_constant_identifier_names

class VerificationRequestModel {
  final UID = "uid";
  final IMAGE_URL = "imageUrl";
  final VERIFICATION_TYPE = "verificationType";

  final String uid;
  String? imageUrl;
  final String verificationType;

  VerificationRequestModel(
      {required this.uid, this.imageUrl, required this.verificationType});
  factory VerificationRequestModel.initialize(
      {required String uid, required String verificationType}) {
    return VerificationRequestModel(
        uid: uid, verificationType: verificationType);
  }

  Map<String, dynamic> toJson() => {
        UID: uid,
        IMAGE_URL: imageUrl,
        VERIFICATION_TYPE: verificationType,
      };
}

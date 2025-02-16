
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class ReferralController extends GetxController{

  static ReferralController to = Get.find<ReferralController>();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Rxn<num> totalReferralAmount = Rxn<num>();
  final Rxn<num> totalReferrals = Rxn<num>();
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;



  Future<void> getReferrals(UserModel? user) async {
    QuerySnapshot querySnapshot = await _db.collection('referral_bonuses').where("userId",isEqualTo: user!.uid).get();

    if(querySnapshot.docs.isNotEmpty){
      totalReferralAmount.value = querySnapshot.docs[0]['amount'];
      totalReferrals.value = querySnapshot.docs[0]['referralCount'];
    }

  }


  Future<String> createDynamicLink(String referralCode) async {
    String code = referralCode;
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://flexxbet.page.link',
      link: Uri.parse(
        'https://flexxbet.page.link/?invitedCode=$code',
      ),
      androidParameters: const AndroidParameters(
        packageName: 'com.flexxbet.app',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.flexxbet.app',
      ),
      socialMetaTagParameters: const SocialMetaTagParameters(
        title: 'Refer A friend',
        description: 'Refer and earn points',
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
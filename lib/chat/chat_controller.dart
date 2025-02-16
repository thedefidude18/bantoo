import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flexx_bet/chat/chat_service.dart';
import 'package:flexx_bet/chat/user_service.dart';
import 'package:flexx_bet/chat/widgets/DimLoadingDialog.dart';
import 'package:flexx_bet/controllers/wallet_controller.dart';
import 'package:flexx_bet/extensions/map_extentions.dart';
import 'package:flexx_bet/extensions/string_extentions.dart';
import 'package:flexx_bet/utils/file_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../constants/images.dart';

class ChatController extends GetxController {
  final String uid;
  int yesCount = 0;
  int noCount = 0;

  RxString sortByCategory = ''.obs;

  ChatService chatService = ChatService();
  UserService userService = UserService();
  final TextEditingController _searchController = TextEditingController();
  final _storage = FirebaseStorage.instance;
  var currentUserData = Rxn<Map>();

  var groupBannerImage = Rxn<File>();

  ChatController({required this.uid}) {
    chatService = ChatService(uid: uid);
    userService = UserService(uid: uid);
  }

  @override
  void onInit() {
    super.onInit();

    // userService.gettingUserData(userId: uid).then((value){
    //   if(value is Map){
    //     "My Details-------------> ${value.toString()}".printSuccess();
    //     currentUserData.value = value;
    //   }
    // });
    getUserData(uid: uid).then((value) {
      if (value is Map) {
        "My Details-------------> ${value.toString()}".printSuccess();
        currentUserData.value = value;
      }
    });
  }

  final List<Map<String, dynamic>> categoriesNewList = [
    {
      "name": "Games",
      "category": "game",
      "imagePath": ImageConstant.gamepadImage,
      "gradiant": [Color(0xff7440FF), Color(0xff04010E)]
    },
    {
      "name": "Sports",
      "category": "sports",
      "imagePath": ImageConstant.categorySportsImage,
      "gradiant": [Color(0xff1B24FF), Color(0xff04010E)]
    },
    {
      "name": "Music",
      "category": "music",
      "imagePath": ImageConstant.djSetup,
      "gradiant": [Color(0xff34C759), Color(0xffFD495E)]
    },
    {
      "name": "Crypto",
      "category": "crypto",
      "imagePath": ImageConstant.bitCoinImage,
      "gradiant": [Color(0xffFF9900), Color(0xff7440FF)]
    },
    {
      "name": "Movies/TV",
      "category": "movies/tv",
      "imagePath": ImageConstant.popCornBoxImage,
      "gradiant": [Color(0xffFF2C2C), Color(0xff080742)]
    },
    {
      "name": "Pop Culture",
      "category": "pop culture",
      "imagePath": ImageConstant.popCultureImage,
      "gradiant": [Color(0xff6B0CFF), Color(0xff266939)]
    },
    {
      "name": "Forex",
      "category": "forex",
      "imagePath": ImageConstant.forex,
      "gradiant": [Color(0xff00A3FF), Color(0xff64EA25)]
    },
    {
      "name": "Politics",
      "category": "politics",
      "imagePath": ImageConstant.politicsImage,
      "gradiant": [Color(0xffFFBF66), Color(0xff7440FF)]
    },
  ];

  void setSortBy(String category) {
    if (sortByCategory.value == category) {
      sortByCategory.value = '';
    } else {
      sortByCategory.value = category;
    }
  }

  String getCategoryImage(String category) {
    var categoryData = categoriesNewList.firstWhere(
        (element) =>
            element["category"].toLowerCase() == category.toLowerCase(),
        orElse: () => {});

    return categoryData["imagePath"] ?? ImageConstant.beach;
  }

  getGroupCategory({Map? groupData}) {
    if (groupData is Map && groupData.containsKey("category")) {
      if (groupData["category"] is String) {
        return groupData["category"];
      }
    }
    return null;
  }

  Future<dynamic> getUserData({required String uid}) async {
    return await userService.gettingUserData(userId: uid);
  }

  Future<Map?> getChatAbout() async {
    return await chatService.getChatAboutData();
  }

  var groupHistory = RxList<QueryDocumentSnapshot>([]);
  var unJoinedGroups = RxList<QueryDocumentSnapshot>([]);
  var joinedGroups = RxList<QueryDocumentSnapshot>([]);
  var totalMember = RxList<QueryDocumentSnapshot>([]);
  var currentGroup = Rxn<QueryDocumentSnapshot>();

  Future<List<QueryDocumentSnapshot>> getGroups() async {
    try {
      var snapshot = await chatService.groupCollection.get();
      if (snapshot.docs.isNotEmpty) {
        var groups = snapshot.docs;
        print("SnapShot::${snapshot.docs}");
        var unJoinedGroups = snapshot.docs
            .where((doc) => ((doc.data() as Map).containsKey("members") &&
                !(doc['members'] as List<dynamic>).contains(
                    '${uid}_${currentUserData.value.getValueOfKey("name") ?? ""}')))
            .toList();
        var joinedGroups = snapshot.docs
            .where((doc) => ((doc.data() as Map).containsKey("members") &&
                (doc['members'] as List<dynamic>).contains(
                    '${uid}_${currentUserData.value.getValueOfKey("name") ?? ""}')))
            .toList();

        for (var element in unJoinedGroups) {
          var data = element.data();
          data.toString().printSuccess();
        }

        for (var element in joinedGroups) {
          var data = element.data();
          print("Data::${data}");
          data.toString().printSuccess();
        }

        for (var element in groups) {
          var data = element.data();
          data.toString().printSuccess();
        }
        this.joinedGroups.value = joinedGroups;
        this.unJoinedGroups.value = unJoinedGroups;
        groupHistory.value = snapshot.docs;
        return snapshot.docs;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  getGroupsStream() async {
    try {
      chatService.groupCollection
          .orderBy("createdAt")
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var groups = snapshot.docs;

          var unJoinedGroups = snapshot.docs
              .where((doc) => ((doc.data() as Map).containsKey("members") &&
                  !(doc['members'] as List<dynamic>).contains(
                      '${uid}_${currentUserData.value.getValueOfKey("name") ?? ""}')))
              .toList();
          var joinedGroups = snapshot.docs
              .where((doc) => ((doc.data() as Map).containsKey("members") &&
                  (doc['members'] as List<dynamic>).contains(
                      '${uid}_${currentUserData.value.getValueOfKey("name") ?? ""}')))
              .toList();

          for (var element in unJoinedGroups) {
            var data = element.data();
            data.toString().printSuccess();
          }

          for (var element in joinedGroups) {
            var data = element.data();
            data.toString().printSuccess();
          }

          for (var element in groups) {
            var data = element.data();
            data.toString().printSuccess();
          }

          this.joinedGroups.value = joinedGroups;
          this.unJoinedGroups.value = unJoinedGroups;
          groupHistory.value = snapshot.docs;
        } else if (snapshot.docs.isEmpty) {
          joinedGroups.value = [];
          unJoinedGroups.value = [];
          groupHistory.value = [];
        }
      });
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> joinExitGroup({
    required BuildContext context,
    required String groupId,
    required String userName,
    required String groupName,
    required WalletContoller walletContoller,
    required int amount,
  }) async {
    var dialog = DimLoadingDialog(context,
        blur: 3,
        dismissable: false,
        backgroundColor: const Color(0x30000000),
        animationDuration: const Duration(milliseconds: 100));
    dialog.show();
    try {
      var value = await walletContoller.joinGroupEvent(
          amount, "Join Group Event - $groupName");
      if (value != null) {
        var data = await chatService.toggleGroupJoin(
            groupId: groupId, userName: userName, groupName: groupName);
        if (data != null) {
          var snapshot =
              await data.parent.where("groupId", isEqualTo: data.id).get();
          if (snapshot.docs.isNotEmpty) {
            currentGroup.value = snapshot.docs.first;
          }
        }
        var doc = await chatService.userCollection.doc(uid).get();
        dialog.dismiss();
        if (doc.exists) {
          var data = doc.data();
          if (data is Map) {
            var groups = data.getValueOfKey("groups");
            if (groups is List) {
              return groups.contains("${groupId}_$groupName");
            }
          }
        }
      }
      dialog.dismiss();
      return null;
    } catch (e) {
      dialog.dismiss();
      e.toString().printError();
      return null;
    }
  }

  var termsConditionsAccepted = RxBool(false);
  var termsConditionsEnabled = RxBool(false);
  var creatorPaid = RxBool(false);
  var description = Rxn<String>();
  var category = Rxn<String>();
  var duration = Rxn<int>();
  var participants = Rxn<int>();
  var visibility = Rxn<int>();
  var rules = Rxn<int>();

  Future<Map?> createGroup({
    required BuildContext context,
    required String title,
    required String description,
    required String category,
    required DateTime startDate,
    required DateTime endDate,
    required String maxLimit,
    required int joinAmount,
    required bool creatorPaid,
    // required String coverImage,
    required String rules,
    required WalletContoller walletContoller,
    String? groupType,
  }) async {
    var dialog = DimLoadingDialog(context,
        blur: 3,
        dismissable: false,
        backgroundColor: const Color(0x30000000),
        animationDuration: const Duration(milliseconds: 100));
    dialog.show();
    try {
      var value = await walletContoller.groupCreation(
          groupFee.value ?? 0, "Group-creation");
      if (value != null) {
        String? url;
        if (groupBannerImage.value != null && context.mounted) {
          url = await uploadImage(
              context: context,
              prefix: "banner",
              image: groupBannerImage.value!);
        }
        var snapshot = await chatService.createGroup(
            userName: currentUserData.value.getValueOfKey("name") ?? "",
            id: uid,
            groupName: title,
            description: description,
            rules: rules,
            category: category,
            startDate: startDate,
            endDate: endDate,
            joinAmount: joinAmount,
            creatorPaid: creatorPaid,
            membersLimit: int.parse(maxLimit),
            coverImage: url,
            groupType: groupType);

        if (snapshot != null && snapshot.exists && snapshot.data() is Map) {
          dialog.dismiss();
          return snapshot.data() as Map;
        }
      }

      dialog.dismiss();
      return null;
    } catch (e) {
      dialog.dismiss();
      return null;
    }
  }

  Future<Map?> updateGroup({
    required BuildContext context,
    required String title,
    required String groupId,
    required String description,
    required String category,
    required DateTime startDate,
    required DateTime endDate,
    required String maxLimit,
    required String rules,
    required int joinAmount,
    required bool creatorPaid,
    String? banner,
    String? groupType,
  }) async {
    var dialog = DimLoadingDialog(context,
        blur: 3,
        dismissable: false,
        backgroundColor: const Color(0x30000000),
        animationDuration: const Duration(milliseconds: 100));
    dialog.show();
    try {
      String? url;
      if (groupBannerImage.value != null) {
        url = await uploadImage(
            context: context, prefix: "banner", image: groupBannerImage.value!);
      }
      await chatService.updateGroup(
          groupId: groupId,
          groupName: title,
          description: description,
          rules: rules,
          joinAmount: joinAmount,
          creatorPaid: creatorPaid,
          category: category,
          startDate: startDate,
          endDate: endDate,
          membersLimit: int.parse(maxLimit),
          coverImage: banner ?? url,
          groupType: groupType);

      dialog.dismiss();
      return null;
    } catch (e) {
      dialog.dismiss();
      return null;
    }
  }

  Future<bool?> joinedOrNot(
      String userName, String groupId, String groupName) async {
    return await chatService.isUserJoined(groupName, groupId, userName);
  }

  Future<dynamic> sendMessage({
    required String groupId,
    required String message,
    required String messageType,
    required String senderName,
    required String senderId,
    String? image,
  }) async {
    try {
      Map<String, dynamic> chatMessageMap = {
        "message": message,
        "sender": senderName,
        "senderId": senderId,
        "type": messageType,
        "image": image ?? "",
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      };
      return await chatService.sendMessage(groupId, chatMessageMap);
    } catch (e) {
      return null;
    }
  }

  Future uploadChatImage({
    required BuildContext context,
    required File image,
    required String groupId,
    String prefix = "image",
  }) async {
    Get.log("updateUserProfileImage");
    var dialog = DimLoadingDialog(context,
        blur: 3,
        dismissable: false,
        backgroundColor: const Color(0x30000000),
        animationDuration: const Duration(milliseconds: 100));
    dialog.show();
    try {
      var reference = _storage
          .ref()
          .child("${prefix}_${groupId}_${FileUtils.getFileDisplayName(image)}");
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      var downloadURL = await taskSnapshot.ref.getDownloadURL();
      dialog.dismiss();
      return downloadURL;
    } catch (e) {
      dialog.dismiss();
      Get.log(e.toString(), isError: true);
      return null;
    }
  }

  Future uploadImage({
    required BuildContext context,
    required File image,
    String prefix = "image",
  }) async {
    Get.log("updateUserProfileImage");
    var dialog = DimLoadingDialog(context,
        blur: 3,
        dismissable: false,
        backgroundColor: const Color(0x30000000),
        animationDuration: const Duration(milliseconds: 100));
    dialog.show();
    try {
      var reference = _storage
          .ref()
          .child("${prefix}_${FileUtils.getFileDisplayName(image)}");
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      var downloadURL = await taskSnapshot.ref.getDownloadURL();
      dialog.dismiss();
      return downloadURL;
    } catch (e) {
      dialog.dismiss();
      Get.log(e.toString(), isError: true);
      return null;
    }
  }

  Future approvedRequest({
    required BuildContext context,
    required String requestId,
    required String userId,
    required String name,
  }) async {
    Get.log("updateUserProfileImage");

    try {
      await chatService.approvedRequest(
          groupId: currentGroup.value?.id ?? "",
          groupName:
              (currentGroup.value?.data() as Map).getValueOfKey("groupName") ??
                  "",
          userName: name,
          requestId: requestId,
          userId: userId);
      // if(context.mounted) dialog.dismiss();
    } catch (e) {
      // dialog.dismiss();
      "Something went wrong".showSnackbar();
      Get.log(e.toString(), isError: true);
    }
  }

  checkIfGroupPrivate({Object? obj}) {
    try {
      if (obj is Map && obj["groupType"] == GroupType.public.name) {
        return false;
      }
      return true;
    } catch (e) {
      e.toString().printError();
      return true;
    }
  }

  getGroupBanner({Map? groupData}) {
    // var data = currentGroup.value?.data();
    if (groupData is Map && groupData.containsKey("groupIcon")) {
      if (groupData.getValueOfKey("groupIcon") is String) {
        return groupData.getValueOfKey("groupIcon");
      }
    }
    return null;
  }

  getGroupDescription({Map? groupData}) {
    // var data = currentGroup.value?.data();
    if (groupData is Map && groupData.containsKey("description")) {
      if (groupData.getValueOfKey("description") is String) {
        return groupData.getValueOfKey("description");
      }
    }
    return null;
  }

  int getGroupMembers({Map? groupData}) {
    // Ensure groupData is not null and contains the key "members"
    if (groupData == null || !groupData.containsKey("members")) {
      return 0;
    }

    // Ensure the value associated with "members" is a list
    var members = groupData["members"];
    if (members is List) {
      return members.length;
    }

    // Return 0 if members is not a List
    return 0;
  }

  double? getGroupMember({Map? groupData}) {
    int totalMembers = 0;
    double poolAmount = 0.0;
    if (groupData?.containsKey("members") ?? false) {
      try {
        for (var data in groupData.getValueOfKey("members")) {
          totalMembers++;
        }
        poolAmount = (totalMembers - 1) *
            double.parse(groupData.getValueOfKey("joinAmount").toString());
        print(poolAmount);
      } catch (e) {
        print(e);
      }
    }

    return poolAmount;
  }

  Future<bool> checkMemberAnswered(
      String collectionName, String documentId, String userId) async {
    try {
      DocumentReference documentRef =
          FirebaseFirestore.instance.collection(collectionName).doc(documentId);
      DocumentSnapshot snapshot = await documentRef.get();
      Map<String, dynamic> currentData =
          snapshot.data() as Map<String, dynamic>;
      List<Map<String, dynamic>> userOutcome =
          List.from(currentData['userOutcome'] ?? []);
      bool userIdExists =
          userOutcome.any((element) => element['userId'] == userId);
      return userIdExists;
    } catch (error) {
      print('Error adding data to Firestore: $error');
    }
    return false;
  }

  Future<void> addOutcomeToGroup(String collectionName, String documentId,
      Map<String, dynamic> newData, String userId) async {
    try {
      DocumentReference documentRef =
          FirebaseFirestore.instance.collection(collectionName).doc(documentId);
      DocumentSnapshot snapshot = await documentRef.get();
      Map<String, dynamic> currentData =
          snapshot.data() as Map<String, dynamic>;
      List<Map<String, dynamic>> userOutcome =
          List.from(currentData['userOutcome'] ?? []);
      bool userIdExists =
          userOutcome.any((element) => element['userId'] == userId);
      if (!userIdExists) {
        userOutcome.add(newData);
        currentData['userOutcome'] = userOutcome;
        await documentRef.update(currentData);
      }
    } catch (error) {
      print('Error adding data to Firestore: $error');
    }
  }

  Future getOutcomeCount(String documentId) async {
    yesCount = 0;
    noCount = 0;
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(documentId)
          .get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('userOutcome')) {
          for (var outcome in data['userOutcome']) {
            if (outcome['selectedOutCome'].toString().toLowerCase() == 'yes') {
              yesCount++;
            } else if (outcome['selectedOutCome'].toString().toLowerCase() ==
                'no') {
              noCount++;
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  var groupFee = Rxn<num>();
  Future<bool> groupCreationEligibility(
      {required WalletContoller controller}) async {
    try {
      var data = await chatService.getChatAboutData();
      if (data != null && data.containsKey("group_creation_fee")) {
        if (data.containsKey("group_creation_fee")) {
          var wallet = await controller.getWalletData(uid);
          if ((wallet.currentAmount + wallet.onlyInAppUseableAmount) >=
              (data.getValueOfKey("group_creation_fee") as num)) {
            groupFee.value = data.getValueOfKey("group_creation_fee");
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> groupEventJoinEligibilityCheck(
      {required WalletContoller controller,
      required int groupJoinAmount}) async {
    try {
      var wallet = await controller.getWalletData(uid);
      if ((wallet.currentAmount + wallet.onlyInAppUseableAmount) >=
          groupJoinAmount) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flexx_bet/ui/components/custom_appbar.dart';
// import 'package:flexx_bet/ui/private%20chat/private_chat.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../constants/colors.dart';
// import '../../constants/images.dart';
// import '../../controllers/auth_controller.dart';
// import '../../controllers/private_chat_list_controller.dart';
// import '../../models/user_model.dart';

// class PrivateChatUserScreen extends StatefulWidget {
//   const PrivateChatUserScreen({super.key});

//   @override
//   State<PrivateChatUserScreen> createState() => _PrivateChatUserScreenState();
// }

// class _PrivateChatUserScreenState extends State<PrivateChatUserScreen> {
//   TextEditingController _searchController = TextEditingController();
//   PrivateChatListController privatechatlistcontroller =
//       PrivateChatListController.to;
//   bool isFriend = false;
//   List<Map<String, dynamic>> friendRequests = [];
//   List<Map<String, dynamic>> frienddetail = [];
//   String _generateChatId(String uid1, String uid2) {
//     return uid1.hashCode <= uid2.hashCode ? '$uid1-$uid2' : '$uid2-$uid1';
//   }

//   @override
//   void initState() {
//     super.initState();
//     // loadData();
//     getFriends();
//   }

//   void getFriends() async {
//     setState(() {
//       isFriend = true;
//     });
//     final FirebaseFirestore _db = FirebaseFirestore.instance;
//     AuthController authController = AuthController.to;
//     final UserModel userModel = authController.userFirestore!;
//     final String userId = userModel.uid;

//     // Listen to friend requests
//     _db.collection('friend_requests').snapshots().listen((snapshot) async {
//       for (var document in snapshot.docs) {
//         var data = document.data();
//         var from = data['from'];
//         var to = data['to'];

//         if (from == userId || to == userId) {
//           Map<String, dynamic> friendData;

//           if (from == userId) {
//             // Fetch the friend's data
//             DocumentSnapshot<Map<String, dynamic>> docSnapshot =
//                 await _db.collection('users').doc(to).get();
//             friendData = docSnapshot.data()!;
//             var _chatId = _generateChatId(from, to);
//             var friendchat = await _db
//                 .collection('chats')
//                 .doc(_chatId)
//                 .collection('messages')
//                 .orderBy('timestamp', descending: false)
//                 .snapshots();
//             print("MyFriendChat::${friendchat}");
//           } else {
//             // Fetch the friend's data
//             DocumentSnapshot<Map<String, dynamic>> docSnapshot =
//                 await _db.collection('users').doc(from).get();
//             friendData = docSnapshot.data()!;
//             var _chatId = _generateChatId(to, from);
//             var friendchat = await _db
//                 .collection('chats')
//                 .doc(_chatId)
//                 .collection('messages')
//                 .orderBy('timestamp', descending: false)
//                 .snapshots();
//             print("MyFriendChat::${friendchat}");
//           }

//           frienddetail.add(friendData);
//           friendRequests.add(data);
//         }
//       }

//       setState(() {
//         isFriend = false;
//       });

//       print("All Friend Requests for User $userId: $friendRequests");
//       print("All Friend Detail for User $userId: $frienddetail");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFEFEFEF),
//       appBar: CustomAppBar(
//         showBackButton: true,
//         showSearchButton: true,
//         showCreateEvent: false,
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: 14,
//           vertical: 15,
//         ),
//         child: Column(
//           children: [
//             Container(
//               height: 35,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               child: TextField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search messages',
//                   hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
//                   border: InputBorder.none,
//                   prefixIcon: Image.asset(
//                     ImageConstant.search1,
//                     width: 17,
//                     height: 17,
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(vertical: 13.5),
//                 ),
//               ),
//             ),
//             SizedBox(height: 25),
//             isFriend == true
//                 ? Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : Column(
//                     children: [
//                       for (var i = 0; i < frienddetail.length; i++)
//                         Padding(
//                           padding: EdgeInsets.only(bottom: 19),
//                           child: _chatUser(
//                             true,
//                             frienddetail[i]['photoUrl'] == null
//                                 ? "https://firebasestorage.googleapis.com/v0/b/flexxbet.appspot.com/o/profile_image3DZp0UVgrkgTMLTJIlhMmvpHoz82?alt=media&token=a7e4d0cf-9eff-4507-ba32-d9fbc15c3dc9"
//                                 : frienddetail[i]['photoUrl'],
//                             frienddetail[i]['name'] == null
//                                 ? "Unknown"
//                                 : frienddetail[i]['name'],
//                             "No message",
//                             "05:10",
//                             () {
//                               Get.to(
//                                 () => PrivateChatScreen(
//                                     userUid: frienddetail[i]['uid'],
//                                     userImage: frienddetail[i]['photoUrl'] ==
//                                             null
//                                         ? "https://firebasestorage.googleapis.com/v0/b/flexxbet.appspot.com/o/profile_image3DZp0UVgrkgTMLTJIlhMmvpHoz82?alt=media&token=a7e4d0cf-9eff-4507-ba32-d9fbc15c3dc9"
//                                         : frienddetail[i]['photoUrl'],
//                                     userName: frienddetail[i]['name'] == null
//                                         ? "Unknown"
//                                         : frienddetail[i]['name']),
//                               );
//                             },
//                           ),
//                         ),
//                     ],
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _chatUser(bool latestMessage, String image, String username,
//       String message, String time, void Function()? onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               SizedBox(
//                 height: 48,
//                 width: 52,
//                 child: Stack(
//                   alignment: Alignment.topRight,
//                   children: [
//                     Positioned(
//                       top: 0,
//                       left: 0,
//                       child: Container(
//                         height: 48,
//                         width: 48,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                         ),
//                         child: ClipOval(
//                           child: SizedBox(
//                             height: 30.0,
//                             width: 30.0,
//                             child: Image.network(
//                               image,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         top: 33,
//                         right: 3,
//                       ),
//                       child: Container(
//                         height: 12,
//                         width: 12,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Colors.white,
//                           ),
//                           gradient: LinearGradient(
//                             colors: [
//                               Color(0xff1BF631),
//                               Color(0xff00AE11),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     username,
//                     style: TextStyle(
//                         color: ColorConstant.black900,
//                         fontFamily: "Popins",
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16),
//                   ),
//                   Text(
//                     message,
//                     style: TextStyle(
//                       color: latestMessage
//                           ? ColorConstant.black900
//                           : Colors.black12,
//                       fontFamily: "Popins",
//                       fontWeight: FontWeight.w400,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 time,
//                 style: TextStyle(
//                   color: ColorConstant.black900,
//                   fontFamily: "Popins",
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                 ),
//               ),
//               if (latestMessage)
//                 Container(
//                   width: 20,
//                   height: 20,
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "12",
//                       style: TextStyle(
//                         color: ColorConstant.whiteA700,
//                         fontFamily: "Popins",
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flexx_bet/models/UserDetailModel.dart';
import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flexx_bet/ui/private%20chat/private_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/private_chat_list_controller.dart';
import '../../models/user_model.dart';
import '../../models/message_model.dart';

class PrivateChatUserScreen extends StatefulWidget {
  const PrivateChatUserScreen({super.key});

  @override
  State<PrivateChatUserScreen> createState() => _PrivateChatUserScreenState();
}

class _PrivateChatUserScreenState extends State<PrivateChatUserScreen> {
  TextEditingController _searchController = TextEditingController();
  PrivateChatListController privatechatlistcontroller =
      PrivateChatListController.to;
  bool isFriend = false;
  List<Map<String, dynamic>> friendDetail = [];
  List<Map<String, dynamic>> filteredFriendDetail = [];

  String _generateChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '$uid1-$uid2' : '$uid2-$uid1';
  }

  AuthController authController = AuthController.to;
  late UserModel? userModel;
  bool isOnline = false;
  @override
  void initState() {
    super.initState();
    userModel = authController.userFirestore!;
    getFriends();
    _searchController.addListener(_onSearchChanged);
  }

  void _listenToUserPresence(String userUid) {
    DatabaseReference userStatusDatabaseRef =
        FirebaseDatabase.instance.ref("status/${userUid}/state");
    print(userStatusDatabaseRef);
    userStatusDatabaseRef.onValue.listen((event) {
      final status = event.snapshot.value as String?;
      setState(() {
        isOnline = status == "online";
      });
    });
  }

  void getFriends() async {
    setState(() {
      isFriend = true;
    });

    final FirebaseFirestore _db = FirebaseFirestore.instance;
    AuthController authController = AuthController.to;
    final UserModel userModel = authController.userFirestore!;
    final String userId = userModel.uid;

    _db.collection('friend_requests').snapshots().listen((snapshot) async {
      List<Map<String, dynamic>> friends = [];

      for (var document in snapshot.docs) {
        var data = document.data();
        var from = data['from'];
        var to = data['to'];
        if (from == userId || to == userId) {
          String friendUid = from == userId ? to : from;

          // Fetch friend's user details
          DocumentSnapshot<Map<String, dynamic>> friendSnapshot =
              await _db.collection('users').doc(friendUid).get();
          UserDetailModel friendData =
              UserDetailModel.fromMap(friendSnapshot.data()!);

          // Fetch latest message in the chat
          String chatId = _generateChatId(from, to);
          QuerySnapshot messageSnapshot = await _db
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          MessageModel? latestMessage;

          if (messageSnapshot.docs.isNotEmpty) {
            latestMessage = MessageModel.fromMap(
              messageSnapshot.docs.first.data() as Map<String, dynamic>,
            );
          } else {
            latestMessage = null;
          }

          int unreadCount = messageSnapshot.docs
              .where((doc) => !doc['isRead'] && doc['senderUid'] != userId)
              .length;
          print("UnReadCont::${unreadCount}");
          _listenToUserPresence(friendUid);
          friends.add({
            'user': friendData,
            'latestMessage': latestMessage,
            'unreadCount': unreadCount,
          });
        }
      }
      friends.sort((a, b) {
        DateTime? timeA = a['latestMessage']?.timestamp;
        DateTime? timeB = b['latestMessage']?.timestamp;

        return timeB?.compareTo(timeA ?? DateTime(0)) ?? 1;
      });
      setState(() {
        friendDetail = friends;
        filteredFriendDetail = friends; // Initially show all friends
        isFriend = false;
      });
    });
  }

  // Handle search input changes
  void _onSearchChanged() {
    setState(() {
      filteredFriendDetail = friendDetail
          .where((friend) => friend['user']
              .name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      appBar: CustomAppBar(
        showBackButton: true,
        showSearchButton: true,
        showCreateEvent: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        child: Column(
          children: [
            Container(
              height: 35,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by username',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                  border: InputBorder.none,
                  prefixIcon: Padding(
                    padding:
                        const EdgeInsets.all(8.0), // Adjust padding as needed
                    child: Image.asset(
                      ImageConstant.search1,
                      width: 16, // Set desired width for the icon
                      height: 16, // Set desired height for the icon
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 13.5),
                ),
              ),
            ),
            SizedBox(height: 25),
            isFriend == true
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      for (var i = 0; i < filteredFriendDetail.length; i++)
                        Padding(
                          padding: EdgeInsets.only(bottom: 19),
                          child: _chatUser(
                            filteredFriendDetail[i]['user'],
                            filteredFriendDetail[i]['latestMessage'],
                            filteredFriendDetail[i]['unreadCount'],
                            () {
                              Get.to(
                                () => PrivateChatScreen(
                                  userUid: filteredFriendDetail[i]['user'].uid,
                                  userImage:
                                      filteredFriendDetail[i]['user'].photoUrl,
                                  userName:
                                      filteredFriendDetail[i]['user'].name,
                                ),
                              );
                              Future.delayed(
                                  Duration(
                                    seconds: 1,
                                  ), () {
                                getFriends();
                              });
                            },
                          ),
                        ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _chatUser(UserDetailModel user, MessageModel? latestMessage,
      int unreadCount, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isOnline ? Color(0xff00AE11) : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    Text(
                      latestMessage?.message ?? "No message",
                      style: TextStyle(
                        color: unreadCount > 0
                            ? ColorConstant.black900
                            : Colors.grey,
                        fontFamily: "Popins",
                        fontWeight: unreadCount > 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  latestMessage?.time ?? "",
                  style: TextStyle(
                    color: ColorConstant.black900,
                    fontFamily: "Popins",
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                if (unreadCount > 0)
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "$unreadCount",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

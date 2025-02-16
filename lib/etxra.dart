// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import '../../constants/colors.dart';
// import '../../constants/images.dart';
// import '../../controllers/wallet_controller.dart';
// import '../notifications_and_bethistory/notifications.dart';
// import '../wallet/wallet.dart';
//
// class PrivateChatScreen extends StatefulWidget {
//   final String userUid;
//   final String userName;
//   final String userImage;
//
//   const PrivateChatScreen({
//     Key? key,
//     required this.userUid,
//     required this.userImage,
//     required this.userName,
//   }) : super(key: key);
//
//   @override
//   _PrivateChatScreenState createState() => _PrivateChatScreenState();
// }
//
// class _PrivateChatScreenState extends State<PrivateChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//
//   late String _chatId;
//
//   @override
//   void initState() {
//     super.initState();
//     final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
//     _chatId = _generateChatId(currentUserUid, widget.userUid);
//   }
//
//   String _generateChatId(String uid1, String uid2) {
//     return uid1.hashCode <= uid2.hashCode ? '$uid1-$uid2' : '$uid2-$uid1';
//   }
//
//   void _sendMessage() async {
//     if (_messageController.text.trim().isEmpty) return;
//
//     final message = _messageController.text.trim();
//     _messageController.clear();
//
//     DateTime now = DateTime.now();
//     String formattedDate = DateFormat('dd MMMM').format(now);
//     String formattedTime = DateFormat('h:mm a').format(now);
//
//     final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
//
//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(_chatId)
//         .collection('messages')
//         .add({
//       'senderUid': currentUserUid,
//       'message': message,
//       'date': formattedDate,
//       'time': formattedTime,
//       'timestamp': now,
//       'isRead': false,
//       'emoji': '',
//     });
//
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }
//
//   void _markMessagesAsRead(QuerySnapshot snapshot) {
//     final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
//
//     for (var doc in snapshot.docs) {
//       final messageData = doc.data() as Map<String, dynamic>;
//       if (messageData['senderUid'] != currentUserUid &&
//           !(messageData['isRead'] ?? false)) {
//         doc.reference.update({'isRead': true});
//       }
//     }
//   }
//
//   String _formatTimestamp(Timestamp timestamp) {
//     final DateTime dateTime = timestamp.toDate();
//     return DateFormat('h:mm a').format(dateTime);
//   }
//
//   void _showEmojiPicker(DocumentSnapshot message) async {
//     final selectedEmoji = await showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Select Emoji'),
//           content: Wrap(
//             spacing: 10.0,
//             children: [
//               _emojiOption(context, '😀', message),
//               _emojiOption(context, '❤️', message),
//               _emojiOption(context, '😆', message),
//               _emojiOption(context, '😢', message),
//               _emojiOption(context, '👍', message),
//               _emojiOption(context, '👎', message),
//             ],
//           ),
//         );
//       },
//     );
//
//     if (selectedEmoji != null) {
//       message.reference.update({'emoji': selectedEmoji});
//     }
//   }
//
//   Widget _emojiOption(BuildContext context, String emoji, DocumentSnapshot message) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).pop(emoji);
//       },
//       child: Text(
//         emoji,
//         style: const TextStyle(fontSize: 24),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         toolbarHeight: 80,
//         iconTheme: IconThemeData(color: ColorConstant.whiteA700),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Get.to(() => NotificationsScreen());
//               },
//               icon: SvgPicture.asset(ImageConstant.notificationIcon)),
//           const SizedBox(
//             width: 6,
//           ),
//           GestureDetector(
//             onTap: () {
//               Get.to(() => WalletScreen());
//             },
//             child: Container(
//               height: 35,
//               width: 97,
//               margin: const EdgeInsets.only(top: 14, bottom: 14),
//               padding: const EdgeInsets.only(left: 18, right: 18),
//               decoration: BoxDecoration(
//                   color: ColorConstant.whiteA700,
//                   borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(50),
//                       bottomLeft: Radius.circular(50))),
//               child: Center(
//                 child: GetBuilder<WalletContoller>(builder: (controller) {
//                   return Text(
//                     "₦${controller.totalAmount}",
//                     style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontWeight: FontWeight.w600,
//                         color: ColorConstant.primaryColor),
//                   );
//                 }),
//               ),
//             ),
//           )
//         ],
//         leading: BackButton(
//           onPressed: () {
//             Get.back();
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//                 border: Border(
//                     bottom: BorderSide(color: Color(0xffEFEFEF), width: 2))),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CircleAvatar(
//                   backgroundImage: NetworkImage(widget.userImage),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '@${widget.userName}',
//                       style: const TextStyle(
//                           color: Color(0xffEE531F),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600),
//                     ),
//                     const Text('Seen 1 minute ago')
//                   ],
//                 ),
//                 IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
//               ],
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .doc(_chatId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: false)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 final messages = snapshot.data!.docs;
//
//                 // Mark messages as read when they arrive
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   _markMessagesAsRead(snapshot.data!);
//                 });
//
//                 String? previousDate;
//
//                 return ListView.builder(
//                   controller: _scrollController,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final messageData =
//                     messages[index].data() as Map<String, dynamic>;
//                     final isSender = messageData['senderUid'] ==
//                         FirebaseAuth.instance.currentUser!.uid;
//                     final isRead = messageData['isRead'] ?? false;
//                     final timestamp = messageData['timestamp'] as Timestamp;
//                     final date = messageData['date'];
//                     final emoji = messageData['emoji'];
//
//                     // Display date if it's different from the previous message's date
//                     bool showDate = false;
//                     if (previousDate != date) {
//                       showDate = true;
//                       previousDate = date;
//                     }
//
//                     return GestureDetector(
//                       onLongPress: () {
//                         _showEmojiPicker(messages[index]);
//                       },
//                       child: Column(
//                         children: [
//                           if (showDate)
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 10.0),
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 12, vertical: 1),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(25),
//                                     color: const Color(0xff606060)),
//                                 child: Text(
//                                   date,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           Align(
//                             alignment: isSender
//                                 ? Alignment.centerRight
//                                 : Alignment.centerLeft,
//                             child: Row(
//                               mainAxisAlignment: isSender
//                                   ? MainAxisAlignment.end
//                                   : MainAxisAlignment.start,
//                               children: [
//                                 if (emoji.isNotEmpty) ...[
//                                   Text(
//                                     emoji,
//                                     style: const TextStyle(fontSize: 24),
//                                   ),
//                                   const SizedBox(width: 5),
//                                 ],
//                                 if (!isSender)
//                                   Container(
//                                     child: CircleAvatar(
//                                       backgroundImage:
//                                       NetworkImage(widget.userImage),
//                                     ),
//                                   ),
//                                 isSender ? const SizedBox():const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: isSender
//                                       ? CrossAxisAlignment.end
//                                       : CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.all(10),
//                                       margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                                       decoration: BoxDecoration(
//                                         color: isSender ? Color(0xffcfcfcf) : Color(0xffffffff),
//                                         // color: isSender
//                                         //     ? const Color(0xffcfcfcf)
//                                         //     : const Color(0xffcfcfcf),
//                                         borderRadius: isSender
//                                             ? const BorderRadius.only(
//                                           topRight: Radius.circular(12),
//                                           topLeft: Radius.circular(12),
//                                           bottomLeft  : Radius.circular(12),
//                                         )
//                                             : const BorderRadius.only(
//                                           topRight: Radius.circular(12),
//                                           topLeft: Radius.circular(12),
//                                           bottomRight: Radius.circular(12),
//                                         ),
//                                       ),
//
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.end,
//                                         children: [
//                                           Text(
//                                             messageData['message'],
//                                             style: TextStyle(
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                           isSender ? Row(
//                                             children: [if (isSender)
//                                               Icon(
//                                                 isRead
//                                                     ? Icons.done_all
//                                                     : Icons.done,
//                                                 size: 16,
//                                                 color: isRead ? Colors.blue : Colors.grey,
//                                               ),
//                                               SizedBox(width: 5),
//                                               Text(
//                                                 _formatTimestamp(timestamp),
//                                                 style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 10,
//                                                 ),
//                                               ),
//
//                                             ],
//                                             mainAxisAlignment: MainAxisAlignment.end,
//                                           ) : SizedBox(),
//                                         ],
//                                       ),
//                                     ),
//                                     // Container(
//                                     //   padding: const EdgeInsets.symmetric(
//                                     //     vertical: 1,
//                                     //     horizontal: 12,
//                                     //   ),
//                                     //   decoration: BoxDecoration(
//                                     //     color: isSender ? Color(0xffcfcfcf) : Color(0xffffffff),
//                                     //     // color: isSender
//                                     //     //     ? const Color(0xffcfcfcf)
//                                     //     //     : const Color(0xffcfcfcf),
//                                     //     borderRadius: isSender
//                                     //         ? const BorderRadius.only(
//                                     //             topRight: Radius.circular(12),
//                                     //             topLeft: Radius.circular(12),
//                                     //             bottomLeft  : Radius.circular(12),
//                                     //           )
//                                     //         : const BorderRadius.only(
//                                     //             topRight: Radius.circular(12),
//                                     //             topLeft: Radius.circular(12),
//                                     //             bottomRight: Radius.circular(12),
//                                     //           ),
//                                     //   ),
//                                     //   child: Container(
//                                     //     constraints: BoxConstraints(
//                                     //       maxWidth:
//                                     //           MediaQuery.sizeOf(context).width *
//                                     //               0.6,
//                                     //     ),
//                                     //     child: Column(
//                                     //       children: [
//                                     //         Text(
//                                     //           messageData['message'],
//                                     //           style: const TextStyle(
//                                     //             fontFamily: "Popins",
//                                     //             fontSize: 16,
//                                     //             fontWeight: FontWeight.w400,
//                                     //             color: Colors.black,
//                                     //           ),
//                                     //         ),
//                                     //         isSender
//                                     //             ? Row(
//                                     //                 children: [
//                                     //                   if (isSender)
//                                     //                     Icon(
//                                     //                       isRead
//                                     //                           ? Icons.done_all
//                                     //                           : Icons.done,
//                                     //                       size: 16,
//                                     //                       color: isRead
//                                     //                           ? Colors.blue
//                                     //                           : Colors.grey,
//                                     //                     ),
//                                     //                   const SizedBox(width: 5),
//                                     //                   Text(
//                                     //                     _formatTimestamp(
//                                     //                         timestamp),
//                                     //                     style: const TextStyle(
//                                     //                       color: Colors.grey,
//                                     //                       fontSize: 10,
//                                     //                     ),
//                                     //                   ),
//                                     //                 ],
//                                     //                 mainAxisAlignment:
//                                     //                     MainAxisAlignment.end,
//                                     //               )
//                                     //             : const SizedBox(),
//                                     //       ],
//                                     //     ),
//                                     //   ),
//                                     // ),
//                                     isSender
//                                         ? const SizedBox(height: 10,)
//                                         : Row(
//                                       children: [
//                                         const SizedBox(width: 5),
//                                         Text(
//                                           _formatTimestamp(timestamp),
//                                           style: const TextStyle(
//                                             color: Colors.grey,
//                                             fontSize: 10,
//                                           ),
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                                 isSender ? const SizedBox(
//                                   width: 10,):const SizedBox(),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(
//                     Icons.attach_file_outlined,
//                     color: Color(0xFF7340ff),
//                   ),
//                   onPressed: _sendMessage,
//                 ),
//                 const ImageIcon(
//                   AssetImage('assets/images/thunder.png'),
//                   color: Color(0xFF7340ff),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintStyle: const TextStyle(
//                         color: Color(0xFF7340ff),
//                       ),
//                       hintText: 'Send a message',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                     ),
//                     onSubmitted: (value) => _sendMessage(),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.arrow_circle_right_rounded,
//                     color: Color(0xFF7340ff),
//                     size: 24,
//                   ),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

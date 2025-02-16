import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flexx_bet/chat/widgets/chat_user_info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../chat/chat_controller.dart';
import '../../chat/chat_service.dart';
import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../controllers/wallet_controller.dart';
import '../../utils/file_utils.dart';
import '../../utils/widgets.dart';
import '../components/custom_appbar.dart';
import '../notifications_and_bethistory/notifications.dart';
import '../wallet/wallet.dart';

class PrivateChatScreen extends StatefulWidget {
  const PrivateChatScreen({
    Key? key,
    required this.userUid,
    required this.userImage,
    required this.userName,
  }) : super(key: key);

  final String userImage;
  final String userName;
  final String userUid;

  @override
  _PrivateChatScreenState createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  var controller = Get.find<ChatController>();
  bool isOnline = false;
  var msgController = TextEditingController();
  String onlineText = "";

  late String _chatId;
  String? _currentDate;
  final ValueNotifier<String> _currentDateNotifier = ValueNotifier<String>('');
  bool _isScrollable = false;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _currentDateNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkOnline();
    print("MyOnlineText::${onlineText}");
    print("MyUserIdOk::${widget.userUid}");
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    print("MyCurrentUedIdOK::${currentUserUid}");

    _chatId = _generateChatId(currentUserUid, widget.userUid);
    _listenToUserPresence();
  }

  String formatDate(DateTime date) {
    final today = DateTime.now();
    final yesterday = today.subtract(Duration(days: 1));
    final oneWeekAgo = today.subtract(Duration(days: 7));

    // Check if the date is today
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return "Today";
    }

    // Check if the date is yesterday
    else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return "Yesterday";
    }

    // Check if the date is within the last week
    else if (date.isAfter(oneWeekAgo)) {
      return DateFormat('EEEE').format(date); // Day of the week, e.g., "Sunday"
    }

    // If the date is more than a week old, return the full date
    else {
      return DateFormat('d MMMM yyyy').format(date); // Format as "2024-11-13"
    }
  }

  void _listenToUserPresence() {
    DatabaseReference userStatusDatabaseRef =
        FirebaseDatabase.instance.ref("status/${widget.userUid}/state");
    print(userStatusDatabaseRef);
    userStatusDatabaseRef.onValue.listen((event) {
      final status = event.snapshot.value as String?;
      print(status);
      setState(() {
        isOnline = status == "online";
      });
    });
  }

  void _checkOnline() {
    // Reference to the user's status in Firebase
    DatabaseReference userStatusDatabaseRef =
        FirebaseDatabase.instance.ref("status/${widget.userUid}/state");
    print(userStatusDatabaseRef);

    // Listen for changes in the user's status
    userStatusDatabaseRef.onValue.listen((event) {
      final data = event.snapshot.value;
      print(data);

      setState(() {
        if (data is Map) {
          final status = data['state'] as String?;
          final lastSeenTimestamp = data['last_seen'] as int?;

          if (status == "online") {
            // Set the text to "Online" if the user is online
            onlineText = "Online";
          } else if (lastSeenTimestamp != null) {
            // If offline, calculate the time difference
            final lastSeenDate =
                DateTime.fromMillisecondsSinceEpoch(lastSeenTimestamp);
            final difference = DateTime.now().difference(lastSeenDate);

            if (difference.inDays >= 2) {
              onlineText = "${difference.inDays} days ago";
            } else if (difference.inDays == 1) {
              onlineText = "Yesterday";
            } else if (difference.inHours >= 1) {
              onlineText = "${difference.inHours} hours ago";
            } else {
              onlineText = "${difference.inMinutes} minutes ago";
            }
          } else {
            // Default to "Offline" if no last seen timestamp is available
            onlineText = "Offline";
            print("OKOK11::${onlineText}");
          }
        } else if (data is String && data == "online") {
          // If the data is a simple string "online"
          onlineText = "Online";
        } else {
          // Default to "Offline" if data is null or unrecognized
          onlineText = "Offline";
          print("OKOK::${onlineText}");
        }
        print(onlineText);
      });
    });
  }

  String _generateChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '$uid1-$uid2' : '$uid2-$uid1';
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    _messageController.clear();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM').format(now);
    String formattedTime = DateFormat('h:mm a').format(now);

    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(_chatId)
        .collection('messages')
        .add({
      'senderUid': currentUserUid,
      'receiverUid': widget.userUid, // Include receiver's UID
      'message': message,
      'date': formattedDate,
      'time': formattedTime,
      'timestamp': now,
      'isRead': false,
      'emoji': '',
    });

    // Optionally scroll to the bottom of the chat
    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );
  }

  void _sendImageMessage(File imageFile) async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    // Upload image to Firebase Storage
    final ref = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child(_chatId)
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    await ref.putFile(imageFile);
    final imageUrl = await ref.getDownloadURL();

    // Send the image message to Firestore
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM').format(now);
    String formattedTime = DateFormat('h:mm a').format(now);

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(_chatId)
        .collection('messages')
        .add({
      'senderUid': currentUserUid,
      'message': '',
      'imageUrl': imageUrl,
      'date': formattedDate,
      'time': formattedTime,
      'timestamp': now,
      'isRead': false,
      'emoji': '',
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _markMessagesAsRead(QuerySnapshot snapshot) {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    for (var doc in snapshot.docs) {
      final messageData = doc.data() as Map<String, dynamic>;
      if (messageData['senderUid'] != currentUserUid &&
          !(messageData['isRead'] ?? false)) {
        doc.reference.update({'isRead': true});
      }
    }
  }

  void _updateScrollStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _isScrollable = _scrollController.position.maxScrollExtent > 0;
        if (!_isScrollable) {
          _currentDateNotifier.value = ""; // Hide the date if not scrollable
        }
      }
    });
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('h:mm a').format(dateTime);
  }

  void _showEmojiPicker(DocumentSnapshot message) async {
    final selectedEmoji = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Wrap(
            spacing: 20.0,
            children: [
              _emojiOption(context, '😂', message),
              _emojiOption(context, '❤️', message),
              _emojiOption(context, '👍', message),
              _emojiOption(context, '🎉', message),
              _emojiOption(context, '😢', message),
            ],
          ),
        );
      },
    );

    if (selectedEmoji != null) {
      message.reference.update({'emoji': selectedEmoji});
    }
  }

  Widget _emojiOption(
      BuildContext context, String emoji, DocumentSnapshot message) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(emoji);
      },
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: double.minPositive,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffBEFF07),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Image.asset("assets/images/Union.png"),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Challenge me',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(height: 1, color: Colors.grey),
                _buildDialogOption(
                  context,
                  icon: Icons.person_remove_alt_1_outlined,
                  text: 'Unfriend',
                  onTap: () async {
                    _rejectFriendRequest(controller.uid!, widget.userUid);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                _buildDialogOption(
                  context,
                  icon: Icons.report_outlined,
                  text: 'Report user',
                  onTap: () {
                    // Handle Report user
                  },
                ),
                _buildDialogOption(
                  context,
                  icon: Icons.block_outlined,
                  text: 'Block User',
                  onTap: () {
                    // Handle Block User
                  },
                ),
                _buildDialogOption(
                  context,
                  icon: Icons.delete,
                  text: 'Delete Conversation',
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () {
                    _deleteConversation();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteConversation() async {
    try {
      // Get a reference to the collection of messages within the chat
      CollectionReference messagesRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(_chatId)
          .collection('messages');

      // Get all documents in the collection and delete them
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Get all messages in the conversation
      QuerySnapshot messagesSnapshot = await messagesRef.get();

      // Iterate through each document and add it to the batch delete operation
      for (DocumentSnapshot doc in messagesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Commit the batch delete operation
      await batch.commit();

      // Optionally, you can delete the chat document itself if no other data is associated with it
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(_chatId)
          .delete();

      // Navigate back after deletion
      Navigator.of(context).pop();
      Get.back();

      print("Conversation deleted successfully.");
    } catch (e) {
      print("Failed to delete conversation: $e");
    }
  }

  Widget _buildDialogOption(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      Color? textColor,
      Color? iconColor}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(
            text,
            style: TextStyle(color: textColor),
          ),
          onTap: onTap,
        ),
        Divider(height: 1, color: Colors.grey),
      ],
    );
  }

  // void _rejectFriendRequest(String userId) async {
  //   final firestore = FirebaseFirestore.instance;

  //   try {
  //     // Assuming the collection for friend requests is 'friend_requests'
  //     final requestRef = firestore.collection('friend_requests').doc(userId);

  //     // Update the friend request to 'rejected'
  //     await requestRef.update({'status': 'rejected'});

  //     print('Friend request from $userId rejected.');
  //   } catch (e) {
  //     print('Failed to reject friend request: $e');
  //   }
  // }
  void _rejectFriendRequest(String currentUserId, String otherUserId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Dono taraf friend request status ko update karein
      final currentUserRequestRef =
          firestore.collection('friend_requests').doc(currentUserId);
      final otherUserRequestRef =
          firestore.collection('friend_requests').doc(otherUserId);

      // Update current user's document
      await currentUserRequestRef.update({'status': 'rejected'});

      // Update other user's document
      await otherUserRequestRef.update({'status': 'rejected'});

      print('Friend request rejected for $otherUserId by $currentUserId');
    } catch (e) {
      print('Failed to reject friend request: $e');
    }
  }

  void _updateCurrentDate(List<QueryDocumentSnapshot> messages) {
    for (final message in messages) {
      final messageData = message.data() as Map<String, dynamic>;
      final date = messageData['date'];

      if (date != _currentDate) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _currentDate = date;
            });
          }
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: true,
        showSearchButton: true,
        showCreateEvent: false,
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xffEFEFEF), width: 2))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.userImage),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '@${widget.userName}',
                      style: const TextStyle(
                          color: Color(0xffEE531F),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const Text('Seen 1 minute ago')
                  ],
                ),
                IconButton(
                    onPressed: () {
                      _showCustomDialog(context);
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
          ),

          // ValueListenableBuilder<String>(
          //   valueListenable: _currentDateNotifier,
          //   builder: (context, currentDate, _) {
          //     return (_isScrollable && currentDate.isNotEmpty)
          //         ? Container(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 12, vertical: 8),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(9),
          //               color: const Color(0xff606060),
          //             ),
          //             child: Text(
          //               currentDate,
          //               style: const TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 12,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           )
          //         : SizedBox();
          //   },
          // ),
          Expanded(
            child: Stack(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(_chatId)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final messages = snapshot.data!.docs;
                    // _updateScrollStatus();
                    // Mark messages as read when they arrive
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _markMessagesAsRead(snapshot.data!);
                    });

                    String? previousDate;

                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final messageData =
                            messages[index].data() as Map<String, dynamic>;
                        final isSender = messageData['senderUid'] ==
                            FirebaseAuth.instance.currentUser!.uid;
                        final isRead = messageData['isRead'] ?? false;
                        final timestamp = messageData['timestamp'] as Timestamp;
                        final date = timestamp.toDate();
                        final formattedDate = formatDate(date);
                        print(formattedDate);
                        final emoji = messageData['emoji'];
                        final imageUrl = messageData['imageUrl'] ?? '';

                        bool showDate = false;
                        if (index == messages.length - 1 ||
                            formatDate((messages[index + 1].data()
                                        as Map<String, dynamic>)['timestamp']
                                    .toDate()) !=
                                formattedDate) {
                          showDate = true;
                        }

                        return GestureDetector(
                          onLongPress: () {
                            _showEmojiPicker(messages[index]);
                          },
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  if (showDate)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 1),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: const Color(0xff606060),
                                        ),
                                        child: Text(
                                          formattedDate,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Align(
                                    alignment: isSender
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment: isSender
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        if (!isSender) SizedBox(width: 10),
                                        if (!isSender)
                                          CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(widget.userImage),
                                          ),
                                        if (!isSender) const SizedBox(width: 5),
                                        Column(
                                          crossAxisAlignment: isSender
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: [
                                            if (imageUrl.isNotEmpty)
                                              GestureDetector(
                                                onTap: () =>
                                                    _showFullScreenImage(
                                                        context, imageUrl),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 4,
                                                      horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    color: isSender
                                                        ? const Color(
                                                            0xffcfcfcf)
                                                        : const Color(
                                                            0xffffffff),
                                                    borderRadius: isSender
                                                        ? const BorderRadius
                                                            .only(
                                                            topRight:
                                                                Radius.circular(
                                                                    12),
                                                            topLeft:
                                                                Radius.circular(
                                                                    12),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    12),
                                                          )
                                                        : const BorderRadius
                                                            .only(
                                                            topRight:
                                                                Radius.circular(
                                                                    12),
                                                            topLeft:
                                                                Radius.circular(
                                                                    12),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    12),
                                                          ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    child: Image.network(
                                                      imageUrl,
                                                      fit: BoxFit.cover,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if (messageData['message']
                                                .isNotEmpty)
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 4, horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: isSender
                                                      ? Color(0xffcfcfcf)
                                                      : Color(0xffffffff),
                                                  borderRadius: isSender
                                                      ? const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  12),
                                                          topLeft:
                                                              Radius.circular(
                                                                  12),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  12),
                                                        )
                                                      : const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  12),
                                                          topLeft:
                                                              Radius.circular(
                                                                  12),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  12),
                                                        ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.6,
                                                      ),
                                                      child: Text(
                                                        messageData['message'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    if (isSender)
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            isRead
                                                                ? Icons.done_all
                                                                : Icons.done,
                                                            size: 16,
                                                            color: isRead
                                                                ? Colors.blue
                                                                : Colors.grey,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            _formatTimestamp(
                                                                timestamp),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ],
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            if (emoji.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: Text(emoji),
                                              ),
                                            if (!isSender)
                                              Row(
                                                children: [
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    _formatTimestamp(timestamp),
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ],
                                        ),
                                        if (isSender) const SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // Expanded(
          //   child: StreamBuilder<QuerySnapshot>(
          //     stream: FirebaseFirestore.instance
          //         .collection('chats')
          //         .doc(_chatId)
          //         .collection('messages')
          //         .orderBy('timestamp', descending: false)
          //         .snapshots(),
          //     builder: (context, snapshot) {
          //       if (!snapshot.hasData) {
          //         return const Center(child: CircularProgressIndicator());
          //       }

          //       final messages = snapshot.data!.docs;

          //       // Mark messages as read when they arrive
          //       WidgetsBinding.instance.addPostFrameCallback((_) {
          //         _markMessagesAsRead(snapshot.data!);
          //       });

          //       String? previousDate;

          //       return ListView.builder(
          //         reverse: true,
          //         controller: _scrollController,
          //         itemCount: messages.length,
          //         itemBuilder: (context, index) {
          //           final messageData =
          //               messages[index].data() as Map<String, dynamic>;
          //           final isSender = messageData['senderUid'] ==
          //               FirebaseAuth.instance.currentUser!.uid;
          //           final isRead = messageData['isRead'] ?? false;
          //           final timestamp = messageData['timestamp'] as Timestamp;
          //           final date = messageData['date'];
          //           print(date);
          //           final emoji = messageData['emoji'];
          //           final imageUrl = messageData['imageUrl'] ?? '';

          //           bool showDate = false;
          //           if (previousDate != date) {
          //             showDate = true;
          //             previousDate = date;
          //           }

          //           return GestureDetector(
          //             onLongPress: () {
          //               _showEmojiPicker(messages[index]);
          //             },
          //             child: Stack(
          //               children: [
          //                 Column(
          //                   children: [
          //                     if (showDate)
          //                       Padding(
          //                         padding: const EdgeInsets.symmetric(
          //                             vertical: 10.0),
          //                         child: Container(
          //                           padding: const EdgeInsets.symmetric(
          //                               horizontal: 12, vertical: 1),
          //                           decoration: BoxDecoration(
          //                             borderRadius: BorderRadius.circular(25),
          //                             color: const Color(0xff606060),
          //                           ),
          //                           child: Text(
          //                             date,
          //                             style: const TextStyle(
          //                               color: Colors.white,
          //                               fontSize: 12,
          //                               fontWeight: FontWeight.bold,
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                     Align(
          //                       alignment: isSender
          //                           ? Alignment.centerRight
          //                           : Alignment.centerLeft,
          //                       child: Row(
          //                         mainAxisAlignment: isSender
          //                             ? MainAxisAlignment.end
          //                             : MainAxisAlignment.start,
          //                         children: [
          //                           if (!isSender) SizedBox(width: 10),
          //                           if (!isSender)
          //                             CircleAvatar(
          //                               backgroundImage:
          //                                   NetworkImage(widget.userImage),
          //                             ),
          //                           if (!isSender) const SizedBox(width: 5),
          //                           Column(
          //                             crossAxisAlignment: isSender
          //                                 ? CrossAxisAlignment.end
          //                                 : CrossAxisAlignment.start,
          //                             children: [
          //                               if (imageUrl.isNotEmpty)
          //                                 GestureDetector(
          //                                   onTap: () => _showFullScreenImage(
          //                                       context, imageUrl),
          //                                   child: Container(
          //                                     padding: const EdgeInsets.all(8),
          //                                     margin:
          //                                         const EdgeInsets.symmetric(
          //                                             vertical: 4,
          //                                             horizontal: 8),
          //                                     decoration: BoxDecoration(
          //                                       color: isSender
          //                                           ? const Color(0xffcfcfcf)
          //                                           : const Color(0xffffffff),
          //                                       borderRadius: isSender
          //                                           ? const BorderRadius.only(
          //                                               topRight:
          //                                                   Radius.circular(12),
          //                                               topLeft:
          //                                                   Radius.circular(12),
          //                                               bottomLeft:
          //                                                   Radius.circular(12),
          //                                             )
          //                                           : const BorderRadius.only(
          //                                               topRight:
          //                                                   Radius.circular(12),
          //                                               topLeft:
          //                                                   Radius.circular(12),
          //                                               bottomRight:
          //                                                   Radius.circular(12),
          //                                             ),
          //                                     ),
          //                                     child: ClipRRect(
          //                                       borderRadius:
          //                                           BorderRadius.circular(12.0),
          //                                       child: Image.network(
          //                                         imageUrl,
          //                                         fit: BoxFit.cover,
          //                                         width: MediaQuery.of(context)
          //                                                 .size
          //                                                 .width *
          //                                             0.4,
          //                                         height: MediaQuery.of(context)
          //                                                 .size
          //                                                 .height *
          //                                             0.3,
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 ),
          //                               if (messageData['message'].isNotEmpty)
          //                                 Container(
          //                                   padding: EdgeInsets.all(10),
          //                                   margin: EdgeInsets.symmetric(
          //                                       vertical: 4, horizontal: 8),
          //                                   decoration: BoxDecoration(
          //                                     color: isSender
          //                                         ? Color(0xffcfcfcf)
          //                                         : Color(0xffffffff),
          //                                     borderRadius: isSender
          //                                         ? const BorderRadius.only(
          //                                             topRight:
          //                                                 Radius.circular(12),
          //                                             topLeft:
          //                                                 Radius.circular(12),
          //                                             bottomLeft:
          //                                                 Radius.circular(12),
          //                                           )
          //                                         : const BorderRadius.only(
          //                                             topRight:
          //                                                 Radius.circular(12),
          //                                             topLeft:
          //                                                 Radius.circular(12),
          //                                             bottomRight:
          //                                                 Radius.circular(12),
          //                                           ),
          //                                   ),
          //                                   child: Column(
          //                                     crossAxisAlignment:
          //                                         CrossAxisAlignment.end,
          //                                     children: [
          //                                       Container(
          //                                         constraints: BoxConstraints(
          //                                           maxWidth: MediaQuery.sizeOf(
          //                                                       context)
          //                                                   .width *
          //                                               0.6,
          //                                         ),
          //                                         child: Text(
          //                                           messageData['message'],
          //                                           style: TextStyle(
          //                                             color: Colors.black,
          //                                           ),
          //                                         ),
          //                                       ),
          //                                       if (isSender)
          //                                         Row(
          //                                           children: [
          //                                             Icon(
          //                                               isRead
          //                                                   ? Icons.done_all
          //                                                   : Icons.done,
          //                                               size: 16,
          //                                               color: isRead
          //                                                   ? Colors.blue
          //                                                   : Colors.grey,
          //                                             ),
          //                                             SizedBox(width: 5),
          //                                             Text(
          //                                               _formatTimestamp(
          //                                                   timestamp),
          //                                               style: TextStyle(
          //                                                 color: Colors.grey,
          //                                                 fontSize: 10,
          //                                               ),
          //                                             ),
          //                                           ],
          //                                           mainAxisAlignment:
          //                                               MainAxisAlignment.end,
          //                                         ),
          //                                     ],
          //                                   ),
          //                                 ),
          //                               if (emoji.isNotEmpty)
          //                                 Padding(
          //                                   padding:
          //                                       const EdgeInsets.only(top: 4.0),
          //                                   child: Text(emoji),
          //                                 ),
          //                               if (!isSender)
          //                                 Row(
          //                                   children: [
          //                                     const SizedBox(width: 5),
          //                                     Text(
          //                                       _formatTimestamp(timestamp),
          //                                       style: const TextStyle(
          //                                         color: Colors.grey,
          //                                         fontSize: 10,
          //                                       ),
          //                                     ),
          //                                   ],
          //                                 )
          //                             ],
          //                           ),
          //                           if (isSender) const SizedBox(width: 10),
          //                         ],
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 if (showDate)
          //                   Padding(
          //                     padding:
          //                         const EdgeInsets.symmetric(vertical: 10.0),
          //                     child: Container(
          //                       padding: const EdgeInsets.symmetric(
          //                           horizontal: 12, vertical: 1),
          //                       decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.circular(25),
          //                         color: Color.fromARGB(255, 237, 42, 42),
          //                       ),
          //                       child: Text(
          //                         date,
          //                         style: const TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 12,
          //                           fontWeight: FontWeight.bold,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //               ],
          //             ),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.attach_file_outlined,
                    color: Color(0xFF7340ff),
                  ),
                  onPressed: () {
                    showAlertDialog(
                      titleText: 'Choose an option',
                      infoText:
                          "choose one of the options from following to continue",
                      extraDetails: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final image =
                                    await FileUtils.getImageFromCamera();
                                if (image != null) {
                                  _sendImageMessage(image);
                                  Get.back();
                                }
                              },
                              child: Image.asset(
                                ImageConstant.iconCamera,
                                height: 60.0,
                              ),
                            ),
                            const SizedBox(width: 40.0),
                            GestureDetector(
                              onTap: () async {
                                final image =
                                    await FileUtils.getImageFromGallery();
                                if (image != null) {
                                  _sendImageMessage(image);
                                  Get.back();
                                }
                              },
                              child: Image.asset(
                                ImageConstant.iconGallery,
                                height: 60.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        color: Color(0xFF7340ff),
                      ),
                      hintText: 'Send a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_circle_right_rounded,
                    color: Color(0xFF7340ff),
                    size: 24,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

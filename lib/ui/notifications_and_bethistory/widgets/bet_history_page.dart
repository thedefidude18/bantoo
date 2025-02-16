import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flexx_bet/ui/notifications_and_bethistory/widgets/bet_loss_screen.dart';
import 'package:flexx_bet/ui/notifications_and_bethistory/widgets/bet_won_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/colors.dart';
import '../../../controllers/notification_controller.dart';
import '../../../models/notification_model.dart';
import '../../../models/user_model.dart';

class BetHistoryPage extends StatefulWidget {
  BetHistoryPage({super.key});

  @override
  State<BetHistoryPage> createState() => _BetHistoryPageState();
}

class _BetHistoryPageState extends State<BetHistoryPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  NotificationController notificationController = NotificationController.to;

  /*List<NotificationModel> notifications = [];

  fetchData() {
    String userId = _auth.currentUser!.uid;
    Get.log("_streamNotifications");
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore.collection('/notifications').where("id", isEqualTo: userId).snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        notifications.add(NotificationModel.fromJson(doc.data()));
      }
      setState(() {});
    });
  }*/

  @override
  void initState() {
    super.initState();
    //fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CustomAppBar(
      //   showBackButton: true,
      //   showCreateEvent: false,
      // ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUserBetHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Bet History Found'));
          } else {
            List<Map<String, dynamic>> betHistory = snapshot.data!;
            return ListView.builder(
              itemCount: betHistory.length,
              itemBuilder: (context, index) {
                var betData = betHistory[index]['bets'];
                var chatroomData = betHistory[index]['chatrooms'];
                var eventData = betHistory[index]['events'];

                // Find matching notification for this event
                String eventId = eventData != null
                    ? eventData['uid']
                    : chatroomData['groupId'];
                /*NotificationModel? matchingNotification = (notificationController.notificationsList.value ?? []).firstWhere(
                      (notification) => (notification.eventId ?? '') == eventId
                );*/

                String result = '';
                NotificationModel? notificationData;
                for (NotificationModel notification
                    in notificationController.notificationsList.value ?? []) {
                  if (notification.eventId != "") {
                    if (eventId == notification.eventId) {
                      notificationData = notification;
                      print("Result ${notification.type}");
                      result =
                          notification.type == 'Win' ? ' You Win' : 'You Loss';
                    }
                  }
                }

                return Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: ColorConstant.gray300,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      eventData?['eventBanner'] != null
                          ? SizedBox(
                              width: 70,
                              height: 70,
                              child: Image.network(
                                eventData?['eventBanner'],
                              ))
                          : SizedBox(
                              width: 70,
                              height: 70,
                              child: Image.network(chatroomData?['groupIcon'])),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            eventData?['title'] != null
                                ? SizedBox(
                                    width: 250,
                                    child: Text(
                                      eventData?['title'],
                                      maxLines: 2,
                                      overflow: TextOverflow.fade,
                                      style: (const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Inter")),
                                    ))
                                : SizedBox(
                                    width: 250,
                                    child: Text(
                                      chatroomData?['groupName'],
                                      maxLines: 2,
                                      overflow: TextOverflow.fade,
                                      style: (const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Inter")),
                                    )),
                            const Spacer(),
                            Row(
                              children: [
                                eventData?['amount'] != null
                                    ? Container(
                                        height: 30,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: ColorConstant.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Join Amount ",
                                              style: (TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontFamily: "Inter")),
                                            ),
                                            Text(
                                              "₦${eventData!['amount'].toString()}",
                                              style: (const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontFamily: "Inter")),
                                            ),
                                          ],
                                        ))
                                    : Container(
                                        height: 30,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: ColorConstant.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Join Amount ",
                                              style: (TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontFamily: "Inter")),
                                            ),
                                            Text(
                                              "₦${chatroomData!['joinAmount'].toString()}",
                                              style: (const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontFamily: "Inter")),
                                            ),
                                          ],
                                        )),
                                const SizedBox(
                                  width: 10,
                                ),
                                result.isNotEmpty
                                    ? InkWell(
                                        onTap: () {
                                          if (notificationData?.type == "Win") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => BetWonScreen(
                                                        notificationData!)));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        BetLossScreen(
                                                            notificationData!)));
                                          }
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: notificationData?.type ==
                                                      'Win'
                                                  ? Colors.green
                                                  : Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Center(
                                            child: Text(
                                              result,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchUserBetHistory() async {
    String userId = _auth.currentUser!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Step 1: Fetch all bets where the user is either firstUserId or secondUserId
    QuerySnapshot betSnapshot = await firestore
        .collection('bets')
        .where('firstUser', isEqualTo: userId)
        .get();

    // Query for secondUserId as well
    QuerySnapshot secondUserBetSnapshot = await firestore
        .collection('bets')
        .where('uid', isEqualTo: userId)
        .get();

    // Combine the two query results
    List<QueryDocumentSnapshot> allBets = [
      ...betSnapshot.docs,
      ...secondUserBetSnapshot.docs
    ];

    List<Map<String, dynamic>> betHistory = [];

    for (var betDoc in allBets) {
      var betData = betDoc.data() as Map<String, dynamic>;
      String eventId = betData['eventId'];

      // Step 2: Fetch related chatroom and event data using eventId
      DocumentSnapshot chatroomSnapshot =
          await firestore.collection('chatrooms').doc(eventId).get();

      DocumentSnapshot eventSnapshot =
          await firestore.collection('events').doc(eventId).get();

      // Combine the bet data with related chatroom and event data
      Map<String, dynamic> combinedData = {
        'bets': betData,
        'chatrooms': chatroomSnapshot.data(),
        'events': eventSnapshot.data(),
      };

      betHistory.add(combinedData);
    }

    return betHistory;
  }
}

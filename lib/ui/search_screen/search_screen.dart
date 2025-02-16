import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/ui/bets_screens/create_bet_screen.dart';
import 'package:flexx_bet/ui/bets_screens/created_bet_history.dart';
import 'package:flexx_bet/ui/events/detailed_event_screen.dart';
import 'package:flexx_bet/ui/search_screen/search_controller.dart';
import 'package:flexx_bet/utils/bet_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../chat/chat_controller.dart';
import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../models/search_model.dart';
import '../components/custom_appbar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {


  final FirestoreService _firestoreService = FirestoreService();
  String _searchQuery = '';
  final controller = Get.find<ChatController>();


  String _formatTime(dynamic heldDate) {
    if (heldDate is Timestamp) {
      DateTime dateTime = heldDate.toDate(); // Convert Timestamp to DateTime
      return DateFormat('h:mm a').format(dateTime); // Format the DateTime
    } else if (heldDate is DateTime) {
      return DateFormat('h:mm a').format(heldDate); // Format the DateTime directly
    } else {
      return 'Not Available';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showBackButton: true,
          showSearchBar: true,
          showCreateEvent: false,
          searchAction: (searchValue){
            _searchQuery = searchValue;
            setState(() {

            });
          },
        ),
      body: FutureBuilder<List<SearchModel>>(
        future:_firestoreService.searchEvents(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if (snapshot.hasError) {
           return Center(child: Text('Error: ${snapshot.error}'));}
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found'));
          }else{
            List<SearchModel>? events = snapshot.data!.where((event) {
              String eventName = event.eventName;
              return eventName.toLowerCase().contains(_searchQuery.toLowerCase());
            }).toList();
            return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: (){
                        if(events[index].type == "chat"){
                          Navigator.push(context, MaterialPageRoute(builder:(context) => CreatedBetHistory(events[index].id), ));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder:(context) => DetailedEventScreen(events[index].id), ));
                        }

                      },
                      child: Container(
                          height: 74,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: ColorConstant.gray2
                          ),
                          child: Row(
                            children: [
                              events[index].coverImage.isEmpty?Container(
                                height: 55,
                                width: 72,
                                decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                  color: Colors.deepPurpleAccent
                                ),
                                child: const Center(child: Text("Empty")),
                              ) :Container(
                                  height: 55,
                                  width: 72,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(events[index].coverImage,fit: BoxFit.fill,))),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                   SizedBox(
                                     width: 175,
                                     child: Text(events[index].eventName,style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: "inter",
                                        fontWeight: FontWeight.w600
                                                                         ),
                                       maxLines: 1,
                                       overflow: TextOverflow.fade,
                                     ),
                                   ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:events[index].createdBy.isEmpty?100 :50,
                                        child: Text(events[index].title ,style: TextStyle(
                                            color: ColorConstant.gray500,
                                            fontSize: 14,
                                            fontFamily: "inter",
                                            fontWeight: FontWeight.w600
                                        ),
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 1,
                                      ),
                                      events[index].createdBy.isEmpty?Container() :Container(
                                        height: 12,
                                        width: 2,
                                        color: ColorConstant.gray500,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      events[index].createdBy.isEmpty?const Text(""): Text("Created By",style: TextStyle(
                                          color: ColorConstant.gray500,
                                          fontSize: 12,
                                          fontFamily: "inter",
                                          fontWeight: FontWeight.w600
                                      )),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      SizedBox(
                                        width: 35,
                                        child: Text(events[index].createdBy.isEmpty?"":"@${events[index].createdBy.split('_').last.toString()}",style: TextStyle(
                                            color: ColorConstant.blue700,
                                            fontSize: 12,
                                            fontFamily: "inter",
                                            fontWeight: FontWeight.w600
                                        ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              events[index].createdBy.isEmpty?const SizedBox(
                                width: 40,

                              ) :const SizedBox(
                                width: 35,

                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 23,
                                        width: 79,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              right: 54,
                                              top: 0,
                                              bottom: 0,
                                              child: CircleAvatar(
                                                radius: 11,
                                                child: Image.asset(
                                                  ImageConstant.avatar1,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 37,
                                              top: 0,
                                              bottom: 0,
                                              child: CircleAvatar(
                                                radius: 11,
                                                child: Image.asset(
                                                  ImageConstant.avatar2,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 21,
                                              child: CircleAvatar(
                                                radius: 11,
                                                child: Image.asset(
                                                  ImageConstant.avatar3,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              child: CircleAvatar(
                                                radius: 11,
                                                child: Text(
                                                  "+${events[index].members.length}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    letterSpacing: -2.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(events[index].type == "chat"?Icons.calendar_month:Icons.history,color: ColorConstant.gray500,size: 14,),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Text(events[index].status.isEmpty?_formatEndDate(events[index].endDate):events[index].status,style: TextStyle(
                                            color: ColorConstant.gray500,
                                            fontSize: 14,
                                            fontFamily: "inter",
                                            fontWeight: FontWeight.w600
                                        )),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                      ),
                    ),
                  );});
          }

        },

      )
    );
  }
  String _formatEndDate(int endAt) {
    try {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(endAt);
      return DateFormat('dd MMM yy').format(dateTime);
    } catch (e) {
      return 'Not Available';
    }
  }

  String getParticipantsAvatar() {
    final List<String> participants = [
      ImageConstant.avatar1,
      ImageConstant.avatar2,
      ImageConstant.avatar3,
    ];

    final Random random = Random();
    final String randomImage = participants[random.nextInt(participants.length)];

    return randomImage;
  }

}


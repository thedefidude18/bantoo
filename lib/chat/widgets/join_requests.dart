import 'package:flexx_bet/chat/chat_controller.dart';
import 'package:flexx_bet/chat/widgets/btn_primary.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/extensions/map_extentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinRequests extends StatefulWidget {
  final Function()? onJoin;

  const JoinRequests({super.key, this.onJoin});

  @override
  State<JoinRequests> createState() => _JoinRequestsState();
}

class _JoinRequestsState extends State<JoinRequests> {
  var controller = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: controller.chatService.getRequests(groupId: controller.currentGroup.value?.id ?? ""),
        builder: (context, snapshot) {
          return snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data?.isNotEmpty == true
              ? ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    var data = snapshot.data![index].data();
                    var userName = (data as Map).getValueOfKey("name") ?? "";
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: ColorConstant.blueGray10096,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "New group request:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "$userName",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          const Text(
                                            " wants to join the group",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              PrimaryButton(
                                  title: "Approved",
                                  backgroundColor: ColorConstant.primaryColor,
                                  titleStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  borderRadius: 25.0,
                                  onPressed: () {
                                    controller.approvedRequest(
                                      context: context,
                                      requestId: snapshot.data![index].id,
                                      userId: data.getValueOfKey("uid") ?? "",
                                      name: data.getValueOfKey("name") ?? "",
                                    );
                                  })
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                )
              : const Center(
                  child: Text("No Request available"),
                );
        });
  }
}

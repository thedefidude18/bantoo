import 'dart:math';

import 'package:flexx_bet/chat/chat_controller.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/wallet_controller.dart';
import 'package:flexx_bet/extensions/map_extentions.dart';
import 'package:flexx_bet/extensions/string_extentions.dart';
import 'package:flexx_bet/models/transaction_model.dart';
import 'package:flexx_bet/ui/wallet/withdraw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyEarnings extends StatefulWidget {
  final Function()? onJoin;
  const MyEarnings({super.key, this.onJoin});

  @override
  State<MyEarnings> createState() => _MyEarningsState();
}

class _MyEarningsState extends State<MyEarnings> {
  var controller = Get.find<ChatController>();
  WalletContoller walletContoller = WalletContoller.to;
  bool isLoading = true;
  List filteredList = [];
  double totalEarnings = 0.0; // Variable to store total earnings for all events
  double totalPoolValueSum = 0.0;
  double previousTotalEarnings = 0.0;
  double percentageChange = 0.0;

  @override
  void initState() {
    super.initState();
    // Simulate data fetching or initialization
    loadData();
    controller.getGroups();
  }

  String formatCurrency(double amount) {
    if (amount >= 1e9) {
      return '${(amount / 1e9).toStringAsFixed(2)}B'; // Billion
    } else if (amount >= 1e6) {
      return '${(amount / 1e6).toStringAsFixed(2)}M'; // Million
    } else if (amount >= 1e3) {
      return '${(amount / 1e3).toStringAsFixed(2)}K'; // Thousand
    } else {
      return '${amount.toStringAsFixed(2)}'; // Less than 1000
    }
  }

  Future<void> saveTotalEarnings(double totalEarnings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalEarnings', totalEarnings);
    print("Total earnings saved: $totalEarnings");
  }

  Future<double?> getSavedTotalEarnings() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('totalEarnings');
  }

  double calculatePercentageChange(double previous, double current) {
    if (previous == 0) {
      return 100.0; // If the previous value was 0, return 100% increase
    }
    return ((current - previous) / previous) * 100;
  }

  void loadData() async {
    setState(() {
      isLoading = true;
    });
    // Load the previous earnings from storage
    previousTotalEarnings = await getSavedTotalEarnings() ?? 0.0;

    // Reverse the list and filter out events based on adminId
    final reversedList = controller.joinedGroups.reversed.toList();
    final filteredList = reversedList.where((event) {
      var data = event.data();
      var adminId =
          "${"${(data as Map).getValueOfKey("admin") ?? ""}".getFirstValueAfterUnderscore()}";
      return adminId == controller.uid;
    }).toList();

    // Initialize earnings and pool values
    totalEarnings = 0.0;
    totalPoolValueSum = 0.0;

    // Iterate over the filtered list
    for (var event in filteredList) {
      var data = event.data();

      // Ensure data is a Map before proceeding
      if (data is Map) {
        // Check if the event has the "creatorPaid" flag
        bool isCreatorPaid = data['creatorPaid'] ?? false;
        print("isCreatorPaid:$isCreatorPaid");

        // Only process events where creatorPaid is false
        if (!isCreatorPaid) {
          // Extract members list and calculate the pool value
          var members = data['members'];
          if (members is List) {
            int membersCount = members.length;
            double eventPoolValue =
                (data['joinAmount'] as num?)?.toDouble() ?? 10.0;
            double totalPoolValue = eventPoolValue * membersCount;

            // Add to total pool value sum
            totalPoolValueSum += totalPoolValue;

            print("Members Count: $membersCount");
            print("Total Pool Value for this event: $totalPoolValue");
          }
        } else {
          // Skip events that are already paid
          print(
              "Skipping event ${data['groupId']} because it's already marked as creatorPaid.");
        }
      }
    }

    // Calculate the total earnings (3% of the total pool value sum)
    totalEarnings = totalPoolValueSum * 0.03;

    // Calculate the percentage change in earnings
    percentageChange =
        calculatePercentageChange(previousTotalEarnings, totalEarnings);

    print("Total Pool Value Sum: $totalPoolValueSum");
    print("Total Earnings (3%): $totalEarnings");
    print("Percentage Change: $percentageChange");

    // Save the updated total earnings to storage
    await saveTotalEarnings(totalEarnings);

    // Update the UI after calculations are complete
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator()) // Show loader while calculating
        : Column(
            children: [
              // Total Earnings Widget
              totalEarningsWidget(
                  totalEarnings, percentageChange, controller.joinedGroups),

              // Events List
              Expanded(child: showEvents()),
            ],
          );
  }

  Widget showEvents() {
    return Obx(() {
      print("unjoined list size------------>${controller.joinedGroups.length}");

      // Reverse list to show the newest items on top
      final reversedList = controller.joinedGroups.reversed.toList();

      // Filter out items where adminId is equal to controller.uid
      final filteredList = reversedList.where((event) {
        var data = event.data();
        var adminId =
            "${"${(data as Map).getValueOfKey("admin") ?? ""}".getFirstValueAfterUnderscore()}";
        return adminId == controller.uid;
      }).toList();

      print("Filtered list size: ${filteredList.length}");

      if (filteredList.isNotEmpty) {
        // Reset totalEarnings before recalculating

        return ListView.builder(
          itemCount: filteredList.length,
          padding: const EdgeInsets.symmetric(vertical: 13),
          itemBuilder: (context, index) {
            return joinedEventTileUI(filteredList[index]);
          },
        );
      } else {
        return const Center(
          child: Text("No event available"),
        );
      }
    });
  }

  // Widget to show total earnings across all events with the percentage increase and withdraw button
  Widget totalEarningsWidget(double totalEarnings, double percentageIncrease,
      List<dynamic> eventList) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 8)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total Earnings Label and Value
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Earnings (3% of Event pool)",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    "₦${formatCurrency(double.parse("$totalEarnings"))}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFF9169FF), // Purple background color for percentage increase
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.trending_up,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "${percentageIncrease.toStringAsFixed(1)}%",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Withdraw Button
          GestureDetector(
            onTap: () async {
              Get.to(() => WithdrawScreen());

              // Iterate through the event list and update the creatorPaid flag to true
              for (var event in eventList) {
                var data = event.data();

                // Ensure data is a Map and check if creatorPaid is false
                if (data is Map && data['creatorPaid'] == false) {
                  // Call updateGroup function to update creatorPaid to true
                  await controller.updateGroup(
                    context: context,
                    groupId: data['groupId'],
                    title: data['groupName'] ?? 'Unknown',
                    description: data['description'] ?? '',
                    category: data['category'] ?? 'party',
                    startDate: DateTime.fromMillisecondsSinceEpoch(
                        data['startAt'] ??
                            DateTime.now().millisecondsSinceEpoch),
                    endDate: DateTime.fromMillisecondsSinceEpoch(
                        data['endAt'] ?? DateTime.now().millisecondsSinceEpoch),
                    maxLimit: data['membersLimit']?.toString() ?? '0',
                    joinAmount: data['joinAmount'] ?? 10,
                    creatorPaid: true, // Mark as paid
                    banner: data['groupIcon'],
                    groupType: data['groupType'],
                    rules: data['rules'] ?? '',
                  );
                  num membersCount = data['members'].length;
                  num totalPoolValue = data['joinAmount'] *
                      membersCount; // Total event pool value for this event
                  num eventEarnings = totalPoolValue * 0.03;

                  // print("membersCount:$membersCount");
                  //  print("totalPoolValue:$totalPoolValue");
                  //  print("eventEarnings:$eventEarnings");
                  //  TransactionModel transactionModel =
                  //  walletContoller.generateTransactionHistory(
                  //      walletAction: WalletActions.Deposit,
                  //      amount: eventEarnings.toStringAsFixed(2),
                  //      account: "",
                  //      concerned: "EventEarning");
                  //
                  //  await walletContoller.incrementRealWalletAmount(num.parse(eventEarnings.toStringAsFixed(2)), transactionModel);
                }
              }

              // After all events are updated, show a confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Earnings withdrawn for all eligible events!'),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(
                    0xFF67FFA4), // Light green background color for withdraw button
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Withdraw",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Function to display individual event UI and calculate the total earnings
  Widget joinedEventTileUI(doc) {
    var data = doc.data();
    print("data:$data");

    // Extract necessary data fields from the document (doc)
    var desc = (data as Map).getValueOfKey("groupName") ?? ""; // Event Name

    // Event Pool Value per participant (join amount)
    double eventPoolValue =
        (data.getValueOfKey("joinAmount") as num?)?.toDouble() ??
            0.0; // Event Pool Value with null safety

    // Initialize Event Earnings
    double eventEarnings = 0.0;
    double totalPoolValue = 0.0;

    // Extract members from the document
    var members = data.getValueOfKey("members"); // Participants Count

    if (members is List) {
      // Calculate the number of members and event earnings (3% of the pool)
      int membersCount = members.length;
      totalPoolValue = eventPoolValue *
          membersCount; // Total event pool value for this event
      eventEarnings = totalPoolValue * 0.03; // 3% of total pool for this event

      // Accumulate the earnings into the global total

      // Display the length of the members list and earnings
      print("Length of members list: $membersCount");
      print("Event earnings (3%): $eventEarnings");
      print("Total Pool Value: $totalPoolValue");
    } else {
      print("members is not a list");
    }

    // Check if the event is live
    var isLive = data.getValueOfKey("isLive") ?? false;

    // Return your widget UI here, using desc, eventEarnings, etc.
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF7440FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Side: Image with Live Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "${controller.getGroupBanner(groupData: data as Map?)}",
                  fit: BoxFit.cover,
                  height: 125,
                  width: 135,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      ImageConstant.staticJoinBet, // Fallback image
                      fit: BoxFit.cover,
                      height: 125,
                      width: 135,
                    );
                  },
                ),
              ),
              if (isLive) // Show live badge if event is live
                Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "LIVE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),

          // Right Side: Event Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  desc,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 25),

                // Event Pool, Earnings, and Withdraw Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Event Pool
                    Column(
                      children: [
                        const Text(
                          "Event pool",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 100,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFFEDEDED), // Background color for event pool
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "₦${totalPoolValue.toStringAsFixed(2)}", // Display total event pool value
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Earnings
                    Column(
                      children: [
                        const Text(
                          "Earnings",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 100,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFF67FFA4), // Background color for earnings
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "₦${eventEarnings.toStringAsFixed(2)}", // Display event earnings (3% of the pool)
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Withdraw Button
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            TransactionModel transactionModel =
                                walletContoller.generateTransactionHistory(
                                    walletAction: WalletActions.Deposit,
                                    amount: eventEarnings.toStringAsFixed(2),
                                    account: "",
                                    concerned: "EventEarning");

                            if (eventEarnings == 0.0 ||
                                (data.getValueOfKey('creatorPaid')) == true) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'Earnings already withdrawn for ${data.getValueOfKey('description')}! or the Earning is zero'),
                              ));
                              print("--------------->");
                            } else {
                              await controller.updateGroup(
                                context: context,
                                groupId: data.getValueOfKey('groupId'),
                                title: data.getValueOfKey('groupName') ??
                                    'Unknown',
                                description:
                                    data.getValueOfKey('description') ?? '',
                                category:
                                    data.getValueOfKey('category') ?? 'party',
                                startDate: DateTime.fromMillisecondsSinceEpoch(
                                    data.getValueOfKey('startAt') ??
                                        DateTime.now().millisecondsSinceEpoch),
                                endDate: DateTime.fromMillisecondsSinceEpoch(
                                    data.getValueOfKey('endAt') ??
                                        DateTime.now().millisecondsSinceEpoch),
                                maxLimit: data
                                        .getValueOfKey('membersLimit')
                                        ?.toString() ??
                                    '0',
                                joinAmount:
                                    data.getValueOfKey('joinAmount') ?? 10,
                                creatorPaid: true, // Mark as paid
                                banner: data.getValueOfKey('groupIcon'),
                                groupType: data.getValueOfKey('groupType'),
                                rules: data.getValueOfKey('rules') ?? '',
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text('Earnings withdrawn for ${desc}!'),
                              ));
                              // num.parse(eventEarnings as String);
                              // print("eventEarnings:$eventEarnings");
                              await walletContoller.incrementRealWalletAmount(
                                  num.parse(eventEarnings.toStringAsFixed(2)),
                                  transactionModel);
                              Get.to(() => WithdrawScreen());
                            }
                          },
                          child: Container(
                            width: 24,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors
                                  .transparent, // Background color for withdraw
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

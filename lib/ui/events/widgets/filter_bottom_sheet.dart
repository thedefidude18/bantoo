import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/ui/components/loader.dart';
import 'package:flexx_bet/ui/events/widgets/single_category_rounded.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../detailed_event_screen.dart';

class BottomFilterSheet extends StatefulWidget {
  const BottomFilterSheet({super.key});
  @override
  State<BottomFilterSheet> createState() => _BottomFilterSheetState();
}

class _BottomFilterSheetState extends State<BottomFilterSheet> {
  int amount = 0;
  final TextEditingController _amountController = TextEditingController();
  final EventsController _eventsController = EventsController.to;
  final List<dynamic> categoriesNewList = [
    {
      "name": "Games",
      "category": "game",
      "imagePath": ImageConstant.gamepadImage,
      "gradiant": [const Color(0xff7440FF), const Color(0xff04010E)]
    },
    {
      "name": "Sports",
      "category": "sports",
      "imagePath": ImageConstant.categorySportsImage,
      "gradiant": [const Color(0xff1B24FF), const Color(0xff04010E)]
    },
    {
      "name": "Music",
      "category": "music",
      "imagePath": ImageConstant.djSetup,
      "gradiant": [const Color(0xff34C759), const Color(0xffFD495E)]
    },
    {
      "name": "Crypto",
      "category": "crypto",
      "imagePath": ImageConstant.bitCoinImage,
      "gradiant": [const Color(0xffFF9900), const Color(0xff7440FF)]
    },
    {
      "name": "Movies/TV",
      "category": "movies/tv",
      "imagePath": ImageConstant.popCornBoxImage,
      "gradiant": [const Color(0xffFF2C2C), const Color(0xff080742)]
    },
    {
      "name": "Pop Culture",
      "category": "pop culture",
      "imagePath": ImageConstant.popCultureImage,
      "gradiant": [const Color(0xff6B0CFF), const Color(0xff266939)]
    },
    {
      "name": "Forex",
      "category": "forex",
      "imagePath": ImageConstant.forex,
      "gradiant": [const Color(0xff00A3FF), const Color(0xff64EA25)]
    },
    {
      "name": "Politics",
      "category": "politics",
      "imagePath": ImageConstant.politicsImage,
      "gradiant": [const Color(0xffFFBF66), const Color(0xff7440FF)]
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: Get.height / 1.1,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 900,
            decoration: BoxDecoration(
                gradient: SweepGradient(
              colors: [Colors.grey[300]!, ColorConstant.primaryColor],
              stops: const [0, 1],
              center: Alignment.topLeft,
            )),
            child: Column(children: [
              const SizedBox(
                height: 40,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: SearchBar(
              //     leading: Image.asset(
              //       ImageConstant.searchIcon,
              //       height: 20,
              //     ),
              //     hintText: "Filter Searches",
              //     hintStyle: const MaterialStatePropertyAll(TextStyle(
              //         color: Colors.grey, fontWeight: FontWeight.normal)),
              //     elevation: const MaterialStatePropertyAll(.1),
              //     backgroundColor: MaterialStateProperty.resolveWith((states) {
              //       // If the button is pressed, return green, otherwise blue
              //       if (states.contains(MaterialState.focused)) {
              //         return Colors.white;
              //       }
              //       return Colors.grey[50];
              //     }),
              //   ),
              // ),
              // const SizedBox(
              //   height: 25,
              // ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text("Search By Category", style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height / 7,
                child: ListView.builder(
                  itemCount: categoriesNewList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        _eventsController.categoryName.value =
                            categoriesNewList[index]['category'];

                        Get.back();
                        await showLoader(() async =>
                            await _eventsController.fetchFirstEventsList(null));
                      },
                      child: CategoryRoundedWidget(
                          name: categoriesNewList[index]['name'],
                          imagePath: categoriesNewList[index]['imagePath']),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text("Search By Amount", style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  amountButton(amountValue: 100),
                  amountButton(amountValue: 500),
                  amountButton(amountValue: 1000),
                  amountButton(amountValue: 5000),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Text("Enter amount"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (amount > 10) amount = amount - 10;
                            _amountController.text = "$amount";
                          });
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(70)),
                          child: const Center(
                              child: Text(
                            "-",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                        )),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "₦",
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: "Inter",
                            fontSize: 20),
                      ),
                      SizedBox(
                        width: Get.width / 3,
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration.collapsed(
                            hintText: "100",
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (val) {
                            amount = val.isNotEmpty ? int.parse(val) : 0;
                          },
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontFamily: "Inter",
                              fontSize: 50),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            amount = amount + 10;
                            _amountController.text = "$amount";
                          });
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(70)),
                          child: const Center(
                              child: Text(
                            "+",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              TextButton(
                  onPressed: () async {
                    _eventsController.userFilteredAmount.value = amount;
                    Get.back();
                    await showLoader(() async =>
                        await _eventsController.fetchFirstEventsList(null));
                  },
                  child: Container(
                    width: Get.width / 1.2,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: ColorConstant.primaryColor),
                    child: const Center(
                      child: Text(
                        "Apply",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ))
            ]),
          ),
        ),
      ),
    );
  }

  Widget amountButton({required int amountValue}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          amount = amountValue;
          _amountController.text = "$amount";
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
            border: Border.all(color: Colors.grey[800]!)),
        child: Text(
          "₦ $amountValue",
          style: TextStyle(
              color: Colors.grey[800], fontFamily: "Inter", fontSize: 16),
        ),
      ),
    );
  }
}

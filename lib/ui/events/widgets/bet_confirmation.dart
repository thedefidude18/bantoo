import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/bet_controller.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/ui/events/widgets/people_betting_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../models/event_model.dart';
import '../../components/custom_button.dart';

class BetConfirmation extends StatefulWidget {
  final EventModel eventData;
  const BetConfirmation({
    super.key,
    required this.eventData,
  });

  @override
  State<BetConfirmation> createState() => _BetConfirmationState();
}

class _BetConfirmationState extends State<BetConfirmation> {
  final BetsController _betsController = BetsController.to;
  final EventsController _eventssController = EventsController.to;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: Get.height / 1.3,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    height: 500,
                    width: Get.width / 1.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            colors: [
                              ColorConstant.primaryColorLighter,
                              Colors.white
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "You have chosen the event ",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '"${widget.eventData.title}"',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                ShowPeopleBetting(),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text:
                                                " There are over ${_eventssController.getCurrentEvent!.peopleWaiting.length} players\ncurrently betting",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontSize: 16,
                                              color: Colors.grey[800],
                                            )),
                                         TextSpan(
                                          text: " ₦${_eventssController.getCurrentEvent!.amount}",
                                          style: const TextStyle(
                                              fontFamily: "Inter",
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 1,
                              width: Get.width / 1.5,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Please kindly choose your preferred\noutcome.",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _betsController
                                                .userSelectedOption.value = "no";
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: ColorConstant.primaryColor),
                                          child: Image.asset(
                                            _betsController.userSelectedOption
                                                        .value ==
                                                    "no"
                                                ? ImageConstant.crossSelected
                                                : ImageConstant.cross,
                                            height: 30,
                                            width: 30,
                                          ),
                                        )),
                                    const Text("No")
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _betsController
                                                .userSelectedOption.value = "yes";
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: ColorConstant.primaryColor),
                                          child: Image.asset(
                                            _betsController.userSelectedOption
                                                        .value ==
                                                    "yes"
                                                ? ImageConstant.checkMarkSelected
                                                : ImageConstant.checkMark,
                                            height: 30,
                                            width: 30,
                                          ),
                                        )),
                                    const Text("Yes")
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomButton(
                                onTap: () async {
                                  if (_betsController.userSelectedOption.value ==
                                      null) {
                                    Get.showSnackbar(const GetSnackBar(
                                      duration: Duration(seconds: 2),
                                      title: "No outcome selected",
                                      message: "Please select yes or no",
                                    ));
                                  } else {
                                    await _betsController.createEntirelyNewBet();
                                    Get.log("createEntirelyNewBet");
                                    _betsController.userSelectedOption.value = "";
                                    Get.back();
                                  }
                                },
                                text: "Done",
                                height: 40,
                                padding: ButtonPadding.PaddingAll8,
                                fontStyle: ButtonFontStyle.InterSemiBold16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

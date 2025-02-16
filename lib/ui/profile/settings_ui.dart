import 'package:flexx_bet/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool generalNotificationValue = true;
  bool soundValue = true;
  bool vibrateValue = true;
  bool appUpdatesValue = true;
  bool billReminderValue = true;
  bool promotionValue = true;
  bool newEventUpdateValue = true;
  bool darkModeValue = true;
  bool newServiceAvailableValue = true;
  bool newTipsAvalaibleValue = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notification",
          style: TextStyle(color: ColorConstant.black900),
        ),
        backgroundColor: ColorConstant.whiteA700,
        leading: BackButton(
          color: ColorConstant.black900,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "General",
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("General Notification"),
              CupertinoSwitch(
                // This bool value toggles the switch.
                value: generalNotificationValue,

                activeColor: ColorConstant.primaryColor,
                onChanged: (bool? value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    generalNotificationValue = value ?? false;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Sound"),
              CupertinoSwitch(
                // This bool value toggles the switch.
                value: soundValue,
                activeColor: ColorConstant.primaryColor,
                onChanged: (bool? value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    soundValue = value ?? false;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Vibrate"),
              CupertinoSwitch(
                // This bool value toggles the switch.
                value: vibrateValue,
                activeColor: ColorConstant.primaryColor,
                onChanged: (bool? value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    vibrateValue = value ?? false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "System & services update",
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("App updates"),
              CupertinoSwitch(
                // This bool value toggles the switch.
                value: appUpdatesValue,
                activeColor: ColorConstant.primaryColor,
                onChanged: (bool? value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    appUpdatesValue = value ?? false;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Bill Reminder"),
              CupertinoSwitch(
                // This bool value toggles the switch.
                value: billReminderValue,
                activeColor: ColorConstant.primaryColor,
                onChanged: (bool? value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    billReminderValue = value ?? false;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Promotion"),
              CupertinoSwitch(
                // This bool value toggles the switch.
                value: promotionValue,
                activeColor: ColorConstant.primaryColor,
                onChanged: (bool? value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    promotionValue = value ?? false;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("New event update"),
              CupertinoSwitch(
                // This bool value toggles the switch.
                value: newEventUpdateValue,
                activeColor: ColorConstant.primaryColor,
                onChanged: (bool? value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    newEventUpdateValue = value ?? false;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Dark mode"),
              CupertinoSwitch(
                // This bool value toggles the switch.
                value: darkModeValue,
                activeColor: ColorConstant.primaryColor,
                onChanged: (bool? value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    darkModeValue = value ?? false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Others",
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("New Service Available"),
              CupertinoSwitch(
                // This bool value toggles the switch.
                value: newServiceAvailableValue,
                activeColor: ColorConstant.primaryColor,
                onChanged: (bool? value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    newServiceAvailableValue = value ?? false;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("New Tips Available"),
              CupertinoSwitch(
                // This bool value toggles the switch.
                value: newTipsAvalaibleValue,
                activeColor: ColorConstant.primaryColor,
                onChanged: (bool? value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    newTipsAvalaibleValue = value ?? false;
                  });
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

import 'package:fast_contacts/fast_contacts.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data' as td;

enum ButtonState { invited, accepted, invite }

class ContactItem extends StatefulWidget {
  const ContactItem({
    Key? key,
    required this.contact,
  }) : super(key: key);

  static const height = 86.0;

  final Contact contact;

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  ButtonState buttonState = ButtonState.invite;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ContactItem.height,
      child: ListTile(
        leading: _ContactImage(contact: widget.contact),
        title: Text(
          widget.contact.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: const Text(
          "Contacts",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              if (buttonState == ButtonState.invite) {
                buttonState = ButtonState.invited;
                return;
              }
              if (buttonState == ButtonState.invited) {
                buttonState = ButtonState.accepted;
                return;
              }
              if (buttonState == ButtonState.accepted) {
                buttonState = ButtonState.invite;
                return;
              }
            });
          },
          child: buttonState == ButtonState.invite
              ? Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                      color: ColorConstant.primaryColor,
                      borderRadius: BorderRadius.circular(90)),
                  child: const Center(
                      child: Text(
                    "Invite",
                    style: TextStyle(color: Colors.white),
                  )),
                )
              : buttonState == ButtonState.invited
                  ? Container(
                      width: 70,
                      height: 30,
                      decoration: BoxDecoration(
                          color: ColorConstant.primaryColor,
                          borderRadius: BorderRadius.circular(90)),
                      child: const Center(
                          child: Text(
                        "Invited",
                        style: TextStyle(color: Colors.white),
                      )),
                    )
                  : Container(
                      width: 90,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(90)),
                      child: const Center(
                          child: Text(
                        "Accepted",
                        style: TextStyle(color: Colors.green),
                      )),
                    ),
        ),
      ),
    );
  }
}

class _ContactImage extends StatefulWidget {
  const _ContactImage({
    Key? key,
    required this.contact,
  }) : super(key: key);

  final Contact contact;

  @override
  __ContactImageState createState() => __ContactImageState();
}

class __ContactImageState extends State<_ContactImage> {
  late Future<td.Uint8List?> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = FastContacts.getContactImage(widget.contact.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<td.Uint8List?>(
      future: _imageFuture,
      builder: (context, snapshot) => SizedBox(
        width: 56,
        height: 56,
        child: snapshot.hasData
            ? Image.memory(snapshot.data!, gaplessPlayback: true)
            : const Icon(Icons.account_box_rounded),
      ),
    );
  }
}

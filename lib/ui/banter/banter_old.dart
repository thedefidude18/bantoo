import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/banter/widgets/chat.dart';
import 'package:flexx_bet/ui/banter/widgets/story_widget.dart';

import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class BanterScreenOld extends StatefulWidget {
  const BanterScreenOld({
    super.key,
  });
  @override
  State<BanterScreenOld> createState() => _BanterScreenOldState();
}

class _BanterScreenOldState extends State<BanterScreenOld> {
  late bool isShowSticker;

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isShowSticker = false;
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Expanded(
              child: SizedBox(
            height: Get.height / 1.05,
            child: ListView(
              children: [
                SizedBox(
                  height: Get.height / 7.5,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      StoryWidget(
                        isLive: true,
                        username: "You",
                        image: ImageConstant.user1,
                      ),
                      StoryWidget(
                          image: ImageConstant.categorySportsImage,
                          username: "Football"),
                      StoryWidget(
                          image: ImageConstant.musicStory, username: "Music"),
                      StoryWidget(
                        image: ImageConstant.techStory,
                        username: "Tech",
                      ),
                      StoryWidget(
                          image: ImageConstant.tvStory, username: "TV/Movies"),
                    ],
                  ),
                ),
                const ChatWidget(
                  username: "bingogees",
                  comment: "Rockets Pleaseeeee",
                  image: ImageConstant.user1,
                  likes: "12.4k",
                  watched: "104k",
                  commentNumber: "200",
                ),
                const ChatWidget(
                  username: "chocoball",
                  comment: "I;ve got a shotre thing coming up",
                  image: ImageConstant.user2,
                  likes: "12.4k",
                  watched: "104k",
                  commentNumber: "200",
                ),
                const ChatWidget(
                  username: "den",
                  comment: "Lets Bet",
                  image: ImageConstant.user3,
                  likes: "12.4k",
                  watched: "104k",
                  commentNumber: "200",
                ),
                const ChatWidget(
                  username: "kevin",
                  comment: "I am winning this one",
                  image: ImageConstant.user4,
                  likes: "12.4k",
                  watched: "104k",
                  commentNumber: "200",
                ),
                const ChatWidget(
                  username: "bingogees",
                  comment: "Rockets Pleaseeeee",
                  image: ImageConstant.user1,
                  likes: "12.4k",
                  watched: "104k",
                  commentNumber: "200",
                ),
              ],
            ),
          )),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: Get.width / 1.3,
                    height: 50,
                    child: TextFormField(
                      onTap: () {
                        setState(() {
                          isShowSticker = false;
                        });
                      },
                      controller: messageController,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                FocusManager.instance.primaryFocus?.unfocus();
                                isShowSticker = true;
                              });
                            },
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                              size: 30,
                            )),
                        hintText: "Send messages",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide:
                              const BorderSide(width: 1.5, color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide:
                              const BorderSide(width: 1.5, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.white,
                      size: 20,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

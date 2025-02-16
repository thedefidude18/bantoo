import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/banter/widgets/chat.dart';
import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class BanterVideoScreen extends StatelessWidget {
  BanterVideoScreen({super.key});

  final _controller = YoutubePlayerController.fromVideoId(
    videoId: 'cE0wfjsybIQ',
    autoPlay: false,
    params: const YoutubePlayerParams(
        showFullscreenButton: false, showVideoAnnotations: false),
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: YoutubePlayerScaffold(
        aspectRatio: 16 / 9,
        controller: _controller,
        builder: (context, player) {
          return Scaffold(
            appBar: const CustomAppBar(),
            body: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      player,
                      SizedBox(
                        height: Get.height / 2.09,
                        child: ListView(
                          children: const [
                            ChatWidget(
                              username: "bingogees",
                              comment: "Rockets Pleaseeeee",
                              image: ImageConstant.user1,
                              likes: "12.4k",
                              watched: "104k",
                              commentNumber: "200",
                            ),
                            ChatWidget(
                              username: "chocoball",
                              comment: "I;ve got a shotre thing coming up",
                              image: ImageConstant.user2,
                              likes: "12.4k",
                              watched: "104k",
                              commentNumber: "200",
                            ),
                            ChatWidget(
                              username: "den",
                              comment: "Lets Bet",
                              image: ImageConstant.user3,
                              likes: "12.4k",
                              watched: "104k",
                              commentNumber: "200",
                            ),
                            ChatWidget(
                              username: "kevin",
                              comment: "I am winning this one",
                              image: ImageConstant.user4,
                              likes: "12.4k",
                              watched: "104k",
                              commentNumber: "200",
                            ),
                            ChatWidget(
                              username: "bingogees",
                              comment: "Rockets Pleaseeeee",
                              image: ImageConstant.user1,
                              likes: "12.4k",
                              watched: "104k",
                              commentNumber: "200",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.emoji_emotions,
                                    color: Colors.grey,
                                    size: 30,
                                  )),
                              hintText: "Send messages",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.grey),
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
        },
      ),
    );
  }
}

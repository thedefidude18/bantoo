import 'package:flexx_bet/chat/chat_controller.dart';
import 'package:flexx_bet/chat/widgets/shimmer.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/ui/bets_screens/created_bet_history.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class TermsConditions extends StatefulWidget {
  final Function()? onPressed;
  const TermsConditions({super.key,this.onPressed});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  var controller = Get.find<ChatController>();
  final GlobalKey _htmlContainerKey = GlobalKey();
  var _contentHeight= 0.0;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        controller.termsConditionsEnabled.value = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Expanded(
          child: FutureBuilder(
              future: controller.getChatAbout(),
              builder: (context, data) {
                if(data.connectionState == ConnectionState.done && data.hasData && data.data!=null && data.data is Map && (data.data as Map).isNotEmpty){
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.termsConditionsEnabled.value = false;
                    if (_contentHeight == 0.0) {
                      RenderBox renderBox = _htmlContainerKey.currentContext?.findRenderObject() as RenderBox;
                      _contentHeight = renderBox.size.height;
                      var isContentScrollable = _contentHeight >= MediaQuery.of(context).size.height;
                      if(!isContentScrollable){
                        controller.termsConditionsEnabled.value = true;
                      }
                    }
                  });

                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: SizedBox(
                      width: Get.width - (20*2),
                      child: RepaintBoundary(
                        key: _htmlContainerKey,
                        child: Html(
                          data: "${data.data!["terms_conditions"]}",
                        ),
                      ),
                    ),
                  );
                  return Text("${data.data!["terms_conditions"]}");
                }else if(data.connectionState == ConnectionState.waiting){
                  return Shimmer.fromColors(
                    baseColor: ColorConstant.shimmerBaseColor,
                    highlightColor: ColorConstant.shimmerHighlightColor,
                    child: const Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",style: TextStyle(backgroundColor: Colors.white),),
                  );
                }else{
                  return const Center(child: Text("No content found."));
                }
              }),
        ),
        const SizedBox(height: 10.0,),
        Obx(() {
            return Opacity(
              opacity: controller.termsConditionsEnabled.value ?1:0.5,
              child: CustomButton(
                text: "I Accept",
                fontStyle: ButtonFontStyle.InterSemiBold16,
                onTap: (controller.termsConditionsEnabled.value)?widget.onPressed ?? () {
                  Get.back();
                }:null,
                height: 48,
                width: 307,
              ),
            );
          }
        )
      ],
    );
  }
}

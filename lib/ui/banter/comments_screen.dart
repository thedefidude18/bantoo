import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/banter/widgets/comments.dart';
import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatelessWidget {
  const CommentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: ListView(children: [
        CommentsWidget(
          username: "@recard",
          image: ImageConstant.user1,
          postedOn: DateTime.now().subtract(const Duration(days: 80)),
          comment:
              "I agree. Worth waiting till it's trading at its true valuation post lock up...",
        ),
        CommentsWidget(
          username: "@o’mamma",
          image: ImageConstant.user2,
          postedOn: DateTime.now().subtract(const Duration(days: 120)),
          comment:
              "I agree. Worth waiting till it's trading at its true valuation post lock up...",
        ),
        CommentsWidget(
          username: "@recard",
          image: ImageConstant.user3,
          postedOn: DateTime.now().subtract(const Duration(days: 40)),
          comment:
              "I agree. Worth waiting till it's trading at its true valuation post lock up...",
        ),
        CommentsWidget(
          username: "@recard",
          image: ImageConstant.user4,
          postedOn: DateTime.now().subtract(const Duration(days: 180)),
          comment:
              "I agree. Worth waiting till it's trading at its true valuation post lock up...",
        ),
        CommentsWidget(
          username: "@recard",
          image: ImageConstant.user1,
          postedOn: DateTime.now().subtract(const Duration(days: 80)),
          comment:
              "I agree. Worth waiting till it's trading at its true valuation post lock up...",
        ),
        CommentsWidget(
          username: "@o’mamma",
          image: ImageConstant.user2,
          postedOn: DateTime.now().subtract(const Duration(days: 120)),
          comment:
              "I agree. Worth waiting till it's trading at its true valuation post lock up...",
        ),
        CommentsWidget(
          username: "@recard",
          image: ImageConstant.user3,
          postedOn: DateTime.now().subtract(const Duration(days: 40)),
          comment:
              "I agree. Worth waiting till it's trading at its true valuation post lock up...",
        ),
        CommentsWidget(
          username: "@recard",
          image: ImageConstant.user4,
          postedOn: DateTime.now().subtract(const Duration(days: 180)),
          comment:
              "I agree. Worth waiting till it's trading at its true valuation post lock up...",
        ),
      ]),
    );
  }
}

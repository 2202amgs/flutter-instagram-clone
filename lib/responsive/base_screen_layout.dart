import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/constant.dart';

class BaseScreenLayout extends StatelessWidget {
  final Widget webScreenLayOut;
  final Widget mobileScreenLayOut;
  const BaseScreenLayout(
      {Key? key,
      required this.mobileScreenLayOut,
      required this.webScreenLayOut})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webWidth) {
          return webScreenLayOut;
        }
        return mobileScreenLayOut;
      },
    );
  }
}

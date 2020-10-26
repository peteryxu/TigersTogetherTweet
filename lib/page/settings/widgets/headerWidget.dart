import 'package:flutter/material.dart';
import 'package:tigerstogether/helper/theme.dart';
import 'package:tigerstogether/widgets/newWidget/customUrlText.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final bool secondHeader;
  const HeaderWidget(this.title, {Key key, this.secondHeader = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: secondHeader
          ? EdgeInsets.only(left: 18, right: 18, bottom: 10, top: 35)
          : EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      color: TwitterColor.mystic,
      alignment: Alignment.centerLeft,
      child: UrlText(
        text: title ?? '',
        style: TextStyle(
            fontSize: 20,
            color: AppColor.darkGrey,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}

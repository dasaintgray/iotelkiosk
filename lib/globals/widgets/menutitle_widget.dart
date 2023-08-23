import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:iotelkiosk/app/data/models_graphql/transaction_model.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class KioskMenuTitle extends StatelessWidget {
  const KioskMenuTitle({super.key, required this.titleLength, required this.titleTrans});

  final RxList<Conversion> titleTrans;
  final int titleLength;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5.h,
      width: double.infinity,
      child: FlutterCarousel.builder(
        itemCount: titleLength,
        itemBuilder: (BuildContext context, int ctr, int realIndex) {
          return SizedBox(
            height: 10.h,
            width: double.infinity,
            child: Center(
              child: Text(titleLength == 1 ? titleTrans.first.translationText : titleTrans[ctr].translationText,
                  style: TextStyle(color: HenryColors.darkGreen, fontSize: 13.sp)),
            ),
          );
        },
        options: CarouselOptions(
            autoPlay: titleLength == 1 ? false : true,
            showIndicator: false,
            reverse: true,
            scrollDirection: Axis.vertical),
      ),
    );
  }
}

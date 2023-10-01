import 'package:flutter/material.dart';
import 'package:iotelkiosk/app/data/models_graphql/transaction_model.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class KioskMenuTitle extends StatelessWidget {
  const KioskMenuTitle({super.key, required this.titleLength, required this.titleTrans, required this.orientation});

  final RxList<Conversion> titleTrans;
  final int titleLength;
  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3.h,
      width: double.infinity,
      child: Center(
        child: Text(titleTrans.first.translationText,
            style:
                TextStyle(color: HenryColors.darkGreen, fontSize: orientation == Orientation.portrait ? 13.sp : 8.sp)),
      ),
    );
  }
}

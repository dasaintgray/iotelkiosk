import 'package:flutter/material.dart';
import 'package:iotelkiosk/app/data/models_graphql/transaction_model.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:get/get.dart';

class KioskMenuTitle extends StatelessWidget {
  const KioskMenuTitle(
      {super.key, required this.titleLength, required this.titleTrans, required this.fontSize, required this.heights});

  final RxList<Conversion?> titleTrans;
  final int? titleLength;
  final double? fontSize;
  final double? heights;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heights,
      width: double.infinity,
      child: Center(
        child: Text(
          titleTrans.first!.translationText,
          style: TextStyle(color: HenryColors.darkGreen, fontSize: fontSize),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

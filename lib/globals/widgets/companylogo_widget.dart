import 'package:flutter/material.dart';
import 'package:iotelkiosk/globals/constant/image_constant.dart';

class CompanyLogo extends StatelessWidget {
  const CompanyLogo({super.key, required this.top, required this.bottom, required this.left, required this.right});

  final double top;
  final double bottom;
  final double left;
  final double right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: SizedBox(
        child: Image.asset(ImageConstant.companyLogo, fit: BoxFit.contain),
      ),
    );
  }
}

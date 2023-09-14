import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/image_constant.dart';

class KioskBottom extends StatelessWidget {
  KioskBottom({Key? key}) : super(key: key);

  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      // alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          child: SizedBox(
            // height: Orientation.portrait ? 10.h : 2.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    hc.getMenu(code: 'SLMT', type: 'TITLE');
                    Get.back();
                  },
                  child: Image.asset(
                    ImageConstant.backArrow,
                    fit: BoxFit.cover,
                    semanticLabel: 'Back to previous menu',
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

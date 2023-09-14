import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/home_view.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:sizer/sizer.dart';

class PrintingView extends GetView {
  PrintingView({Key? key}) : super(key: key);

  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (BuildContext context, orientation, deviceType) {
      return Stack(
        children: [
          const KioskBackgroundImage(),
          orientation == Orientation.portrait
              ? CompanyLogo(top: 15.h, bottom: 65.h, left: 35.w, right: 35.w)
              : CompanyLogo(top: 5.h, bottom: 45.h, left: 45.w, right: 45.w),
          // KioskHeader(),
          Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => KioskHeader(
                    isLive: hc.clockLiveUpdate.value,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 20.h,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        'CARD# ${hc.issueResponseList.first.data.first.cardNumber}',
                        style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                      ),
                      Text(
                        'ROOM# ${hc.issueResponseList.first.data.first.roomNumber}',
                        style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                      ),
                      Text(
                        'CHECK IN : ${hc.issueResponseList.first.data.first.checkinDate}',
                        style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                      ),
                      Text(
                        'CHECK OUT : ${hc.issueResponseList.first.data.first.checkoutDate}',
                        style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                      ),
                      Text(
                        'Enjoy your stay.',
                        style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                // SPACE
                SizedBox(
                  height: 8.h,
                  width: 35.w,
                  child: MaterialButton(
                    onPressed: () {
                      Get.off(() => HomeView());
                    },
                    color: HenryColors.darkGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      'Finish Transaction',
                      style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                      // textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

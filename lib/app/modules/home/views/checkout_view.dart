import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:sizer/sizer.dart';

class CheckoutView extends GetView<HomeController> {
  CheckoutView({Key? key}) : super(key: key);

  final hc = Get.find<HomeController>();

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
                // SPACE
                SizedBox(
                  height: 10.h,
                  width: double.infinity,
                ),
                // TITLE
                KioskMenuTitle(titleLength: hc.titleTrans.length, titleTrans: hc.titleTrans),
                Obx(
                  () => SizedBox(
                    height: 50.h,
                    width: double.infinity,
                    child: hc.isLoading.value
                        ? Column(
                            children: [
                              const LinearProgressIndicator(),
                              Center(
                                child: Text(
                                  hc.statusMessage.value,
                                  style: TextStyle(color: HenryColors.darkGreen, fontSize: 12.sp),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'CARD# ${hc.readCardInfoList.first.message.first.cardNumber}',
                                style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'ROOM# ${hc.readCardInfoList.first.message.first.roomNumber}',
                                style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                              ),
                              Text(
                                'CHECK IN DATE/TIME: \n${hc.readCardInfoList.first.message.first.checkinDate}',
                                style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'CHECK OUT DATE/TIME: \n${hc.readCardInfoList.first.message.first.checkoutDate}',
                                style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10.h,
                                width: double.infinity,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    // 
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: HenryColors.darkGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    padding: const EdgeInsets.all(30),
                                    shadowColor: Colors.black26.withOpacity(0.5),
                                  ),
                                  child: Text(
                                    'CHECK-OUT',
                                    style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                                  ))
                            ],
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

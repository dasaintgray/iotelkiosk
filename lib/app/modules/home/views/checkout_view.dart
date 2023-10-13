import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/home_view.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:lottie/lottie.dart';
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
                  height: orientation == Orientation.portrait ? 10.h : 2.h,
                  width: double.infinity,
                ),
                // TITLE
                KioskMenuTitle(
                  titleTrans: hc.titleTrans,
                  fontSize: orientation == Orientation.portrait ? 12.sp : 8.sp,
                  heights: orientation == Orientation.portrait ? 7.h : 2.h,
                ),
                Obx(
                  () => SizedBox(
                    height: 50.h,
                    width: double.infinity,
                    child: hc.isLoading.value
                        ? Column(
                            children: [
                              DotLottieLoader.fromAsset(
                                'assets/lottie/card.lottie',
                                frameBuilder: (ctx, dotlottie) {
                                  if (dotlottie != null) {
                                    return Lottie.memory(
                                      dotlottie.animations.values.single,
                                      height: 30.h,
                                      // width: 20.w,
                                      fit: BoxFit.cover,
                                    );
                                  } else {
                                    return const CircularProgressIndicator.adaptive();
                                  }
                                },
                              ),
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
                                  hc.isLoading.value = true;
                                  hc.checkOUT(credentialHeaders: hc.accessTOKEN);
                                  Get.to(() => HomeView());
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
                                  ' CHECK-OUT ',
                                  style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                                ),
                              ),
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

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/views/checkout_view.dart';
import 'package:iotelkiosk/app/modules/home/views/home_view.dart';
import 'package:iotelkiosk/app/modules/home/views/transaction2_view.dart';
import 'package:iotelkiosk/app/modules/home/views/underdev_view.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/constant/led_constant.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:sizer/sizer.dart';

import '../controllers/home_controller.dart';

class TransactionView extends GetView<HomeController> {
  TransactionView({Key? key}) : super(key: key);

  final hc = Get.find<HomeController>();
  // final hc = Get.put(HomeController());
  // final sc = Get.find<ScreenController>();

  // final DateTime dtLocalTime = DateTime.now();
  final imgKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
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
                  Obx(() => KioskHeader(
                        isLive: hc.clockLiveUpdate.value,
                      )),
                  // SPACE
                  SizedBox(
                    height: orientation == Orientation.portrait ? 10.h : 1.h,
                  ),
                  // TITLE
                  KioskMenuTitle(
                    titleTrans: hc.titleTrans,
                    fontSize: orientation == Orientation.portrait ? 12.sp : 10.sp,
                    heights: orientation == Orientation.portrait ? 7.h : 2.h,
                  ),
                  // SPACE
                  SizedBox(
                    height: 2.h,
                  ),
                  // MENU
                  menuTransactionTitle(orientation),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 5.h : 1.h,
                  ),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 5.h : 2.h,
                    child: GestureDetector(
                      onTap: () {
                        hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'SLMT', type: 'TITLE');
                        // Get.back();
                        Get.off(() => HomeView());
                      },
                      child: Image.asset(
                        'assets/menus/back-arrow.png',
                        fit: BoxFit.cover,
                        semanticLabel: 'Back to previous menu',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget menuTransactionTitle(Orientation orientation, {int? languageID, String? code, String? type}) {
    return SizedBox(
      height: orientation == Orientation.portrait ? 40.h : 20.h,
      width: orientation == Orientation.portrait ? 70.w : 55.w,
      child: ListView.builder(
        padding: const EdgeInsets.all(25.0),
        itemCount: hc.pageTrans.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: orientation == Orientation.portrait ? 10.h : 8.h,
            child: Stack(
              children: [
                Positioned(
                  left: orientation == Orientation.portrait ? 25.w : 20.w,
                  top: orientation == Orientation.portrait ? 32 : 40,
                  // right: 10.w,
                  child: SizedBox(
                    // width: 10.w,
                    child: hc.isLoading.value
                        ? Center(
                            child: Column(
                              children: [
                                const CircularProgressIndicator.adaptive(),
                                Text(
                                  'Loading, please wait..',
                                  style: TextStyle(
                                      color: HenryColors.puti,
                                      fontSize: orientation == Orientation.portrait ? 10.sp : 8.sp),
                                )
                              ],
                            ),
                          )
                        : Text(
                            hc.pageTrans[index].translationText,
                            style: TextStyle(
                              color: HenryColors.darkGreen,
                              fontSize: orientation == Orientation.portrait ? 12.sp : 10.sp,
                            ),
                          )
                            .animate()
                            .fade(duration: HenryGlobal.animationSpeed)
                            .scale(duration: HenryGlobal.animationSpeed),
                  ),
                ),
                Positioned(
                  left: orientation == Orientation.portrait ? 8.w : 1.w,
                  right: orientation == Orientation.portrait ? 8.w : 1.w,
                  child: GestureDetector(
                    onTap: () async {
                      switch (index) {
                        case 0: //CHECK IN
                          {
                            hc.isLoading.value = true;
                            final response =
                                hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'SCIP', type: 'ITEM');
                            if (response) {
                              hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'SCIP', type: 'TITLE');
                              hc.isLoading.value = false;
                              Get.to(() => Transaction2View());
                            }
                          }
                          break;
                        case 1: //CHECK OUT
                          {
                            hc.isLoading.value = true;
                            hc.openLEDLibserial(portName: hc.ledPort.value, ledLocationAndStatus: LedOperation.cardON);
                            hc.statusMessage.value = 'Please Insert Key Card \nto the dispenser';
                            hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'COP', type: 'TITLE');
                            hc.startReadCardTimer();
                            Get.to(
                              () => CheckoutView(),
                            );
                          }
                          break;
                        case 2: //book a room
                          {
                            Get.defaultDialog(
                              title: 'Too Follow',
                              middleText: "Not Yet Implemented",
                            );
                            // Get.to(() => BookaroomView());
                          }
                          break;
                        case 3: //Extend
                          {
                            Get.defaultDialog(
                              title: 'Too Follow',
                              middleText: "Not Yet Implemented",
                            );
                          }
                          break;
                        default:
                          {
                            Get.to(() => UnderdevView());
                          }
                          break;
                      }
                    },
                    child: SizedBox(
                      height: orientation == Orientation.portrait ? 7.h : 7.h,
                      width: orientation == Orientation.portrait ? 10.w : 10.w,
                      child: Image.asset(
                        hc.pageTrans[index].images!,
                        fit: BoxFit.contain,
                      )
                          .animate()
                          .fade(duration: HenryGlobal.animationSpeed)
                          .scale(duration: HenryGlobal.animationSpeed),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

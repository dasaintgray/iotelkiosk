// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/views/accommodation_view.dart';
import 'package:iotelkiosk/app/modules/home/views/bookaroom_view.dart';
import 'package:iotelkiosk/app/modules/home/views/checkout_view.dart';
import 'package:iotelkiosk/app/modules/home/views/home_view.dart';
import 'package:iotelkiosk/app/modules/home/views/underdev_view.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
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
  final sc = Get.find<ScreenController>();

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
                    height: 12.h,
                  ),
                  // TITLE
                  KioskMenuTitle(titleLength: hc.titleTrans.length, titleTrans: hc.titleTrans),
                  // SPACE
                  SizedBox(
                    height: 2.h,
                  ),
                  // MENU
                  menuTransactionTitle(orientation),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 5.h : 2.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            hc.getMenu(code: 'SLMT', type: 'TITLE');
                            // Get.back();
                            Get.off(() => HomeView());
                          },
                          child: Image.asset(
                            'assets/menus/back-arrow.png',
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
      height: orientation == Orientation.portrait ? 45.h : 20.h,
      width: 75.w,
      child: ListView.builder(
        padding: const EdgeInsets.all(25.0),
        itemCount: hc.pageTrans.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 10.h,
            child: Stack(
              children: [
                Positioned(
                  left: 25.w,
                  top: 35,
                  right: 10.w,
                  child: SizedBox(
                    width: 10.w,
                    child: sc.isLoading.value
                        ? Center(
                            child: Column(
                              children: [
                                const CircularProgressIndicator.adaptive(),
                                Text(
                                  'Loading, please wait..',
                                  style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                                )
                              ],
                            ),
                          )
                        : Text(
                            hc.pageTrans[index].translationText,
                            style: TextStyle(
                              color: HenryColors.darkGreen,
                              fontSize: 12.sp,
                            ),
                          )
                            .animate()
                            .fade(duration: HenryGlobal.animationSpeed)
                            .scale(duration: HenryGlobal.animationSpeed),
                  ),
                ),
                Positioned(
                  left: 8.w,
                  right: 8.w,
                  child: Obx(
                    () => GestureDetector(
                      onTap: () async {
                        switch (index) {
                          case 0: //CHECK IN
                            {
                              hc.isLoading.value = true;
                              var response = await hc.getAccommodation(
                                  credentialHeaders: hc.accessTOKEN, languageCode: hc.selectedLanguageCode.value);
                              if (response) {
                                if (kDebugMode) print('SELECTED ROOM TYPE ID: ${hc.selectedRoomTypeID.value}');
                                // sc.selectedRoomType.value = sc.roomTypeList.first.data.roomTypes[index].code;
                                hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'SACT', type: 'TITLE');
                                if (kDebugMode) print(hc.selecttedLanguageID.value);
                                hc.update();
                                Get.to(() => AccommodationView());
                              }
                            }
                            break;
                          case 1: //CHECK OUT
                            {
                              hc.isLoading.value = true;
                              // hc.cardDispenser(portNumber: 'COM1');
                              hc.openLEDLibserial(portName: 'COM1', ledLocationAndStatus: LedOperation.topRIGHTLEDON);
                              hc.statusMessage.value = 'Please Insert Key Card \nto the dispenser';
                              hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'COP', type: 'TITLE');
                              hc.startReadCardTimer();
                              Get.to(
                                () => CheckoutView(),
                              );

                              // final response = await hc.readCard(
                              //     url: hc.kioskURL.value,
                              //     sCommand: APIConstant.readCard,
                              //     terminalID: hc.defaultTerminalID.value);
                              // if (response) {
                              //   hc.isLoading.value = false;
                              //   hc.openLEDLibserial(
                              //       portName: 'COM1', ledLocationAndStatus: LedOperation.topRIGHTLEDOFF);
                              //   Get.to(
                              //     () => CheckoutView(),
                              //   );
                              // } else {
                              //   hc.statusMessage.value =
                              //       'Unable to read Key Card \nPlease insert Key Card on Card Dispenser';
                              // }
                            }
                            break;
                          case 2: //book a room
                            {
                              Get.to(() => BookaroomView());
                            }
                            break;
                          default:
                            {
                              Get.to(() => UnderdevView());
                            }
                        }
                      },
                      child: SizedBox(
                        height: 7.h,
                        child: hc.pageTrans.isEmpty
                            ? null
                            : Image.asset(
                                hc.pageTrans[index].images!,
                                fit: BoxFit.contain,
                              )
                                .animate()
                                .fade(duration: HenryGlobal.animationSpeed)
                                .scale(duration: HenryGlobal.animationSpeed),
                      ),
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

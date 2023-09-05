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
                children: [
                  Obx(() => KioskHeader(
                        isLive: hc.clockLiveUpdate.value,
                      )),
                  // SPACE
                  SizedBox(
                    height: 12.h,
                  ),
                  // TITLE
                  KioskMenuTitle(titleLength: sc.titleTrans.length, titleTrans: sc.titleTrans),
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
                            sc.getMenu(code: 'SLMT', type: 'TITLE');
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
        itemCount: sc.pageTrans.length,
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
                            sc.pageTrans[index].translationText,
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
                  child: GestureDetector(
                    onTap: () async {
                      switch (index) {
                        case 0: //CHECK IN
                          {
                            sc.isLoading.value = true;
                            var response = await sc.getAccommodation(
                                credentialHeaders: hc.globalHeaders, languageCode: sc.selectedLanguageCode.value);
                            if (response) {
                              if (kDebugMode) print('SELECTED ROOM TYPE ID: ${sc.selectedRoomTypeID.value}');
                              // sc.selectedRoomType.value = sc.roomTypeList.first.data.roomTypes[index].code;
                              sc.getMenu(languageID: sc.selecttedLanguageID.value, code: 'SACT', type: 'TITLE');
                              hc.update();
                              Get.to(() => AccommodationView());
                            }
                          }
                          break;
                        case 1: //CHECK OUT
                          {
                            Get.to(() => CheckoutView());
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
                      child: sc.pageTrans.isEmpty
                          ? null
                          : Image.asset(
                              sc.pageTrans[index].images!,
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

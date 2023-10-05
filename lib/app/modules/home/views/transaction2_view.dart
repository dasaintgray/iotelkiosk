import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/accommodation_view.dart';
import 'package:iotelkiosk/app/modules/home/views/bookedroom_view.dart';
import 'package:iotelkiosk/app/modules/home/views/home_view.dart';
import 'package:iotelkiosk/app/modules/home/views/underdev_view.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:sizer/sizer.dart';

class Transaction2View extends GetView {
  Transaction2View({Key? key}) : super(key: key);

  final hc = Get.find<HomeController>();

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
                    height: orientation == Orientation.portrait ? 10.h : 2.h,
                  ),
                  // TITLE
                  KioskMenuTitle(
                    titleLength: hc.titleTrans.length,
                    titleTrans: hc.titleTrans,
                    orientation: orientation,
                  ),
                  // SPACE
                  SizedBox(
                    height: 2.h,
                  ),
                  // MENU
                  menuTransactionTitle2(orientation),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 5.h : 2.h,
                    child: GestureDetector(
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
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget menuTransactionTitle2(Orientation orientation, {int? languageID, String? code, String? type}) {
    return SizedBox(
      height: orientation == Orientation.portrait ? 45.h : 20.h,
      width: orientation == Orientation.portrait ? 70.w : 55.w,
      child: ListView.builder(
        padding: const EdgeInsets.all(25.0),
        itemCount: hc.pageTrans.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: orientation == Orientation.portrait ? 10.h : 6.h,
            child: Stack(
              children: [
                Positioned(
                  left: orientation == Orientation.portrait ? 25.w : 20.w,
                  top: 32,
                  right: 10.w,
                  child: SizedBox(
                    width: 10.w,
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
                              fontSize: orientation == Orientation.portrait ? 12.sp : 8.sp,
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
                        case 0: //BOOKED ROOM
                          {
                            hc.isLoading.value = true;
                            final response =
                                hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'PIBN', type: 'TITLE');
                            if (response) {
                              hc.isLoading.value = false;
                              Get.to(() => BookedroomView());
                            }
                          }
                          break;
                        case 1: //WALK-IN
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
                        default:
                          {
                            Get.to(() => UnderdevView());
                          }
                          break;
                      }
                    },
                    child: SizedBox(
                      height: orientation == Orientation.portrait ? 7.h : 5.h,
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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/roomtype_view.dart';
import 'package:iotelkiosk/app/modules/home/views/transaction2_view.dart';
// import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:sizer/sizer.dart';

class AccommodationView extends GetView {
  AccommodationView({Key? key}) : super(key: key);

  final hc = Get.find<HomeController>();
  // final sc = Get.find<ScreenController>();

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
                  Obx(
                    () => KioskHeader(
                      isLive: hc.clockLiveUpdate.value,
                    ),
                  ),
                  // SPACE
                  SizedBox(
                    height: orientation == Orientation.portrait ? 10.h : 2.h,
                  ),
                  // TITLE
                  KioskMenuTitle(
                    titleTrans: hc.titleTrans,
                    fontSize: orientation == Orientation.portrait ? 12.sp : 8.sp,
                    heights: orientation == Orientation.portrait ? 7.h : 2.h,
                  ),
                  // SPACE
                  SizedBox(
                    height: 2.h,
                  ),
                  // MENU

                  SizedBox(
                    height: orientation == Orientation.portrait ? 40.h : 20.h,
                    width: orientation == Orientation.portrait ? 70.w : 55.w,
                    child: menuAccommodationType(orientation, languageID: hc.selecttedLanguageID.value),
                  ),

                  SizedBox(
                    height: orientation == Orientation.portrait ? 5.h : 1.h,
                  ),

                  SizedBox(
                    height: orientation == Orientation.portrait ? 5.h : 2.h,
                    child: GestureDetector(
                      onTap: () {
                        hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'SCIP', type: 'TITLE');
                        // hc.update();
                        // Get.back();
                        Get.off(() => Transaction2View());
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

  Widget menuAccommodationType(Orientation orientation, {int? languageID, String? code, String? type}) {
    final langCode = hc.languageList.first.data.languages.where((element) => element.id == languageID);

    return ListView.builder(
      padding: const EdgeInsets.all(25.0),
      itemCount: hc.accommodationTypeList.first.data.accommodationTypes.length,
      // physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: orientation == Orientation.portrait ? 10.h : 8.h,
          child: Stack(
            children: [
              Positioned(
                left: orientation == Orientation.portrait ? 27.w : 22.w,
                top: orientation == Orientation.portrait ? 35 : 20,
                child: Center(
                  child: Text(
                    langCode.first.code.toLowerCase() == hc.selectedLanguageCode.value.toLowerCase()
                        ? hc.accommodationTypeList.first.data.accommodationTypes[index].description.toUpperCase()
                        : hc.accommodationTypeList.first.data.accommodationTypes[index].translatedText!,
                    style: TextStyle(
                      color: HenryColors.darkGreen,
                      fontSize: orientation == Orientation.portrait ? 12.sp : 8.sp,
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   left: orientation == Orientation.portrait ? 25.w : 22.w,
              //   top: 35,
              //   right: 10.w,
              //   child: SizedBox(
              //     width: 10.w,
              //     child: Text(
              //       langCode.first.code.toLowerCase() == hc.selectedLanguageCode.value.toLowerCase()
              //           ? hc.accommodationTypeList.first.data.accommodationTypes[index].description.toUpperCase()
              //           : hc.accommodationTypeList.first.data.accommodationTypes[index].translatedText!,
              //       style: TextStyle(
              //         color: HenryColors.darkGreen,
              //         fontSize: orientation == Orientation.portrait ? 12.sp : 8.sp,
              //       ),
              //     ),
              //   ),
              // ),
              Positioned(
                left: 8.w,
                right: 8.w,
                child: GestureDetector(
                  onTap: () async {
                    hc.selectedTransactionType.value = hc.pageTrans[index].translationText;

                    hc.isLoading.value = true;
                    var response = await hc.getRoomType(
                        credentialHeaders: hc.accessTOKEN, languageCode: hc.selectedLanguageCode.value);
                    if (response) {
                      hc.selectedAccommodationTypeID.value =
                          hc.accommodationTypeList.first.data.accommodationTypes[index].id;
                      if (kDebugMode) {
                        print('SELECTED ACCOMMODATION TYPE ID: ${hc.selectedAccommodationTypeID.value}');
                      }
                      hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'SRT', type: 'TITLE');
                      hc.isLoading.value = false;
                      hc.update();
                      Get.to(() => RoomTypeView());
                    }
                  },
                  child: SizedBox(
                    height: orientation == Orientation.portrait ? 7.h : 5.h,
                    child: hc.accommodationTypeList.first.data.accommodationTypes.isNotEmpty
                        ? Image.asset(
                                'assets/menus/hour${hc.accommodationTypeList.first.data.accommodationTypes[index].seq}.png',
                                fit: BoxFit.contain)
                            .animate()
                            .fade(duration: HenryGlobal.animationSpeed)
                            .scale(duration: HenryGlobal.animationSpeed)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

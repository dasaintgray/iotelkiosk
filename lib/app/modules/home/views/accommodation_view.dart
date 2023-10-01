import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/roomtype_view.dart';
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
                    titleLength: hc.titleTrans.length,
                    titleTrans: hc.titleTrans,
                    orientation: orientation,
                  ),
                  // SPACE
                  SizedBox(
                    height: 2.h,
                  ),
                  // MENU
                  menuAccommodationType(orientation, languageID: hc.selecttedLanguageID.value),

                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 5.h : 2.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            hc.getMenu(code: 'SLMT', type: 'TITLE');
                            // hc.update();
                            Get.back();
                          },
                          child: Image.asset(
                            'assets/menus/back-arrow.png',
                            fit: BoxFit.cover,
                            semanticLabel: 'Back to previous menu',
                          ),
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

  Widget menuAccommodationType(Orientation orientation, {int? languageID, String? code, String? type}) {
    final langCode = hc.languageList.first.data.languages.where((element) => element.id == languageID);

    return SizedBox(
      height: orientation == Orientation.portrait ? 43.h : 20.h,
      width: 75.w,
      child: ListView.builder(
        padding: const EdgeInsets.all(25.0),
        itemCount: hc.accommodationTypeList.first.data.accommodationTypes.length,
        physics: const ClampingScrollPhysics(),
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
                    child: Text(
                      langCode.first.code.toLowerCase() == hc.selectedLanguageCode.value.toLowerCase()
                          ? hc.accommodationTypeList.first.data.accommodationTypes[index].description.toUpperCase()
                          : hc.accommodationTypeList.first.data.accommodationTypes[index].translatedText!,
                      style: TextStyle(
                        color: HenryColors.darkGreen,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
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
                      height: 7.h,
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
      ),
    );
  }
}

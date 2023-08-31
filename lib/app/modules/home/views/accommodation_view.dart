import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/roomtype_view.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
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
  final sc = Get.find<ScreenController>();

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
                children: [
                  KioskHeader(),
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
                  menuAccommodationType(orientation, languageID: sc.selecttedLanguageID.value),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 5.h : 2.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            sc.getMenu(code: 'SLMT', type: 'TITLE');
                            hc.update();
                            Get.back();
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

  Widget menuAccommodationType(Orientation orientation, {int? languageID, String? code, String? type}) {
    final langCode = sc.languageList.first.data.languages.where((element) => element.id == languageID);

    return SizedBox(
      height: orientation == Orientation.portrait ? 49.h : 20.h,
      width: 75.w,
      child: ListView.builder(
        padding: const EdgeInsets.all(25.0),
        itemCount: sc.accommodationTypeList.first.data.accommodationTypes.length,
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
                      langCode.first.code.toLowerCase() == sc.defaultLanguageCode.value.toLowerCase()
                          ? sc.accommodationTypeList.first.data.accommodationTypes[index].description.toUpperCase()
                          : sc.accommodationTypeList.first.data.accommodationTypes[index].translatedText!,
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
                      sc.isLoading.value = true;
                      var response = await sc.getRoomType(
                          credentialHeaders: hc.globalHeaders, languageCode: sc.selectedLanguageCode.value);
                      if (response) {
                        sc.selectedAccommodationTypeID.value =
                            sc.accommodationTypeList.first.data.accommodationTypes[index].id;
                        if (kDebugMode) {
                          print('SELECTED ACCOMMODATION TYPE ID: ${sc.selectedAccommodationTypeID.value}');
                        }
                        sc.getMenu(languageID: sc.selecttedLanguageID.value, code: 'SRT');
                        sc.isLoading.value = false;
                        sc.selectedTransactionType.value = sc.pageTrans[index].translationText;
                        hc.update();
                        Get.to(() => RoomTypeView());
                      }
                    },
                    child: SizedBox(
                      height: 7.h,
                      child: sc.accommodationTypeList.first.data.accommodationTypes.isNotEmpty
                          ? Image.asset(
                                  'assets/menus/hour${sc.accommodationTypeList.first.data.accommodationTypes[index].seq}.png',
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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/payment_method_view.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:sizer/sizer.dart';

class RoomTypeView extends GetView {
  RoomTypeView({Key? key}) : super(key: key);

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
                  menuRoomType(orientation, languageID: sc.selecttedLanguageID.value),
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

  Widget menuRoomType(Orientation orientation, {int? languageID, String? code, String? type}) {
    final langCode = sc.languageList.first.data.languages.where((element) => element.id == languageID);
    // bool isTranslate = langCode.first.code.toLowerCase() != sc.defaultLanguageCode.value.toLowerCase();
    return SizedBox(
      height: orientation == Orientation.portrait ? 45.h : 20.h,
      width: 75.w,
      child: ListView.builder(
        padding: const EdgeInsets.all(25.0),
        itemCount: sc.roomTypeList.first.data.roomTypes.length,
        itemBuilder: (BuildContext context, int index) {
          var imageFilename = 'assets/menus/${sc.roomTypeList.first.data.roomTypes[index].code.toLowerCase()}.png';
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
                            langCode.first.code.toLowerCase() == sc.defaultLanguageCode.value.toLowerCase()
                                ? sc.roomTypeList.first.data.roomTypes[index].description.toUpperCase()
                                : sc.roomTypeList.first.data.roomTypes[index].translatedText!,
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
                      // sc.isLoading.value = true;
                      // sc.selectedRoomType.value = sc.roomTypeList.first.data.roomTypes[index].code;
                      // sc.getMenu(languageID: sc.selecttedLanguageID.value, code: 'SACT', type: 'TITLE');
                      // var response = await sc.getAccommodation(
                      //     credentialHeaders: hc.globalHeaders, languageCode: sc.selectedLanguageCode.value);
                      // if (response) {
                      //   if (kDebugMode) print('SELECTED ROOM TYPE ID: ${sc.selectedRoomTypeID.value}');
                      //   Get.to(() => AccommodationView());
                      // }

                      sc.isLoading.value = true;
                      sc.selectedRoomTypeID.value = sc.roomTypeList.first.data.roomTypes[index].id;
                      var response = await sc.getPaymentType(
                          credentialHeaders: hc.globalHeaders, languageCode: sc.selectedLanguageCode.value);
                      if (response) {
                        sc.getMenu(languageID: sc.selecttedLanguageID.value, code: 'SPM');
                        var response = await hc.cashDispenserCommand(sCommand: 'CASH', iTerminalID: 1);
                        if (kDebugMode) print(response);

                        hc.update();
                        Get.to(() => PaymentMethodView());
                      }
                    },
                    child: SizedBox(
                      height: 7.h,
                      child: sc.roomTypeList.first.data.roomTypes.isEmpty
                          ? null
                          : Image.asset(imageFilename, fit: BoxFit.contain)
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

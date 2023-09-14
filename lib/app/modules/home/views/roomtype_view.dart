import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/payment_method_view.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/api_constant.dart';
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
                  menuRoomType(orientation, languageID: hc.selecttedLanguageID.value),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 5.h : 2.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            hc.getMenu(code: 'SLMT', type: 'TITLE');
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
    final langCode = hc.languageList.first.data.languages.where((element) => element.id == languageID);
    // bool isTranslate = langCode.first.code.toLowerCase() != sc.defaultLanguageCode.value.toLowerCase();
    return SizedBox(
      height: orientation == Orientation.portrait ? 45.h : 20.h,
      width: 75.w,
      child: ListView.builder(
        padding: const EdgeInsets.all(25.0),
        itemCount: hc.roomTypeList.first.data.roomTypes.length,
        itemBuilder: (BuildContext context, int index) {
          var imageFilename = 'assets/menus/${hc.roomTypeList.first.data.roomTypes[index].code.toLowerCase()}.png';
          return SizedBox(
            height: 10.h,
            child: Stack(
              children: [
                Positioned(
                  left: 25.w,
                  top: 35,
                  right: 10.w,
                  child: Obx(
                    () => SizedBox(
                      width: 10.w,
                      child: hc.isLoading.value
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
                              langCode.first.code.toLowerCase() == hc.selectedLanguageCode.value.toLowerCase()
                                  ? hc.roomTypeList.first.data.roomTypes[index].description.toUpperCase()
                                  : hc.roomTypeList.first.data.roomTypes[index].translatedText!,
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
                ),
                Positioned(
                  left: 8.w,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: () async {
                      hc.isLoading.value = true;
                      hc.selectedRoomTypeID.value = hc.roomTypeList.first.data.roomTypes[index].id;
                      var response = await hc.getPaymentType(
                          credentialHeaders: hc.accessTOKEN, languageCode: hc.selectedLanguageCode.value);
                      if (response) {
                        hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'SPM', type: 'TITLE');
                        if (kDebugMode) print('PAYMENT => LANGUAGE ID: ${hc.selecttedLanguageID.value}');
                        await hc.cashDispenserCommand(
                            sCommand: APIConstant.cashPoolingStop, iTerminalID: hc.defaultTerminalID.value);

                        hc.isLoading.value = false;
                        Get.to(() => PaymentMethodView());
                      }
                    },
                    child: SizedBox(
                      height: 7.h,
                      child: hc.roomTypeList.first.data.roomTypes.isEmpty
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

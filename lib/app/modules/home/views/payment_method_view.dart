import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/insert_payment_view.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/api_constant.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/constant/led_constant.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:sizer/sizer.dart';

class PaymentMethodView extends GetView {
  PaymentMethodView({Key? key}) : super(key: key);

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
                  menuPaymentType(orientation, languageID: hc.selecttedLanguageID.value),
                  Obx(() => Visibility(
                        visible: !sc.isLoading.value,
                        child: SizedBox(
                          height: orientation == Orientation.portrait ? 10.h : 2.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  var response = hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'ST');
                                  if (response) Get.back();
                                },
                                child: Image.asset(
                                  'assets/menus/back-arrow.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget menuPaymentType(Orientation orientation, {int? languageID, String? code, String? type}) {
    final langCode = hc.languageList.first.data.languages.where((element) => element.id == languageID);
    return Obx(() => SizedBox(
          height: orientation == Orientation.portrait ? 45.h : 20.h,
          width: 75.w,
          child: hc.isLoading.value
              ? Center(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: 18.w,
                        child: CircularProgressIndicator.adaptive(
                            strokeWidth: 5.sp, valueColor: const AlwaysStoppedAnimation<Color>(HenryColors.puti)),
                      ),
                      Text(
                        'Initializing \nCash Acceptor Device \nplease wait ....',
                        style: TextStyle(color: HenryColors.darkGreen, fontSize: 20.sp),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '[The light is flushing...]',
                        style: TextStyle(color: HenryColors.puti, fontSize: 5.sp),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(25.0),
                  itemCount: hc.paymentTypeList.first.data.paymentTypes.length,
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
                              child: Animate(
                                // effects: const [FadeEffect(), ScaleEffect()],
                                child: sc.isLoading.value
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                            ? hc.paymentTypeList.first.data.paymentTypes[index].description
                                                .toUpperCase()
                                            : hc.paymentTypeList.first.data.paymentTypes[index].translatedText!,
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
                                switch (index) {
                                  // CASH
                                  case 0:
                                    {
                                      hc.isLoading.value = true;
                                      hc.selectedPaymentTypeCode.value =
                                          hc.paymentTypeList.first.data.paymentTypes[index].code;

                                      var response = await hc.getAvailableRoomsGraphQL(
                                          credentialHeaders: hc.accessTOKEN,
                                          roomTYPEID: hc.selectedRoomTypeID.value,
                                          accommodationTYPEID: hc.selectedAccommodationTypeID.value);

                                      if (response!) {
                                        // sc.subscribeCashDispenser();
                                        // initialize the led on cash acceptor
                                        final String ledPort;
                                        if (kDebugMode) {
                                          ledPort = "COM1";
                                        } else {
                                          ledPort = "COM8";
                                        }

                                        sc.openLEDLibserial(
                                            ledLocationAndStatus: LedOperation.bottomRIGHTLEDON, portName: ledPort);
                                        // hc.defaultTerminalID.value = hc.terminalsList.first.data.terminals.first.id;

                                        var cashresponse = await hc.cashDispenserCommand(
                                            sCommand: APIConstant.cashPoolingStart,
                                            iTerminalID: hc.defaultTerminalID.value);
                                        if (cashresponse!) {
                                          sc.openLEDLibserial(
                                              ledLocationAndStatus: LedOperation.bottomRIGHTLEDOFF, portName: ledPort);
                                          hc.isLoading.value = false;
                                          // CHECK ANG TERMINAL DATA DITO

                                          var accessToken = await hc.getAccessToken();
                                          hc.getTerminalData(
                                              headers: accessToken!,
                                              terminalID: hc.defaultTerminalID.value,
                                              sCode: 'CASI');

                                          hc.getMenu(languageID: languageID, code: 'IP', type: 'TITLE');

                                          await hc.getCamera();

                                          // hc.update();
                                          Get.to(() => InsertPaymentView());
                                        }
                                      }
                                    }
                                    break;
                                  default:
                                    {
                                      Get.defaultDialog(
                                        title: "Information",
                                        content: const Text('No POS MCR Device Detected'),
                                      );
                                    }
                                }
                              },
                              child: SizedBox(
                                height: 7.h,
                                child: hc.paymentTypeList.first.data.paymentTypes.isNotEmpty
                                    ? Image.asset('assets/menus/payment${index + 1}.png', fit: BoxFit.contain)
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
        ));
  }
}

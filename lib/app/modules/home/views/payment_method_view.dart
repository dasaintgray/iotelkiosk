import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/insert_payment_view.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/carousel_title_widget.dart';
import 'package:iotelkiosk/globals/widgets/weather_clock_widget.dart';
import 'package:sizer/sizer.dart';

class PaymentMethodView extends GetView {
  PaymentMethodView({Key? key}) : super(key: key);

  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (BuildContext context, orientation, deviceType) {
      return GestureDetector(
        onTap: () {
          if (hc.isIdleActive.value) {
            sc.player.play();
          }
        },
        child: Stack(
          children: [
            Positioned(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background/bck.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              top: orientation == Orientation.portrait ? 15.h : 5.h,
              bottom: orientation == Orientation.portrait ? 65.h : 45.h,
              left: orientation == Orientation.portrait ? 35.w : 45.w,
              right: orientation == Orientation.portrait ? 35.w : 45.w,
              child: SizedBox(
                child: Image.asset('assets/png/iotellogo.png', fit: BoxFit.contain),
              ),
            ),
            Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.h,
                      width: double.infinity,
                      child: WeatherAndClock(
                        localTime: hc.localTime,
                        localTimeLocation: 'Philipppines',
                        degreeC: sc.weatherList.first.current.tempC.toStringAsFixed(0),
                        degreeF: sc.weatherList.first.current.tempF.toStringAsFixed(0),
                        weatherCondition: sc.weatherList.first.current.condition.text,
                        localWeatherLocation: sc.weatherList.first.location.name,
                        localWeatherCountry: sc.weatherList.first.location.country,
                        countryOneTime: hc.japanNow,
                        countryOneLocation: 'Japan',
                        countryTwoTime: hc.newyorkNow,
                        countryTwoLocation: 'New York',
                        countryThreeTime: hc.seoulNow,
                        countryThreeLocation: 'Seoul',
                        countryFourTime: hc.sydneyNow,
                        countryFourLocation: 'Sydney',
                        weatherImage: sc.imgUrl.value,
                        textStyle: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(
                      height: orientation == Orientation.portrait ? 12.h : 1.h,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 5.h,
                      width: double.infinity,
                      child: CarouselTitle(
                        titleTrans: sc.titleTrans,
                        textStyle: TextStyle(color: HenryColors.darkGreen, fontSize: 15.sp),
                      ),
                    ),
                    menuPaymentType(orientation, languageID: sc.selecttedLanguageID.value),
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
                                    var response = sc.getMenu(languageID: sc.selecttedLanguageID.value, code: 'ST');
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
            ),
          ],
        ),
      );
    });
  }

  Widget menuPaymentType(Orientation orientation, {int? languageID, String? code, String? type}) {
    final langCode = sc.languageList.first.data.languages.where((element) => element.id == languageID);
    return Obx(() => SizedBox(
          height: orientation == Orientation.portrait ? 49.h : 20.h,
          width: 75.w,
          child: sc.isLoading.value
              ? Center(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator.adaptive(),
                      Text(
                        'Initializing payment, \nplease wait ....',
                        style: TextStyle(color: HenryColors.darkGreen, fontSize: 25.sp),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(25.0),
                  itemCount: sc.paymentTypeList.first.data.paymentTypes.length,
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
                                        langCode.first.code.toLowerCase() == sc.defaultLanguageCode.value.toLowerCase()
                                            ? sc.paymentTypeList.first.data.paymentTypes[index].description
                                                .toUpperCase()
                                            : sc.paymentTypeList.first.data.paymentTypes[index].translatedText!,
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
                                  case 0:
                                    {
                                      sc.isLoading.value = true;
                                      sc.selectedPaymentTypeCode.value =
                                          sc.paymentTypeList.first.data.paymentTypes[index].code;
                                      var response = await sc.getAvailableRoomsGraphQL(
                                          credentialHeaders: hc.globalHeaders,
                                          roomTYPEID: sc.selectedRoomTypeID.value,
                                          accommodationTYPEID: sc.selectedAccommodationTypeID.value);

                                      if (response!) {
                                        // sc.subscribeCashDispenser();

                                        sc.getMenu(languageID: languageID, code: 'IP', type: 'TITLE');

                                        var cashresponse =
                                            await hc.cashDispenserCommand(sCommand: 'CASA', iTerminalID: 3);
                                        if (cashresponse!) {
                                          sc.isLoading.value = false;
                                          Get.to(() => InsertPaymentView());
                                        }
                                      }
                                    }
                                    break;
                                  default:
                                    {
                                      Get.defaultDialog(
                                        title: "Information",
                                        content: const Text('No Device Detected'),
                                      );
                                    }
                                }
                              },
                              child: SizedBox(
                                height: 7.h,
                                child: sc.paymentTypeList.first.data.paymentTypes.isNotEmpty
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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/carousel_title_widget.dart';
import 'package:iotelkiosk/globals/widgets/weather_clock_widget.dart';
import 'package:sizer/sizer.dart';

class BookaroomView extends GetView {
  BookaroomView({Key? key}) : super(key: key);
  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, orientation, deviceType) {
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
                          isLiveUpdate: hc.clockLiveUpdate.value,
                          localTime: hc.localTime.value,
                          localTimeLocation: 'Philipppines',
                          degreeC: sc.weatherList.first.current.tempC.toStringAsFixed(0),
                          degreeF: sc.weatherList.first.current.tempF.toStringAsFixed(0),
                          weatherCondition: sc.weatherList.first.current.condition.text,
                          localWeatherLocation: sc.weatherList.first.location.name,
                          localWeatherCountry: sc.weatherList.first.location.country,
                          countryOneTime: hc.japanNow.value,
                          countryOneLocation: 'Japan',
                          countryTwoTime: hc.newyorkNow.value,
                          countryTwoLocation: 'New York',
                          countryThreeTime: hc.seoulNow.value,
                          countryThreeLocation: 'Seoul',
                          countryFourTime: hc.sydneyNow.value,
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
                      // menuRoomType(orientation, languageID: sc.selecttedLanguageID.value),
                      menuBookARoom(orientation, languageID: sc.selecttedLanguageID.value),
                      SizedBox(
                        height: orientation == Orientation.portrait ? 10.h : 2.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                var response =
                                    sc.getMenu(languageID: sc.selecttedLanguageID.value, code: 'ST', type: 'ITEM');
                                if (response) {
                                  Get.back();
                                }
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  menuBookARoom(Orientation orientation, {int? languageID, String? code, String? type}) {
    final langCode = sc.languageList.first.data.languages.where((element) => element.id == languageID);

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
                      sc.selectedRoomType.value = sc.roomTypeList.first.data.roomTypes[index].code;
                      sc.getMenu(languageID: sc.selecttedLanguageID.value, code: 'SACT', type: 'TITLE');
                      var response = await sc.getAccommodation(
                          credentialHeaders: hc.globalHeaders, languageCode: sc.selectedLanguageCode.value);
                      if (response) {
                        if (kDebugMode) print('SELECTED ROOM TYPE ID: ${sc.selectedRoomTypeID.value}');
                        // Get.to(() => AccommodationView());
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

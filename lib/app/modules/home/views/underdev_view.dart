import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/carousel_title_widget.dart';
import 'package:iotelkiosk/globals/widgets/weather_clock_widget.dart';
import 'package:sizer/sizer.dart';

class UnderdevView extends GetView {
  UnderdevView({Key? key}) : super(key: key);

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
    });
  }
}

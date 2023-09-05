import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/weather_clock_widget.dart';
import 'package:sizer/sizer.dart';

class KioskHeader extends StatelessWidget {
  KioskHeader({Key? key, required this.isLive}) : super(key: key);

  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  final bool isLive;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 20.h,
        child: WeatherAndClock(
          isLiveUpdate: isLive,
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
          textStyle: TextStyle(
            color: HenryColors.puti,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}

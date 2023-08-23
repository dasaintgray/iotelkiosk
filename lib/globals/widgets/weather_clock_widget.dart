import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/henryclock_widget.dart';
import 'package:sizer/sizer.dart';

class WeatherAndClock extends StatelessWidget {
  final DateTime localTime;
  final String localTimeLocation;
  final String degreeC;
  final String degreeF;
  final String weatherCondition;
  final String localWeatherLocation;
  final String localWeatherCountry;
  final DateTime countryOneTime;
  final String countryOneLocation;
  final DateTime countryTwoTime;
  final String countryTwoLocation;
  final DateTime countryThreeTime;
  final String countryThreeLocation;
  final DateTime countryFourTime;
  final String countryFourLocation;
  final String weatherImage;
  final TextStyle textStyle;

  const WeatherAndClock({
    super.key,
    required this.localTime,
    required this.localTimeLocation,
    required this.degreeC,
    required this.degreeF,
    required this.weatherCondition,
    required this.localWeatherLocation,
    required this.localWeatherCountry,
    required this.countryOneTime,
    required this.countryOneLocation,
    required this.countryTwoTime,
    required this.countryTwoLocation,
    required this.countryThreeTime,
    required this.countryThreeLocation,
    required this.countryFourTime,
    required this.countryFourLocation,
    required this.weatherImage,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  // width: 10.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: textStyle,
                        child: Text(
                          DateFormat("EEEE").format(localTime),
                        ),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(color: HenryColors.puti, fontSize: 6.sp),
                        child: Text(
                          DateFormat("MMMM, dd, y").format(localTime),
                        ),
                      ),
                      const Divider(
                        color: HenryColors.puti,
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: HenryClock(
                          locationOfTime: localTimeLocation,
                          locationStyle: const TextStyle(color: HenryColors.puti, fontSize: 15),
                          dateTime: localTime,
                          isLive: true,
                          useClockSkin: false,
                          showSeconds: false,
                          textScaleFactor: 1.5,
                          digitalClockTextColor: HenryColors.darkGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
                width: 55.w,
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(
                            weatherImage,
                            fit: BoxFit.cover,
                            height: 80,
                            width: 100,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultTextStyle(
                                style: TextStyle(color: HenryColors.puti, fontSize: 6.sp),
                                child: Text(
                                  '$degreeC° C',
                                ),
                              ),
                              DefaultTextStyle(
                                style: TextStyle(color: HenryColors.puti, fontSize: 6.sp),
                                child: Text(
                                  '$degreeF° F',
                                ),
                              ),

                              // Text(
                              //   '$degreeC° C',
                              //   style: TextStyle(color: HenryColors.puti, fontSize: 6.sp),
                              // ),
                              // Text(
                              //   '$degreeF° F',
                              //   style: TextStyle(color: HenryColors.puti, fontSize: 6.sp),
                              // ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        color: HenryColors.puti,
                        thickness: 3,
                      ),
                      DefaultTextStyle(
                        style: TextStyle(color: HenryColors.puti, fontSize: 4.sp, overflow: TextOverflow.ellipsis),
                        child: Text(
                          weatherCondition,
                        ),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(color: HenryColors.puti, fontSize: 3.sp),
                        child: Text('$localWeatherLocation, $localWeatherCountry'),
                      ),
                      // Text(
                      //   weatherCondition,
                      //   style: TextStyle(color: HenryColors.puti, fontSize: 4.sp, overflow: TextOverflow.ellipsis),
                      // ),
                      // Text('$localWeatherLocation, $localWeatherCountry',
                      //     style: TextStyle(color: HenryColors.puti, fontSize: 3.sp))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DefaultTextStyle(
              style: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
              child: HenryClock(
                locationOfTime: countryOneLocation,
                locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
                dateTime: countryOneTime,
                isLive: true,
                showSeconds: false,
                use24Hour: true,
                useClockSkin: true,
                textScaleFactor: 2,
                digitalClockTextColor: Colors.black,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
              ),
            ),
            DefaultTextStyle(
              style: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
              child: HenryClock(
                locationOfTime: countryTwoLocation,
                locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
                dateTime: countryTwoTime,
                isLive: true,
                showSeconds: false,
                use24Hour: true,
                useClockSkin: true,
                textScaleFactor: 2,
                digitalClockTextColor: Colors.black,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
              ),
            ),
            DefaultTextStyle(
              style: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
              child: HenryClock(
                locationOfTime: countryThreeLocation,
                locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
                dateTime: countryThreeTime,
                isLive: true,
                showSeconds: false,
                use24Hour: true,
                useClockSkin: true,
                textScaleFactor: 2,
                digitalClockTextColor: Colors.black,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
              ),
            ),
            DefaultTextStyle(
              style: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
              child: HenryClock(
                locationOfTime: countryFourLocation,
                locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
                dateTime: countryFourTime,
                isLive: true,
                showSeconds: false,
                use24Hour: true,
                useClockSkin: true,
                textScaleFactor: 2,
                digitalClockTextColor: Colors.black,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
              ),
            ),
            // HenryClock(
            //   locationOfTime: countryOneLocation,
            //   locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
            //   dateTime: countryOneTime,
            //   isLive: true,
            //   showSeconds: false,
            //   use24Hour: true,
            //   useClockSkin: true,
            //   textScaleFactor: 2,
            //   digitalClockTextColor: Colors.black,
            //   decoration: const BoxDecoration(
            //     shape: BoxShape.rectangle,
            //     borderRadius: BorderRadius.all(Radius.zero),
            //   ),
            // ),
            // HenryClock(
            //   locationOfTime: countryTwoLocation,
            //   locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
            //   dateTime: countryTwoTime,
            //   isLive: true,
            //   showSeconds: false,
            //   use24Hour: true,
            //   useClockSkin: true,
            //   textScaleFactor: 2,
            //   digitalClockTextColor: Colors.black,
            //   decoration: const BoxDecoration(
            //     shape: BoxShape.rectangle,
            //     borderRadius: BorderRadius.all(Radius.zero),
            //   ),
            // ),
            // HenryClock(
            //   locationOfTime: countryThreeLocation,
            //   locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
            //   dateTime: countryThreeTime,
            //   isLive: true,
            //   showSeconds: false,
            //   use24Hour: true,
            //   useClockSkin: true,
            //   textScaleFactor: 2,
            //   digitalClockTextColor: Colors.black,
            //   decoration: const BoxDecoration(
            //     shape: BoxShape.rectangle,
            //     borderRadius: BorderRadius.all(Radius.zero),
            //   ),
            // ),
            // HenryClock(
            //   locationOfTime: countryFourLocation,
            //   locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
            //   dateTime: countryFourTime,
            //   isLive: true,
            //   showSeconds: false,
            //   use24Hour: true,
            //   useClockSkin: true,
            //   textScaleFactor: 2,
            //   digitalClockTextColor: Colors.black,
            //   decoration: const BoxDecoration(
            //     shape: BoxShape.rectangle,
            //     borderRadius: BorderRadius.all(Radius.zero),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}

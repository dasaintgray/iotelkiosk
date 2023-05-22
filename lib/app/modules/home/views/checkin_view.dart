import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/henryclock_widget.dart';
import 'package:sizer/sizer.dart';

class CheckinView extends GetView {
  CheckinView({Key? key}) : super(key: key);

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
                    clockAndWeather(),

                    SizedBox(
                      height: orientation == Orientation.portrait ? 12.h : 1.h,
                      width: double.infinity,
                    ),

                    menuTitle(),

                    menuRoomType(orientation, languageID: sc.selecttedLanguageID.value),

                    Obx(
                      () => Visibility(
                        visible: hc.menuIndex.value != 0,
                        child: SizedBox(
                          height: orientation == Orientation.portrait ? 10.h : 2.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (hc.menuIndex.value > 1) {
                                    hc.menuIndex.value--;
                                  } else {
                                    hc.disposeCamera();
                                    hc.menuIndex.value = 0;
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
                      ),
                    ),

                    // SizedBox(
                    //   height: 5.h,
                    //   width: double.infinity,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget clockAndWeather() {
    return SizedBox(
      height: 20.h,
      width: double.infinity,
      child: Column(
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
                        Text(
                          DateFormat("EEEE").format(hc.localTime),
                          style: TextStyle(color: HenryColors.puti, fontSize: 6.sp),
                        ),
                        Text(
                          DateFormat("MMMM, dd, y").format(hc.localTime),
                          style: TextStyle(color: HenryColors.puti, fontSize: 6.sp),
                        ),
                        const Divider(
                          color: HenryColors.puti,
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: HenryClock(
                            locationOfTime: 'Philippines',
                            locationStyle: const TextStyle(color: HenryColors.puti, fontSize: 15),
                            dateTime: hc.localTime,
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
                              sc.imgUrl.value,
                              fit: BoxFit.cover,
                              height: 80,
                              width: 100,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${sc.weatherList.first.current.tempC.toStringAsFixed(0)}° C',
                                  style: TextStyle(color: HenryColors.puti, fontSize: 6.sp),
                                ),
                                Text(
                                  '${sc.weatherList.first.current.tempF.toStringAsFixed(0)}° F',
                                  style: TextStyle(color: HenryColors.puti, fontSize: 6.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(
                          color: HenryColors.puti,
                          thickness: 3,
                        ),
                        Text(
                          sc.weatherList.first.current.condition.text,
                          style: TextStyle(color: HenryColors.puti, fontSize: 4.sp, overflow: TextOverflow.ellipsis),
                        ),
                        Text('${sc.weatherList.first.location.name}, ${sc.weatherList.first.location.country}',
                            style: TextStyle(color: HenryColors.puti, fontSize: 3.sp))
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
              HenryClock(
                locationOfTime: 'Japan',
                locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
                dateTime: hc.japanNow,
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
              HenryClock(
                locationOfTime: 'New York',
                locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
                dateTime: hc.newyorkNow,
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
              HenryClock(
                locationOfTime: 'Korea',
                locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
                dateTime: hc.seoulNow,
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
              HenryClock(
                locationOfTime: 'Sydney',
                locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
                dateTime: hc.sydneyNow,
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
            ],
          ),
        ],
      ),
    );
  }

  Widget menuTitle() {
    return Obx(
      () => SizedBox(
        height: 5.h,
        width: double.infinity,
        child: FlutterCarousel.builder(
          itemCount: sc.titleTrans.length,
          itemBuilder: (BuildContext context, int ctr, int realIndex) {
            return SizedBox(
              height: 10.h,
              width: double.infinity,
              child: Center(
                child: Text(
                    sc.titleTrans.length == 1 ? sc.titleTrans[0].translationText : sc.titleTrans[ctr].translationText,
                    style: TextStyle(color: HenryColors.darkGreen, fontSize: 13.sp)),
              ),
            );
          },
          options: CarouselOptions(
              autoPlay: sc.titleTrans.length == 1 ? false : true,
              showIndicator: false,
              reverse: true,
              scrollDirection: Axis.vertical),
        ),
      ),
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

          hc.translator
              .translate(sc.roomTypeList.first.data.roomTypes[index].description, to: langCode.first.code.toLowerCase())
              .then((value) {
            hc.roomTypeTranslatedText.value = value.text;
            if (kDebugMode) {
              print(hc.roomTypeTranslatedText.value);
            }
            sc.roomTypeList.refresh();
          });

          if (kDebugMode) {
            print(imageFilename);
          }

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
                      hc.roomTypeTranslatedText.value,
                      style: TextStyle(
                        color: HenryColors.darkGreen,
                        fontSize: 12.sp,
                      ),
                    ).animate().fade(duration: HenryGlobal.animationSpeed).scale(duration: HenryGlobal.animationSpeed),
                  ),
                ),
                Positioned(
                  left: 8.w,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: () {
                      sc.selectedRoomType.value = sc.roomTypeList.first.data.roomTypes[index].code;
                      if (kDebugMode) {
                        print('SELECTED ROOM TYPE ID: ${sc.selectedRoomTypeID.value}');
                      }
                      hc.menuIndex.value++;
                      // var response =
                      //     sc.getMenu(languageID: languageID, code: 'SACT', type: 'ITEM', indexCode: hc.menuIndex.value);
                      // if (response) {
                      //   // var roomIndex = sc.roomTypeList.first.data.roomTypes
                      //   //     .indexWhere((element) => element.code == sc.selectedRoomType.value);
                      //   sc.selectedRoomTypeID.value = sc.roomTypeList.first.data.roomTypes[index].id;

                      //   if (kDebugMode) {
                      //     print('SELECTED ROOM TYPE ID: ${sc.selectedRoomTypeID.value}');
                      //   }
                      //   hc.menuIndex.value++;
                      // }
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

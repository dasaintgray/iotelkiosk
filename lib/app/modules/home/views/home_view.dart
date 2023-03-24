// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/henryclock_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  // final DateTime dtLocalTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return GestureDetector(
          onTap: () {
            hc.resetTimer();
            hc.initTimezone();
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
                top: orientation == Orientation.portrait ? 25.h : 5.h,
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
                        height: orientation == Orientation.portrait ? 15.h : 1.h,
                        width: double.infinity,
                        // child: menuTitle(hc.tlSLList),
                      ),
                      menuTitle(),
                      Obx(
                        () => IndexedStack(
                          index: hc.menuIndex.value,
                          children: [
                            // 0
                            menuLanguage(orientation),
                            // 1
                            menuTransactionTitle(orientation,
                                languageID: hc.selecttedLanguageID.value, code: 'SCIP', type: 'ITEM'),
                            // 2
                            menuCheckIn(orientation,
                                languageID: hc.selecttedLanguageID.value, code: 'SBP', type: 'ITEM'),
                            // 3
                            menuBookingProcess(orientation,
                                languageID: hc.selecttedLanguageID.value, code: 'PIBN', type: 'BUTTON'),
                            // 4
                            menuInputBookingNumber(orientation,
                                languageID: hc.selecttedLanguageID.value, code: '', type: ''),
                            // 5
                            menuSelectArrivalTime(orientation,
                                languageID: hc.selecttedLanguageID.value, code: '', type: ''),
                          ],
                        ),
                      ),
                      Obx(
                        () => Visibility(
                          visible: hc.menuIndex.value != 0,
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // var response = hc.getMenu(languageID: 0, code: 'SLMT', type: 'TITLE');
                                    // if (response) {
                                    hc.menuIndex.value = 0;
                                    // }
                                    // Get.back();
                                  },
                                  child: Image.asset(
                                    'assets/menus/back-arrow.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // hc.getMenu(languageID: 0, code: 'SLMT', type: 'TITLE');
                                    // Get.back();
                                  },
                                  child: Image.asset(
                                    'assets/menus/forward-arrow.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  Widget menuLanguage(Orientation orientation) {
    return Obx(
      () => SizedBox(
        height: orientation == Orientation.portrait ? 45.h : 25.h,
        width: 70.w,
        child: ListView.builder(
          padding: const EdgeInsets.all(25.0),
          itemCount: hc.languageList.first.data.languages.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10.h,
              child: Stack(
                children: [
                  Positioned(
                    left: 28.w,
                    top: 25,
                    // right: 10.w,
                    child: SizedBox(
                      child: Text(
                        hc.languageList.first.data.languages[index].description,
                        style: TextStyle(
                          color: HenryColors.darkGreen,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8.w,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: () {
                        int lID = hc.languageList.first.data.languages[index].id;
                        String sCode = 'ST';
                        hc.selecttedLanguageID.value = hc.languageList.first.data.languages[index].id;
                        var response = hc.getMenu(languageID: lID, code: sCode, type: 'ITEM');
                        if (response) {
                          hc.menuIndex.value = 1;
                        }
                      },
                      child: SizedBox(
                        height: 7.h,
                        child: hc.languageList.isEmpty
                            ? null
                            : Image.asset(hc.languageList.first.data.languages[index].flag, fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget menuTransactionTitle(Orientation orientation, {int? languageID, String? code, String? type}) {
    return Obx(() => SizedBox(
          height: orientation == Orientation.portrait ? 45.h : 25.h,
          width: 70.w,
          child: ListView.builder(
            padding: const EdgeInsets.all(25.0),
            itemCount: hc.pageTrans.length,
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
                          hc.pageTrans[index].translationText,
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
                        onTap: () {
                          var response = hc.getMenu(languageID: languageID, code: code, type: type);
                          if (response) {
                            hc.menuIndex.value = 2;
                          }
                        },
                        child: SizedBox(
                          height: 7.h,
                          child: hc.languageList.isEmpty
                              ? null
                              : Image.asset(hc.pageTrans[index].images!, fit: BoxFit.contain),
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

  Widget menuCheckIn(Orientation orientation, {int? languageID, String? code, String? type}) {
    return Obx(
      () => SizedBox(
        height: orientation == Orientation.portrait ? 45.h : 25.h,
        width: 70.w,
        child: ListView.builder(
          padding: const EdgeInsets.all(25.0),
          itemCount: hc.pageTrans.length,
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
                        hc.pageTrans[index].translationText,
                        // textAlign: TextAlign.justify,
                        style: TextStyle(color: HenryColors.darkGreen, fontSize: 12.sp, overflow: TextOverflow.fade),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8.w,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: () {
                        var response = hc.getMenu(languageID: languageID, code: code, type: type);
                        if (response) {
                          switch (index) {
                            case 0:
                              hc.menuIndex.value = 3;
                              break;
                            case 1:
                              hc.getMenu(languageID: languageID, code: 'SAT');
                              hc.menuIndex.value = 5;
                              break;
                          }
                          // hc.menuIndex.value = 3;
                        }
                      },
                      child: SizedBox(
                        height: 7.h,
                        child: hc.languageList.isEmpty
                            ? null
                            : Image.asset(hc.pageTrans[index].images!, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget menuBookingProcess(Orientation orientation, {int? languageID, String? code, String? type}) {
    return Obx(
      () => SizedBox(
        height: orientation == Orientation.portrait ? 45.h : 25.h,
        width: 70.w,
        child: ListView.builder(
          padding: const EdgeInsets.all(25.0),
          itemCount: hc.pageTrans.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10.h,
              child: Stack(
                children: [
                  Positioned(
                    left: 23.w,
                    top: 35,
                    right: 10.w,
                    child: SizedBox(
                      width: 10.w,
                      child: languageID == 1 && index == 0
                          ? Text(
                              hc.pageTrans[index].translationText,
                              // textAlign: TextAlign,
                              style:
                                  TextStyle(color: HenryColors.darkGreen, fontSize: 8.sp, overflow: TextOverflow.fade),
                            )
                          : Text(
                              hc.pageTrans[index].translationText,
                              // textAlign: TextAlign,
                              style:
                                  TextStyle(color: HenryColors.darkGreen, fontSize: 12.sp, overflow: TextOverflow.fade),
                            ),
                    ),
                  ),
                  Positioned(
                    left: 8.w,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: () {
                        var response = hc.getMenu(languageID: languageID, code: code, type: type);
                        if (response) {
                          hc.menuIndex.value = 4;
                        }
                      },
                      child: SizedBox(
                        height: 7.h,
                        child: hc.pageTrans[index].images!.isEmpty
                            ? null
                            : Image.asset(hc.pageTrans[index].images!, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget menuInputBookingNumber(Orientation orientation, {int? languageID, String? code, String? type}) {
    return Obx(
      () => SizedBox(
        height: orientation == Orientation.portrait ? 45.h : 25.h,
        width: 70.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 3.h,
            ),
            SizedBox(
              height: 5.h,
              child: TextFormField(
                controller: hc.textEditingController,
                style: TextStyle(color: HenryColors.puti, fontSize: 15.sp),
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.book_online,
                      size: 15.sp,
                      color: HenryColors.puti,
                    ),
                    enabledBorder: const OutlineInputBorder(),
                    border: const OutlineInputBorder()),
              ),
            ),

            SizedBox(
              height: 20.h,
              child: VirtualKeyboard(
                height: 20.h,
                width: 75.w,
                fontSize: 15.sp,
                textColor: HenryColors.puti,
                textController: hc.textEditingController,
                type: VirtualKeyboardType.Alphanumeric,
                // customLayoutKeys: VirtualKeyboardLayoutKeys(),
                alwaysCaps: true,
              ),
            ),
            // BUTTON
            SizedBox(
              height: 8.h,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.all(25.0),
                itemCount: hc.pageTrans.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      SizedBox(
                        // width: 10.w,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HenryColors.darkGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shadowColor: Colors.black26.withOpacity(0.5),
                          ),
                          child: Text(
                            hc.pageTrans[index].translationText,
                            style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MENU SELECT ARRIVAL TIME
  Widget menuSelectArrivalTime(Orientation orientation, {int? languageID, String? code, String? type}) {
    return SizedBox(
      height: orientation == Orientation.portrait ? 45.h : 25.h,
      width: 70.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 25.h,
            child: TimePickerDialog(
              initialTime: TimeOfDay(
                  hour: int.parse(DateFormat('HH').format(hc.localTime)),
                  minute: int.parse(DateFormat('mm').format(hc.localTime))),
            ),
          ),
          // SizedBox(
          //   height: 15.h,
          //   child: FormBuilderDateTimePicker(
          //     name: 'sat',
          //     // initialEntryMode: DatePickerEntryMode.calendar,
          //     timePickerInitialEntryMode: TimePickerEntryMode.dial,
          //     // initialValue: DateTime.now(),
          //     inputType: InputType.time,
          //     textAlign: TextAlign.center,

          //     decoration: InputDecoration(
          //       // labelText: 'ARRIVAL TIME',
          //       // labelStyle: TextStyle(color: HenryColors.darkGreen, fontSize: 10.sp),

          //       suffixIcon: IconButton(
          //         icon: const Icon(Icons.close),
          //         onPressed: () {},
          //       ),
          //     ),
          //     initialTime: TimeOfDay(
          //         hour: int.parse(DateFormat('HH').format(hc.localTime)),
          //         minute: int.parse(DateFormat('mm').format(hc.localTime))),
          //     style: TextStyle(color: HenryColors.puti, fontSize: 15.sp),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget clockAndWeather() {
    return SizedBox(
      height: 23.h,
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
                          style: TextStyle(color: HenryColors.puti, fontSize: 4.sp),
                        ),
                        Text(
                          DateFormat("MMMM, dd, y").format(hc.localTime),
                          style: TextStyle(color: HenryColors.puti, fontSize: 4.sp),
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
                            textScaleFactor: 1,
                            digitalClockTextColor: HenryColors.darkGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 65.w,
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  style: TextStyle(color: HenryColors.puti, fontSize: 5.sp),
                                ),
                                Text(
                                  '${sc.weatherList.first.current.tempF.toStringAsFixed(0)}° F',
                                  style: TextStyle(color: HenryColors.puti, fontSize: 5.sp),
                                ),
                                Text(sc.weatherList.first.current.condition.text,
                                    style: TextStyle(color: HenryColors.puti, fontSize: 3.sp)),
                              ],
                            ),
                          ],
                        ),
                        const Divider(
                          color: HenryColors.puti,
                          thickness: 3,
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
                locationOfTime: 'Seoul',
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
          itemCount: hc.titleTrans.length,
          itemBuilder: (BuildContext context, int ctr, int realIndex) {
            return SizedBox(
              height: 10.h,
              width: double.infinity,
              child: Center(
                child: Text(
                    hc.titleTrans.length == 1 ? hc.titleTrans[0].translationText : hc.titleTrans[ctr].translationText,
                    style: TextStyle(color: HenryColors.darkGreen, fontSize: 13.sp)),
              ),
            );
          },
          options:
              CarouselOptions(autoPlay: hc.titleTrans.length == 1 ? false : true, showIndicator: false, reverse: true),
        ),
      ),
    );
  }
}

// class SkewCut extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(size.width, 0);
//     // path.addRRect(RRect.fromLTRBR(10, 5, 5, 10, 10.2 as Radius));

//     path.lineTo(size.width - 20, size.height);
//     path.lineTo(0, size.height);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(SkewCut oldClipper) => false;
// }

// ignore_for_file: depend_on_referenced_packages

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iotelkiosk/app/modules/home/views/accommodation_view.dart';
import 'package:iotelkiosk/app/modules/home/views/underdev_view.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/carousel_title_widget.dart';
import 'package:iotelkiosk/globals/widgets/henryclock_widget.dart';
import 'package:iotelkiosk/globals/widgets/weather_clock_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import 'package:camera_platform_interface/camera_platform_interface.dart';

import '../controllers/home_controller.dart';

class TransactionView extends GetView<HomeController> {
  TransactionView({Key? key}) : super(key: key);

  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  // final DateTime dtLocalTime = DateTime.now();
  final imgKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
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
                      // clockAndWeather(),
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

                      // menuTitle(),
                      SizedBox(
                        height: 5.h,
                        width: double.infinity,
                        child: CarouselTitle(
                          titleTrans: sc.titleTrans,
                          textStyle: TextStyle(color: HenryColors.darkGreen, fontSize: 15.sp),
                        ),
                      ),

                      menuTransactionTitle(orientation, languageID: sc.selecttedLanguageID.value),

                      SizedBox(
                        height: orientation == Orientation.portrait ? 10.h : 2.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                sc.getMenu(code: 'SLMT', type: 'TITLE');
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget menuLanguage(Orientation orientation) {
    return SizedBox(
      height: orientation == Orientation.portrait ? 45.h : 20.h,
      width: 75.w,
      child: ListView.builder(
        padding: const EdgeInsets.all(25.0),
        itemCount: sc.languageList.first.data.languages.length,
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
                    child: Animate(
                      child: Text(
                        sc.languageList.first.data.languages[index].description,
                        style: TextStyle(
                          color: HenryColors.darkGreen,
                          fontSize: 15.sp,
                        ),
                      )
                          .animate()
                          .slide(duration: HenryGlobal.animationSpeed)
                          .scale(duration: HenryGlobal.animationSpeed),
                    ),
                  ),
                ),
                Positioned(
                  left: 8.w,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: () {
                      int lID = sc.languageList.first.data.languages[index].id;
                      String sCode = 'ST';
                      sc.selecttedLanguageID.value = sc.languageList.first.data.languages[index].id;
                      sc.selectedLanguageCode.value = sc.languageList.first.data.languages[index].code;

                      var response =
                          sc.getMenu(languageID: lID, code: sCode, type: 'ITEM', indexCode: hc.menuIndex.value);
                      if (response) {
                        // hc.menuIndex.value = 1;
                        hc.menuIndex.value++;
                        // debugPrint('CURRENT INDEX ${hc.menuIndex.value}');
                      }
                    },
                    child: SizedBox(
                      height: 7.h,
                      child: sc.languageList.isEmpty
                          ? null
                          : Image.asset(sc.languageList.first.data.languages[index].flag!, fit: BoxFit.fill)
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

  Widget menuTransactionTitle(Orientation orientation, {int? languageID, String? code, String? type}) {
    return SizedBox(
      height: orientation == Orientation.portrait ? 45.h : 20.h,
      width: 75.w,
      child: ListView.builder(
        padding: const EdgeInsets.all(25.0),
        itemCount: sc.pageTrans.length,
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
                            sc.pageTrans[index].translationText,
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
                      switch (index) {
                        case 0: //CHECK IN
                          {
                            // sc.isLoading.value = true;
                            // var response = await sc.getRoomType(
                            //     credentialHeaders: hc.globalHeaders, languageCode: sc.selectedLanguageCode.value);
                            // if (response) {
                            //   sc.getMenu(languageID: sc.selecttedLanguageID.value, code: 'SRT');
                            //   sc.isLoading.value = false;
                            //   sc.selectedTransactionType.value = sc.pageTrans[index].translationText;
                            //   if (kDebugMode) {
                            //     print('SELECTED TRANSACTION: ${sc.selectedTransactionType.value}');
                            //   }
                            // }
                            // Get.to(() => RoomTypeView());
                            sc.isLoading.value = true;
                            var response = await sc.getAccommodation(
                                credentialHeaders: hc.globalHeaders, languageCode: sc.selectedLanguageCode.value);
                            if (response) {
                              if (kDebugMode) print('SELECTED ROOM TYPE ID: ${sc.selectedRoomTypeID.value}');
                              // sc.selectedRoomType.value = sc.roomTypeList.first.data.roomTypes[index].code;
                              sc.getMenu(languageID: sc.selecttedLanguageID.value, code: 'SACT', type: 'TITLE');
                              Get.to(() => AccommodationView());
                            }
                          }
                          break;
                        case 1: //CHECK OUT
                          {}
                          break;
                        default:
                          {
                            Get.to(() => UnderdevView());
                          }
                      }
                    },
                    child: SizedBox(
                      height: 7.h,
                      child: sc.pageTrans.isEmpty
                          ? null
                          : Image.asset(
                              sc.pageTrans[index].images!,
                              fit: BoxFit.contain,
                            )
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

  Widget menuCheckIn(Orientation orientation, {int? languageID, String? code, String? type}) {
    return Obx(
      () => SizedBox(
        height: orientation == Orientation.portrait ? 45.h : 25.h,
        width: 70.w,
        child: ListView.builder(
          padding: const EdgeInsets.all(25.0),
          itemCount: sc.pageTrans.length,
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
                        sc.pageTrans[index].translationText,
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
                        var response =
                            sc.getMenu(languageID: languageID, code: code, type: type, indexCode: hc.menuIndex.value);
                        if (response) {
                          switch (index) {
                            case 0:
                              hc.menuIndex.value = 3;
                              break;
                            case 1:
                              sc.getMenu(languageID: languageID, code: 'SAT', indexCode: hc.menuIndex.value);
                              hc.menuIndex.value = 5;
                              break;
                          }
                          // hc.menuIndex.value = 3;
                        }
                      },
                      child: SizedBox(
                        height: 7.h,
                        child: sc.languageList.isEmpty
                            ? null
                            : Image.asset(sc.pageTrans[index].images!, fit: BoxFit.contain),
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
        height: orientation == Orientation.portrait ? 45.h : 20.h,
        width: 70.w,
        child: ListView.builder(
          padding: const EdgeInsets.all(25.0),
          itemCount: sc.pageTrans.length,
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
                              sc.pageTrans[index].translationText,
                              // textAlign: TextAlign,
                              style:
                                  TextStyle(color: HenryColors.darkGreen, fontSize: 8.sp, overflow: TextOverflow.fade),
                            )
                          : Text(
                              sc.pageTrans[index].translationText,
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
                        var response =
                            sc.getMenu(languageID: languageID, code: code, type: type, indexCode: hc.menuIndex.value);
                        if (response) {
                          hc.menuIndex.value = 4;
                        }
                      },
                      child: SizedBox(
                        height: 7.h,
                        child: sc.pageTrans[index].images!.isEmpty
                            ? null
                            : Image.asset(sc.pageTrans[index].images!, fit: BoxFit.contain),
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
        height: orientation == Orientation.portrait ? 45.h : 20.h,
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
                itemCount: sc.pageTrans.length,
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
                            sc.pageTrans[index].translationText,
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

  // MENU SELECT ARRIVAL TIME
  Widget menuSelectArrivalTime(Orientation orientation, {int? languageID, String? code, String? type}) {
    return SizedBox(
      height: orientation == Orientation.portrait ? 45.h : 20.h,
      width: 70.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: orientation == Orientation.portrait ? 25.h : 20.h,
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

  Widget menuAccommodationType(Orientation orientation, {int? languageID, String? code, String? type}) {
    final langCode = sc.languageList.first.data.languages.where((element) => element.id == languageID);

    bool isTranslate = langCode.first.code.toLowerCase() != sc.defaultLanguageCode.value.toLowerCase();
    if (kDebugMode) {
      print('is translated: $isTranslate');
    }
    // sc.isLoading.value = true;

    return SizedBox(
      height: orientation == Orientation.portrait ? 49.h : 20.h,
      width: 75.w,
      child: ListView.builder(
        padding: const EdgeInsets.all(25.0),
        itemCount: sc.accommodationTypeList.first.data.accommodationTypes.length,
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
                    child: Text(
                      isTranslate
                          ? sc.accommodationTypeList.first.data.accommodationTypes[index].description
                          : sc.accommodationTypeList.first.data.accommodationTypes[index].translatedText == null
                              ? sc.accommodationTypeList.first.data.accommodationTypes[index].description
                              : sc.accommodationTypeList.first.data.accommodationTypes[index].translatedText!,
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
                      sc.selectedAccommodationTypeID.value =
                          sc.accommodationTypeList.first.data.accommodationTypes[index].id;

                      if (kDebugMode) {
                        print('SELECTED ACCOMMODATION TYPE ID: ${sc.selectedAccommodationTypeID.value}');
                      }
                      var response = sc.getMenu(languageID: languageID, code: 'SPM');
                      if (response) {
                        // hc.initializeCamera();
                        // hc.menuIndex.value = 4; //payment type
                      }
                      hc.menuIndex.value++;
                    },
                    child: SizedBox(
                      height: 7.h,
                      child: sc.accommodationTypeList.first.data.accommodationTypes.isNotEmpty
                          ? Image.asset(
                                  'assets/menus/hour${sc.accommodationTypeList.first.data.accommodationTypes[index].seq}.png',
                                  fit: BoxFit.contain)
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
    );
  }

  Widget menuPaymentType(Orientation orientation, {int? languageID, String? code, String? type}) {
    return SizedBox(
      height: orientation == Orientation.portrait ? 49.h : 20.h,
      width: 75.w,
      child: ListView.builder(
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
                      child: Text(
                        sc.paymentTypeList.first.data.paymentTypes[index].description.toUpperCase(),
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
                      // query the get available Rooms
                      final accessToken = sc.userLoginList.first.accessToken;
                      final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'};

                      await sc.getAvailableRoomsGraphQL(
                          credentialHeaders: headers,
                          roomTYPEID: sc.selectedRoomTypeID.value,
                          accommodationTYPEID: sc.selectedAccommodationTypeID.value);

                      sc.getMenu(languageID: languageID, code: 'IP', type: 'TITLE');

                      // DIRECT TO MENU INDEX 5 - PAYMENT TYPE, BASE ON THE SELECRED ROOM AND ACCOMMODATION
                      // hc.menuIndex.value = 5;
                      hc.menuIndex.value++;

                      // var response = sc.getMenu(languageID: languageID, code: 'DI', type: 'ITEM');
                      // if (response) {
                      //   hc.menuIndex.value = 5;
                      // }
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
    );
  }

  // INSERT PAYMENT
  Widget menuInsertPayment(Orientation orientation) {
    return SizedBox(
      height: orientation == Orientation.portrait ? 49.h : 20.h,
      width: 75.w,
      child: Container(
        margin: const EdgeInsets.all(20.0),
        height: 20.h,
        width: 20.w,
        decoration: const BoxDecoration(
            color: Colors.black54,
            gradient: LinearGradient(
                colors: [Colors.black, HenryColors.grey],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.decal),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(100.0),
              bottomRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(100.0),
            ),
            boxShadow: [BoxShadow(color: Colors.black54, offset: Offset(15, 15), blurRadius: 10)]),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'CASH',
                    style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                  ),
                ),
              ),
              const Divider(
                color: HenryColors.puti,
                thickness: 2,
              ),
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2.h,
                      width: double.infinity,
                    ),
                    Text(
                      'CARD DEPOSIT : PHP ${sc.availRoomList[sc.preSelectedRoomID.value].serviceCharge.toStringAsFixed(2)}',
                      style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                    ),
                    Text(
                      'ROOM RATE : PHP ${sc.availRoomList[sc.preSelectedRoomID.value].rate.toStringAsFixed(2)}',
                      style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                    ),
                    Text(
                      'AMOUNT DUE : PHP ${sc.totalAmountDue.toStringAsFixed(2)}',
                      style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                    ),
                    SizedBox(
                      height: 2.h,
                      width: double.infinity,
                    ),
                    Container(
                      height: 13.h,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: HenryColors.darkGreen,
                        gradient: LinearGradient(
                            colors: [HenryColors.darkGreen, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            tileMode: TileMode.clamp),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'AMOUNT RECEIVED:',
                              style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: MaterialButton(
                    onPressed: () async {
                      hc.menuIndex.value = 6;
                    },
                    color: HenryColors.darkGreen,
                    padding: const EdgeInsets.all(30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                    // AGREE BUTTON
                    child: Text(
                      '   Confirm   ',
                      style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget menuDisclaimer(Orientation orientation, BuildContext context) {
    return SizedBox(
      height: orientation == Orientation.portrait ? 49.h : 20.h,
      width: 75.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: false,
            child: SizedBox(
              height: 20.h,
              width: 60.w,
              child: Transform(
                key: imgKey,
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: CameraPlatform.instance.buildPreview(hc.cameraID.value),
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
            width: double.infinity,
          ),
          // DISCLAIMER
          sc.translationTermsList.first.data.translationTerms.isNotEmpty
              ? SizedBox(
                  height: 40.h,
                  child: SingleChildScrollView(
                    controller: sc.scrollController,
                    child: Text(
                      sc.translationTermsList.first.data.translationTerms.first.translationText,
                      style: TextStyle(
                        color: HenryColors.puti,
                        fontSize: 5.sp,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          SizedBox(
            height: 2.h,
            width: double.infinity,
          ),
          sc.translationTermsList.first.data.translationTerms.isNotEmpty
              ? SizedBox(
                  child: hc.isLoading.value
                      ? Column(
                          children: [
                            const CircularProgressIndicator.adaptive(
                              backgroundColor: HenryColors.puti,
                            ),
                            Text(
                              'Processing, please wait',
                              style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                            )
                          ],
                        )
                      : Visibility(
                          visible: sc.isBottom.value,
                          child: MaterialButton(
                            onPressed: () async {
                              hc.isLoading.value = true;
                              // var output = hc.findVideoPlayer(pamagat: 'iOtel Kiosk Application');
                              final handle = imgKey.currentContext?.findAncestorWidgetOfExactType<SizedBox>().hashCode;
                              if (kDebugMode) {
                                print('Picture Handle: $handle');
                              }
                              final accessToken = sc.userLoginList.first.accessToken;
                              final headers = {
                                'Content-Type': 'application/json',
                                'Authorization': 'Bearer $accessToken'
                              };

                              var response = await sc.addTransaction(credentialHeaders: headers);
                              if (response) {
                                //
                                hc.isLoading.value = false;
                              }
                            },
                            color: HenryColors.darkGreen,
                            padding: const EdgeInsets.all(30),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                            // AGREE BUTTON
                            child: Text(
                              'Agree',
                              style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                            ),
                          ),
                        ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget menuGuestInformation(Orientation orientation, {int? languageID, String? code, String? type}) {
    // final GlobalKey<FormState> formKey = GlobalKey<FormState>;
    return Obx(
      () => SizedBox(
        height: orientation == Orientation.portrait ? 45.h : 20.h,
        width: 70.w,
        child: ListView.builder(
          padding: const EdgeInsets.all(25.0),
          itemCount: sc.pageTrans.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 2.h,
              child: Form(
                // key: formKey,
                child: Text(
                  sc.pageTrans[index].translationText,
                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                ),
              ),
            );
          },
        ),
      ),
    );
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
}

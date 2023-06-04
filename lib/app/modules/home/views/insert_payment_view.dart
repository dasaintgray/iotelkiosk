import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/carousel_title_widget.dart';
import 'package:iotelkiosk/globals/widgets/weather_clock_widget.dart';
import 'package:sizer/sizer.dart';

class InsertPaymentView extends GetView {
  InsertPaymentView({Key? key}) : super(key: key);

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
                    // menuRoomType(orientation, languageID: sc.selecttedLanguageID.value),

                    menuInsertPayment(orientation, languageID: sc.selecttedLanguageID.value),

                    SizedBox(
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
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget menuInsertPayment(Orientation orientation, {required int? languageID}) {
    final langCode = sc.languageList.first.data.languages.where((element) => element.id == languageID);

    final selectedPaymentType =
        sc.paymentTypeList.first.data.paymentTypes.where((element) => element.code == sc.selectedPaymentTypeCode.value);

    if (kDebugMode) {
      print('${selectedPaymentType.first.description} : ${selectedPaymentType.first.translatedText}');
      print('${langCode.first.code} : ${langCode.first.description}');
    }

    String denomination = 'PHP';
    String cardDeposit = 'Card Deposit';
    String roomRate = 'Room Rate';
    String amountDue = 'Amount Dude';
    String amountReceived = 'Amount Received';

    if (langCode.first.code.toLowerCase() != sc.defaultLanguageCode.value.toLowerCase()) {
      cardDeposit = sc.translateText(
          sourceText: cardDeposit,
          fromLang: sc.defaultLanguageCode.value.toLowerCase(),
          toLang: langCode.first.code.toLowerCase());
    }

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
                    langCode.first.code.toLowerCase() == sc.defaultLanguageCode.value.toLowerCase()
                        ? selectedPaymentType.first.description.toUpperCase()
                        : selectedPaymentType.first.translatedText!,
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
                      '$cardDeposit : $denomination ${sc.availRoomList[sc.preSelectedRoomID.value].serviceCharge.toStringAsFixed(2)}',
                      style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                    ),
                    Text(
                      '$roomRate : $denomination ${sc.availRoomList[sc.preSelectedRoomID.value].rate.toStringAsFixed(2)}',
                      style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                    ),
                    Text(
                      '$amountDue : $denomination ${sc.totalAmountDue.toStringAsFixed(2)}',
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
                              amountReceived,
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
}
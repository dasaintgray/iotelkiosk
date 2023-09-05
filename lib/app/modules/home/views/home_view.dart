// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/views/transaction_view.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:sizer/sizer.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  // final hc = Get.find<HomeController>();
  final hc = Get.put(HomeController());
  final sc = Get.find<ScreenController>();

  // final DateTime dtLocalTime = DateTime.now();
  // final imgKey = GlobalKey();

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
                children: [
                  Obx(() => KioskHeader(
                        isLive: hc.clockLiveUpdate.value,
                      )),
                  // SPACE
                  SizedBox(
                    height: 12.h,
                  ),
                  // TITLE
                  KioskMenuTitle(titleLength: sc.titleTrans.length, titleTrans: sc.titleTrans),
                  // SPACE
                  SizedBox(
                    height: 2.h,
                  ),
                  // MENU
                  menuLanguage(orientation),
                  // menuLanguage2(orientation),
                ],
              ),
            ),
          ],
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
                      child: Center(
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

                      var response = sc.getMenu(
                        languageID: lID,
                        code: sCode,
                      );
                      if (response) {
                        // hc.menuIndex.value = 1;
                        // hc.menuIndex.value++;
                        if (kDebugMode) print('SELECTED LANGUAGE CODE ${sc.selectedLanguageCode.value}');
                        hc.update();
                        Get.to(
                          () => TransactionView(),
                        );
                        hc.update();
                        // debugPrint('CURRENT INDEX ${hc.menuIndex.value}');
                      }
                    },
                    child: SizedBox(
                      height: 7.h,
                      child: sc.languageList.isEmpty
                          ? null
                          : Image.asset(
                              'assets/png/${sc.languageList.first.data.languages[index].flag!}',
                              fit: BoxFit.fill,
                              semanticLabel: 'Select Language',
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

  Widget menuLanguage2(Orientation orientation) {
    return SizedBox(
      height: orientation == Orientation.portrait ? 45.h : 20.h,
      width: 75.w,
      child: ListView.builder(
        padding: const EdgeInsets.all(25),
        itemCount: sc.languageList.first.data.languages.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            child: GestureDetector(
              onTap: () {
                int lID = sc.languageList.first.data.languages[index].id;
                String sCode = 'ST';
                sc.selecttedLanguageID.value = sc.languageList.first.data.languages[index].id;
                sc.selectedLanguageCode.value = sc.languageList.first.data.languages[index].code;

                var response = sc.getMenu(
                  languageID: lID,
                  code: sCode,
                );
                if (response) {
                  if (kDebugMode) print('SELECTED LANGUAGE CODE ${sc.selectedLanguageCode.value}');
                  hc.update();
                  Get.to(
                    () => TransactionView(),
                  );
                  hc.update();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child: SizedBox(
                  height: 7.h,
                  child: sc.languageList.isEmpty
                      ? null
                      : Image.asset(
                          'assets/png/${sc.languageList.first.data.languages[index].flag!}',
                          fit: BoxFit.fill,
                          semanticLabel: 'Select Language',
                        )
                          .animate()
                          .fade(duration: HenryGlobal.animationSpeed)
                          .scale(duration: HenryGlobal.animationSpeed),
                ),
              ),
            ),
          );
          // return SizedBox(
          //   child: Animate(
          //     child: Center(
          //       child: Text(
          //         sc.languageList.first.data.languages[index].description,
          //         style: TextStyle(
          //           color: HenryColors.darkGreen,
          //           fontSize: 15.sp,
          //         ),
          //       ).animate().slide(duration: HenryGlobal.animationSpeed).scale(duration: HenryGlobal.animationSpeed),
          //     ),
          //   ),
          // );
        },
      ),
    );
  }
}

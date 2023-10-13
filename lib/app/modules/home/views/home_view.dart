// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/views/transaction_view.dart';
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

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return Stack(
          children: [
            const KioskBackgroundImage(),
            orientation == Orientation.portrait
                ? CompanyLogo(top: 15.h, bottom: 65.h, left: 35.w, right: 35.w)
                : CompanyLogo(top: 5.h, bottom: 46.h, left: 45.w, right: 45.w),
            // KioskHeader(),
            Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() => KioskHeader(
                        isLive: hc.clockLiveUpdate.value,
                      )),
                  // SPACE
                  SizedBox(
                    height: orientation == Orientation.portrait ? 10.h : 1.h,
                  ),
                  // TITLE
                  KioskMenuTitle(
                    titleTrans: hc.titleTrans,
                    fontSize: orientation == Orientation.portrait ? 12.sp : 10.sp,
                    heights: orientation == Orientation.portrait ? 7.h : 2.h,
                  ),
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
      height: orientation == Orientation.portrait ? 40.h : 20.h,
      width: orientation == Orientation.portrait ? 70.w : 55.w,
      child: ListView.builder(
        padding: const EdgeInsets.all(25.0),
        itemCount: hc.languageList.first.data.languages.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: orientation == Orientation.portrait ? 10.h : 8.h,
            child: Animate(
              child: Stack(
                children: [
                  Positioned(
                    left: orientation == Orientation.portrait ? 27.w : 22.w,
                    top: orientation == Orientation.portrait ? 20 : 30,
                    child: Center(
                      child: Text(
                        hc.languageList.first.data.languages[index].description,
                        style: TextStyle(
                            color: HenryColors.darkGreen,
                            fontSize: orientation == Orientation.portrait ? 18.sp : 14.sp),
                      ),
                    ),
                  ),
                  Positioned(
                    left: orientation == Orientation.portrait ? 8.w : 1.w,
                    right: orientation == Orientation.portrait ? 8.w : 1.w,
                    child: GestureDetector(
                      onTap: () {
                        int lID = hc.languageList.first.data.languages[index].id;
                        String sCode = 'ST';
                        hc.selecttedLanguageID.value = hc.languageList.first.data.languages[index].id;
                        hc.selectedLanguageCode.value = hc.languageList.first.data.languages[index].code;

                        var response = hc.getMenu(languageID: lID, code: sCode, type: 'TITLE');
                        if (response) {
                          if (kDebugMode) print('SELECTED LANGUAGE CODE: ${hc.selectedLanguageCode.value}');
                          hc.update();
                          Get.to(
                            () => TransactionView(),
                          );
                        }
                      },
                      child: SizedBox(
                        height: orientation == Orientation.portrait ? 7.h : 7.h,
                        width: orientation == Orientation.portrait ? 10.w : 10.w,
                        child: Image.asset(
                          'assets/png/${hc.languageList.first.data.languages[index].flag!}',
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
            ),
          );
        },
      ),
    );
  }

  Widget menuLanguage2(Orientation orientation) {
    return SizedBox(
      height: orientation == Orientation.portrait ? 45.h : 10.h,
      width: 75.w,
      child: ListView.builder(
        padding: const EdgeInsets.all(25),
        itemCount: hc.languageList.first.data.languages.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            child: GestureDetector(
              onTap: () {
                int lID = hc.languageList.first.data.languages[index].id;
                String sCode = 'ST';
                hc.selecttedLanguageID.value = hc.languageList.first.data.languages[index].id;
                hc.selectedLanguageCode.value = hc.languageList.first.data.languages[index].code;

                var response = hc.getMenu(
                  languageID: lID,
                  code: sCode,
                );
                if (response) {
                  if (kDebugMode) print('SELECTED LANGUAGE CODE ${hc.selectedLanguageCode.value}');
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
                  child: hc.languageList.isEmpty
                      ? null
                      : Image.asset(
                          'assets/png/${hc.languageList.first.data.languages[index].flag!}',
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

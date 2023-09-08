import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:sizer/sizer.dart';

// ignore_for_file: depend_on_referenced_packages
import 'package:camera_platform_interface/camera_platform_interface.dart';

class DisclaimerView extends GetView {
  DisclaimerView({Key? key}) : super(key: key);

  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (BuildContext context, orientation, deviceType) {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => KioskHeader(
                    isLive: hc.clockLiveUpdate.value,
                  ),
                ),
                // SPACE
                SizedBox(
                  height: 10.h,
                ),
                // TITLE
                KioskMenuTitle(titleLength: sc.titleTrans.length, titleTrans: sc.titleTrans),
                // SPACE
                SizedBox(
                  height: 2.h,
                ),
                // MENU
                // menuAccommodationType(orientation, languageID: sc.selecttedLanguageID.value),
                menuDisclaimer(orientation, context),

                Visibility(
                  visible: false,
                  child: SizedBox(
                    height: orientation == Orientation.portrait ? 8.h : 2.h,
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
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget menuDisclaimer(Orientation orientation, BuildContext context) {
    final imgKey = GlobalKey();
    return SizedBox(
      height: orientation == Orientation.portrait ? 45.h : 20.h,
      width: 75.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => Visibility(
              visible: true,
              child: SizedBox(
                height: 15.h,
                width: 60.w,
                child: Transform(
                  key: imgKey,
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: CameraPlatform.instance.buildPreview(hc.cameraID.value),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
            width: double.infinity,
          ),
          // DISCLAIMER
          sc.languageList.first.data.languages.isNotEmpty
              ? SizedBox(
                  height: 20.h,
                  child: SingleChildScrollView(
                    controller: sc.scrollController,
                    child: Text(
                      sc.languageList.first.data.languages.first.disclaimer,
                      style: TextStyle(
                        color: HenryColors.puti,
                        fontSize: 3.sp,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          SizedBox(
            height: 1.h,
            width: double.infinity,
          ),
          sc.languageList.first.data.languages.isNotEmpty
              ? Obx(() => SizedBox(
                    child: hc.isLoading.value
                        ? Column(
                            children: [
                              const CircularProgressIndicator.adaptive(
                                backgroundColor: HenryColors.puti,
                              ),
                              Text(
                                'Processing, please wait',
                                style: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
                              )
                            ],
                          )
                        : Visibility(
                            visible: sc.isBottom.value,
                            child: MaterialButton(
                              onPressed: () async {
                                hc.isLoading.value = true;
                                // var output = hc.findVideoPlayer(pamagat: 'iOtel Kiosk Application');
                                final handle =
                                    imgKey.currentContext?.findAncestorWidgetOfExactType<SizedBox>().hashCode;
                                if (kDebugMode) {
                                  print('Picture Handle: $handle');
                                }
                                final accessToken = sc.userLoginList.first.accessToken;
                                final headers = {
                                  'Content-Type': 'application/json',
                                  'Authorization': 'Bearer $accessToken'
                                };

                                // String? basePhoto = await hc.takePicture(camID: hc.cameraID.value);

                                var response = await hc.addTransaction(credentialHeaders: headers);
                                if (response == "Success") {
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
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/printing_view.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:sizer/sizer.dart';

import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:lottie/lottie.dart';

// ignore_for_file: depend_on_referenced_packages
import 'package:camera_platform_interface/camera_platform_interface.dart';

class DisclaimerView extends GetView {
  DisclaimerView({Key? key}) : super(key: key);

  final hc = Get.find<HomeController>();
  // final sc = Get.find<ScreenController>();

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
                  height: orientation == Orientation.portrait ? 10.h : 2.h,
                ),
                // TITLE
                KioskMenuTitle(
                  titleLength: hc.titleTrans.length,
                  titleTrans: hc.titleTrans,
                  fontSize: orientation == Orientation.portrait ? 12.sp : 8.sp,
                  heights: orientation == Orientation.portrait ? 7.h : 2.h,
                ),
                // SPACE
                SizedBox(
                  height: 2.h,
                  child: Text(
                    'Please scroll up the disclaimer',
                    style: TextStyle(color: HenryColors.puti, fontSize: 3.sp),
                  ),
                ),
                // MENU
                // menuAccommodationType(orientation, languageID: sc.selecttedLanguageID.value),
                Expanded(child: menuDisclaimer(orientation, context)),
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
      height: orientation == Orientation.portrait ? 40.h : 20.h,
      width: 75.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: false,
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

          SizedBox(
            height: 2.h,
            width: double.infinity,
          ),
          // DISCLAIMER

          Expanded(
            flex: 8,
            child: Obx(
              () => SizedBox(
                height: 35.h,
                child: !hc.isDisclaimer.value
                    ? Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                            width: 28.w,
                            child: DotLottieLoader.fromAsset(
                              'assets/lottie/anim4.lottie',
                              frameBuilder: (ctx, lottie) {
                                if (lottie != null) {
                                  return Lottie.memory(
                                    lottie.animations.values.single,
                                    height: 30.h,
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  return SizedBox(
                                    height: 10.h,
                                    width: 18.w,
                                    child: const CircularProgressIndicator.adaptive(
                                      backgroundColor: HenryColors.puti,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                            width: double.infinity,
                          ),
                          Center(
                            child: Text(
                              hc.statusMessage.value,
                              style: TextStyle(color: HenryColors.puti, fontSize: 15.sp),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      )
                    : SizedBox(
                        height: 24.h,
                        child: SingleChildScrollView(
                          controller: hc.scrollController,
                          child: Text(
                            hc.languageList.first.data.languages.first.disclaimer,
                            style: TextStyle(
                              color: HenryColors.puti,
                              fontSize: 5.sp,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),

          SizedBox(
            height: 2.h,
            width: double.infinity,
          ),
          Obx(
            () => Visibility(
              visible: hc.isButtonActive.value,
              child: Expanded(
                flex: 1,
                child: SizedBox(
                  height: 2.h,
                  width: 30.w,
                  child: ElevatedButton(
                    onPressed: hc.isButtonActive.value
                        ? () async {
                            hc.isLoading.value = true;
                            hc.isButtonActive.value = false;
                            hc.isBottom.value = false;
                            hc.isDisclaimer.value = false;
                            // var output = hc.findVideoPlayer(pamagat: 'iOtel Kiosk Application');
                            // final handle = imgKey.currentContext?.findAncestorWidgetOfExactType<SizedBox>().hashCode;
                            // if (kDebugMode) print('Picture Handle: $handle');
                            // hc.getMenu(code: 'SLMT', type: 'TITLE');

                            // await hc.cashDispenserCommand(sCommand: 'CASH', iTerminalID: hc.defaultTerminalID.value);
                            // hc.statusMessage.value = 'Issuing Command to Cash Dispenser';
                            // print(dispenseResponse);

                            var response = await hc.addTransaction(credentialHeaders: hc.accessTOKEN);

                            if (response) {
                              hc.disposeCamera();
                              hc.isLoading.value = false;
                              // STOP THE DISPENSER CASH POLLING
                              // await hc.cashDispenserCommand(
                              //     sCommand: APIConstant.cashPoolingStop, iTerminalID: hc.defaultTerminalID.value);
                              // hc.isLoading.value = false;

                              Get.to(() => PrintingView());
                              // PRINTING OF CARDS AND DISPLAY INFO OF ROOMS
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HenryColors.darkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shadowColor: Colors.black26.withOpacity(0.5),
                    ),
                    // AGREE BUTTON
                    child: Text(
                      'Agree',
                      style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 1.h,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}

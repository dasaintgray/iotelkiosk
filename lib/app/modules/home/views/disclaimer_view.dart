import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/printing_view.dart';
import 'package:iotelkiosk/globals/constant/settings_constant.dart';
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
  DisclaimerView({Key? key, required this.isBookedRoom, this.sourceRoomNumber, this.sourceRoomRate}) : super(key: key);

  final hc = Get.find<HomeController>();
  final bool? isBookedRoom;
  final String? sourceRoomNumber;
  final double? sourceRoomRate;

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
                Obx(
                  () => Visibility(
                    visible: hc.isDisclaimer.value,
                    child: KioskMenuTitle(
                      titleTrans: hc.titleTrans,
                      fontSize: orientation == Orientation.portrait ? 12.sp : 8.sp,
                      heights: orientation == Orientation.portrait ? 7.h : 2.h,
                    ),
                  ),
                ),
                // SPACE
                Obx(
                  () => Visibility(
                    visible: hc.isDisclaimer.value,
                    child: SizedBox(
                      height: 2.h,
                      child: Text(
                        'Please scroll up the disclaimer',
                        style: TextStyle(color: HenryColors.puti, fontSize: 3.sp),
                      ),
                    ),
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
    // var scrollController = ScrollController();
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
                          controller: hc.disclaimerScroller,
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
                            hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'TD', type: 'TITLE');
                            // var response = await hc.addTransaction(credentialHeaders: hc.accessTOKEN);
                            var ledPORT = kDebugMode ? 'COM1' : 'COM8';

                            if (isBookedRoom!) {
                              hc.statusMessage.value = 'Initializing devices';
                              await hc.getAccommodation(
                                credentialHeaders: hc.accessTOKEN,
                                languageCode: hc.selectedLanguageCode.value,
                                recordValue: 8,
                              );

                              var durationValue = hc.accommodationTypeList.first.data.accommodationTypes.where(
                                  (element) =>
                                      element.description ==
                                      hc.guestInfoList.first.data.viewBookings.first.accommodationType);

                              final int hoursStay = durationValue.first.valueMax.toInt();

                              final moduleReponse = hc.settingsList.first.data.settings
                                  .where((element) => element.code == SettingConstant.bookingModuleID);
                              final assignBookingNumber = await hc.getSeriesDetails(
                                  credentialHeaders: hc.accessTOKEN, moduleID: int.parse(moduleReponse.first.value));

                              await hc.getRooms(roomName: hc.guestInfoList.first.data.viewBookings.first.room);

                              await hc.getCamera();

                              final postResponse = await hc.postTransaction(
                                ledPORT: ledPORT,
                                seriesControlNo: hc.seriesDetailsList.first.data.seriesDetails.first.docNo,
                                totalHoursStay: hoursStay,
                                assignBookingNumber: assignBookingNumber,
                                selectedRoomRate: sourceRoomRate,
                                assignBookingID: hc.generatedBookingID.value,
                                selectedAccommodationTypeID: durationValue.first.id,
                                agentID: hc.guestInfoList.first.data.viewBookings.first.agentId,
                                selectedCutOffID: hc.cutOffList.first.data.cutOffs.first.id,
                                selectedRoomTypeID: hc.guestInfoList.first.data.viewBookings.first.roomTypeID,
                                numberOfBED: hc.guestInfoList.first.data.viewBookings.first.bed,
                                numberOfPAX: 2,
                                roomID: hc.roomList.first.data.rooms.first.id,
                                discountAMOUNT: 0,
                                serviceCHARGE: 0,
                                depositAMOUNT: 100,
                                invoiceNO: '',
                                dVAT: 12,
                                cashPOSITIONID: 1,
                                iChargesID: 1,
                                iQTY: 1,
                                paymentTYPEID: 1,
                                terminalID: 1,
                                roomNO: hc.guestInfoList.first.data.viewBookings.first.room,
                                keycardNO: '',
                                contactID: hc.guestInfoList.first.data.viewBookings.first.contactId,
                              );
                              if (postResponse) {
                                // PRINT THE RECEIPT
                              }
                            } else {
                              var response =
                                  await hc.addTransaction(credentialHeaders: hc.accessTOKEN, ledCOMPORT: ledPORT);
                              if (response) {
                                hc.disposeCamera();
                                hc.isLoading.value = false;
                                Get.to(() => PrintingView());
                                // PRINTING OF CARDS AND DISPLAY INFO OF ROOMS
                              } else {
                                Get.defaultDialog(
                                  title: 'Error',
                                  titleStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
                                  titlePadding: const EdgeInsets.all(10),
                                  middleText: 'Error Adding Transaction',
                                  middleTextStyle: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                                  contentPadding: const EdgeInsets.all(20),
                                  backgroundColor: HenryColors.darkGreen,
                                );
                              }
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

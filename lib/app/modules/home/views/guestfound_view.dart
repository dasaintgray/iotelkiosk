import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/disclaimer_view.dart';
import 'package:iotelkiosk/app/modules/home/views/payment_method_view.dart';
import 'package:iotelkiosk/globals/constant/api_constant.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:translator/translator.dart';

class GuestfoundView extends GetView {
  GuestfoundView({super.key});

  final hc = Get.find<HomeController>();
  final translator = GoogleTranslator();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, orientation, deviceType) {
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
                  KioskHeader(
                    isLive: true,
                  ),
                  // SPACE
                  SizedBox(
                    height: orientation == Orientation.portrait ? 10.h : 2.h,
                  ),
                  // TITLE
                  KioskMenuTitle(
                    titleTrans: hc.titleTrans,
                    fontSize: orientation == Orientation.portrait ? 12.sp : 8.sp,
                    heights: orientation == Orientation.portrait ? 7.h : 2.h,
                  ),
                  // SPACE
                  // MENU
                  menuGuestInfo(orientation, context),
                  // SizedBox(
                  //   height: 45.h,
                  //   width: double.infinity,
                  //   child: hc.isLoading.value
                  //       ? const Center(
                  //           child: CircularProgressIndicator.adaptive(),
                  //         )
                  //       : menuGuestInfo(orientation, context),
                  // ),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 5.h : 1.h,
                  ),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 5.h : 2.h,
                    child: GestureDetector(
                      onTap: () {
                        hc.bkReferenceNo.clear();
                        hc.guestInfoList.clear();
                        hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'PIBN', type: 'TITLE');
                        Get.back();
                      },
                      child: Image.asset(
                        'assets/menus/back-arrow.png',
                        fit: BoxFit.cover,
                        semanticLabel: 'Back to previous menu',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget menuGuestInfo(orientation, BuildContext context) {
    final moneyFormatting = NumberFormat("#,##0.00", "en_PH");

    var nameText = 'Guest Name'.obs;
    var bookingSourceText = 'Agent Booking Source'.obs;
    var bookingNumberText = 'Agent Booking Number'.obs;
    var bookingStatusText = 'Booking Status'.obs;
    var roomTypeText = 'Room Type'.obs;
    var roomNumberText = 'Room Number'.obs;
    var roomRateText = 'Room Rate'.obs;
    var roomPaidText = 'Paid'.obs;
    var roomNotPaidText = 'Need To Pay'.obs;
    var paymentStatusText = 'Payment Status'.obs;
    var proceedPaymentText = 'Proceed for Payments'.obs;
    var checkInText = 'Check-In'.obs;
    var inHouseBookingNumberText = 'iOtel Booking Number'.obs;

    final String langCode = hc.selectedLanguageCode.value.toString();

    // DITO NA ANG TRANSLATION
    translator.translate(nameText.value, to: langCode).then((value) => nameText.value = value.text);
    translator.translate(bookingSourceText.value, to: langCode).then((value) => bookingSourceText.value = value.text);
    translator.translate(bookingNumberText.value, to: langCode).then((value) => bookingNumberText.value = value.text);
    translator.translate(bookingStatusText.value, to: langCode).then((value) => bookingStatusText.value = value.text);
    translator.translate(roomTypeText.value, to: langCode).then((value) => roomTypeText.value = value.text);
    translator.translate(roomNumberText.value, to: langCode).then((value) => roomNumberText.value = value.text);
    translator.translate(roomRateText.value, to: langCode).then((value) => roomRateText.value = value.text);
    translator.translate(roomPaidText.value, to: langCode).then((value) => roomPaidText.value = value.text);
    translator.translate(roomNotPaidText.value, to: langCode).then((value) => roomNotPaidText.value = value.text);
    translator.translate(paymentStatusText.value, to: langCode).then((value) => paymentStatusText.value = value.text);
    translator.translate(proceedPaymentText.value, to: langCode).then((value) => proceedPaymentText.value = value.text);
    translator.translate(checkInText.value, to: langCode).then((value) => checkInText.value = value.text);
    translator
        .translate(inHouseBookingNumberText.value, to: langCode)
        .then((value) => inHouseBookingNumberText.value = value.text);

    // var scrollController = ScrollController();

    return SizedBox(
      height: orientation == Orientation.portrait ? 45.h : 20.h,
      width: orientation == Orientation.portrait ? 80.w : 90.w,
      child: SingleChildScrollView(
        controller: hc.guestScroller,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  color: HenryColors.darkGreen,
                  // elevation: 2.0,
                  margin: const EdgeInsets.all(8.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      'assets/icons/user.png',
                      height: 10.h,
                      width: 5.w,
                      fit: BoxFit.fill,
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          nameText.value,
                          style: TextStyle(color: HenryColors.black87, fontSize: 6.sp),
                        ),
                        Text(
                          hc.guestInfoList.first.data.viewBookings.first.contact,
                          style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),
                ).animate().slideX(duration: 500.ms, curve: Curves.easeIn),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BOOKING SOURCE
                    Expanded(
                      child: Card(
                        color: HenryColors.darkGreen,
                        margin: const EdgeInsets.all(8.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            hc.guestInfoList.first.data.viewBookings.first.description.toUpperCase() == "AGODA"
                                ? 'assets/icons/agoda.png'
                                : 'assets/icons/bcom.png',
                            height: 10.h,
                            width: 5.w,
                            fit: BoxFit.fill,
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                bookingSourceText.value,
                                style: TextStyle(color: HenryColors.black87, fontSize: 6.sp),
                              ),
                              Text(
                                hc.guestInfoList.first.data.viewBookings.first.description,
                                style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                              ),
                            ],
                          ),
                        ),
                      ).animate().scaleXY(duration: 500.ms),
                    ),
                    // BOOKING NUMBER
                    Expanded(
                      child: Card(
                        color: HenryColors.darkGreen,
                        elevation: 2.0,
                        margin: const EdgeInsets.all(8.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/booknum.png',
                            height: 10.h,
                            width: 5.w,
                            fit: BoxFit.fill,
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                bookingNumberText.value,
                                style: TextStyle(color: HenryColors.black87, fontSize: 6.sp),
                              ),
                              Text(
                                hc.guestInfoList.first.data.viewBookings.first.agentDocNo,
                                style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                              ),
                            ],
                          ),
                        ),
                      ).animate().scaleXY(duration: 500.ms),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BOOKING STATUS
                    Expanded(
                      child: Card(
                        color: HenryColors.darkGreen,
                        // elevation: 2.0,
                        margin: const EdgeInsets.all(8.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/bookstatus.png',
                            height: 10.h,
                            width: 5.w,
                            fit: BoxFit.fill,
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                bookingStatusText.value,
                                style: TextStyle(color: HenryColors.black87, fontSize: 6.sp),
                              ),
                              Text(
                                hc.guestInfoList.first.data.viewBookings.first.bookingStatus.toUpperCase(),
                                style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                              ),
                            ],
                          ),
                        ),
                      ).animate().scaleXY(duration: 500.ms),
                    ),
                    // ROOM TYPE
                    Expanded(
                      child: Card(
                        color: HenryColors.darkGreen,
                        // elevation: 2.0,
                        margin: const EdgeInsets.all(8.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            hc.guestInfoList.first.data.viewBookings.first.roomType.toUpperCase() == "SMOKING"
                                ? 'assets/icons/smoking.png'
                                : 'assets/icons/nosmoking.png',
                            height: 10.h,
                            width: 5.w,
                            fit: BoxFit.fill,
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                roomTypeText.value,
                                style: TextStyle(color: HenryColors.black87, fontSize: 6.sp),
                              ),
                              Text(
                                hc.guestInfoList.first.data.viewBookings.first.roomType.toUpperCase(),
                                style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                              ),
                            ],
                          ),
                        ),
                      ).animate().scaleXY(duration: 500.ms),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ROOM NUMBER
                    Expanded(
                      child: Card(
                        color: HenryColors.darkGreen,
                        // elevation: 2.0,
                        margin: const EdgeInsets.all(8.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/roomnumber.png',
                            height: 10.h,
                            width: 5.w,
                            fit: BoxFit.fill,
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                roomNumberText.value,
                                style: TextStyle(color: HenryColors.black87, fontSize: 6.sp),
                              ),
                              Text(
                                hc.guestInfoList.first.data.viewBookings.first.room,
                                style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                              ),
                            ],
                          ),
                        ),
                      ).animate().scaleXY(duration: 500.ms),
                    ),
                    // ROOM RATE
                    Expanded(
                      child: Card(
                        color: HenryColors.darkGreen,
                        // elevation: 2.0,
                        margin: const EdgeInsets.all(8.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/rate.png',
                            height: 10.h,
                            width: 5.w,
                            fit: BoxFit.fill,
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                roomRateText.value,
                                style: TextStyle(color: HenryColors.black87, fontSize: 6.sp),
                              ),
                              Text(
                                moneyFormatting.format(hc.guestInfoList.first.data.viewBookings.first.roomRate),
                                style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                              ),
                            ],
                          ),
                        ),
                      ).animate().scaleXY(duration: 500.ms),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: hc.isRoomPayed.value ? HenryColors.darkGreen : HenryColors.warmRed,
                        // elevation: 2.0,
                        margin: const EdgeInsets.all(8.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/booknum.png',
                            height: 12.h,
                            width: 5.w,
                            fit: BoxFit.fill,
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                inHouseBookingNumberText.value,
                                style: TextStyle(color: HenryColors.black87, fontSize: 6.sp),
                              ),
                              Text(
                                hc.guestInfoList.first.data.viewBookings.first.docNo,
                                style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                              ),
                            ],
                          ),
                        ),
                      ).animate().scaleXY(duration: 500.ms),
                    ),
                    Expanded(
                      child: Card(
                        color: hc.isRoomPayed.value ? HenryColors.darkGreen : HenryColors.warmRed,
                        // elevation: 2.0,
                        margin: const EdgeInsets.all(8.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            hc.isRoomPayed.value ? 'assets/icons/rate.png' : 'assets/icons/unpaid.png',
                            height: 12.h,
                            width: 5.w,
                            fit: BoxFit.fill,
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                paymentStatusText.value,
                                style: TextStyle(color: HenryColors.black87, fontSize: 6.sp),
                              ),
                              Text(
                                hc.isRoomPayed.value ? roomPaidText.value : roomNotPaidText.value,
                                style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                              ),
                            ],
                          ),
                        ),
                      ).animate().scaleXY(duration: 500.ms),
                    ),
                  ],
                ),
                // BUTTON - IS DEPEND EITHER PAID OR NOT PAID
                // GOTO TO PAYMENT METHOD
                SizedBox(
                  height: 2.h,
                  width: double.infinity,
                ),
                SizedBox(
                  height: orientation == Orientation.portrait ? 8.h : 5.h,
                  width: 30.w,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (hc.isRoomPayed.value) {
                        //BAYAD NA
                        hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'DI', type: 'TITLE');
                        hc.isDisclaimer.value = true;
                        Get.to(
                          () => DisclaimerView(
                            isBookedRoom: true,
                            sourceRoomNumber: hc.guestInfoList.first.data.viewBookings.first.room,
                            sourceRoomRate: hc.guestInfoList.first.data.viewBookings.first.roomRate,
                          ),
                        );
                      } else {
                        hc.isLoading.value = true;
                        // hc.selectedRoomTypeID.value = hc.roomTypeList.first.data.roomTypes[index].id; // nned this
                        var response = await hc.getPaymentType(
                            credentialHeaders: hc.accessTOKEN, languageCode: hc.selectedLanguageCode.value);
                        if (response) {
                          hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'SPM', type: 'TITLE');
                          if (kDebugMode) print('PAYMENT => LANGUAGE ID: ${hc.selecttedLanguageID.value}');
                          await hc.cashDispenserCommand(
                              sCommand: APIConstant.cashPoolingStop, iTerminalID: hc.defaultTerminalID.value);
                          hc.isLoading.value = false;
                          Get.to(
                            () => PaymentMethodView(
                              isBookedRoom: true,
                              sourceRoomNumber: hc.guestInfoList.first.data.viewBookings.first.room,
                              sourceRoomRate: hc.guestInfoList.first.data.viewBookings.first.roomRate,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HenryColors.darkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      shadowColor: Colors.black26.withOpacity(0.5),
                    ),
                    child: Text(
                      hc.isRoomPayed.value ? checkInText.value : proceedPaymentText.value,
                      style: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

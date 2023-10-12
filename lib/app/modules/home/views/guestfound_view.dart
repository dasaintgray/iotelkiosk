import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:translator/translator.dart';

class GuestfoundView extends GetView {
  GuestfoundView({Key? key}) : super(key: key);

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
                    titleLength: hc.titleTrans.length,
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

    var nameText = 'Name'.obs;
    var bookingSourceText = 'Booking Source & Booking Number'.obs;
    var bookingStatusText = 'Booking Status'.obs;
    var roomTypeText = 'Room Type'.obs;
    var roomNumberText = 'Room Number'.obs;
    var roomRateText = 'Room Rate'.obs;

    final String langCode = hc.selectedLanguageCode.value.toString();

    // DITO NA ANG TRANSLATION
    translator.translate(nameText.value, to: langCode).then((value) => nameText.value = value.text);
    translator.translate(bookingSourceText.value, to: langCode).then((value) => bookingSourceText.value = value.text);
    translator.translate(bookingStatusText.value, to: langCode).then((value) => bookingStatusText.value = value.text);
    translator.translate(roomTypeText.value, to: langCode).then((value) => roomTypeText.value = value.text);
    translator.translate(roomNumberText.value, to: langCode).then((value) => roomNumberText.value = value.text);
    translator.translate(roomRateText.value, to: langCode).then((value) => roomRateText.value = value.text);


    return SizedBox(
      height: orientation == Orientation.portrait ? 35.h : 20.h,
      width: orientation == Orientation.portrait ? 80.w : 40.w,
      child: SingleChildScrollView(
        controller: hc.scrollController,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: HenryColors.darkGreen,
                  elevation: 2.0,
                  margin: const EdgeInsets.all(8.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: HenryColors.puti,
                      size: 15.sp,
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          nameText.value,
                          style: TextStyle(color: HenryColors.black87, fontSize: 8.sp),
                        ),
                        Text(
                          hc.guestInfoList.first.data.viewBookings.first.contact,
                          style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),
                ).animate().scaleXY(duration: 500.ms),
                Card(
                  color: HenryColors.darkGreen,
                  elevation: 2.0,
                  margin: const EdgeInsets.all(8.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.web,
                      color: HenryColors.puti,
                      size: 15.sp,
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          bookingSourceText.value,
                          style: TextStyle(color: HenryColors.black87, fontSize: 8.sp),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hc.guestInfoList.first.data.viewBookings.first.description,
                              style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                            ),
                            Text(
                              hc.guestInfoList.first.data.viewBookings.first.agentDocNo,
                              style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ).animate().slideY(duration: 500.ms),
                Card(
                  color: HenryColors.darkGreen,
                  elevation: 2.0,
                  margin: const EdgeInsets.all(8.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.tab,
                      color: HenryColors.puti,
                      size: 15.sp,
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          bookingStatusText.value,
                          style: TextStyle(color: HenryColors.black87, fontSize: 8.sp),
                        ),
                        Text(
                          hc.guestInfoList.first.data.viewBookings.first.bookingStatus.toUpperCase(),
                          style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),
                ).animate().slideX(duration: 500.ms),
                Card(
                  color: HenryColors.darkGreen,
                  elevation: 2.0,
                  margin: const EdgeInsets.all(8.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.smoking_rooms,
                      color: HenryColors.puti,
                      size: 15.sp,
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          roomTypeText.value,
                          style: TextStyle(color: HenryColors.black87, fontSize: 8.sp),
                        ),
                        Text(
                          hc.guestInfoList.first.data.viewBookings.first.roomType.toUpperCase(),
                          style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),
                ).animate().slideY(duration: 500.ms),
                Card(
                  color: HenryColors.darkGreen,
                  elevation: 2.0,
                  margin: const EdgeInsets.all(8.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.hotel_outlined,
                      color: HenryColors.puti,
                      size: 15.sp,
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          roomNumberText.value,
                          style: TextStyle(color: HenryColors.black87, fontSize: 8.sp),
                        ),
                        Text(
                          hc.guestInfoList.first.data.viewBookings.first.room,
                          style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),
                ).animate().slideX(duration: 500.ms),
                Card(
                  color: HenryColors.darkGreen,
                  elevation: 2.0,
                  margin: const EdgeInsets.all(8.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.currency_bitcoin,
                      color: HenryColors.puti,
                      size: 15.sp,
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          roomRateText.value,
                          style: TextStyle(color: HenryColors.black87, fontSize: 8.sp),
                        ),
                        Text(
                          moneyFormatting.format(hc.guestInfoList.first.data.viewBookings.first.roomRate),
                          style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),
                ).animate().slideY(duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

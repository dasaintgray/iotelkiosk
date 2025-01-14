import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/guestfound_view.dart';
import 'package:iotelkiosk/app/modules/home/views/transaction2_view.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:translator/translator.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class BookedroomView extends GetView {
  BookedroomView({super.key});

  final hc = Get.find<HomeController>();

  final GlobalKey<FormState> formKey = GlobalKey();

  final translator = GoogleTranslator();

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() => KioskHeader(
                        isLive: hc.clockLiveUpdate.value,
                      )),
                  // SPACE
                  SizedBox(
                    height: orientation == Orientation.portrait ? 10.h : 0.h,
                  ),
                  // TITLE
                  KioskMenuTitle(
                    titleTrans: hc.titleTrans,
                    fontSize: orientation == Orientation.portrait ? 12.sp : 8.sp,
                    heights: orientation == Orientation.portrait ? 7.h : 2.h,
                  ),
                  // SPACE
                  SizedBox(
                    height: orientation == Orientation.portrait ? 2.h : 1.h,
                  ),
                  // MENU
                  menuBookingInfo(orientation),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 5.h : 1.h,
                  ),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 5.h : 2.h,
                    child: GestureDetector(
                      onTap: () {
                        hc.bkReferenceNo.clear();
                        hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'SCIP', type: 'TITLE');
                        Get.off(() => Transaction2View());
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

  Widget menuBookingInfo(Orientation orientation) {
    final String langCode = hc.selectedLanguageCode.value.toString();
    var buttonText = 'Search'.obs;
    var hintText = 'Please Input Booking Number'.obs;

    translator.translate(buttonText.value, from: 'auto', to: langCode).then(
      (value) {
        buttonText.value = value.text;
      },
    );

    translator.translate(hintText.value, to: langCode).then((value) => hintText.value = value.text);

    hc.bkReferenceNo.addListener(
      () {
        hc.isSearchButton.value = hc.bkReferenceNo.text.isNotEmpty;
      },
    );

    return SizedBox(
      height: orientation == Orientation.portrait ? 40.h : 25.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Obx(
              () => SizedBox(
                height: orientation == Orientation.portrait ? 20.h : 10.h,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: orientation == Orientation.portrait ? 10.w : 60.w,
                      right: orientation == Orientation.portrait ? 10.w : 60.w),
                  child: TextFormField(
                    controller: hc.bkReferenceNo,
                    textAlignVertical: TextAlignVertical.bottom,
                    maxLength: 20,
                    style: TextStyle(
                        color: HenryColors.puti, fontSize: orientation == Orientation.portrait ? 12.sp : 10.sp),
                    autofocus: true,
                    textAlign: TextAlign.center,
                    inputFormatters: [FilteringTextInputFormatter(RegExp(r'[fff0-9]'), allow: true)],
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        // width: 0.0 produces a thin "hairline" border
                        borderSide: BorderSide(color: HenryColors.puti, width: 1.0),
                      ),
                      border: const OutlineInputBorder(),
                      disabledBorder: InputBorder.none,
                      focusedBorder: const OutlineInputBorder(
                        // width: 0.0 produces a thin "hairline" border
                        borderSide: BorderSide(color: HenryColors.puti, width: 1.0),
                      ),
                      hintText: hintText.value,
                      // labelText: '[ BOOKING REFERENCE NUMBER ]',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      // helperText: 'Only accept letters from a to z & 0-9',
                      helperStyle: TextStyle(
                          color: HenryColors.puti, fontSize: orientation == Orientation.portrait ? 10.sp : 8.sp),
                      prefixIcon: Icon(
                        Icons.numbers,
                        color: HenryColors.puti,
                        size: orientation == Orientation.portrait ? 15.sp : 10.sp,
                      ),
                      labelStyle: TextStyle(
                        color: HenryColors.puti,
                        fontSize: orientation == Orientation.portrait ? 12.sp : 10.sp,
                      ),
                      hintStyle: TextStyle(
                        color: HenryColors.puti,
                        fontSize: orientation == Orientation.portrait ? 12.sp : 10.sp,
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: SizedBox(
              width: orientation == Orientation.portrait ? 50.w : 40.w,
              height: orientation == Orientation.portrait ? 10.h : 25.h,
              child: VirtualKeyboard(
                textController: hc.bkReferenceNo,
                textColor: HenryColors.puti,
                fontSize: orientation == Orientation.portrait ? 15.sp : 10.sp,
                type: VirtualKeyboardType.Numeric,
              ),
            ),
          ),
          SizedBox(
            height: orientation == Orientation.portrait ? 3.h : 1.h,
          ),
          Expanded(
            flex: 2,
            child: Obx(
              () => SizedBox(
                height: orientation == Orientation.portrait ? 10.h : 5.h,
                width: 25.w,
                child: Visibility(
                  visible: hc.isSearchButton.value,
                  child: ElevatedButton(
                    onPressed: () async {
                      hc.isLoading.value = true;
                      final response =
                          await hc.searchBK(bookingNumber: hc.bkReferenceNo.text, credentialHeaders: hc.accessTOKEN);
                      if (response) {
                        await hc.searchPayments(
                            bookingNumber: hc.guestInfoList.first.data.viewBookings.first.docNo,
                            credentialHeaders: hc.accessTOKEN);
                        hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'GI', type: 'TITLE');
                        hc.isGuestFound.value = true;
                        Get.to(
                          () => GuestfoundView(),
                        );
                        hc.isLoading.value = false;
                      } else {
                        hc.isGuestFound.value = false;
                        hc.isLoading.value = false;
                        Get.defaultDialog(
                            title: 'Record not found',
                            titleStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
                            titlePadding: const EdgeInsets.all(10),
                            middleText: 'Booking reference number \n ${hc.bkReferenceNo.text} \n not found!',
                            middleTextStyle: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                            contentPadding: const EdgeInsets.all(20),
                            backgroundColor: HenryColors.darkGreen);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HenryColors.darkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: orientation == Orientation.portrait ? 30 : 20,
                          vertical: orientation == Orientation.portrait ? 25 : 10),
                      shadowColor: Colors.black26.withOpacity(0.5),
                    ),
                    // SEARCH
                    child: Text(
                      buttonText.value,
                      style: TextStyle(
                          color: HenryColors.puti, fontSize: orientation == Orientation.portrait ? 15.sp : 10.sp),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

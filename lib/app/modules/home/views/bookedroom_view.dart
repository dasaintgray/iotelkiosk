import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
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
  BookedroomView({Key? key}) : super(key: key);

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
                    titleLength: hc.titleTrans.length,
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
                          hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'SCIP', type: 'TITLE');
                          Get.off(() => Transaction2View());
                        },
                        child: Image.asset(
                          'assets/menus/back-arrow.png',
                          fit: BoxFit.cover,
                          semanticLabel: 'Back to previous menu',
                        ),
                      )),
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

    translator.translate(buttonText.value, from: 'auto', to: langCode).then((value) {
      buttonText.value = value.text;
    });

    translator.translate(hintText.value, to: langCode).then(
          (value) => hintText.value = value.text,
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
                child: Padding(
                  padding: EdgeInsets.only(left: 60.w, right: 60.w),
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
              width: orientation == Orientation.portrait ? 20.w : 40.w,
              child: VirtualKeyboard(
                textController: hc.bkReferenceNo,
                textColor: HenryColors.puti,
                fontSize: 15.sp,
                type: VirtualKeyboardType.Numeric,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: orientation == Orientation.portrait ? 5.h : 10.h,
              child: ElevatedButton(
                onPressed: () async {
                  hc.isLoading.value = true;
                  final response =
                      await hc.searchBK(bookingNumber: hc.bkReferenceNo.text, credentialHeaders: hc.accessTOKEN);
                  if (response) {
                    hc.isGuestFound.value = true;
                    // display the info
                    hc.isLoading.value = false;
                  } else {
                    hc.isGuestFound.value = false;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HenryColors.darkGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: orientation == Orientation.portrait ? 40 : 20,
                      vertical: orientation == Orientation.portrait ? 15 : 10),
                  shadowColor: Colors.black26.withOpacity(0.5),
                ),
                // SEARCH
                child: Obx(
                  () => Text(
                    buttonText.value,
                    style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
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

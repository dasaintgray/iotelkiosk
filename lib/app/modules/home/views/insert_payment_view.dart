import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/disclaimer_view.dart';
// import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/settings_constant.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:sizer/sizer.dart';

class InsertPaymentView extends GetView {
  InsertPaymentView({Key? key}) : super(key: key);

  final hc = Get.find<HomeController>();
  // final sc = Get.find<ScreenController>();

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
                  ),
                  // MENU
                  menuInsertPayment(orientation, languageID: hc.selecttedLanguageID.value),
                  SizedBox(
                    height: 5.h,
                  ),

                  // SizedBox(
                  //   height: orientation == Orientation.portrait ? 5.h : 2.h,
                  //   child: GestureDetector(
                  //     onTap: () async {
                  //       // STOP THE CASH DISPENSER IF RUNNING
                  //       // var cashDResponse = await hc.cashDispenserCommand(sCommand: 'CASH', iTerminalID: 1);
                  //       // if (cashDResponse!) {}
                  //       await hc.updateTerminalData(
                  //           recordID: hc.terminalDataList.first.id, terminalID: hc.terminalDataList.first.terminalId);

                  //       if (hc.isCashDispenserRunning.value) {
                  //         await hc.cashDispenserCommand(
                  //             sCommand: APIConstant.cashPoolingStop, iTerminalID: hc.defaultTerminalID.value);
                  //       }
                  //       var response = hc.getMenu(languageID: hc.selecttedLanguageID.value, code: 'IP', type: 'TITLE');
                  //       if (response) Get.back();
                  //     },
                  //     child: Image.asset(
                  //       'assets/menus/back-arrow.png',
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget menuInsertPayment(Orientation orientation, {required int? languageID}) {
    final langCode = hc.languageList.first.data.languages.where((element) => element.id == languageID);

    final selectedPaymentType =
        hc.paymentTypeList.first.data.paymentTypes.where((element) => element.code == hc.selectedPaymentTypeCode.value);

    if (kDebugMode) {
      print('${selectedPaymentType.first.description} : ${selectedPaymentType.first.translatedText}');
      print('${langCode.first.code} : ${langCode.first.description}');
    }

    String denomination = 'PHP';
    String cardDeposit = 'Card Deposit';
    String roomRate = 'Room Rate';
    String amountDue = 'Amount Due';
    String amountReceivedText = 'Total Amount Received';
    String roomNumber = 'Room Number';

    if (langCode.first.code.toLowerCase() != hc.selectedLanguageCode.value.toLowerCase()) {
      cardDeposit = hc.translateText(
          sourceText: cardDeposit,
          fromLang: hc.selectedLanguageCode.value.toLowerCase(),
          toLang: langCode.first.code.toLowerCase());
    }

    return SizedBox(
      height: orientation == Orientation.portrait ? 40.h : 25.h,
      width: 75.w,
      child: Container(
        margin: const EdgeInsets.all(30.0),
        height: 15.h,
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
                    langCode.first.code.toLowerCase() == hc.selectedLanguageCode.value.toLowerCase()
                        ? selectedPaymentType.first.description.toUpperCase()
                        : selectedPaymentType.first.translatedText!,
                    style: TextStyle(
                        color: HenryColors.puti, fontSize: orientation == Orientation.portrait ? 10.sp : 8.sp),
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
                    Text(
                      '$roomNumber : ${hc.availRoomList[hc.preSelectedRoomID.value].description}',
                      style: TextStyle(
                          color: HenryColors.puti, fontSize: orientation == Orientation.portrait ? 10.sp : 8.sp),
                    ),
                    Text(
                      '$roomRate : $denomination ${hc.availRoomList[hc.preSelectedRoomID.value].rate.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: HenryColors.puti, fontSize: orientation == Orientation.portrait ? 10.sp : 8.sp),
                    ),
                    Text(
                      '$cardDeposit : $denomination ${hc.cardDeposit.value.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: HenryColors.puti, fontSize: orientation == Orientation.portrait ? 10.sp : 8.sp),
                    ),
                    Text(
                      '$amountDue : $denomination ${hc.totalAmountDue.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: HenryColors.puti, fontSize: orientation == Orientation.portrait ? 10.sp : 8.sp),
                    ),
                    SizedBox(
                      height: 2.h,
                      width: double.infinity,
                    ),
                    Obx(
                      () => SizedBox(
                        height: 10.h,
                        width: double.infinity,
                        child: hc.nabasangPera.value != 0.0
                            ? Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      amountReceivedText,
                                      style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Visibility(
                                      visible: hc.nabasangPera.value != 0.0,
                                      child: Text(
                                        'PHP ${hc.nabasangPera.value.toStringAsFixed(2)}',
                                        style: TextStyle(color: HenryColors.puti, fontSize: 18.sp),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: hc.isOverPaymentDetected.value,
                                    child: Expanded(
                                      flex: 1,
                                      child: hc.isOverPaymentDetected.value
                                          ? Text(
                                              'Change: PHP ${hc.overPayment.value.toStringAsFixed(2)}',
                                              style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                                            )
                                          : const Text(''),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'Please insert CASH in Cash Acceptor...',
                                  style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Visibility(
                  visible: hc.isConfirmReady.value,
                  child: Expanded(
                    flex: 2,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: hc.isButtonActive.value
                            ? () async {
                                hc.isButtonActive.value = false;
                                hc.isDisclaimer.value = true;
                                // hc.isLoading.value = true;
                                hc.getMenu(code: 'DI', type: 'TITLE', languageID: languageID);
                                await hc.initializeCamera();

                                var moduleResponse = hc.settingsList.first.data.settings
                                    .where((element) => element.code == SettingConstant.contactModuleID);
                                hc.contactNumber.value = (await hc.getSeriesDetails(
                                    credentialHeaders: hc.accessTOKEN,
                                    moduleID: int.parse(moduleResponse.first.value)))!;

                                hc.statusMessage.value = "Processing... please wait..";
                                hc.isButtonActive.value = true;

                                Get.to(() => DisclaimerView());
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HenryColors.darkGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          padding: const EdgeInsets.all(30),
                          shadowColor: Colors.black26.withOpacity(0.5),
                        ),
                        // CONFIRM BUTTON
                        child: Text(
                          '   Confirm   ',
                          style: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

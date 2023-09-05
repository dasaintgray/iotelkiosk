import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/disclaimer_view.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:iotelkiosk/globals/widgets/menutitle_widget.dart';
import 'package:sizer/sizer.dart';

class InsertPaymentView extends GetView {
  InsertPaymentView({Key? key}) : super(key: key);

  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  menuInsertPayment(orientation, languageID: sc.selecttedLanguageID.value),

                  SizedBox(
                    height: orientation == Orientation.portrait ? 10.h : 2.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // STOP THE CASH DISPENSER IF RUNNING
                            var cashDResponse = await hc.cashDispenserCommand(sCommand: 'CASH', iTerminalID: 1);
                            if (cashDResponse!) {
                              await hc.updateTerminalData(
                                  recordID: hc.terminalDataList.first.id,
                                  terminalID: hc.terminalDataList.first.terminalId);

                              var response = sc.getMenu(languageID: sc.selecttedLanguageID.value, code: 'ST');
                              if (response) Get.back();
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
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget menuInsertPayment(Orientation orientation, {required int? languageID}) {
    final langCode = sc.languageList.first.data.languages.where((element) => element.id == languageID);

    final selectedPaymentType =
        sc.paymentTypeList.first.data.paymentTypes.where((element) => element.code == sc.selectedPaymentTypeCode.value);

    if (kDebugMode) {
      print('${selectedPaymentType.first.description} : ${selectedPaymentType.first.translatedText}');
      print('${langCode.first.code} : ${langCode.first.description}');
    }

    String denomination = 'PHP';
    String cardDeposit = 'Card Deposit';
    String roomRate = 'Room Rate';
    String amountDue = 'Amount Due';
    String amountReceivedText = 'Total Amount Received';

    if (langCode.first.code.toLowerCase() != sc.defaultLanguageCode.value.toLowerCase()) {
      cardDeposit = sc.translateText(
          sourceText: cardDeposit,
          fromLang: sc.defaultLanguageCode.value.toLowerCase(),
          toLang: langCode.first.code.toLowerCase());
    }

    return SizedBox(
      height: orientation == Orientation.portrait ? 49.h : 20.h,
      width: 75.w,
      child: Container(
        margin: const EdgeInsets.all(30.0),
        height: 20.h,
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
                    langCode.first.code.toLowerCase() == sc.defaultLanguageCode.value.toLowerCase()
                        ? selectedPaymentType.first.description.toUpperCase()
                        : selectedPaymentType.first.translatedText!,
                    style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
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
                    SizedBox(
                      height: 2.h,
                      width: double.infinity,
                    ),
                    Text(
                      '$roomRate : $denomination ${sc.availRoomList[sc.preSelectedRoomID.value].rate.toStringAsFixed(2)}',
                      style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                    ),
                    Text(
                      '$cardDeposit : $denomination ${sc.availRoomList[sc.preSelectedRoomID.value].serviceCharge.toStringAsFixed(2)}',
                      style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                    ),
                    Text(
                      '$amountDue : $denomination ${sc.totalAmountDue.toStringAsFixed(2)}',
                      style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                    ),
                    SizedBox(
                      height: 2.h,
                      width: double.infinity,
                    ),
                    Obx(
                      () => SizedBox(
                        height: 15.h,
                        width: double.infinity,
                        // decoration: const BoxDecoration(
                        //   color: HenryColors.darkGreen,
                        //   gradient: LinearGradient(
                        //       colors: [HenryColors.darkGreen, Colors.white],
                        //       begin: Alignment.topLeft,
                        //       end: Alignment.bottomRight,
                        //       tileMode: TileMode.clamp),
                        //   borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                        // ),
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
                                        style: TextStyle(color: HenryColors.puti, fontSize: 20.sp),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: hc.isOverPaymentDetected.value
                                        ? Text(
                                            'Change: PHP ${hc.overPayment.value.toStringAsFixed(2)}',
                                            style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                                          )
                                        : const Text(''),
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'Please insert CASH in Cash Acceptor...',
                                  style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
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
                      child: MaterialButton(
                        onPressed: () async {
                          sc.isLoading.value = true;
                          var response = await sc.getTerms(credentialHeaders: hc.globalHeaders);
                          if (response) {
                            sc.isLoading.value = false;
                            Get.to(() => DisclaimerView());
                          }
                        },
                        color: HenryColors.darkGreen,
                        padding: const EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                        // AGREE BUTTON
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

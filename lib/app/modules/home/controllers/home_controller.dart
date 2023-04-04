// ignore_for_file: avoid_print
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iotelkiosk/app/data/models_graphql/accomtype_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/languages_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/transaction_model.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/app/providers/providers_global.dart';
import 'package:iotelkiosk/globals/services/controller/base_controller.dart';

import 'package:timezone/data/latest.dart' as tzd;
import 'package:timezone/standalone.dart' as tz;

// FFI

class HomeController extends GetxController with BaseController {
  DateTime japanNow = DateTime.now();
  DateTime newyorkNow = DateTime.now();
  DateTime seoulNow = DateTime.now();
  DateTime sydneyNow = DateTime.now();

  // LOCAL TIME
  DateTime localTime = DateTime.now();

  late Timer timer;
  late final idleTime = 0;

  // BOOLEAN
  final isLoading = false.obs;

  // INT
  final menuIndex = 0.obs;
  final currentIndex = 0.obs;
  final selecttedLanguageID = 1.obs;

  // MODEL LIST
  final languageList = <LanguageModel>[].obs;
  final transactionList = <TransactionModel>[].obs;
  final pageTrans = <Translation>[].obs;
  final titleTrans = <Translation>[].obs;
  final btnMessage = <Translation>[].obs;
  final accommodationTypeList = <AccomTypeModel>[].obs;

  // UI
  late TextEditingController textEditingController = TextEditingController();

  // ScreenController screenController = Get.put(ScreenController());
  final ScreenController screenController = Get.find<ScreenController>();

  @override
  void onInit() {
    super.onInit();
    initTimezone();
    startTimer();
    getLanguages();
    getTransaction();
    getAccommodation();
  }

  @override
  void onReady() {
    // ignore: unnecessary_overrides
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    stopTimer();
    screenController.dispose();
  }

  String properCase(String value) {
    var result = value[0].toUpperCase();
    bool cap = true;
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " " && cap == true) {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
        cap = false;
      }
    }
    return result;
  }

  void initTimezone() {
    tzd.initializeTimeZones();
    final japan = tz.getLocation('Asia/Tokyo');
    final newyork = tz.getLocation('America/New_York');
    final seoul = tz.getLocation('Asia/Seoul');
    final sydney = tz.getLocation('Australia/Sydney');

    japanNow = tz.TZDateTime.now(japan);
    newyorkNow = tz.TZDateTime.now(newyork);
    seoulNow = tz.TZDateTime.now(seoul);
    sydneyNow = tz.TZDateTime.now(sydney);
  }

  void startTimer() {
    // Start a 5-second timer
    // timer = Timer(const Duration(seconds: 30), () {
    //   // Navigate back to the previous screen
    //   Get.back();
    // });

    timer = Timer.periodic(const Duration(minutes: 30), (timer) {
      initTimezone();
      screenController.player.play();
      menuIndex.value = 0;
      Get.back();
    });
  }

  void stopTimer() {
    // Cancel the timer if it's still running
    // ignore: unnecessary_null_comparison
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
  }

  void resetTimer() {
    // Cancel the existing timer and start a new one
    stopTimer();
    startTimer();
  }

  Future<bool> getLanguages() async {
    isLoading.value = true;
    final response = await GlobalProvider().fetchLanguages();
    try {
      if (response != null) {
        languageList.add(response);
        print(languageList.first.data.languages.length);
        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> getTransaction() async {
    isLoading.value = true;
    final response = await GlobalProvider().getTranslation();
    try {
      if (response != null) {
        transactionList.add(response);
        print('TRANSLATION RECORDS: ${transactionList.first.data.translations.length}');
        getMenu(languageID: 0, code: 'SLMT', type: 'TITLE');
        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> getAccommodation() async {
    isLoading.value = true;
    final response = await GlobalProvider().fetchAccommodationType();

    try {
      if (response != null) {
        accommodationTypeList.add(response);
        print('TOTAL ACCOMMODATION: ${accommodationTypeList.first.data.accommodationTypes.length}');
        isLoading.value = false;
        return true;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  bool getMenu({int? languageID, String? code, String? type, int? indexCode}) {
    pageTrans.clear();
    titleTrans.clear();
    if (transactionList.isNotEmpty) {
      // TITLE
      if (type == "TITLE") {
        titleTrans.addAll(
            transactionList[0].data.translations.where((element) => element.code == code && element.type == 'TITLE'));
      } else {
        titleTrans.addAll(transactionList[0]
            .data
            .translations
            .where((element) => element.languageId == languageID && element.code == code && element.type == 'TITLE'));
      }
      print('TOTAL MENU : ${titleTrans.length}');

      // ITEM
      pageTrans.addAll(
        transactionList[0]
            .data
            .translations
            .where((element) => element.languageId == languageID && element.code == code && element.type == type),
      );
      print('TOTAL MENU ITEMS ($code : $type) : ${pageTrans.length} : INDEX: $indexCode');

      // btnMessage.addAll(
      //   transactionList[0]
      //       .data
      //       .translations
      //       .where((element) => element.languageId == languageID && element.code == code && element.type == 'BUTTON'),
      // );
    }
    return true;
  }
}

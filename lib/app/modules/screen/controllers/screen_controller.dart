import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iotelkiosk/app/data/models_graphql/accomtype_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/availablerooms_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/languages_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/payment_type_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/roomtype_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/seriesdetails_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/settings_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/transaction_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/translation_terms_model.dart';
import 'package:iotelkiosk/app/data/models_rest/roomavailable_model.dart';
import 'package:iotelkiosk/app/data/models_rest/userlogin_model.dart';

import 'package:iotelkiosk/app/data/models_rest/weather_model.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/providers/providers_global.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/services/base/base_storage.dart';
import 'package:iotelkiosk/globals/services/controller/base_controller.dart';

class ScreenController extends GetxController with BaseController {
  // VARIABLE DECLARTION WITH OBSERVABLE CAPABILITY;

  // BOOLEAN
  final isLoading = false.obs;
  final isBottom = false.obs;

  // STRING
  final imgUrl = ''.obs;
  final sCity = ''.obs;
  final defaultLanguageCode = 'en'.obs;
  final hostname = ''.obs;

  // INTEGER

  // LIST or OBJECT DATA
  final weatherList = <WeatherModel>[].obs;
  final settingsList = <SettingsModel>[].obs;
  final userLoginList = <UserLoginModel>[].obs;

  final languageList = <LanguageModel>[].obs;
  final transactionList = <TransactionModel>[].obs;
  final accommodationTypeList = <AccomTypeModel>[].obs;
  final seriesDetailsList = <SeriesDetailsModel>[].obs;
  final roomAvailableList = <RoomAvailableModel>[].obs;
  final roomTypeList = <RoomTypesModel>[].obs;
  final paymentTypeList = <PaymentTypeModel>[].obs;
  final availableRoomList = <AvailableRoomsModel>[].obs;
  final translationTermsList = <TranslationTermsModel>[].obs;

  final roomsList = [].obs; //DYNAMIC KASI PABABAGO ANG OUTPUT
  final resultList = [].obs;

  // TRANSACTION VARIABLE

  final selecttedLanguageID = 1.obs;
  final selectedLanguageCode = 'en'.obs;
  final selectedTransactionType = ''.obs;
  final selectedRoomType = ''.obs;
  final selectedRoomTypeID = 1.obs;
  final selectedAccommodationType = 1.obs;
  final selectedNationalities = 77.obs;
  final selectedPaymentType = 0.obs;
  final preSelectedRoomID = 0.obs;
  final totalAmountDue = 0.0.obs;

  // MODEL LIST
  final pageTrans = <Conversion>[].obs;
  final titleTrans = <Conversion>[].obs;
  final btnMessage = <Conversion>[].obs;
  final availRoomList = <AvailableRoom>[].obs;

  // SCROLL CONTROLLER
  final scrollController = ScrollController();

  final player = Player(
    id: 0,
  );

  // GLOBAL

  @override
  void onInit() async {
    super.onInit();
    await userLogin();
    await getSettings();
    await getWeather();
    mediaOpen();
    hostname.value = Platform.localHostname;

    final accessToken = userLoginList.first.accessToken;
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'};

    await getLanguages(credentialHeaders: headers);
    await getTransaction(credentialHeaders: headers);
    await getAccommodation(credentialHeaders: headers);
    await getSeriesDetails(credentialHeaders: headers);
    await getRoomType(credentialHeaders: headers);
    await getPaymentType(credentialHeaders: headers);

    await getAvailableRoomsGraphQL(
        credentialHeaders: headers,
        roomTYPEID: selectedRoomTypeID.value,
        accommodationTYPEID: selectedAccommodationType.value);

    await getTerms(credentialHeaders: headers, languageID: 6);
  }

  @override
  void onReady() async {
    super.onReady();
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge) {
          isBottom.value = scrollController.position.pixels == 0 ? false : true;
        }
      },
    );
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  void mediaOpen() {
    player.setVolume(0);
    player.open(
      Playlist(
        medias: [
          Media.asset('assets/background/iOtelWalkin.mp4'),
          Media.asset('assets/background/iotel.mp4'),
        ],
      ),
      autoStart: true,
    );
  }

  int pickRoom() {
    final random = Random();

    if (availRoomList.isNotEmpty) {
      for (var i = availRoomList.length - 1; i > 0; i++) {
        var n = random.nextInt(i + 1);
        if (n != 0) {
          return n;
        }
      }
    }
    return 0;
  }

  Future<bool> getSettings() async {
    isLoading.value = true;

    final accessToken = await HenryStorage.readFromLS(titulo: HenryGlobal.jwtToken);
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'};

    final settingsResponse = await GlobalProvider().fetchSettings(headers: headers);

    try {
      if (settingsResponse != null) {
        settingsList.add(settingsResponse);

        // GET CITY
        final cityIndex = settingsResponse.data.settings.indexWhere((element) => element.code == "CITY");
        sCity.value = settingsResponse.data.settings[cityIndex].value;

        // DEFAULT LANGUAGE CODE
        final langIndex =
            settingsResponse.data.settings.indexWhere((element) => element.code == "EN" || element.value == "English");
        defaultLanguageCode.value = settingsResponse.data.settings[langIndex].code;

        isLoading.value = false;
        return true;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> getWeather() async {
    isLoading.value = true;
    final weatherResponse =
        await GlobalProvider().fetchWeather(queryParam: sCity.value.isEmpty ? 'Angeles City' : sCity.value);
    try {
      if (weatherResponse != null) {
        weatherList.add(weatherResponse);
        imgUrl.value = 'http:${weatherResponse.current.condition.icon}';
        // ignore: avoid_print
        // print(weatherResponse);
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

  Future<bool> userLogin() async {
    isLoading.value = true;

    final userresponse = await GlobalProvider().userLogin();
    try {
      if (userresponse != null) {
        userLoginList.add(userresponse);
        await HenryStorage.saveToLS(titulo: HenryGlobal.jwtToken, userresponse.accessToken);
        await HenryStorage.saveToLS(titulo: HenryGlobal.jwtExpire, userresponse.expiresIn);
        // update();
        isLoading.value = false;
        return true;
      } else {
        return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> getLanguages({required Map<String, String> credentialHeaders}) async {
    isLoading.value = true;

    final response = await GlobalProvider().fetchLanguages(headers: credentialHeaders);

    try {
      if (response != null) {
        // var balik = response.data.languages.indexWhere((element) => element.flag == null);
        response.data.languages.removeWhere((element) => element.flag == null);
        languageList.add(response);

        if (kDebugMode) {
          print('Language: ${languageList.first.data.languages.length}');
        }
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

  Future<bool> getTransaction({required Map<String, String> credentialHeaders}) async {
    isLoading.value = true;

    final response = await GlobalProvider().getTranslation(headers: credentialHeaders);
    try {
      if (response != null) {
        transactionList.add(response);
        if (kDebugMode) {
          print('TRANSLATION RECORDS: ${transactionList.first.data.conversion.length}');
        }
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

  Future<bool> getAccommodation({required Map<String, String> credentialHeaders}) async {
    isLoading.value = true;

    final response = await GlobalProvider().fetchAccommodationType(3, headers: credentialHeaders);
    // const inputHenry = 'Acknowledgement';

    try {
      if (response != null) {
        // await translator.translate('sex', from: 'en', to: 'zh-cn').then((value) => print(value));
        // print(await inputHenry.translate(from: 'en', to: 'ja'));

        accommodationTypeList.add(response);

        if (kDebugMode) {
          print('TOTAL ACCOMMODATION: ${accommodationTypeList.first.data.accommodationTypes.length}');
        }
        isLoading.value = false;
        return true;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> getSeriesDetails({required Map<String, String> credentialHeaders}) async {
    isLoading.value = true;

    final response = await GlobalProvider().fetchSeriesDetails(headers: credentialHeaders);

    try {
      if (response != null) {
        seriesDetailsList.add(response);
        if (kDebugMode) {
          print(response.data.seriesDetails.first.docNo);
        }
        isLoading.value = false;
        return true;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> getAvailableRooms() async {
    isLoading.value = true;

    final dtNow = DateTime.now();

    final availResponse = await GlobalProvider().fetchAvailableRooms(1, 1, 1, dtNow, dtNow, false, 1, 1);

    try {
      if (availResponse != null) {
        roomAvailableList.addAll(availResponse);
        if (kDebugMode) {
          print('AVAILABLE ROOMS: ${roomAvailableList.length}');
        }
        roomAvailableList.shuffle();
        if (kDebugMode) {
          print(roomAvailableList.first.description);
        }
        isLoading.value = true;
        return true;
      } else {
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool?> getAvailableRoomsGraphQL(
      {required Map<String, String> credentialHeaders,
      required int? roomTYPEID,
      required int? accommodationTYPEID}) async {
    isLoading.value = true;

    final dtnow = DateTime.now();

    final response = await GlobalProvider().fetchAvailableRoomsGraphQL(
        agentID: 1,
        roomTypeID: roomTYPEID,
        accommodationTypeID: accommodationTYPEID == 0 ? 1 : accommodationTYPEID,
        startDate: dtnow,
        endDate: dtnow,
        headers: credentialHeaders);

    try {
      if (response != null) {
        availableRoomList.add(response);
        availableRoomList.shuffle();

        availRoomList.addAll(availableRoomList.first.data.availableRooms.toList());
        preSelectedRoomID.value = pickRoom();

        if (preSelectedRoomID.value != 0) {
          totalAmountDue.value =
              availRoomList[preSelectedRoomID.value].rate + availRoomList[preSelectedRoomID.value].serviceCharge;
        }

        if (kDebugMode) {
          print('Available Room Orig: ${availableRoomList.first.data.availableRooms.length}');
          print('Available Room Shuffle: ${availRoomList.length}');
        }

        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> getRooms({required Map<String, String> credentialHeaders}) async {
    isLoading.value = true;

    final responseValue =
        await GlobalProvider().fetchRooms(isInclude: false, includeFragments: true, headers: credentialHeaders);

    try {
      if (responseValue != null) {
        // var listBooks = (result['data']['books'] as List).map((e) => Books.fromMap(e)).toList();
        var resultList = (responseValue['data']['Rooms'] as List);
        resultList.shuffle();
        if (kDebugMode) {
          print(resultList[0]['description']);
        }
        roomsList.add(resultList);
        isLoading.value = true;
        return true;
      } else {
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  // PAYMENT TYPE
  Future<bool> getPaymentType({required Map<String, String> credentialHeaders}) async {
    isLoading.value = true;

    final response = await GlobalProvider().fetchPaymentType(headers: credentialHeaders);

    try {
      if (response != null) {
        paymentTypeList.add(response);
        if (kDebugMode) {
          print('Payment Type: ${paymentTypeList.first.data.paymentTypes.length}');
        }
        return true;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  // ROOM TYPE
  Future<bool> getRoomType({required Map<String, String> credentialHeaders}) async {
    isLoading.value = true;

    final response = await GlobalProvider().fetchRoomTypes(headers: credentialHeaders, limit: 2);

    try {
      if (response != null) {
        roomTypeList.add(response);
        return true;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  // TRANSLATION TERMS
  Future<bool> getTerms({required Map<String, String> credentialHeaders, int? languageID}) async {
    isLoading.value = true;

    final response = await GlobalProvider().fetchTerms(headers: credentialHeaders, langID: languageID);

    try {
      if (response != null) {
        translationTermsList.add(response);
        if (kDebugMode) {
          print('Total Terms: ${translationTermsList.first.data.translationTerms.length}');
        }
        return true;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  //  MUTATION AREA

  Future addTransaction({required Map<String, String> credentialHeaders}) async {
    isLoading.value = true;
    final dtNow = DateTime.now();

    // add contact first
    // var result = languageList.first.data.languages.where((element) => element.id == selecttedLanguageID.value);
    // var nationalCode = result.first.code;

    // int? resultID = await GlobalProvider().fetchNationalities(code: nationalCode);

    if (selecttedLanguageID.value != 0) {
      // selectedNationalities.value = resultID!;
      String? name = '$hostname-${seriesDetailsList.first.data.seriesDetails.first.docNo}';

      int? contactID = await GlobalProvider().addContacts(
          code: seriesDetailsList.first.data.seriesDetails.first.docNo,
          firstName: name,
          lastName: "Terminal",
          middleName: 'Kiosk',
          prefixID: 1,
          suffixID: 1,
          nationalityID: selecttedLanguageID.value,
          genderID: 1,
          discriminitor: 'Contact',
          headers: credentialHeaders);

      String? basePhoto = await HomeController().takePicture();

      var response = await GlobalProvider().addContactPhotoes(
          contactID: contactID, isActive: true, photo: basePhoto, createdDate: dtNow, createdBy: hostname.value);

      if (response) {
        // update series
        await GlobalProvider().updateSeriesDetails(
            idNo: seriesDetailsList.first.data.seriesDetails.first.id,
            docNo: seriesDetailsList.first.data.seriesDetails.first.docNo,
            isActive: false,
            modifiedBy: hostname.value,
            modifiedDate: dtNow);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // ---------------------------------------------------------------------------------------------------------
  bool getMenu({int? languageID, String? code, String? type, int? indexCode}) {
    pageTrans.clear();
    titleTrans.clear();
    if (transactionList.isNotEmpty) {
      // TITLE
      if (type == "TITLE") {
        titleTrans.addAll(
            transactionList[0].data.conversion.where((element) => element.code == code && element.type == 'TITLE'));
      } else {
        titleTrans.addAll(transactionList[0]
            .data
            .conversion
            .where((element) => element.languageId == languageID && element.code == code && element.type == 'TITLE'));
        // titleTrans.addAll(
        //     transactionList[0].data.conversion.where((element) => element.code == code && element.type == 'TITLE'));
      }
      // for (var ctr = 0; ctr < titleTrans.length; ctr++) {
      //   var valueString = await titleTrans[ctr].translationText.translate(
      //       from: screenController.defaultLanguageCode.value.toLowerCase(),
      //       to: selectedLanguageCode.value.toLowerCase());
      //   titleTrans[ctr].translationText = valueString.toString();
      //   print(valueString);
      // }
      if (kDebugMode) {
        print('TOTAL MENU : ${titleTrans.length}');
      }

      // ITEM
      pageTrans.addAll(
        transactionList[0]
            .data
            .conversion
            .where((element) => element.languageId == languageID && element.code == code && element.type == type),
      );
      // pageTrans.addAll(
      //   transactionList[0].data.conversion.where((element) => element.code == code && element.type == type),
      // );

      // for (var ctr = 0; ctr < pageTrans.length; ctr++) {
      //   var valueString = await pageTrans[ctr].translationText.translate(
      //       from: screenController.defaultLanguageCode.value.toLowerCase(),
      //       to: selectedLanguageCode.value.toLowerCase());
      //   pageTrans[ctr].translationText = valueString.toString();
      // }
      if (kDebugMode) {
        print('TOTAL MENU ITEMS ($code : $type) : ${pageTrans.length} : INDEX: $indexCode');
      }

      return true;
    } else {
      return false;
    }
    // return true;
  }
  // ---------------------------------------------------------------------------------------------------------
}

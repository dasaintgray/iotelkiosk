// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iotelkiosk/app/data/models_graphql/accomtype_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/languages_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/roomtypes_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/seriesdetails_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/transaction_model.dart';
import 'package:iotelkiosk/app/data/models_rest/roomavailable_model.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/app/providers/providers_global.dart';
import 'package:iotelkiosk/globals/services/controller/base_controller.dart';

import 'package:timezone/data/latest.dart' as tzd;
import 'package:timezone/standalone.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:camera_platform_interface/camera_platform_interface.dart';

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

  // TRANSACTION VARIABLE
  final hostname = ''.obs;
  final selecttedLanguageID = 1.obs;
  final selectedTransactionType = ''.obs;
  final selectedRoomType = ''.obs;
  final selectedAccommodationType = 0.obs;
  final selectedNationalities = 77.obs;

  // MODEL LIST
  final pageTrans = <Translation>[].obs;
  final titleTrans = <Translation>[].obs;
  final btnMessage = <Translation>[].obs;

  final languageList = <LanguageModel>[].obs;
  final transactionList = <TransactionModel>[].obs;
  final accommodationTypeList = <AccomTypeModel>[].obs;
  final seriesDetailsList = <SeriesDetailsModel>[].obs;
  final roomAvailableList = <RoomAvailableModel>[].obs;
  final roomTypeList = <RoomTypesModel>[].obs;

  final roomsList = [].obs; //DYNAMIC KASI PABABAGO ANG OUTPUT
  final resultList = [].obs;

  // CAMERA GLOBAL VARIABLES
  final cameraInfo = 'Unkown'.obs;
  final cameraList = [].obs;
  final isInitialized = false.obs;
  final cameraID = 0.obs;
  late Size previewSize;

  StreamSubscription<CameraClosingEvent>? errorStreamSubscription;
  StreamSubscription<CameraClosingEvent>? cameraClosingEvent;

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
    getSeriesDetails();
    getAvailableRooms();
    // getRooms();
  }

  @override
  void onReady() {
    // ignore: unnecessary_overrides
    super.onReady();
    getCamera();
    hostname.value = Platform.localHostname;
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

  bool checkMonitor() {
    final monitorData = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

    final bool isMonitor = monitorData.size.shortestSide > 600;
    if (isMonitor) {
      return true;
    } else {
      return false;
    }
  }

  // INITIALIZING CAMERAS
  // AUTHOR: Henry V. Mempin

  Future<void> getCamera() async {
    try {
      cameraList.value = await CameraPlatform.instance.availableCameras();
      if (cameraList.isEmpty) {
        cameraInfo.value = 'No Available Camera';
      } else {
        debugPrint(cameraList.toString());
      }
    } on PlatformException catch (e) {
      cameraInfo.value = 'Failed to get cameras : ${e.code} : ${e.message}';
    }
  }

  Future<void> initializeCamera() async {
    assert(!isInitialized.value);

    if (cameraList.isEmpty) {
      return;
    }

    try {
      final CameraDescription camera = cameraList[0];

      cameraID.value = await CameraPlatform.instance.createCamera(camera, ResolutionPreset.veryHigh);
      errorStreamSubscription?.cancel();
      // errorStreamSubscription = CameraPlatform.instance.onCameraClosing(cameraID.value).listen((event) { })

      final Future<CameraInitializedEvent> initialized =
          CameraPlatform.instance.onCameraInitialized(cameraID.value).first;

      await CameraPlatform.instance.initializeCamera(cameraID.value);

      final CameraInitializedEvent event = await initialized;
      previewSize = Size(event.previewHeight, event.previewWidth);
    } on CameraException catch (e) {
      if (cameraID.value >= 0) {
        await CameraPlatform.instance.dispose(cameraID.value);
      } else {
        debugPrint('Failed to dispose camera ${e.code} : ${e.description}');
      }
    }
  }

  Future<void> disposeCamera() async {
    if (cameraID.value >= 0) {
      try {
        await CameraPlatform.instance.dispose(cameraID.value);
      } on CameraException catch (e) {
        cameraInfo.value = 'Failed to dispose camera ${e.code} : ${e.description}';
      }
    }
  }

  Future<String?> takePicture() async {
    final XFile pictureFile = await CameraPlatform.instance.takePicture(cameraID.value);
    final imgBytes = File(pictureFile.path).readAsBytesSync();

    final img64 = base64Encode(imgBytes);
    if (img64.isNotEmpty) {
      return img64.toString();
    } else {
      return '';
    }
  }

  // END OF INITIALIZING CAMERAS

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
    final response = await GlobalProvider().fetchAccommodationType(3);

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

  Future<bool> getSeriesDetails() async {
    isLoading.value = true;

    final response = await GlobalProvider().fetchSeriesDetails();

    try {
      if (response != null) {
        seriesDetailsList.add(response);
        print(response.data.seriesDetails.first.docNo);
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
        print('AVAILABLE ROOMS: ${roomAvailableList.length}');
        roomAvailableList.shuffle();
        print(roomAvailableList.first.description);
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

  Future<bool> getRooms() async {
    isLoading.value = true;

    final responseValue = await GlobalProvider().fetchRooms(isInclude: false, includeFragments: true);

    try {
      if (responseValue != null) {
        // var listBooks = (result['data']['books'] as List).map((e) => Books.fromMap(e)).toList();
        var resultList = (responseValue['data']['Rooms'] as List);
        resultList.shuffle();
        print(resultList[0]['description']);
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

  Future addTransaction() async {
    isLoading.value = true;
    final dtNow = DateTime.now();

    // add contact first
    var result = languageList.first.data.languages.where((element) => element.id == selecttedLanguageID.value);
    var nationalCode = result.first.code;

    int? resultID = await GlobalProvider().fetchNationalities(code: nationalCode);

    if (resultID != 0) {
      selectedNationalities.value = resultID!;
      String? name = '$hostname-${seriesDetailsList.first.data.seriesDetails.first.docNo}';

      int? contactID = await GlobalProvider().addContacts(
          code: seriesDetailsList.first.data.seriesDetails.first.docNo,
          firstName: name,
          lastName: "Terminal",
          middleName: 'Kiosk',
          prefixID: 1,
          suffixID: 1,
          nationalityID: selectedNationalities.value,
          createdDate: dtNow,
          createdBy: hostname.value,
          genderID: 1,
          discriminitor: 'Contact');

      String? basePhoto = await takePicture();

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
      return true;
    } else {
      return false;
    }
    // return true;
  }
  // ---------------------------------------------------------------------------------------------------------
}

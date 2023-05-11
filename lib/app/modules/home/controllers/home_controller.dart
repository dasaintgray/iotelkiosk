// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iotelkiosk/app/data/models_graphql/accomtype_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/availablerooms_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/languages_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/paymentType_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/roomtype_model.dart';
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
import 'package:translator/translator.dart';

// FFI AND WIN32
import 'package:ffi/ffi.dart' as fi;
import 'package:win32/win32.dart';
import 'dart:ffi' as dartffi;

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
  final selectedLanguageCode = 'en'.obs;
  final selectedTransactionType = ''.obs;
  final selectedRoomType = ''.obs;
  final selectedAccommodationType = 0.obs;
  final selectedNationalities = 77.obs;

  // MODEL LIST
  final pageTrans = <Conversion>[].obs;
  final titleTrans = <Conversion>[].obs;
  final btnMessage = <Conversion>[].obs;

  final languageList = <LanguageModel>[].obs;
  final transactionList = <TransactionModel>[].obs;
  final accommodationTypeList = <AccomTypeModel>[].obs;
  final seriesDetailsList = <SeriesDetailsModel>[].obs;
  final roomAvailableList = <RoomAvailableModel>[].obs;

  final roomTypeList = <RoomTypesModel>[].obs;
  final paymentTypeList = <PaymentTypeModel>[].obs;

  final availableRoomList = <AvailableRoomsModel>[].obs;

  final roomsList = [].obs; //DYNAMIC KASI PABABAGO ANG OUTPUT
  final resultList = [].obs;

  // CAMERA GLOBAL VARIABLES
  final cameraInfo = 'Unkown'.obs;
  final cameraList = [].obs;
  final isInitialized = false.obs;
  final cameraID = 0.obs;
  late Size previewSize;

  // SERIAL TEST

  StreamSubscription<CameraClosingEvent>? errorStreamSubscription;
  StreamSubscription<CameraClosingEvent>? cameraClosingEvent;

  // UI
  late TextEditingController textEditingController = TextEditingController();

  // ScreenController screenController = Get.put(ScreenController());
  final ScreenController screenController = Get.find<ScreenController>();

  // TRANSLATOR
  final translator = GoogleTranslator();

  @override
  void onInit() {
    super.onInit();
    initTimezone();
    startTimer();
    getLanguages();
    getTransaction();
    getAccommodation();
    getSeriesDetails();
    getRoomType();
    // getAvailableRooms();
    getPaymentType();
    getAvailableRoomsGraphQL();
    // getRooms();
  }

  @override
  void onReady() {
    // ignore: unnecessary_overrides
    super.onReady();
    getCamera();
    hostname.value = Platform.localHostname;
    // var os = Platform.operatingSystem;
    // var system = Platform.operatingSystemVersion;
    // openSerialPort();
  }

  @override
  void onClose() {
    super.onClose();
    stopTimer();
    screenController.dispose();
  }

  // SERIAL PORT TEST
  Future openSerialPort() async {
    // final portName = SerialPort.availablePorts.first;
    // SerialPort serialPort = SerialPort(portName);
    // var response = await serialPort.open(mode: SerialPortMode.readWrite);

    // final port = SerialPort(portName);
    // port.config.baudRate = 9600;

    // var result = port.openReadWrite();
    // if (result) {
    //   try {
    //     port.write(stringToUint8List('0XC0'));

    //     final portReader = SerialPortReader(port);
    //     Stream<String> dataRead = portReader.stream.map(
    //       (event) {
    //         return String.fromCharCodes(event);
    //       },
    //     );

    //     dataRead.listen(
    //       (event) {
    //         print('read data: $event');
    //       },
    //     );
    //   } on SerialPortError catch (err, _) {
    //     print(SerialPort.lastError);
    //     port.close();
    //   }
    // }
  }

  Uint8List stringToUint8List(String data) {
    List<int> codeUnits = data.codeUnits;
    Uint8List uint8list = Uint8List.fromList(codeUnits);
    return uint8list;
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

  // bool checkMonitor() {
  //   final monitorData = MediaQueryData.fromView();

  //   final bool isMonitor = monitorData.size.shortestSide > 600;
  //   if (isMonitor) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // FIND THE WINDOW HANDLE USING THE WIN32 AND FFI
  int? findVideoPlayer({String? pamagat}) {
    final source = pamagat.toString().toNativeUtf16();

    final hwnd = FindWindowEx(0, 0, source, dartffi.nullptr);

    if (hwnd == 0) {
      print('cannot find window');
    } else {
      return hwnd;
    }
    return 0;
  }

  int enumWindowsProc(int hWnd, int lParam) {
    // Don't enumerate windows unless they are marked as WS_VISIBLE
    if (IsWindowVisible(hWnd) == FALSE) return TRUE;

    final length = GetWindowTextLength(hWnd);
    if (length == 0) {
      return TRUE;
    }

    final buffer = wsalloc(length + 1);
    GetWindowText(hWnd, buffer, length + 1);
    print('hWnd $hWnd: ${buffer.toDartString()}');
    free(buffer);

    return TRUE;
  }

  // void enumerateWindows() {
  //   final wndProc = dartffi.Pointer.fromFunction<EnumWindowsProc>(enumWindowsProc, 0);
  //   // dartffi.Pointer.fromFunction<EnumWindowsProc>(enumWindowsProc, 0);
  //   EnumWindows(wndProc, 0);
  // }
  // FIND THE WINDOW HANDLE USING THE WIN32 AND FFI

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
      File(pictureFile.path).delete();
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
        print('TRANSLATION RECORDS: ${transactionList.first.data.conversion.length}');
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
    // const inputHenry = 'Acknowledgement';

    try {
      if (response != null) {
        // await translator.translate('sex', from: 'en', to: 'zh-cn').then((value) => print(value));
        // print(await inputHenry.translate(from: 'en', to: 'ja'));

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

  Future<bool?> getAvailableRoomsGraphQL() async {
    isLoading.value = true;

    final dtnow = DateTime.now();

    final response = await GlobalProvider().fetchAvailableRoomsGraphQL(
        agentID: 1, roomTypeID: 1, accommodationTypeID: 1, startDate: dtnow, endDate: dtnow);

    try {
      if (response != null) {
        availableRoomList.add(response);
        availableRoomList.shuffle();
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } finally {
      isLoading.value = false;
    }
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

  // PAYMENT TYPE
  Future<bool> getPaymentType() async {
    isLoading.value = true;

    final response = await GlobalProvider().fetchPaymentType();
    try {
      if (response != null) {
        paymentTypeList.add(response);
        return true;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  // ROOM TYPE
  Future<bool> getRoomType() async {
    isLoading.value = true;

    final response = await GlobalProvider().fetchRoomTypes();

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

  Future addTransaction() async {
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
      print('TOTAL MENU : ${titleTrans.length}');

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
      print('TOTAL MENU ITEMS ($code : $type) : ${pageTrans.length} : INDEX: $indexCode');

      return true;
    } else {
      return false;
    }
    // return true;
  }
  // ---------------------------------------------------------------------------------------------------------
}

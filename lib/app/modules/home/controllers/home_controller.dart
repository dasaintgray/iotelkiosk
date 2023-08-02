// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:iotelkiosk/app/data/models_graphql/terminaldata_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/terminals_model.dart';
import 'package:iotelkiosk/app/data/models_rest/apiresponse_model.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/app/modules/screen/views/screen_view.dart';
import 'package:iotelkiosk/app/providers/providers_global.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/services/controller/base_controller.dart';
import 'package:system_idle/system_idle.dart';

import 'package:timezone/data/latest.dart' as tzd;
import 'package:timezone/standalone.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:translator/translator.dart';

// FFI AND WIN32

class HomeController extends GetxController with BaseController {
  DateTime japanNow = DateTime.now();
  DateTime newyorkNow = DateTime.now();
  DateTime seoulNow = DateTime.now();
  DateTime sydneyNow = DateTime.now();

  // LOCAL TIME
  DateTime localTime = DateTime.now();

  // late Timer timer;
  late final idleTime = 0;

  // BOOLEAN
  final isLoading = false.obs;
  final isIdleActive = false.obs;
  final isMenuLanguageVisible = true.obs;
  final isMenuTransactionVisible = true.obs;
  final roomTypeTranslatedText = ''.obs;

  // INT
  final menuIndex = 0.obs;

  // CAMERA GLOBAL VARIABLES
  final cameraInfo = 'Unkown'.obs;
  final cameraList = [].obs;
  final isInitialized = false.obs;
  final cameraID = 0.obs;
  late Size previewSize;

  final accessToken = ''.obs;
  late final Map<String, String> globalHeaders;

  // LIST
  final apiResponseList = <ApiResponseModel>[].obs;
  final terminalDataList = <TerminalDataModel>[].obs;
  final terminalsList = <TerminalsModel>[];

  // MAP
  final snapshotData = [];

  // SERIAL TEST
  StreamSubscription<CameraClosingEvent>? errorStreamSubscription;
  StreamSubscription<CameraClosingEvent>? cameraClosingEvent;

  // UI
  late TextEditingController textEditingController = TextEditingController();

  // ScreenController screenController = Get.put(ScreenController());
  final ScreenController screenController = Get.find<ScreenController>();

  final SystemIdle systemIdle = SystemIdle.instance;

  final translator = GoogleTranslator();

  @override
  void onInit() async {
    super.onInit();

    initTimezone();
    configureSystemIdle();

    // startTimer();

    if (screenController.userLoginList.isNotEmpty) {
      accessToken.value = screenController.userLoginList.first.accessToken;
      globalHeaders = {'Content-Type': 'application/json', 'Authorization': 'Bearer ${accessToken.value}'};
      getTerminalData(headers: globalHeaders, terminalID: 3);
    }
    // await getTerms(credentialHeaders: headers, languageID: 6);
  }

  @override
  void onReady() async {
    // ignore: unnecessary_overrides
    super.onReady();
    await getCamera();
    await getTerminals();

    // globalAccessToken = HenryStorage.readFromLS(titulo: HenryGlobal.jwtToken);
    // globalHeaders = {'Content-Type': 'application/json', 'Authorization': 'Bearer $globalAccessToken'};

    // var os = Platform.operatingSystem;
    // var system = Platform.operatingSystemVersion;
    // openSerialPort();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  //   // stopTimer();
  //   // screenController.dispose();
  // }

  Map<String, String>? getAccessToken() {
    if (screenController.userLoginList.isNotEmpty) {
      accessToken.value = screenController.userLoginList.first.accessToken;
      Map<String, String> globalToken = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken.value}'
      };
      return globalToken;
    } else {
      return null;
    }
  }

  Future<dynamic> getTerminalData(
      {required Map<String, String> headers, required int terminalID, int delay = 5, int iteration = 50}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    Map<String, dynamic> variables = {
      "terminalID": terminalID,
      "status": "NEW",
      "delay": delay,
      "iteration": iteration
    };
    Snapshot terminalDataSnapShot = await hasuraConnect.subscription(terminalData, variables: variables);

    // LISTENING
    terminalDataSnapShot.listen(
      (event) {
        var eventData = terminalDataModelFromJson(jsonEncode(event['data']['TerminalData']));
        if (eventData.isNotEmpty) {
          // print('event data: $eventData');
          terminalDataList.clear();
          terminalDataList.addAll(eventData);
          print(terminalDataList.length);
          print(terminalDataList.first.code);
        }
      },
    ).onError(handleError);
  }

  Future<String?> convertText(
      {required String? sourceText, required String? fromLangCode, required String? toLanguageCode}) async {
    String textString;

    if (sourceText != null) {
      var textConverted = await translator.translate(sourceText, from: fromLangCode!, to: toLanguageCode!);
      textString = textConverted.text;
      return textString;
    }
    return null;
  }

  void configureSystemIdle() async {
    await systemIdle.initialize(time: 30);

    systemIdle.onIdleStateChanged.listen((event) {
      if (kDebugMode) {
        print('SYSTEM IDLE?: $event');
      }
      screenController.player.play(); //play the video
      screenController.getMenu(code: 'SLMT', type: 'TITLE'); //go back to main selection
      isIdleActive.value = event;
      //CLOSE THE HOMECONTROLLER INTO THE MEMORY AND STAY THE SCREENCONTROLLER ALIVE
      Get.off(() => ScreenView());
    });
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

  Future<bool?> cashDispenserCommand({required String? sCommand, required String? sTerminal}) async {
    isLoading.value = true;
    final cashResponse = await GlobalProvider()
        .cashDispenserCommand(cashCommand: sCommand!.toUpperCase(), sTerminalCode: sTerminal!.toUpperCase());
    try {
      if (cashResponse != null) {
        apiResponseList.add(cashResponse);
        return true;
      } else {
        return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool?> getTerminals() async {
    // final response = await GlobalProvider().fetchGraphQLData(documents: qryTerminals, headers: getAccessToken());
    isLoading.value = true;
    Map<String, String>? accessHeaders = getAccessToken();
    final response = await GlobalProvider().fetchTerminals(headers: accessHeaders!);
    try {
      if (response != null) {
        terminalsList.add(response);
        print(terminalsList.first.data.terminals.first.code);
        return true;
      } else {
        return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  // void startTimer() {
  //   // Start a 5-second timer
  //   // timer = Timer(const Duration(seconds: 30), () {
  //   //   // Navigate back to the previous screen
  //   //   Get.back();
  //   // });

  //   timer = Timer.periodic(const Duration(minutes: 30), (timer) {
  //     initTimezone();
  //     screenController.player.play();
  //     menuIndex.value = 0;
  //     Get.back();
  //   });
  // }

  // void stopTimer() {
  //   // Cancel the timer if it's still running
  //   // ignore: unnecessary_null_comparison
  //   if (timer != null && timer.isActive) {
  //     timer.cancel();
  //   }
  // }

  // void resetTimer() {
  //   // Cancel the existing timer and start a new one
  //   stopTimer();
  //   startTimer();
  // }
}

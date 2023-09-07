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
import 'package:iotelkiosk/globals/constant/bank_note_constant.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/services/controller/base_controller.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:system_idle/system_idle.dart';

// ignore: depend_on_referenced_packages
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:translator/translator.dart';

import 'package:timezone/data/latest.dart' as tzd;
import 'package:timezone/standalone.dart' as tz;

// FFI AND WIN32

class HomeController extends GetxController with BaseController {
  // late Timer timer;
  late final idleTime = 0;

  // BOOLEAN
  final isLoading = false.obs;
  final isIdleActive = false.obs;
  final isMenuLanguageVisible = true.obs;
  final isMenuTransactionVisible = true.obs;
  final isConfirmReady = false.obs;
  final isOverPaymentDetected = false.obs;
  final clockLiveUpdate = false.obs;

  // INT
  final menuIndex = 0.obs;

  // DOUBLE
  final nabasangPera = 0.0.obs;
  final overPayment = 0.0.obs;

  // MONEY DUE
  final iP20 = 0.obs;
  final iP50 = 0.obs;
  final iP100 = 0.obs;
  final iP200 = 0.obs;
  final iP500 = 0.obs;
  final iP1000 = 0.obs;
  final iTotal = 0.obs;

  // CAMERA GLOBAL VARIABLES
  final cameraInfo = 'Unkown'.obs;
  final cameraList = [].obs;
  final isInitialized = false.obs;
  final cameraID = 0.obs;
  late Size previewSize;

  final accessToken = ''.obs;
  final defaultTerminalID = 0.obs;
  late final Map<String, String> globalHeaders;

  // LIST
  final terminalDataList = <TerminalDataModel>[].obs;
  final apiResponseList = <ApiResponseModel>[];
  final terminalsList = <TerminalsModel>[];
  // final denominationList = <DenominationModel>[];

  // MAP
  final snapshotData = [];

  // LOCAL TIME
  final japanNow = DateTime.now().obs;
  final newyorkNow = DateTime.now().obs;
  final seoulNow = DateTime.now().obs;
  final sydneyNow = DateTime.now().obs;
  final localTime = DateTime.now().obs;

  // STRING
  final roomTypeTranslatedText = ''.obs;

  // SERIAL TEST
  StreamSubscription<CameraClosingEvent>? errorStreamSubscription;
  StreamSubscription<CameraClosingEvent>? cameraClosingEvent;

  // UI
  late TextEditingController textEditingController = TextEditingController();
  // ScreenController screenController = Get.put(ScreenController());
  // final ScreenController screenController = Get.find<ScreenController>();
  final ScreenController screenController = Get.put(ScreenController());
  final SystemIdle systemIdle = SystemIdle.instance;
  final translator = GoogleTranslator();

  @override
  void onInit() async {
    super.onInit();

    clockLiveUpdate.value = true;

    initTimezone();
    configureSystemIdle(idlingTime: 120);
    await getTerminals();

    // startTimer();
    if (screenController.userLoginList.isNotEmpty) {
      accessToken.value = screenController.userLoginList.first.accessToken;
      globalHeaders = {'Content-Type': 'application/json', 'Authorization': 'Bearer ${accessToken.value}'};
      defaultTerminalID.value = terminalsList.first.data.terminals.first.id;

      await getDenominationData(terminalID: defaultTerminalID.value);

      // getTerminalData(
      //     headers: globalHeaders, terminalID: defaultTerminalID.value.isEqual(0) ? 1 : defaultTerminalID.value);
    }

    nabasangPera.value = 0;
    // await getTerms(credentialHeaders: headers, languageID: 6);
  }

  @override
  void onReady() async {
    // ignore: unnecessary_overrides
    super.onReady();
    await getCamera();
    // await printIPS();
    var response = await getIPFromInterface(interfaceName: 'Wi-Fi');
    print(response);

    // await getSignalRData(hubConnectURL: 'https://cargo-chatsupport.circuitmindz.com/agenthub');

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

  void initTimezone() {
    tzd.initializeTimeZones();
    final japan = tz.getLocation('Asia/Tokyo');
    final newyork = tz.getLocation('America/New_York');
    final seoul = tz.getLocation('Asia/Seoul');
    final sydney = tz.getLocation('Australia/Sydney');

    japanNow.value = tz.TZDateTime.now(japan);
    newyorkNow.value = tz.TZDateTime.now(newyork);
    seoulNow.value = tz.TZDateTime.now(seoul);
    sydneyNow.value = tz.TZDateTime.now(sydney);
  }

  // DISPLAY THE IP OF ALL INTERFACES
  Future printIPS() async {
    for (var interfaces in await NetworkInterface.list()) {
      print('== interface: ${interfaces.name} ==');
      for (var addr in interfaces.addresses) {
        print('${addr.address} ${addr.host} ${addr.rawAddress} ${addr.isLoopback} ${addr.type.name}');
      }
    }
  }

  Future<String?> getIPFromInterface({required String interfaceName}) async {
    for (var interfaces in await NetworkInterface.list()) {
      for (var addr in interfaces.addresses) {
        if (interfaceName == interfaces.name) {
          return addr.address;
        }
      }
    }
    return null;
  }

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
      {required Map<String, String>? headers,
      required int? terminalID,
      int delay = 5,
      int iteration = 60,
      required String? sCode}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    Map<String, dynamic> variables = {
      "terminalID": terminalID,
      "status": "NEW",
      "delay": delay,
      "iteration": iteration,
      "code": sCode
    };

    // Map<String, dynamic> variables = sCode.isEmpty
    //     ? {"terminalID": terminalID, "status": "NEW", "delay": delay, "iteration": iteration}
    //     : {"terminalID": terminalID, "status": "NEW", "delay": delay, "iteration": iteration, "code": sCode};

    Snapshot terminalDataSnapShot = await hasuraConnect.subscription(terminalData, variables: variables);

    // LISTENING
    terminalDataSnapShot.listen(
      (event) {
        var eventData = terminalDataModelFromJson(jsonEncode(event['data']['TerminalData']));
        if (eventData.isNotEmpty) {
          terminalDataList.clear();
          terminalDataList.addAll(eventData);
          if (kDebugMode) print(terminalDataList.first.code);
          if (terminalDataList.isNotEmpty) {
            if (sCode == "CASI") {
              if (kDebugMode) print(terminalDataList.first.value);
              var valueRead = terminalDataList.first.value;
              if (kDebugMode) print('READ STATUS: $valueRead');
              if (valueRead.isCurrency) {
                if (kDebugMode) print('READ DENOM: $valueRead');
                nabasangPera.value == 0
                    ? nabasangPera.value = double.parse(valueRead)
                    : nabasangPera.value = nabasangPera.value + double.parse(valueRead);

                if (kDebugMode) print('COMPUTED DENOM: ${nabasangPera.value}');
                // ADD DENOMINATION COUNT IN DB
                updateDenominationData(
                    klaseNgPera: valueRead, iCount: 1, terminalID: defaultTerminalID.value, bCounterIncrement: true);

                // UPDATE THE TERMINAL DATA
                updateTerminalData(recordID: terminalDataList.first.id, terminalID: terminalDataList.first.terminalId);

                if (nabasangPera.value >= screenController.totalAmountDue.value) {
                  if (nabasangPera.value == screenController.totalAmountDue.value) {
                    isOverPaymentDetected.value = false;
                  } else {
                    overPayment.value = nabasangPera.value - screenController.totalAmountDue.value;
                    isOverPaymentDetected.value = true;
                  }
                  isConfirmReady.value = true;
                } else {
                  isConfirmReady.value = false;
                }
              } else {
                if (kDebugMode) print(terminalDataList.first.value);
              }
              updateTerminalData(recordID: terminalDataList.first.id, terminalID: terminalDataList.first.terminalId);
            }
          }
        }
      },
    ).onError(handleError);
  }

  Future<bool> updateDenominationData(
      {required String klaseNgPera,
      required int iCount,
      required int terminalID,
      required bool bCounterIncrement}) async {
    // ignore: constant_pattern_never_matches_value_type
    final String docs;

    print(klaseNgPera);

    switch (klaseNgPera) {
      case "20.00" || "20.0" || "20":
        {
          iP20.value = bCounterIncrement ? iP20.value + iCount : iP20.value - iCount;
          docs =
              'mutation updateDenomination {TerminalDenominations(mutate: {${Pera.bente.value} : ${iP20.value} } where: {TerminalId: $terminalID}) {Ids response}}';
        }
        break;
      case "50.00" || "50.0" || "50":
        {
          iP50.value = bCounterIncrement ? iP50.value + iCount : iP50.value - iCount;
          docs =
              'mutation updateDenomination {TerminalDenominations(mutate: {${Pera.tapwe.value} : ${iP50.value} } where: {TerminalId: $terminalID}) {Ids response}}';
        }
        break;
      case "100.00" || "100.0" || "100":
        {
          iP100.value = bCounterIncrement ? iP100.value + iCount : iP100.value - iCount;
          docs =
              'mutation updateDenomination {TerminalDenominations(mutate: {${Pera.isangdaan.value} : ${iP100.value} } where: {TerminalId: $terminalID}) {Ids response}}';
        }
        break;
      case "200.00" || "200.0" || "200":
        {
          iP200.value = bCounterIncrement ? iP200.value + iCount : iP200.value - iCount;
          docs =
              'mutation updateDenomination {TerminalDenominations(mutate: {${Pera.dalawangdaan.value}: ${iP200.value} } where: {TerminalId: $terminalID}) {Ids response}}';
        }
        break;
      case "500.00" || "500.0" || "500":
        {
          iP500.value = bCounterIncrement ? iP500.value + iCount : iP500.value - iCount;
          docs =
              'mutation updateDenomination {TerminalDenominations(mutate: {${Pera.limangdaan.value} : ${iP500.value} } where: {TerminalId: $terminalID}) {Ids response}}';
        }
        break;
      case "1000.00" || "1000.0" || "1000":
        {
          iP1000.value = bCounterIncrement ? iP1000.value + iCount : iP1000.value - iCount;
          docs =
              'mutation updateDenomination {TerminalDenominations(mutate: {${Pera.isanglibo.value} : ${iP1000.value} } where: {TerminalId: $terminalID}) {Ids response}}';
        }
        break;
      default:
        {
          docs =
              'mutation updateDenomination {TerminalDenominations(mutate: {TerminalId : $terminalID } where: {TerminalId: $terminalID}) {Ids response}}';
        }
        break;
    }

    if (kDebugMode) print(docs);

    var response = GlobalProvider().mutateGraphQLData(documents: docs, accessHeaders: globalHeaders);
    // ignore: unnecessary_null_comparison
    if (response != null) {
      // iTotal.value = iP20.value + iP50.value + iP100.value + iP200.value + iP500.value + iP1000.value;
      return true;
    } else {
      return false;
    }
  }

  Future<void> getSignalRData({required String hubConnectURL}) async {
    final connection = HubConnectionBuilder()
        .withUrl(
            hubConnectURL,
            HttpConnectionOptions(
                transport: HttpTransportType.longPolling,
                // client: IOClient(HttpClient()..badCertificateCallback = (x, y, z) => true),
                // logging: (level, message) => print(message),
                // logMessageContent: true,
                // skipNegotiation: true,
                withCredentials: false))
        .build();

    await connection.start();

    connection.on('Announcement', (message) {
      print(message.toString());
      print(message?[1].toString());
    });
    // await connection.invoke('Announcement', args: ['iotelkiosk', 'Jakolista']);
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

  void configureSystemIdle({required int? idlingTime}) async {
    await systemIdle.initialize(time: idlingTime!);

    systemIdle.onIdleStateChanged.listen((event) {
      if (kDebugMode) {
        print('SYSTEM IDLE?: $event');
      }
      screenController.player.play(); //play the video
      screenController.getMenu(code: 'SLMT', type: 'TITLE'); //go back to main selection
      isIdleActive.value = event;
      //CLOSE THE HOMECONTROLLER INTO THE MEMORY AND STAY THE SCREENCONTROLLER ALIVE
      // Get.off(() => ScreenView());
      Get.offAll(() => ScreenView());
      // Get.back();
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

  Future<bool?> cashDispenserCommand({required String? sCommand, required int? iTerminalID}) async {
    isLoading.value = true;
    final cashResponse =
        await GlobalProvider().cashDispenserCommand(cashCommand: sCommand!.toUpperCase(), iTerminalID: iTerminalID!);
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

  Future<bool?> getDenominationData({required int terminalID}) async {
    isLoading.value = true;
    Map<String, String>? accessHeaders = getAccessToken();

    final response = await GlobalProvider().fetchDenominationData(headers: accessHeaders!, terminalID: terminalID);

    try {
      if (response != null) {
        // denominationList.add(response);
        iP20.value = response.terminalDenominations[0].p20;
        iP50.value = response.terminalDenominations[0].p50;
        iP100.value = response.terminalDenominations[0].p100;
        iP200.value = response.terminalDenominations[0].p200;
        iP500.value = response.terminalDenominations[0].p500;
        iP1000.value = response.terminalDenominations[0].p1000;
        iTotal.value = response.terminalDenominations[0].total;
        // print(denominationList.first.terminalDenominations.length);
        return true;
      } else {
        return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  // UPDATE THE TERMINAL DATA USING MUTATION
  // DATE: 14 AUGUST, 2023
  Future<bool?> updateTerminalData({required int recordID, required int terminalID}) async {
    Map<String, dynamic> params = {"STATUS": "READ", "ID": recordID, "TerminalID": terminalID};

    var accessToken = getAccessToken();

    var response = await GlobalProvider()
        .mutateGraphQLData(documents: updateTerminalDataGraphQL, variables: params, accessHeaders: accessToken);
    if (response != null) {
      print(response);
      return true;
    } else {
      return false;
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

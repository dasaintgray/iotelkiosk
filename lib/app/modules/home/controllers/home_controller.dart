// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:hex/hex.dart';
import 'package:intl/intl.dart';
import 'package:iotelkiosk/app/data/models_graphql/accomtype_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/availablerooms_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/cashpositions_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/charges_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/cutoff_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/languages_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/payment_type_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/roomtype_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/seriesdetails_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/settings_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/terminaldata_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/terminals_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/transaction_model.dart';
import 'package:iotelkiosk/app/data/models_rest/apiresponse_model.dart';
import 'package:iotelkiosk/app/data/models_rest/cardissueresponse_model.dart';
import 'package:iotelkiosk/app/data/models_rest/cardresponse_model.dart';
import 'package:iotelkiosk/app/data/models_rest/userlogin_model.dart';
import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:iotelkiosk/app/modules/screen/views/screen_view.dart';
import 'package:iotelkiosk/app/providers/providers_global.dart';
import 'package:iotelkiosk/globals/constant/api_constant.dart';
import 'package:iotelkiosk/globals/constant/bank_note_constant.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/constant/led_constant.dart';
import 'package:iotelkiosk/globals/constant/settings_constant.dart';
import 'package:iotelkiosk/globals/services/base/base_storage.dart';
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
  final isBottom = false.obs;
  final isDisclaimerClick = false.obs;
  final isButtonActive = true.obs;
  final kioskURL = ''.obs;

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

  // final accessToken = ''.obs;
  final defaultTerminalID = 0.obs;
  // final Map<String, String> globalHeaders;

  // LIST
  // final denominationList = <DenominationModel>[];
  final terminalDataList = <TerminalDataModel>[].obs;
  final apiResponseList = <ApiResponseModel>[];
  final terminalsList = <TerminalsModel>[];
  final seriesDetailsList = <SeriesDetailsModel>[].obs;
  final issueResponseList = <CardIssueResponseModel>[];

  final settingsList = <SettingsModel>[].obs;
  final paymentTypeList = <PaymentTypeModel>[].obs;
  final roomTypeList = <RoomTypesModel>[].obs;
  final languageList = <LanguageModel>[].obs;
  final userLoginList = <UserLoginModel>[].obs;
  final availableRoomList = <AvailableRoomsModel>[].obs;
  final availRoomList = <AvailableRoom>[].obs;
  final accommodationTypeList = <AccomTypeModel>[].obs;
  final chargesList = <ChargesModel>[];
  final chargesListV2 = <ChargesModel>[];
  final cutOffList = <CutOffModel>[];
  final cashpositionList = <CashPositionModel>[];
  final readCardInfoList = <CardResponseModel>[];

  final transactionList = <TransactionModel>[].obs;
  final pageTrans = <Conversion>[].obs;
  final titleTrans = <Conversion>[].obs;
  final btnMessage = <Conversion>[].obs;

  // TRANSACTION VARIABLE
  final selectedAccommodationTypeID = 1.obs;
  final selectedLanguageCode = 'en'.obs;
  final selecttedLanguageID = 1.obs;
  final selectedRoomType = ''.obs;
  final selectedRoomTypeID = 1.obs;
  final preSelectedRoomID = 0.obs;
  final totalAmountDue = 0.0.obs;
  final generatedBookingID = 0.obs;
  final kioskName = ''.obs;

  final bookingNumber = ''.obs;
  final contactNumber = ''.obs;
  final invoiceNumber = ''.obs;
  final globalFetchID = 0.obs;
  final paymentChargesID = 0.obs;

  final selectedPaymentTypeCode = ''.obs;
  final selectedPaymentTypeID = 0.obs;
  final serviceResponseStatusMessages = ''.obs;

  final statusMessage = 'Initializing \nCash Acceptor Device \nplease wait ....'.obs;

  final sCity = ''.obs;

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

  // SCROLL CONTROLLERS
  var scrollController = ScrollController();
  var accessTOKEN = <String, String>{};

  // TIMER TO USE TO FETCH OR READ CARD
  Timer? readCardTimer;

  @override
  void onInit() async {
    await userLogin();
    super.onInit();

    accessTOKEN = (await getAccessToken())!;

    initTimezone();
    configureSystemIdle(idlingTime: 120);

    await getSettings();

    var iFNAME = getSettingsValue(elementCode: SettingConstant.networkInterface);
    String? ipaResponse;
    if (iFNAME != null) {
      ipaResponse = await getIPFromInterface(interfaceName: iFNAME);
      ipaResponse == null ? ipaResponse = await getIPFromInterface(interfaceName: 'Wi-Fi') : null;
    }

    await getTerminals(ipAddress: ipaResponse, accessHeader: accessTOKEN);

    await getTransaction(credentialHeaders: accessTOKEN);
    await getLanguages(credentialHeaders: accessTOKEN);
    await getDenominationData(terminalID: defaultTerminalID.value);
    await getAvailableRoomsGraphQL(credentialHeaders: accessTOKEN, roomTYPEID: 1, accommodationTYPEID: 1);
    await getCharges(credentialHeaders: accessTOKEN, isActive: true, isDefault: true);
    // paymentChargesID.value = (await getChargesV2(credentialHeaders: accessTOKEN, codeValue: 'PYMT', ))!;

    // startTimer();
    // if (userLoginList.isNotEmpty) {
    //   accessToken.value = userLoginList.first.accessToken;
    //   globalHeaders = {'Content-Type': 'application/json', 'Authorization': 'Bearer ${accessToken.value}'};
    //   // getTerminalData(
    //   //     headers: globalHeaders, terminalID: defaultTerminalID.value.isEqual(0) ? 1 : defaultTerminalID.value);
    // }
    // await getTerms(credentialHeaders: headers, languageID: 6);

    // scrollController.addListener(
    //   () {
    //     if (scrollController.position.atEdge) {
    //       isBottom.value = scrollController.position.pixels == 0 ? false : true;
    //     }
    //   },
    // );
  }

  @override
  void onReady() async {
    // ignore: unnecessary_overrides
    super.onReady();
    // await getCamera();
    // await printIPS();
    // await getSignalRData(hubConnectURL: 'https://cargo-chatsupport.circuitmindz.com/agenthub');
    // globalAccessToken = HenryStorage.readFromLS(titulo: HenryGlobal.jwtToken);
    // globalHeaders = {'Content-Type': 'application/json', 'Authorization': 'Bearer $globalAccessToken'};
    // var os = Platform.operatingSystem;
    // var system = Platform.operatingSystemVersion;
    // openSerialPort();

    clockLiveUpdate.value = true;
    nabasangPera.value = 0;
  }

  @override
  void onClose() {
    super.onClose();
    readCardTimer?.cancel();
    // scrollController.dispose();
    // stopTimer();
    // screenController.dispose();
  }

  // ---------------------------------------------------------------------------------------------------------
  bool getMenu({int? languageID, String? code, String? type}) {
    pageTrans.clear();
    titleTrans.clear();
    if (code == 'SRT') {
      if (kDebugMode) print(code);
    }

    if (transactionList.isNotEmpty) {
      // TITLE
      if (code != 'SLMT' && type == "TITLE") {
        titleTrans.addAll(transactionList[0]
            .data
            .conversion
            .where((element) => element.languageId == languageID && element.code == code && element.type == 'TITLE'));
      } else {
        titleTrans.addAll(
            transactionList[0].data.conversion.where((element) => element.code == code && element.type == 'TITLE'));
      }
      if (kDebugMode) {
        print('TOTAL TITLE : ${titleTrans.length}');
      }
      // ITEM LABEL
      pageTrans.addAll(
        transactionList[0]
            .data
            .conversion
            .where((element) => element.languageId == languageID && element.code == code && element.type == 'ITEM'),
      );

      if (kDebugMode) {
        print('LANGUAGE ID: $languageID MENU ITEMS (code: $code | type: $type) : ITEM TRANS: ${pageTrans.length}');
      }
      return true;
    } else {
      return false;
    }
    // return true;
  }
  // ---------------------------------------------------------------------------------------------------------

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

  Future<Map<String, String>?> getAccessToken() async {
    var accessToken = await HenryStorage.readFromLS(titulo: HenryGlobal.jwtToken);
    if (accessToken != null) {
      // accessToken = accessToken;
      Map<String, String> globalToken = {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'};
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

                if (nabasangPera.value >= totalAmountDue.value) {
                  if (nabasangPera.value == totalAmountDue.value) {
                    isOverPaymentDetected.value = false;
                  } else {
                    overPayment.value = nabasangPera.value - totalAmountDue.value;
                    isOverPaymentDetected.value = true;
                  }
                  isConfirmReady.value = true;
                } else {
                  isConfirmReady.value = false;
                }
              } else {
                if (kDebugMode) print(terminalDataList.first.value);
                // statusMessage.value = terminalDataList.first.value;
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

    var accessToken = await getAccessToken();
    var response = GlobalProvider().mutateGraphQLData(documents: docs, accessHeaders: accessToken);
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
      getMenu(code: 'SLMT', type: 'TITLE'); //go back to main selection
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

  Future<String?> takePicture({required int? camID}) async {
    // final XFile pictureFile = await CameraPlatform.instance.takePicture(cameraID.value);
    final XFile pictureFile = await CameraPlatform.instance.takePicture(camID!);
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
    // isLoading.value = true;
    final cashResponse =
        await GlobalProvider().cashDispenserCommand(cashCommand: sCommand!.toUpperCase(), iTerminalID: iTerminalID!);
    if (kDebugMode) print(cashResponse?.message.toString());
    if (kDebugMode) print(cashResponse?.statuscode.toString());

    try {
      if (cashResponse?.statuscode == 200) {
        apiResponseList.add(cashResponse!);
        serviceResponseStatusMessages.value = apiResponseList.first.message!;
        return true;
      } else {
        return false;
      }
    } finally {
      // isLoading.value = false;
    }
  }

  Future<bool> readCard({required String? url, required String? sCommand, required int? terminalID}) async {
    final readResponse = await GlobalProvider().readCardInfo(url: url, cardCommand: sCommand, terminalID: terminalID);
    if (readResponse != null) {
      readCardInfoList.add(readResponse);
      return true;
    }
    return false;
  }

  Future<bool> issueCard(
      {required String? command,
      required int? iTerminalID,
      required String? roomNo,
      required String checkInTime,
      required String checkOuttime,
      required String? guestName,
      String? commonDoor,
      String? liftReader}) async {
    isLoading.value = true;

    final bodyPayload = {
      "RoomNo": roomNo,
      "CheckInDateTime": checkInTime,
      "CheckOutDateTime": checkOuttime,
      "OverrideKeys": "",
      "GuestName": guestName,
      "CommonDoor": commonDoor,
      "LiftReader": liftReader,
    };

    // var jdata = jsonEncode(bodyPayload);
    // print(jdata);

    final issueResponse =
        await GlobalProvider().issueRoomCard(cardCommand: command, iTerminalID: iTerminalID, bodyPayload: bodyPayload);

    try {
      if (issueResponse != null) {
        issueResponseList.add(issueResponse);
        return true;
      } else {
        return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool?> getTerminals({required String? ipAddress, required Map<String, String>? accessHeader}) async {
    // final response = await GlobalProvider().fetchGraphQLData(documents: qryTerminals, headers: getAccessToken());
    isLoading.value = true;
    // final Map<String, String>? accessHeaders = await getAccessToken();
    final response = await GlobalProvider().fetchTerminals(headers: accessHeader!, ipAddress: ipAddress);

    try {
      if (response != null) {
        terminalsList.add(response);
        defaultTerminalID.value = terminalsList.first.data.terminals.first.id;
        kioskName.value = terminalsList.first.data.terminals.first.code;
        print('TERMINAL ID: ${defaultTerminalID.value}');
        return true;
      } else {
        if (kDebugMode) defaultTerminalID.value = 1;
        return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool?> getDenominationData({required int terminalID}) async {
    isLoading.value = true;
    Map<String, String>? accessHeaders = await getAccessToken();

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

    var accessToken = await getAccessToken();

    var response = await GlobalProvider()
        .mutateGraphQLData(documents: updateTerminalDataGraphQL, variables: params, accessHeaders: accessToken);
    if (response != null) {
      print(response);
      return true;
    } else {
      return false;
    }
  }

  //  MUTATION AREA
  Future addTransaction({required Map<String, String> credentialHeaders}) async {
    if (selecttedLanguageID.value != 0) {
      // selectedNationalities.value = resultID!;
      String? name = '${screenController.hostname}-${seriesDetailsList.first.data.seriesDetails.first.docNo}';
      DateTime? dtNow = DateTime.now();

      statusMessage.value = 'Transaction started...';

      int? contactID = await GlobalProvider().addContacts(
          code: seriesDetailsList.first.data.seriesDetails.first.docNo,
          firstName: name,
          lastName: "Terminal ${defaultTerminalID.value}",
          middleName: 'Guest',
          prefixID: 1,
          suffixID: 1,
          nationalityID: selecttedLanguageID.value,
          genderID: 1,
          discriminitor: 'Contact',
          headers: credentialHeaders);

      // String? basePhoto = await HomeController().takePicture();
      String? basePhoto = await takePicture(camID: cameraID.value);

      // var accessToken = await getAccessToken();

      var response = await GlobalProvider()
          .addContactPhotoes(accessHeader: credentialHeaders, contactID: contactID!, isActive: true, photo: basePhoto);

      statusMessage.value = 'Processing client transaction';

      if (response) {
        // update series, on CONTACT MODULE ID
        await GlobalProvider().updateSeriesDetails(
          accessHeader: credentialHeaders,
          // idNo: seriesDetailsList.first.data.seriesDetails.first.id,
          idNo: globalFetchID.value,
          docNo: contactNumber.value,
          // docNo: seriesDetailsList.first.data.seriesDetails.first.docNo,
          isActive: false,
          tranDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(dtNow),
        );
        // print(response);

        // ======================================================================================
        // addBooking
        var durationValue = accommodationTypeList.first.data.accommodationTypes
            .where((element) => element.id == selectedAccommodationTypeID.value);

        final int intValue = durationValue.first.valueMax.toInt();

        // CHECK IF THE VALUE MAX
        DateTime endtime = intValue == 1 ? dtNow.add(Duration(days: intValue)) : dtNow.add(Duration(hours: intValue));

        String startDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dtNow);
        String endDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(endtime);

        statusMessage.value = 'Fetching Series Information';

        // hc.availRoomList[hc.preSelectedRoomID.value].description
        var moduleResponse =
            settingsList.first.data.settings.where((element) => element.code == SettingConstant.bookingModuleID);
        bookingNumber.value =
            (await getSeriesDetails(credentialHeaders: accessTOKEN, moduleID: int.parse(moduleResponse.first.value)))!;

        final bookingParams = {
          "isActive": true,
          // "docNo": seriesDetailsList.first.data.seriesDetails.first.docNo,
          "docNo": bookingNumber.value,
          "accommodationTypeID": selectedAccommodationTypeID.value,
          "agentID": 1,
          "bookingStatusID": 2,
          "cutOffID": 1,
          "roomTypeID": selectedRoomTypeID.value,
          "actualStartDate": startDateTime,
          "bed": 1,
          "endDate": endDateTime,
          "numPax": 2,
          "startDate": startDateTime,
          "roomRate": availRoomList[preSelectedRoomID.value].rate,
          "roomID": int.parse(availRoomList[preSelectedRoomID.value].id),
          "discountAMT": 0.0,
          "isWithBreakfast": false,
          "isDoNotDesturb": false,
          "serviceCharge": availRoomList[preSelectedRoomID.value].serviceCharge,
          "contactID": contactID
        };

        // var jsondata = jsonEncode(bookingParams);
        // print(jsondata);
        // INSERT BOOKING
        var bookingResponse = await GlobalProvider()
            .mutateGraphQLData(documents: addBooking, variables: bookingParams, accessHeaders: credentialHeaders);
        final saveResponse = bookingResponse['data']['Bookings']['response'];
        final bookingIDResponse = bookingResponse['data']['Bookings']['Ids'];
        // print(bookingIDResponse);
        // print(bookingIDResponse[0]);

        if (saveResponse == "Success") {
          generatedBookingID.value = bookingIDResponse[0];

          // update seriesDetails
          await GlobalProvider().updateSeriesDetails(
            accessHeader: accessTOKEN,
            // idNo: seriesDetailsList.first.data.seriesDetails.first.id,
            // docNo: seriesDetailsList.first.data.seriesDetails.first.docNo,
            idNo: globalFetchID.value,
            docNo: bookingNumber.value,
            isActive: false,
            tranDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(dtNow),
          );

          // PROCESSING PAYMENT;
          // insert all Charges into Booking Charges
          // BOOKING CHARGES
          for (var x = 0; x < chargesList.first.data.charges.length; x++) {
            bool isRoomBa = chargesList.first.data.charges[x].code == "Room" ? true : false;
            final bookingChargesParams = {
              "iBookingID": generatedBookingID.value,
              "iChargeID": chargesList.first.data.charges[x].id,
              "isForDebit": chargesList.first.data.charges[x].isForDebit,
              "quantity": 1,
              "rate": isRoomBa ? availRoomList[preSelectedRoomID.value].rate : chargesList.first.data.charges[x].rate,
              "tranDate": startDateTime
            };

            await GlobalProvider().mutateGraphQLData(
                documents: addBookingCharges, variables: bookingChargesParams, accessHeaders: credentialHeaders);
          }
          statusMessage.value = 'Posting client transaction';

          var moduleResponse =
              settingsList.first.data.settings.where((element) => element.code == SettingConstant.invoiceModuleID);
          invoiceNumber.value = (await getSeriesDetails(
              credentialHeaders: credentialHeaders, moduleID: int.parse(moduleResponse.first.value)))!;

          final iData = settingsList.first.data.settings.where((element) => element.code == SettingConstant.vat);
          final iVat = int.parse(iData.first.value);

          final vatAmount = (iVat * availRoomList[preSelectedRoomID.value].rate) / 100;
          final iCashPositionsID =
              await getCashPositions(credentialHeaders: credentialHeaders, codeValue: kioskName.value);
          final iChargesID = await getChargesV2(credentialHeaders: credentialHeaders, codeValue: 'PYMT');

          // PAYMENTS AREA
          final paymentParams = {
            "cutOffID": getCutOffs(credentialHeaders: credentialHeaders, isActive: true),
            "balance": 0.0,
            "bookingNo": bookingNumber.value,
            "discount": 0,
            "discountAmount": 0.0,
            "dueDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(dtNow),
            "totalAmount": availRoomList[preSelectedRoomID.value].rate,
            "totalPaid": availRoomList[preSelectedRoomID.value].rate,
            "totalQuantity": 1,
            "tranDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(dtNow),
            "vat": iVat,
            "vatAmount": vatAmount,
            "invoiceNo": invoiceNumber.value,
            "cashPosition": iCashPositionsID,
            "chargeID": iChargesID
          };
          // final dtjson = jsonEncode(paymentParams);
          // print(dtjson);

          statusMessage.value = 'Processing payment transaction';

          var paymentResponse = await GlobalProvider()
              .mutateGraphQLData(documents: addPayments, variables: paymentParams, accessHeaders: credentialHeaders);

          final paymentID = paymentResponse['data']['Payments']['Ids'];
          // print(paymentResponse);

          statusMessage.value = "Processing payment details";

          final paymentDetailsParams = {
            "amount": availRoomList[preSelectedRoomID.value].rate,
            "paymentID": paymentID[0],
            "paymentTypeID": selectedPaymentTypeID.value
          };

          await GlobalProvider().mutateGraphQLData(
              documents: addPaymentDetails, variables: paymentDetailsParams, accessHeaders: credentialHeaders);
          // final pdResponse =  paymentDetailResponse['data']['PaymentDetails']['response'];

          final String ledPort;
          ledPort = kDebugMode ? "COM1" : "COM8";

          statusMessage.value = 'Issuing Card....';

          openLEDLibserial(portName: ledPort, ledLocationAndStatus: LedOperation.cardON);
          // PRINTING CARD
          // 202309081129
          // DateFormat('yyyy-MM-dd HH:mm:ss').format(dtNow);
          await issueCard(
            command: APIConstant.issueCard,
            iTerminalID: defaultTerminalID.value,
            roomNo: availRoomList[preSelectedRoomID.value].code,
            checkInTime: DateFormat('yyyyMMddHHmm').format(dtNow),
            checkOuttime: DateFormat('yyyyMMddHHmm').format(endtime),
            guestName: name,
            commonDoor: "01",
            liftReader: "010101",
          );

          // update seriesDetails
          await GlobalProvider().updateSeriesDetails(
            accessHeader: credentialHeaders,
            idNo: globalFetchID.value,
            docNo: invoiceNumber.value,
            isActive: false,
            tranDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(dtNow),
          );
          // UPDATE BOOKING WITH FINAL INVOICE#
          // final updateBookingParams = {}
          // STOP THE DISPENSER CASH POLLING
          await cashDispenserCommand(sCommand: APIConstant.cashPoolingStop, iTerminalID: defaultTerminalID.value);

          openLEDLibserial(portName: ledPort, ledLocationAndStatus: LedOperation.cardOFF);

          // DITO ANG PRINTING
          openLEDLibserial(portName: ledPort, ledLocationAndStatus: LedOperation.printingON);

          setBackToDefaultValue();

          openLEDLibserial(portName: ledPort, ledLocationAndStatus: LedOperation.printingOFF);

          return true;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // CHECKOUT MODULE
  Future checkOUT({required Map<String, String> credentialHeaders}) async {
    if (selecttedLanguageID.value != 0) {}
  }

  Future<String?> getSeriesDetails({required Map<String, String> credentialHeaders, required int moduleID}) async {
    isLoading.value = true;
    seriesDetailsList.clear();

    final Map<String, dynamic> params = {"moduleID": moduleID};

    final response = await GlobalProvider().fetchSeriesDetails(headers: credentialHeaders, params: params);

    try {
      if (response != null) {
        seriesDetailsList.add(response);
        if (kDebugMode) print(response.data.seriesDetails.first.docNo);
        isLoading.value = false;
        globalFetchID.value = response.data.seriesDetails.first.id;
        return response.data.seriesDetails.first.docNo;
      }
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<bool> getAccommodation({required Map<String, String> credentialHeaders, required String? languageCode}) async {
    // isLoading.value = true;

    final response = await GlobalProvider().fetchAccommodationType(6, headers: credentialHeaders);
    // const inputHenry = 'Acknowledgement';

    try {
      if (response != null) {
        // await translator.translate('sex', from: 'en', to: 'zh-cn').then((value) => print(value));
        // print(await inputHenry.translate(from: 'en', to: 'ja'));

        accommodationTypeList.add(response);

        if (accommodationTypeList.first.data.accommodationTypes.isNotEmpty &&
            languageCode != selectedLanguageCode.value.toLowerCase()) {
          var record = accommodationTypeList.first.data.accommodationTypes.length;

          for (var ctr = 0; ctr < record; ctr++) {
            var textTranslated = await translator.translate(
                accommodationTypeList.first.data.accommodationTypes[ctr].description,
                from: selectedLanguageCode.value.toLowerCase(),
                to: languageCode!);
            accommodationTypeList.first.data.accommodationTypes[ctr].translatedText = textTranslated.text;
          }
          accommodationTypeList.refresh();
        }

        if (kDebugMode) {
          print('TOTAL ACCOMMODATION: ${accommodationTypeList.first.data.accommodationTypes.length}');
        }
        isLoading.value = false;
        return true;
      }
    } finally {
      // isLoading.value = false;
    }
    return false;
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
        selectedLanguageCode.value = settingsResponse.data.settings[langIndex].code;

        final idx = settingsResponse.data.settings.indexWhere((element) => element.code == 'PHLOCKURL');
        kioskURL.value = settingsResponse.data.settings[idx].value;

        isLoading.value = false;
        return true;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  String? getSettingsValue({required String elementCode}) {
    if (settingsList.first.data.settings.isNotEmpty) {
      final settingsValue = settingsList.first.data.settings.where((element) => element.code == elementCode);

      if (settingsValue.isNotEmpty) {
        return settingsValue.first.value;
      }
    }
    return null;
  }

  // PAYMENT TYPE
  Future<bool> getPaymentType({required Map<String, String> credentialHeaders, required String? languageCode}) async {
    isLoading.value = true;

    final response = await GlobalProvider().fetchPaymentType(headers: credentialHeaders);

    try {
      if (response != null) {
        paymentTypeList.add(response);

        if (paymentTypeList.first.data.paymentTypes.isNotEmpty &&
            languageCode != selectedLanguageCode.value.toLowerCase()) {
          for (var ctr = 0; ctr < paymentTypeList.first.data.paymentTypes.length; ctr++) {
            var textTranslated = await translator.translate(paymentTypeList.first.data.paymentTypes[ctr].description,
                from: selectedLanguageCode.value.toLowerCase(), to: languageCode!.toLowerCase());
            paymentTypeList.first.data.paymentTypes[ctr].translatedText = textTranslated.text;
          }
          paymentTypeList.refresh();
        }

        if (kDebugMode) print('Payment Type: ${paymentTypeList.first.data.paymentTypes.length}');

        return true;
      } else {
        return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ROOM TYPE
  Future<bool> getRoomType({required Map<String, String> credentialHeaders, required String? languageCode}) async {
    isLoading.value = true;

    final response = await GlobalProvider().fetchRoomTypes(headers: credentialHeaders, limit: 2);

    try {
      if (response != null) {
        roomTypeList.add(response);

        if (roomTypeList.first.data.roomTypes.isNotEmpty && languageCode != selectedLanguageCode.value.toLowerCase()) {
          var record = roomTypeList.first.data.roomTypes.length;
          for (var ctr = 0; ctr < record; ctr++) {
            var textTranslated = await translator.translate(roomTypeList.first.data.roomTypes[ctr].description,
                from: selectedLanguageCode.value.toLowerCase(), to: languageCode!);
            roomTypeList.first.data.roomTypes[ctr].translatedText = textTranslated.text;
          }
          roomTypeList.refresh();
        }

        return true;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
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

  Future<bool?> getAvailableRoomsGraphQL(
      {required Map<String, String> credentialHeaders,
      required int? roomTYPEID,
      required int? accommodationTYPEID}) async {
    // isLoading.value = true;

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
        availableRoomList.clear(); //clear first
        availableRoomList.add(response);
        availableRoomList.shuffle();

        availRoomList.clear(); //clear first
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
        // isLoading.value = false;
        return false;
      }
    } finally {
      // isLoading.value = false;
    }
  }

  Future<bool?> getCharges(
      {required Map<String, String> credentialHeaders, required bool? isActive, required bool? isDefault}) async {
    final chargesResponse =
        await GlobalProvider().fetchChargesData(headers: credentialHeaders, isActive: isActive, isDefault: isDefault);

    if (chargesResponse != null) {
      chargesList.add(chargesResponse);
      return true;
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
        getMenu(code: 'SLMT', type: 'TITLE');
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

  Future<int>? getCutOffs({required Map<String, String> credentialHeaders, required bool isActive}) async {
    final cutParams = {'isActive': isActive};

    final cutResponse =
        await GlobalProvider().executeGraphQLData(documents: qryCutOffs, headers: accessTOKEN, params: cutParams);
    if (cutResponse != null) {
      cutOffList.add(cutResponse);
      return cutOffList.first.id;
    }
    return 0;
  }

  Future<int?> getChargesV2({required Map<String, String> credentialHeaders, required String codeValue}) async {
    final chargeResponse = await GlobalProvider().fetchChargesV2(headers: credentialHeaders, code: codeValue);

    if (chargeResponse != null) {
      chargesListV2.add(chargeResponse);
      // final sData = chargesListV2.first.data.charges.where((element) => element.code == codeValue);

      if (chargesListV2.first.data.charges.isNotEmpty) {
        return chargesListV2.first.data.charges.first.id;
      }
    }
    return 0;
  }

  Future<int?> getCashPositions({required Map<String, String> credentialHeaders, required String codeValue}) async {
    final cashResponse = await GlobalProvider().fetchCashPositions(headers: credentialHeaders, username: codeValue);
    if (cashResponse != null) {
      cashpositionList.add(cashResponse);
      if (cashpositionList.first.data.cashPositions.isNotEmpty) {
        // final iresult = cashpositionList.first.data.cashPositions.where((element) => element.username == codeValue);
        return cashpositionList.first.data.cashPositions.first.id;
      }
    }
    return 0;
  }

  void setBackToDefaultValue() {
    statusMessage.value = 'Initializing \nCash Acceptor Device \nplease wait ....';
    isButtonActive.value = true;
    bookingNumber.value = '';
    contactNumber.value = '';
    invoiceNumber.value = '';
    globalFetchID.value = 0;
    paymentChargesID.value = 0;
    nabasangPera.value = 0.0;
    totalAmountDue.value = 0.0;
    isConfirmReady.value = false;
    isDisclaimerClick.value = false;
  }

  void startReadCardTimer() {
    // / Create a timer that fires every 3 to 5 seconds

    readCardTimer = Timer.periodic(Duration(seconds: 3 + (Random().nextInt(3))), (timer) {
      // Fetch data from the API
      fetchReadCardInfo();
    });
  }

  Future<bool> fetchReadCardInfo() async {
    statusMessage.value = 'Reading card....';
    final response =
        await readCard(url: kioskURL.value, sCommand: APIConstant.readCard, terminalID: defaultTerminalID.value);
    if (response) {
      readCardTimer?.cancel();
      isLoading.value = false;
      openLEDLibserial(portName: 'COM1', ledLocationAndStatus: LedOperation.cardOFF);
      return true;
    } else {
      statusMessage.value = 'Unable to read Key Card \nPlease insert Key Card on Card Dispenser';
      return false;
    }
  }

  // ============ SERIAL COMMUNICATION ===========================
  void openLEDLibserial({String ledLocationAndStatus = '', required String? portName}) {
    // final serialPort = SerialPort.availablePorts;
    final portConfig = SerialPortConfig();
    final port = SerialPort(portName!);
    portConfig.baudRate = 9600;
    portConfig.parity = SerialPortParity.none;

    if (port.isOpen) {
      port.close();
    } else {
      if (kDebugMode) print('Connected to: ${port.name}');
    }

    port.openWrite();
    // Encode the string using a specific encoding (e.g., ASCII)
    List<int> encodedBytes = ascii.encode(ledLocationAndStatus);
    // Create a Uint8List from the encoded bytes
    Uint8List uint8List = Uint8List.fromList(encodedBytes);

    if (port.isOpen) {
      port.write(uint8List);
    }

    if (port.isOpen) {
      port.close();
      // exit(-1);
    }
  }

  // CARD DISPENSER
  void cardDispenser({required String portNumber}) {
    // final serialPort = SerialPort.availablePorts;
    final port = SerialPort(portNumber);
    final portConfig = SerialPortConfig();

    portConfig.baudRate = 9600;
    portConfig.parity = SerialPortParity.none;
    portConfig.bits = 1;
    portConfig.stopBits = 1;

    if (!port.openReadWrite()) {
      if (kDebugMode) print(SerialPort.lastError);
      // exit(-1);
    }

    // var sendCmd = '02 00 00 00 02 52 46 03 00';
    var sendCmd = '020000000241500312';
    Uint8List byteAP = Uint8List.fromList(HEX.decode(sendCmd));
    if (port.isOpen) {
      port.write(byteAP, timeout: 2);
    }

    if (kDebugMode) print('${port.name} is open');

    int readBuffer = 512;

    while (port.isOpen) {
      Uint8List bytesRead = port.read(readBuffer, timeout: 60);

      if (bytesRead.isNotEmpty) {
        if (kDebugMode) print('BYTES READ DECIMAL: $bytesRead');
        if (kDebugMode) print('BYTES READ HEX: ${HEX.encode(bytesRead).toUpperCase()}');
        var asciiTable = String.fromCharCodes(bytesRead);
        if (kDebugMode) print('ASCII: $asciiTable');
      }

      // if (bytesRead.isEmpty) {
      //   port.close();
      // }
    }
  }
}

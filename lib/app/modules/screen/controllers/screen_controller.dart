import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:iotelkiosk/globals/constant/bdotransaction_constant.dart';
import 'package:serial_port_win32/serial_port_win32.dart' as winsp;
import 'package:get/get.dart';
import 'package:hex/hex.dart';
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
import 'package:translator/translator.dart';

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
  final selectedAccommodationTypeID = 1.obs;
  final selectedNationalities = 77.obs;
  final selectedPaymentTypeCode = ''.obs;
  final preSelectedRoomID = 0.obs;
  final totalAmountDue = 0.0.obs;

  // MODEL LIST
  final pageTrans = <Conversion>[].obs;
  final titleTrans = <Conversion>[].obs;
  final btnMessage = <Conversion>[].obs;
  final availRoomList = <AvailableRoom>[].obs;

  // OTHER LIST
  List<int> serialReadList = [];

  // OTHERS
  final translator = GoogleTranslator();

  // CONTROLLERS
  final scrollController = ScrollController();

  // LISTENING

  final player = Player(
    id: 0,
  );

  // GLOBAL
  // var ports = <String>[];
  // late SerialPort port;

  @override
  void onInit() async {
    super.onInit();

    hostname.value = Platform.localHostname;

    // getPorts();
    getBDOOpen(
        transactionCode: BDOTransaction.sSale,
        pricePerRoom: '1',
        messageResponseIndicator: BDOMessageData.sRequestRespondeIndicator0);
    // getMoneydispenser();
    // cardDispenser();
    // openLED();
    // openLEDLibserial(ledLocationAndStatus: LedOperation.bottomRIGHTLEDOFF);

    mediaOpen();

    await userLogin();
    await getWeather();
    await getSettings();

    final accessToken = userLoginList.first.accessToken;
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'};

    await getLanguages(credentialHeaders: headers);
    await getTransaction(credentialHeaders: headers);

    // await getRoomType(credentialHeaders: headers, languageCode: selectedLanguageCode.value);
    // await getSeriesDetails(credentialHeaders: headers);

    // // CHECK THE LANGUAGE CODE
    // // if (languageList.first.data.languages.isNotEmpty) {
    // //   var langCode = languageList.first.data.languages.where((element) => element.id == selecttedLanguageID.value);
    // // }

    // String langcode = selectedLanguageCode.value;

    // await getAccommodation(credentialHeaders: headers, languageCode: langcode);
    // await getPaymentType(credentialHeaders: headers);

    // await getAvailableRoomsGraphQL(
    //     credentialHeaders: headers,
    //     roomTYPEID: selectedRoomTypeID.value,
    //     accommodationTYPEID: selectedAccommodationType.value);

    // await getTerms(credentialHeaders: headers, languageID: selecttedLanguageID.value);
  }

  @override
  void onReady() {
    super.onReady();
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge) {
          isBottom.value = scrollController.position.pixels == 0 ? false : true;
        }
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
    // port.close();
  }

  //=================================================================================================
  // void getPorts() {
  //   final List<PortInfo> portInfoList = SerialPort.getPortsWithFullMessages();
  //   ports = SerialPort.getAvailablePorts();
  //   String data = '';
  //   const buffer =
  //       '06, 02,03,88,36,30,30,30,30,30,30,30,30,30,31,31,32,30,30,30,30,1C,30,32,00,40,41,50,50,52,4F,56,45,44,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,1C,30,31,00,06,32,30,31,31,34,39,1C,36,35,00,06,30,30,30,30,30,31,1C,44,30,00,69,4D,4F,56,45,35,30,30,30,20,50,52,4F,44,55,43,54,49,4F,4E,20,54,45,53,42,44,4F,20,50,4F,53,20,4C,41,42,20,20,20,20,20,20,20,20,20,20,20,20,4D,41,4E,44,41,4C,55,59,4F,4E,47,20,43,49,54,59,20,20,20,20,20,20,20,1C,31,36,00,08,56,33,33,39,39,30,30,31,1C,44,31,00,15,30,30,30,30,30,39,31,38,33,36,39,30,32,32,31,1C,44,32,00,10,56,49,53,41,20,20,20,20,20,20,1C,33,30,00,16,34,31,38,33,35,39,30,30,30,30,30,30,39,31,30,35,1C,33,31,00,04,2A,2A,2A,2A,1C,35,30,00,06,30,30,30,38,30,30,1C,30,33,00,06,32,33,30,34,30,34,1C,30,34,00,06,31,34,30,32,35,31,1C,44,33,00,12,33,30,39,34,32,31,37,37,31,36,30,32,1C,44,34,00,02,30,31,1C,44,35,00,26,53,59,53,54,45,53,43,41,52,44,20,35,2F,50,53,20,20,20,20,20,20,20,20,20,20,20,1C,45,46,00,16,41,30,30,30,30,30,30,30,30,33,31,30,31,30,20,20,1C,45,47,00,16,56,69,73,61,20,43,72,65,64,69,74,20,20,20,20,20,1C,45,48,00,16,46,37,30,45,32,35,37,44,32,38,35,31,31,30,45,44,1C,03,A4';
  //   var sendCommand =
  //       '02 00 35 36 30 30 30 30 30 30 30 30 30 31 30 32 30 30 30 30 1C 34 30 00 12 30 30 30 30 30 30 30 30 31 30 30 30 1C 03 14';
  //   var sendByte = '02003536303030303030303030313032303030301C343000123030303030303030313030301C0314';
  //   sendCommand = sendCommand.replaceAll(' ', '');
  //   Uint8List bytes = Uint8List.fromList(HEX.decode(sendByte));
  //   if (kDebugMode) {
  //     print(portInfoList);
  //     print(ports);
  //   }
  //   if (ports.isNotEmpty) {
  //     port = SerialPort(ports[0], openNow: false, ReadIntervalTimeout: 1, ReadTotalTimeoutConstant: 2);
  //     port.openWithSettings(BaudRate: 9600, Parity: 0);
  //     // port.open();
  //     if (kDebugMode) print('Port Open: ${port.isOpened}');
  //     port.writeBytesFromUint8List(bytes);
  //     while (port.isOpened) {
  //       // port.readBytesOnListen(8, (value) {
  //       //   data = String.fromCharCodes(value);
  //       //   if (kDebugMode) print(DateTime.now());
  //       //   if (kDebugMode) print(data);
  //       //   port.close();
  //       // });
  //       port.readBytesOnListen(1, (value) {
  //         print(value);
  //         port.close();
  //       });
  //     }
  //     // port.close();
  //   }
  // }

  void getBDOOpen(
      {required String transactionCode, required String pricePerRoom, required String messageResponseIndicator}) {
    // final serialPort = SerialPort.availablePorts;
    final portConfig = SerialPortConfig();
    final port = SerialPort("COM1");
    List<String> responseCodeList = ['0000', '0101', 'NDND', 'EDED', 'ENEN', 'TOTO', 'NANA'];

    portConfig.baudRate = 9600;
    portConfig.parity = SerialPortParity.none;
    if (port.isOpen) port.close();

    // OPENING THE PORT
    if (!port.openReadWrite()) {
      if (kDebugMode) print(SerialPort.lastError);
      // exit(-1);
    } else {
      if (kDebugMode) print('Successfully connected to ${port.name}');
    }

    //other method
    // List<int> bytes = utf8.encode(ppr);
    // bytes.map((e) => e.toRadixString(16)).join(' ');

    var padding = pricePerRoom.length;
    padding >= 2 ? padding = padding + 2 : padding = 3;

    var pprRight = pricePerRoom.padRight(padding, '0');
    var ppr = pprRight.padLeft(12, '0');
    var amount = ppr.codeUnits.map((e) => e.toRadixString(16)).join('');
    // if (kDebugMode) print('amount hex: $amount, amount length: ${amount.length / 2.toInt()}');

    var transactionCodeHEX = transactionCode.codeUnits.map((e) => e.toRadixString(16)).join('');
    if (kDebugMode) print('TRANSACTION CODE HEX: $transactionCodeHEX');

    var transportHeader =
        '${BDOMessageData.sTransportHeaderType}${BDOMessageData.sTransportDestination}${BDOMessageData.sTransportSource}';
    var presentationHeader =
        '${BDOMessageData.sFormatVersion}$messageResponseIndicator$transactionCodeHEX${BDOMessageData.sResponseCode}${BDOMessageData.sMoreIndicator0}${BDOMessageData.sFieldSeparator}';
    var fieldData =
        '${BDOMessageData.sTransactionAmount}${BDOMessageData.sFieldLength}$amount${BDOMessageData.sFieldSeparator}';

    var messageData = '$transportHeader$presentationHeader$fieldData';

    if (kDebugMode) print('MESSAGE DATA: $messageData');

    List<int> lrcBytes = HEX.decode(messageData);
    lrcBytes = lrcBytes.toList();

    lrcBytes.add(int.parse(BDOMessageData.sETX));

    // Uint8List lrcBytes = Uint8List.fromList(HEX.decode(messageData));
    if (kDebugMode) print('MESSAGE DATA BYTES: $lrcBytes');

    int lrcData = 0;

    for (int hvm = 1; hvm < lrcBytes.length - 1; hvm++) {
      lrcData ^= lrcBytes[hvm];
    }

    if (kDebugMode) print(HEX.encode([lrcData]));
    if (kDebugMode) print('LRC DATA: $lrcData');

    var lrcHEX = HEX.encode([lrcData]);

    var lrcLength = lrcBytes.length - 1;
    var ttlMsgData = lrcLength.toString();
    var sLLLL = ttlMsgData.padLeft(4, '0');

    var sendCommand = '${BDOMessageData.sSTX}$sLLLL$messageData${BDOMessageData.sETX}$lrcHEX';
    if (kDebugMode) print('SEND COMMAND HEX $sendCommand');
    Uint8List sendCommandBytes = Uint8List.fromList(HEX.decode(sendCommand));

    // var sendByte =
    '02 00 35 36 30 30 30 30 30 30 30 30 30 31 30 32 30 30 30 30 1C 34 30 00 12 30 30 30 30 30 30 30 30 31 30 30 30 1C 03 14';
    // Uint8List bytesToWrite = Uint8List.fromList(HEX.decode(sendByte));

    // if (kDebugMode) print('WORKING SEND BYTES : $bytesToWrite');
    if (kDebugMode) print('NEW SEND BYTES : $sendCommandBytes');
    port.write(sendCommandBytes); //pagsusulat
    int readBuffer = 1;
    port.drain();

    while (port.isOpen && serialReadList.isNotEmpty) {
      Uint8List bytesRead = port.read(readBuffer, timeout: 0);
      // if (kDebugMode) print('BYTES AVAILABLE FOR READING ${port.bytesAvailable} ');
      // if (kDebugMode) print('SERIAL PORT SIGNAL : ${port.signals}');

      if (bytesRead.isNotEmpty && serialReadList.isNotEmpty) {
        serialReadList.add(bytesRead.first);
        // var totalLength = serialReadList.length;
        // if (totalLength >= 165) {
        //   if (kDebugMode) print('Closing port ${port.name}');
        //   port.close();
        // }
      } else {
        port.flush();
        port.close();
      }
    }

    // serialReadList.addAll(HEX.decode(data));
    // serialReadList.addAll(byteArray);

    if (kDebugMode) print('READ DATA: $serialReadList');
    // if (kDebugMode) print(String.fromCharCodes(serialReadList));
    if (serialReadList.first == 6) {
      serialReadList = serialReadList.sublist(1);
      if (serialReadList.first == 2) {
        // FIRST READ
        if (kDebugMode) print('STX: ${serialReadList.first.toRadixString(16)}');
        // 2ND READ
        String sLL1 = serialReadList[1].toRadixString(16);
        String sLL2 = serialReadList[2].toRadixString(16);
        String sLLLL = sLL1 + sLL2;

        // 2nd read verification
        // int sLLLData = int.parse(sLLLL);
        List<int> sllllDatalist = serialReadList.sublist(1, 3);

        if (kDebugMode) print('LLLL: $sLL1$sLL2 ');

        // 3RD READ SIMULATION
        var offset = 3;
        var messageDataLengthWithOffset = offset + int.parse(sLLLL);

        var messageDataList = serialReadList.sublist(offset, messageDataLengthWithOffset);

        // if (kDebugMode) print('MESSAGE DATA LIST : $messageDataList');
        var sETX = serialReadList[offset + int.parse(sLLLL)].toRadixString(16);
        var sLRC = serialReadList[offset + int.parse(sLLLL) + 1].toRadixString(16);

        if (kDebugMode) print('ETX: $sETX');
        if (kDebugMode) print('LRC: $sLRC');

        var etxList = serialReadList.sublist(messageDataLengthWithOffset, messageDataLengthWithOffset + 1);
        var lrcList = serialReadList.sublist(messageDataLengthWithOffset + 1, messageDataLengthWithOffset + 2);
        if (kDebugMode) print('ETX LIST: $etxList');
        if (kDebugMode) print('LRC LIST: $lrcList');

        if (sETX == '3') {
          var lrc = 0;

          var lrcCheck = sllllDatalist + messageDataList + etxList;
          if (kDebugMode) print('LRC TOTAL: ${lrcCheck.length}}');

          for (int mainCtr in lrcCheck) {
            lrc ^= mainCtr;
            var responseCode = '';

            var lrcReceived = int.parse(lrc.toRadixString(16), radix: 16);

            if (lrcReceived == lrc) {
              if (kDebugMode) print('LRC CORRECT');
              // var transportHeader = messageDataList.sublist(0, 10);
              var presentationHeader = messageDataList.sublist(10, 18);
              var presentationHeaderList = presentationHeader.sublist(4, 6);

              for (var x in presentationHeaderList) {
                x++;
                if (kDebugMode) print(x);

                responseCode += ascii.decode(presentationHeaderList);

                // if (responseCode == "NANA") break;
                var res = responseCodeList.where((element) => element == responseCode);
                if (res.isNotEmpty) {
                  break;
                }

                if (kDebugMode) print('RESPONSE CODE: $responseCode');
                var fields = HEX.encode(messageDataList.sublist(18, messageDataList.length - 1));

                var messageDataFields = fields.split('1c');
                // List<int> msgDataFields = messageDataFields.map((e) => int.parse(e)).toList();

                for (var ctr = 0; ctr < messageDataFields.length; ctr++) {
                  Uint8List fn = Uint8List.fromList(HEX.decode(messageDataFields[ctr]));
                  // Uint8List fv = Uint8List.fromList(HEX.decode(messageDataFields[ctr]));
                  String fieldName = String.fromCharCodes(fn);
                  // String fieldValue = String.fromCharCodes(fn);

                  if (kDebugMode) {
                    print(
                        "DATA $ctr : ${fieldName.substring(0, 2).trim()} : ${fieldName.replaceRange(0, 4, '').replaceAll('       ', ' ')}");
                  }
                }
              }
              if (kDebugMode) print('LRC: $lrc : MAIN CTR: $mainCtr');
            } else {
              if (kDebugMode) print('LRC ERROR');
            }
            // if (responseCode == "NANA") break;
            var res = responseCodeList.where((element) => element == responseCode);
            if (res.isNotEmpty) {
              break;
            }
          }
        } else {
          if (kDebugMode) print('STX UNREAD');
        }
      }
    } else {
      if (kDebugMode) print('Acknowledged code not received');
    }
  }

  void getMoneydispenser() {
    // final serialPort = SerialPort.availablePorts;
    final portConfig = SerialPortConfig();
    final port = SerialPort("COM1");

    portConfig.baudRate = 9600;
    portConfig.parity = SerialPortParity.none;
    portConfig.bits = 8;
    portConfig.stopBits = 2;

    if (!port.openReadWrite()) {
      if (kDebugMode) print(SerialPort.lastError);
      exit(-1);
    }

    var stx = '7F';
    var bezel = '1101';

    Uint8List bytesInitialize = Uint8List.fromList(HEX.decode(bezel));
    Uint8List stxInit = Uint8List.fromList(HEX.decode(stx));

    port.write(stxInit);
    port.write(bytesInitialize);

    if (kDebugMode) print('${port.name} is open');

    int readBuffer = 512;
    // var asciiList = [];

    while (port.isOpen) {
      Uint8List bytesRead = port.read(readBuffer, timeout: 60);

      // if (kDebugMode) {
      //   print('BYTES READ: $bytesRead');
      //   // for (var i = 0; i < bytesRead.length; i++) {
      //   //   // print(String.fromCharCode(bytesRead[i]));
      //   //   asciiList.add(String.fromCharCode(bytesRead[i]));
      //   // }
      //   var asciiTable = String.fromCharCodes(bytesRead);
      //   print('ASCII: $asciiTable');
      // }

      if (bytesRead.isNotEmpty) {
        if (kDebugMode) print('BYTES READ DECIMAL: $bytesRead');
        if (kDebugMode) print('BYTES READ HEX: ${HEX.encode(bytesRead).toUpperCase()}');
        var asciiTable = String.fromCharCodes(bytesRead);
        if (kDebugMode) print('ASCII: $asciiTable');
      }

      // if (bytesRead.isEmpty) {
      //   port.close();
      //   if (kDebugMode) print('Port is close');
      // }
    }
  }

  void cardDispenser() {
    final serialPort = SerialPort.availablePorts;
    final portConfig = SerialPortConfig();
    final port = SerialPort(serialPort.first);

    portConfig.baudRate = 9600;
    // portConfig.parity = SerialPortParity.none;
    // portConfig.bits = 1;
    // portConfig.stopBits = 1;

    if (!port.openReadWrite()) {
      if (kDebugMode) print(SerialPort.lastError);
      // exit(-1);
    }

    var sendCmd = '02 00 00 00 02 52 46 03 00';
    Uint8List byteAP = Uint8List.fromList(HEX.decode(sendCmd));

    port.write(byteAP);

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

      if (bytesRead.isEmpty) {
        port.close();
      }
    }
  }

  void openLED() {
    final serialPort = winsp.SerialPort.getAvailablePorts();
    final port = winsp.SerialPort(serialPort.first, BaudRate: 9600);

    if (port.isOpened) {
      port.close();
    } else {
      if (kDebugMode) print('Connected to: ${port.portName}');
    }

    port.open();

    var sendCom = 'O(00,01,0)E';
    port.writeBytesFromString(sendCom);
    if (port.isOpened) {
      port.close();
      // exit(-1);
    }
  }

  void openLEDLibserial({String ledLocationAndStatus = ''}) {
    // final serialPort = SerialPort.availablePorts;
    final portConfig = SerialPortConfig();
    final port = SerialPort("COM2");
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

    port.write(uint8List);

    if (port.isOpen) {
      port.close();
      // exit(-1);
    }
  }

  // -----------------------------------------------------------------------------------------

  // -----------------------------------------------------------------------------------------

  void mediaOpen() {
    if (kDebugMode) {
      player.setVolume(0);
    }
    player.open(
      Playlist(
        medias: [
          Media.asset('assets/background/iotel.mp4'),
          Media.asset('assets/background/iOtelWalkin.mp4'),
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

  Future<bool> getAccommodation({required Map<String, String> credentialHeaders, required String? languageCode}) async {
    // isLoading.value = true;

    final response = await GlobalProvider().fetchAccommodationType(3, headers: credentialHeaders);
    // const inputHenry = 'Acknowledgement';

    try {
      if (response != null) {
        // await translator.translate('sex', from: 'en', to: 'zh-cn').then((value) => print(value));
        // print(await inputHenry.translate(from: 'en', to: 'ja'));

        accommodationTypeList.add(response);

        if (accommodationTypeList.first.data.accommodationTypes.isNotEmpty &&
            languageCode != defaultLanguageCode.value.toLowerCase()) {
          var record = accommodationTypeList.first.data.accommodationTypes.length;
          for (var ctr = 0; ctr < record; ctr++) {
            var textTranslated = await translator.translate(
                accommodationTypeList.first.data.accommodationTypes[ctr].description,
                from: defaultLanguageCode.value.toLowerCase(),
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
  Future<bool> getPaymentType({required Map<String, String> credentialHeaders, required String? languageCode}) async {
    isLoading.value = true;

    final response = await GlobalProvider().fetchPaymentType(headers: credentialHeaders);

    try {
      if (response != null) {
        paymentTypeList.add(response);

        if (paymentTypeList.first.data.paymentTypes.isNotEmpty &&
            languageCode != defaultLanguageCode.value.toLowerCase()) {
          for (var ctr = 0; ctr < paymentTypeList.first.data.paymentTypes.length; ctr++) {
            var textTranslated = await translator.translate(paymentTypeList.first.data.paymentTypes[ctr].description,
                from: defaultLanguageCode.value.toLowerCase(), to: languageCode!.toLowerCase());
            paymentTypeList.first.data.paymentTypes[ctr].translatedText = textTranslated.text;
          }
          paymentTypeList.refresh();
        }

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
  Future<bool> getRoomType({required Map<String, String> credentialHeaders, required String? languageCode}) async {
    isLoading.value = true;

    final response = await GlobalProvider().fetchRoomTypes(headers: credentialHeaders, limit: 2);

    try {
      if (response != null) {
        roomTypeList.add(response);

        if (roomTypeList.first.data.roomTypes.isNotEmpty && languageCode != defaultLanguageCode.value.toLowerCase()) {
          var record = roomTypeList.first.data.roomTypes.length;
          for (var ctr = 0; ctr < record; ctr++) {
            var textTranslated = await translator.translate(roomTypeList.first.data.roomTypes[ctr].description,
                from: defaultLanguageCode.value.toLowerCase(), to: languageCode!);
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

  String translateText({required String sourceText, required String fromLang, required String toLang}) {
    translator.translate(sourceText, from: fromLang, to: toLang).then((value) {
      if (value.text.isNotEmpty) {
        return value.text;
      } else {
        return '';
      }
    });
    return '';
  }

  // ---------------------------------------------------------------------------------------------------------
  bool getMenu({int? languageID, String? code, String? type, int? indexCode}) {
    pageTrans.clear();
    titleTrans.clear();
    if (transactionList.isNotEmpty) {
      // TITLE
      if (type == "TITLE") {
        titleTrans.addAll(
            transactionList[0].data.conversion.where((element) => element.code == code && element.type == type));
      } else {
        titleTrans.addAll(transactionList[0]
            .data
            .conversion
            .where((element) => element.languageId == languageID && element.code == code && element.type == type));
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
        print('MENU ITEMS (code: $code | type: $type) : TOTAL RECORD: ${pageTrans.length} : INDEX: $indexCode');
      }

      return true;
    } else {
      return false;
    }
    // return true;
  }

// ---------------------------------------------------------------------------------------------------------
}

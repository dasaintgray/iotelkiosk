// ignore_for_file: unused_element

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:intl/intl.dart';
import 'package:iotelkiosk/globals/constant/bdotransaction_constant.dart';
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
import 'package:iotelkiosk/globals/services/devices/display_service.dart';
import 'package:translator/translator.dart';
import 'package:get/get.dart';
import 'package:hex/hex.dart';

import 'package:timezone/data/latest.dart' as tzd;
import 'package:timezone/standalone.dart' as tz;

class ScreenController extends GetxController with BaseController {
  // VARIABLE DECLARTION WITH OBSERVABLE CAPABILITY;

  // BOOLEAN
  final isLoading = false.obs;
  final isBottom = false.obs;
  final isECREmpty = true.obs;
  final isBankNoteReadyToReceive = false.obs;

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

  // DATE
  final dtNow = DateFormat.yMMMMd().format(DateTime.now());

  final japanNow = DateTime.now().obs;
  final newyorkNow = DateTime.now().obs;
  final seoulNow = DateTime.now().obs;
  final sydneyNow = DateTime.now().obs;

  // LOCAL TIME
  final localTime = DateTime.now().obs;

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

    initTimezone();

    // monitorInfo();
    setDisplayMonitor('DISPLAY2');

    // getBDOOpen(
    //     transactionCode: BDOTransaction.sSale,
    //     pricePerRoom: '2',
    //     messageResponseIndicator: BDOMessageData.sRequestRespondeIndicator0);
    // getMoneydispenser();
    // cardDispenser();
    // openLED();
    // openLEDLibserial(ledLocationAndStatus: LedOperation.bottomCENTERLEDON);

    mediaOpen();

    await userLogin();
    final accessToken = userLoginList.first.accessToken;
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'};

    await getWeather();
    await getSettings();

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

    await getAvailableRoomsGraphQL(credentialHeaders: headers, roomTYPEID: 1, accommodationTYPEID: 1);
    // await getTerminalDataSubs(headers: headers);
    // await getTerminalData(authorizationHeader: headers);

    // await getTerms(credentialHeaders: headers, languageID: selecttedLanguageID.value);
  }

  // APP LIFE CYCLE

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

  // ------------------------------------------------------------------------------------------------------
  // CONTROLLER CODE

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

  String? getAccessToken() {
    if (userLoginList.isEmpty) {
      return null;
    } else {
      return userLoginList.first.accessToken;
    }
  }

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
    // port.drain();

    Uint8List bytesRead = Uint8List(0);

    bytesRead = port.read(readBuffer, timeout: 0);
    if (bytesRead.first == 6) {
      isECREmpty.value = true;
    }
    while (isECREmpty.value) {
      // Uint8List bytesRead = port.read(readBuffer, timeout: 0);
      bytesRead = port.read(readBuffer, timeout: 0);

      if (bytesRead.isNotEmpty) {
        serialReadList.add(bytesRead.first);
        if (kDebugMode) print('BYTES AVAILABLE FOR READING ${port.bytesAvailable} ');
        if (port.bytesAvailable <= 0) isECREmpty.value = false;
      } else {
        isECREmpty.value = false;
      }
    }
    port.close();

    if (kDebugMode) print('READ DATA: $serialReadList');
    // if (kDebugMode) print(String.fromCharCodes(serialReadList));
    // if (serialReadList.first == 6) {
    //   serialReadList = serialReadList.sublist(1);
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
        if (kDebugMode) print('Start Transaction code not received');
      }
    }
    // } else {
    //   if (kDebugMode) print('Acknowledged code not received');
    // }
  }

  // **********************************************************************
  // DESCRIPTION: BANK NOTE AREA THIS WILL BE TRANSFER TO HOME CONTROLLER LATER
  // AUTHOR: Henry V. Mempin
  // DATE: 9 JUNE 2023
  // BEGIN FUNCTION
  // **********************************************************************

  List<int> calculateCRC(List<int> bytes) {
    const int seed = 0xFFFF;
    const int polynomial = 0x8005;
    const int stx = 0x7F;

    int crc = seed;

    for (int byte in bytes) {
      if (byte != stx) {
        // Exclude STX byte
        crc ^= (byte << 8);

        for (int bit = 0; bit < 8; bit++) {
          if ((crc & 0x8000) != 0) {
            crc = (crc << 1) ^ polynomial;
          } else {
            crc <<= 1;
          }
        }
      }
    }

    int lowByte = crc & 0xFF;
    int highByte = (crc >> 8) & 0xFF;

    return [lowByte, highByte];
  }

  int createPacket(int sequenceFlag, int slaveAddress) {
    // Check if sequenceFlag is a valid value (0 or 1)
    if (sequenceFlag != 0 && sequenceFlag != 1) {
      throw ArgumentError('Invalid sequenceFlag value. Must be 0 or 1.');
    }

    // Check if slaveAddress is within the allowable range (0x00 to 0x7D)
    if (slaveAddress < 0x00 || slaveAddress > 0x7D) {
      // if (slaveAddress < 0 || slaveAddress > 125) {
      throw ArgumentError('Invalid slaveAddress value. Must be between 0x00 and 0x7D.');
    }

    // Combine sequenceFlag and slaveAddress using bitwise operations
    int packet = (sequenceFlag << 7) | slaveAddress;

    return packet;
  }

  void getMoneydispenser() {
    final serialPort = SerialPort.availablePorts;
    final portConfig = SerialPortConfig();
    final port = SerialPort(serialPort.first);

    portConfig.baudRate = 9600;
    // portConfig.parity = SerialPortParity.none;

    // portConfig.bits = 8;
    // portConfig.stopBits = 2;
    if (port.isOpen) port.close();
    // port.drain();

    // var packetHEX = createPacket(0, 0).toRadixString(16);

    var seqID = createPacket(0, 0);
    if (kDebugMode) print('SEQ/ID: $seqID');
    var sSTX = '7F';
    // var sSLAVEID = '00'; // 80 SEND THÉ COMMAND, 00 ACK TO DEVICE
    var sSLAVEID = HEX.encode([seqID]);
    // var sCommand = '606745230167452301';
    var sCommand = '11';
    var sCommandParam = '';
    var sCombinedComm = sCommandParam.isEmpty ? sCommand : sCommand + sCommandParam;

    var sLEN = (sCombinedComm.length / 2).ceil();

    // var sLENGTH = '';
    // sLEN >= 10 ? sLENGTH = sLEN.toString() : sLENGTH = '0$sLEN';
    var sLENGTH = sLEN.toString().padLeft(2, '0');

    var sTransaction = '$sSTX$sSLAVEID$sLENGTH$sCombinedComm';
    var crcData = HEX.decode(sTransaction);
    // var crcDataHEX = crcData.map((h) => h.toRadixString(16));
    // CHECK THE CRC
    // var crcCheck = calculateCRC(crcData).map((e) => e.toRadixString(16));
    // var crcL = crcCheck.first.padLeft(2, '0');
    // var crcH = crcCheck.last.padLeft(2, '0');
    // ADD THE EXISTING COMMAND AND INCLUDE THE CRC
    // var crcHEX = '$sTransaction$crcL$crcH'.toUpperCase();
    if (!port.openReadWrite()) {
      // if (kDebugMode) print(SerialPort.lastError);
      if (kDebugMode) print('The port ${serialPort.first} is opened by other');
      // exit(-
    }
    if (kDebugMode) print(port.isOpen ? "Port is open" : "Port is closed");

    // OTHER METHOD OF COMBINING COMMAND AND CRC
    var crc = calculateCRC(crcData);
    var commandBytes = [crcData, crc].expand((element) => element).toList(); //COMBINED THE DATA + CRC
    var hexvalue = HEX.encode(commandBytes).toUpperCase();

    if (kDebugMode) print('SEND: $hexvalue');
    // port.write(Uint8List.fromList(HEX.decode(crcHEX)), timeout: 0);
    port.write(Uint8List.fromList(commandBytes), timeout: 0);
    int readBuffer = 255;

    // TIMER
    // Timer? reconnectionTimer;
    // var interv = 3;
    // var attempts = 5;
    // reconnectionTimer = Timer.periodic(Duration(seconds: interv), (Timer timer) {
    //   reconnectionTimer!.cancel();
    // });

    // for (int i = 0; i < attempts; i++) {
    Uint8List bytesRead = Uint8List(0);

    bytesRead = port.read(readBuffer, timeout: 10);
    if (bytesRead.isNotEmpty) {
      var hexValue = HEX.encode(bytesRead).toUpperCase();
      var response = bytesRead.sublist(3, bytesRead.length);
      if (kDebugMode) print('HEX READ: $hexValue');
      if (kDebugMode) print('BYTES READ: $bytesRead');
      if (kDebugMode) print('RESPONSE CODE: ${response.first} -> ${genericResponse(response.first)}');
      if (kDebugMode) print(String.fromCharCodes(bytesRead));
      isBankNoteReadyToReceive.value = true;
      if (port.bytesAvailable <= 0) isBankNoteReadyToReceive.value = false;
    }
    //   reconnectionTimer!.cancel();
    //   reconnectionTimer = Timer.periodic(Duration(seconds: interv), (Timer timer) {
    //     reconnectionTimer!.cancel();
    //   });
    // }
    port.close();
    if (kDebugMode) print(port.isOpen ? "Port is open" : "Port is closed");
  }

  String genericResponse(int responseCode) {
    switch (responseCode) {
      case 240:
        {
          return "OK, SUCCESS";
        }
      case 241:
        {
          return "SLAVE RESET";
        }
      case 242:
        {
          return "COMMAND NOT KNOWN";
        }
      case 243:
        {
          return "WRONG OR NO PARAMETERS";
        }
      case 244:
        {
          return "PARAMETERS OUT OF RANGE";
        }
      case 245:
        {
          return "COMMAND CANNOT BE PROCESSED";
        }
      case 246:
        {
          return "SOFTWARE ERROR";
        }
      case 248:
        {
          return "FAIL";
        }
      case 250:
        {
          return "KEY NOT SET";
        }
      default:
        {
          return "INVALID BYTE";
        }
    }
  }

  bool sendBankNotedCommand(String hexCommand, SerialPort port) {
    int readBuffer = 255;
    if (port.isOpen) {
      var bytesToWrite = Uint8List.fromList(HEX.decode(hexCommand));
      port.write(bytesToWrite);
      Uint8List bytesRead = Uint8List(0);
      bytesRead = port.read(readBuffer, timeout: 5);
      if (bytesRead.isNotEmpty) {
        var hexValue = HEX.encode(bytesRead).toUpperCase();
        var response = bytesRead.sublist(3, bytesRead.length);
        if (kDebugMode) print('HEX READ: $hexValue');
        if (kDebugMode) print('BYTES READ: $bytesRead');
        if (kDebugMode) print('RESPONSE CODE: ${response.first} -> ${genericResponse(response.first)}');
        if (kDebugMode) print(String.fromCharCodes(bytesRead));
        isBankNoteReadyToReceive.value = true;
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  // THIS WILL BE TEMPORARY, IT WILL MOVE THE HC (Home Controller)
  bool connectToBankNoteValidator(int attempts, int interval) {
    // Timer reconnectionTimer = Timer(interval.seconds, () {});

    return true;
  }

  // FINDMAXPROTOCOLVERSION

  // **********************************************************************
  // DESCRIPTION: BANK NOTE AREA THIS WILL BE TRANSFER TO HOME CONTROLLER LATER
  // AUTHOR: Henry V. Mempin
  // DATE: 9 JUNE 2023
  // BEGIN FUNCTION
  // **********************************************************************

  // void monitorInfo() {
  //   // Enumerate all displays and print their information
  //   for (final display in Display.findAll()) {
  //     if (kDebugMode) {
  //       print('Display name: ${display.name}');
  //       print('Display Resolution : ${display.resolution.prettify()}');
  //       print('Is connected: ${display.isConnected}');
  //       print('Is primary: ${display.isPrimary}');
  //     }
  //     // if (display.isConnected) {
  //     //   if (kDebugMode) {
  //     //     print('Display Resolution : ${display.resolution.prettify()}');
  //     //     // print('Supported Resolution');
  //     //     // for (final resolution in display.supportedResolutions) {
  //     //     //   if (kDebugMode) print(' - ${resolution.prettify()}');
  //     //     // }
  //     //   }
  //     // }
  //   }
  //   final display = Display.findByName("DISPLAY3");
  //   if (display != null && display.isConnected) {
  //     if (!display.isPrimary) display.setAsPrimary();
  //   }
  // }

  void setDisplayMonitor(String displayName) {
    final display = Display.findByName(displayName);
    if (display != null && display.isConnected) {
      if (!display.isPrimary) display.setAsPrimary();
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

  // void openLED() {
  //   final serialPort = winsp.SerialPort.getAvailablePorts();
  //   final port = winsp.SerialPort(serialPort.first, BaudRate: 9600);

  //   if (port.isOpened) {
  //     port.close();
  //   } else {
  //     if (kDebugMode) print('Connected to: ${port.portName}');
  //   }

  //   port.open();

  //   var sendCom = 'O(00,01,0)E';
  //   port.writeBytesFromString(sendCom);
  //   if (port.isOpened) {
  //     port.close();
  //     // exit(-1);
  //   }
  // }

  void openLEDLibserial({String ledLocationAndStatus = ''}) {
    // final serialPort = SerialPort.availablePorts;
    final portConfig = SerialPortConfig();
    final port = SerialPort("COM1");
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

  // SUBSCRIPTION
  Future<bool?> getTerminalData({required Map<String, String> authorizationHeader}) async {
    Map<String, dynamic> variables = {"terminalID": 3, "status": "New", "delay": 5, "iteration": 50};

    Snapshot snapshot =
        await GlobalProvider().eventDataSubscription(headers: authorizationHeader, variables: variables);

    snapshot.listen((event) {
      if (kDebugMode) print('event: $event');
    }).onError(handleError);
    return null;
  }

  // Future getTerminalDataSubs({required Map<String, String> headers}) async {
  //   var response = GlobalProvider().terminalDataSubscription(headers: headers);
  //   if (kDebugMode) print('terminal response: ${response.toString()}');
  // }

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

  // TERMINALS

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
            transactionList[0].data.conversion.where((element) => element.code == code && element.type == 'TITLE'));
      } else {
        titleTrans.addAll(transactionList[0]
            .data
            .conversion
            .where((element) => element.languageId == languageID && element.code == code && element.type == 'TITLE'));
      }
      // titleTrans.addAll(transactionList[0]
      //     .data
      //     .conversion
      //     .where((element) => element.languageId == languageID && element.code == code && element.type == 'TITLE'));
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
        print('MENU ITEMS (code: $code | type: $type) : PAGE TRANS: ${pageTrans.length} : INDEX: $indexCode');
      }
      return true;
    } else {
      return false;
    }
    // return true;
  }
  // ---------------------------------------------------------------------------------------------------------
}

typedef Resolution = ({int width, int height});

extension on Resolution {
  /// Returns a prettified version of the [Resolution] (e.g. `1920 x 1080`).
  String prettify() {
    final (:width, :height) = this;
    return '$width x $height';
  }
}

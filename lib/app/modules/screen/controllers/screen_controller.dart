// ignore_for_file: unused_element

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
// import 'package:dart_vlc_ffi/dart_vlc_ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:intl/intl.dart';
import 'package:iotelkiosk/app/data/models_rest/weather_model.dart';
import 'package:iotelkiosk/globals/constant/bdotransaction_constant.dart';
import 'package:iotelkiosk/app/data/models_graphql/translation_terms_model.dart';
import 'package:iotelkiosk/app/data/models_rest/roomavailable_model.dart';

import 'package:iotelkiosk/app/providers/providers_global.dart';
import 'package:iotelkiosk/globals/services/controller/base_controller.dart';
import 'package:iotelkiosk/globals/services/devices/display_service.dart';
import 'package:translator/translator.dart';
import 'package:get/get.dart';
import 'package:hex/hex.dart';

class ScreenController extends GetxController with BaseController {
  // VARIABLE DECLARTION WITH OBSERVABLE CAPABILITY;

  // BOOLEAN
  final isLoading = false.obs;
  final isECREmpty = true.obs;
  final isBankNoteReadyToReceive = false.obs;

  // STRING
  final hostname = ''.obs;
  final imgUrl = ''.obs;
  final sCity = ''.obs;
  final tempC = '0'.obs;
  final tempF = '0'.obs;
  final weatherCondition = ''.obs;
  final weatherLocation = ''.obs;
  final weatherCountry = ''.obs;
  // INTEGER

  // LIST or OBJECT DATA
  final roomAvailableList = <RoomAvailableModel>[].obs;
  final translationTermsList = <TranslationTermsModel>[].obs;

  final roomsList = [].obs; //DYNAMIC KASI PABABAGO ANG OUTPUT
  final resultList = [].obs;

  // TRANSACTION VARIABLE
  final selectedNationalities = 77.obs;

  // MODEL LIST
  final weatherList = <WeatherModel>[].obs;

  // OTHER LIST
  List<int> serialReadList = [];

  // OTHERS
  final translator = GoogleTranslator();

  // DATE
  final dtNow = DateFormat.yMMMMd().format(DateTime.now());

  // LISTENING
  final player = Player(
    id: 0,
  );

  // GLOBAL
  // var ports = <String>[];
  // late SerialPort port;

  // APP LIFE CYCLE ***********************************************************************************
  @override
  void onInit() async {
    super.onInit();

    await getWeather();
    // isLoading.value = true;
    mediaOpen(useLocal: true);
    // isLoading.value = false;

    hostname.value = Platform.localHostname;

    // print(ngayon.toIso8601String());

    // monitorInfo();
    if (kDebugMode) setDisplayMonitor('DISPLAY3');

    // getBDOOpen(
    //     transactionCode: BDOTransaction.sSale,
    //     pricePerRoom: '2',
    //     messageResponseIndicator: BDOMessageData.sRequestRespondeIndicator0);
    // getMoneydispenser();
    // cardDispenser();
    // openLED();
    // openLEDLibserial(ledLocationAndStatus: LedOperation.bottomCENTERLEDON);

    // await userLogin();
    // final accessToken = userLoginList.first.accessToken;
    // final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'};

    // await getRoomType(credentialHeaders: headers, languageCode: selectedLanguageCode.value);
    // await getSeriesDetails(credentialHeaders: headers);

    // // CHECK THE LANGUAGE CODE
    // // if (languageList.first.data.languages.isNotEmpty) {
    // //   var langCode = languageList.first.data.languages.where((element) => element.id == selecttedLanguageID.value);
    // // }

    // String langcode = selectedLanguageCode.value;

    // await getAccommodation(credentialHeaders: headers, languageCode: langcode);
    // await getPaymentType(credentialHeaders: headers);

    // await getAvailableRoomsGraphQL(credentialHeaders: headers, roomTYPEID: 1, accommodationTYPEID: 1);
    // await getTerminalDataSubs(headers: headers);
    // await getTerminalData(authorizationHeader: headers);

    // await getTerms(credentialHeaders: headers, languageID: selecttedLanguageID.value);
  }

  // @override
  // void onReady() async {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();

  //   // port.close();
  // }

  // APP LIFE CYCLE ***********************************************************************************

  // ------------------------------------------------------------------------------------------------------
  // CONTROLLERS CODE

  // String? getAccessToken() {
  //   if (userLoginList.isEmpty) {
  //     return null;
  //   } else {
  //     return userLoginList.first.accessToken;
  //   }
  // }

  Future<bool> getWeather() async {
    final weatherResponse =
        await GlobalProvider().fetchWeather(queryParam: sCity.value.isEmpty ? 'Angeles City' : sCity.value);

    if (weatherResponse != null) {
      weatherList.add(weatherResponse);
      imgUrl.value = 'http:${weatherResponse.current.condition.icon}';
      tempC.value = weatherList.first.current.tempC.toStringAsFixed(0);
      tempF.value = weatherList.first.current.tempF.toStringAsFixed(0);
      weatherCondition.value = weatherList.first.current.condition.text;
      weatherLocation.value = weatherList.first.location.name;
      weatherCountry.value = weatherList.first.location.country;

      return true;
    }
    return false;
  }

  void getBDOOpen(
      {required String transactionCode,
      required String pricePerRoom,
      required String messageResponseIndicator,
      required String bdoPort}) {
    // final serialPort = SerialPort.availablePorts;
    final portConfig = SerialPortConfig();
    final port = SerialPort(bdoPort);
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

  void getMoneydispenser({required String moneyDispenserPort}) {
    // final serialPort = SerialPort.availablePorts;
    final portConfig = SerialPortConfig();
    final port = SerialPort(moneyDispenserPort);

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
      if (kDebugMode) print('The port $moneyDispenserPort is opened by other');
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

  // void cardDispenser({required String portNumber}) {
  //   // final serialPort = SerialPort.availablePorts;
  //   final port = SerialPort(portNumber);
  //   final portConfig = SerialPortConfig();

  //   portConfig.baudRate = 9600;
  //   // portConfig.parity = SerialPortParity.none;
  //   // portConfig.bits = 1;
  //   // portConfig.stopBits = 1;

  //   if (!port.openReadWrite()) {
  //     if (kDebugMode) print(SerialPort.lastError);
  //     // exit(-1);
  //   }

  //   var sendCmd = '02 00 00 00 02 52 46 03 00';
  //   Uint8List byteAP = Uint8List.fromList(HEX.decode(sendCmd));

  //   port.write(byteAP);

  //   if (kDebugMode) print('${port.name} is open');

  //   int readBuffer = 512;

  //   while (port.isOpen) {
  //     Uint8List bytesRead = port.read(readBuffer, timeout: 60);

  //     if (bytesRead.isNotEmpty) {
  //       if (kDebugMode) print('BYTES READ DECIMAL: $bytesRead');
  //       if (kDebugMode) print('BYTES READ HEX: ${HEX.encode(bytesRead).toUpperCase()}');
  //       var asciiTable = String.fromCharCodes(bytesRead);
  //       if (kDebugMode) print('ASCII: $asciiTable');
  //     }

  //     if (bytesRead.isEmpty) {
  //       port.close();
  //     }
  //   }
  // }

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

  // void openLEDLibserial({String ledLocationAndStatus = '', required String? portName}) {
  //   // final serialPort = SerialPort.availablePorts;
  //   final portConfig = SerialPortConfig();
  //   final port = SerialPort(portName!);
  //   portConfig.baudRate = 9600;
  //   portConfig.parity = SerialPortParity.none;

  //   if (port.isOpen) {
  //     port.close();
  //   } else {
  //     if (kDebugMode) print('Connected to: ${port.name}');
  //   }

  //   port.openWrite();
  //   // Encode the string using a specific encoding (e.g., ASCII)
  //   List<int> encodedBytes = ascii.encode(ledLocationAndStatus);
  //   // Create a Uint8List from the encoded bytes
  //   Uint8List uint8List = Uint8List.fromList(encodedBytes);

  //   if (port.isOpen) port.write(uint8List);

  //   if (port.isOpen) {
  //     port.close();
  //     // exit(-1);
  //   }
  // }

  // -----------------------------------------------------------------------------------------

  // -----------------------------------------------------------------------------------------

  void mediaOpen({required bool useLocal}) {
    if (kDebugMode) {
      player.setVolume(0);
    }
    player.open(
      useLocal
          ? Playlist(
              medias: [
                Media.asset('assets/background/iOtelWalkin.mp4'),
                Media.asset('assets/background/iotel.mp4'),
              ],
            )
          : Playlist(medias: [
              Media.network('https://www.youtube.com/watch?v=Mn254cnduOY&t=1426s', parse: true),
            ]),
      autoStart: true,
    );
  }

  // SUBSCRIPTION
  // Future<bool?> getTerminalData({required Map<String, String> authorizationHeader}) async {
  //   Map<String, dynamic> variables = {"terminalID": 3, "status": "New", "delay": 5, "iteration": 50};

  //   Snapshot snapshot =
  //       await GlobalProvider().eventDataSubscription(headers: authorizationHeader, variables: variables);

  //   snapshot.listen((event) {
  //     if (kDebugMode) print('event: $event');
  //   }).onError(handleError);
  //   return null;
  // }

  // Future getTerminalDataSubs({required Map<String, String> headers}) async {
  //   var response = GlobalProvider().terminalDataSubscription(headers: headers);
  //   if (kDebugMode) print('terminal response: ${response.toString()}');
  // }

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

  // TERMINALS

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
}

typedef Resolution = ({int width, int height});

extension on Resolution {
  /// Returns a prettified version of the [Resolution] (e.g. `1920 x 1080`).
  String prettify() {
    final (:width, :height) = this;
    return '$width x $height';
  }
}

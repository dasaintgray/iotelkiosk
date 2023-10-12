import 'dart:typed_data';

class SSPCommand {
  // Define the structure for SSP_COMMAND (you need to match the actual structure)
}

enum LevelCheck {
  off,
  on,
}

enum FloatMode {
  payoutToPayout,
  payoutToCashbox,
}

enum PayoutRequestStatus {
  levelNotSufficient,
  notExactAmount,
  hopperBusy,
  hopperDisabled,
  reqStatusOK,
}

enum DealMode {
  split,
  free,
}

class Coin {
  late int coinValue;
  late int coinLevel;
  late Uint8List countryCode;
}

const int maxCoinChannel = 30;

class Pay {
  late int numberOfCoinValues;
  List<Coin> coinsToPay = List<Coin>.filled(maxCoinChannel, Coin());
  List<Coin> coinsInHopper = List<Coin>.filled(maxCoinChannel, Coin());
  List<int> floatMode = List<int>.filled(maxCoinChannel, 0);
  List<int> dealTest = List<int>.filled(maxCoinChannel, 0);
  List<int> searchTime = List<int>.filled(maxCoinChannel, 0);
  List<int> splitQty = List<int>.filled(maxCoinChannel, 0);
  late int amountPayOutRequest;
  late Uint32List amountPaidOut;
  late int floatAmountRequest;
  late Uint32List minPayout;
  late Uint32List valueInHopper;
  late Uint32List cashboxAmount;
  late Uint32List totalAvailableValue;
  late int globalSearchTime;
  late Uint8List countryCode;
  late int newCoinCredit;
  late int amountToPay;
  late int mode;
  late int dealMode;
  late int levelMode;
  late int exitMode;
  late int minPayoutRequest;
  late Uint8List payoutCountryReq;
  late int protocolVersion;
  late int currentCountryIndex;
  late int numCountries;
  late Uint8List multiCountryCodes;
}

class CCTUDT {
  late int param1;
  late int param2;
  late int param3;
  late int param4;
  late int n;
  Uint8List buffer = Uint8List(256);
  Uint8List secArray = Uint8List(6);
}

// int createHostInterKey(Int64List keyArray);
// int createSlaveInterKey(Int64List keyArray);
// int createSlaveEncryptionKey(Int64List keyArray);

// int testSSPSlaveKeys(Int64List keyArray);
// int createSSPHostEncryptionKey(Int64List keyArray);
// int encryptSSPPacket(int ptNum, Uint8List dataIn, Uint8List dataOut, Uint8List lengthIn, Uint8List lengthOut, Int64List key);
// int encryptSSPMultiplePortPacket(int portIndex, int address, Uint8List dataIn, Uint8List dataOut, Uint8List lengthIn, Uint8List lengthOut, Int64List key);
// int decryptSSPPacket(Uint8List dataIn, Uint8List dataOut, Uint8List lengthIn, Uint8List lengthOut, Int64List key);
// int getProcDLLVersion(Uint8List ver);
// int initiateSSPHostKeys(Int64List keyArray, SSPCommand cmd);
// int testSplit(Pay pay, int valueToFind);

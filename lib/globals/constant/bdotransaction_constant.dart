class BDOTransaction {
  static const String sSale = '20';
  static const String sVoid = '26';
  static const String sCardVerify = '37';
  static const String sCompletion = '38';
  static const String sTipAdjustment = '28';
  static const String sCommunicationTest = 'D0';
  static const String sSettlement = '50';
  static const String sInstallmentSale = '22';
  static const String sInstallmentVoid = '23';
  static const String sReprintReceipt = '71';
}

class BDOResponseCode {
  static const String sApproved = '00';
  static const String sVoiceReferral = '01';
  static const String sDeclined = 'ND';
  static const String sDestinationError = 'ED';
  static const String sNetworkErrorRequest = 'EN';
  static const String sTimeOut = 'TO';
  static const String sTransactionNotAvailable = 'NA';
}

class BDOMessageData {
  // NOTE: THE VALUE IS IN HEX FORMAT
  static const String sSTX = '02';
  static const String sETX = '03';
  static const String sTransportHeaderType = '3630';
  static const String sTransportDestination = '30303030';
  static const String sTransportSource = '30303030';
  static const String sFormatVersion = '31';
  static const String sRequestRespondeIndicator0 = '30';
  static const String sRequestRespondeIndicator1 = '31';
  static const String sRequestRespondeIndicator2 = '32';
  static const String sResponseCode = '3030';
  static const String sMoreIndicator0 = '30';
  static const String sMoreIndicator1 = '31';
  static const String sFieldSeparator = '1C';
  static const String sTransactionAmount = '3430';
  static const String sFieldLength = '0012';
}

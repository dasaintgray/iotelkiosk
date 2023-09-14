class BankNoteCommand {
  static const String sSTX = '7F';
  static const String sSYNC = '11';
  static const String sRESET = '01';
  static const String sHOSTPROTOCOLVERSION = '06';
  static const String sPOLL = '07';
  static const String sGETSERIALNUMBER = '0C';
  static const String sDISABLE = '09';
  static const String sENABLE = '0A';
  static const String sGETFIRMWAREVERSION = '20';
  static const String sGETDATASETVERSION = '21';
  static const String sSETINHIBITS = '02';
  static const String sREJECT = '08';
  static const String sLASTREJECTCODE = '17';
  static const String sGETBARCODEREADERCONFIGURATION = '23';
  static const String sSETBARCODEREADERCONFIGURATION = '24';
  static const String sGETBARCODEINHIBIT = '25';
  static const String sSETBARCODEINHIBIT = '26';
  static const String sGETBARCODEDATA = '27';
  static const String sCONFIGUREBEZEL = '54';
  static const String sPOLLWITHACK = '56';
  static const String sEVENTACT = '57';
  static const String sGETCOUNTERS = '58';
  static const String sRESETCOUNTERS = '59';
  static const String sSETGENERATOR = '4A';
  static const String sSETMODULUS = '4B';
  static const String sREQUESTKEYEXCHANGE = '4C';
  static const String sGETBUILDVERSION = '4F';
  static const String sSETBAUDRATE = '4D';
  static const String sSSPSETENCRYPTIONKEY = '60';
  static const String sSSPENCRYPTIONRESETTODEFAULT = '61';
  static const String sSSPDOWNLOADDATAPACKET = '74';
  static const String sHOLD = '18';
  static const String sSETUPREQUEST = '05';
  static const String sSLAVERESET = 'F1';
  static const String sREAD = 'EF';
  static const String sNOTECREDIT = 'EE';
  static const String sREJECTING = 'ED';
  static const String sREJECTED = 'EC';
  static const String sSTACKED = 'EB';
  static const String sUNSAFEJAM = 'E9';
  static const String sDISABLED = 'E8';
  static const String sFRAUDATTEMPT = 'E6';
  static const String sSTACKERFULL = 'E7';
  static const String sNOTECLEAREDFROMFRONT = 'E1';
  static const String sNOTECLEAREDINTOCASHBOX = 'E2';
  static const String sCASHBOXREMOVED = 'E3';
  static const String sCASHBOXREPLACED = 'E4';
  static const String sBARCODETICKETVALIDATED = 'E5';
  static const String sBARCODETICKETACK = 'D1';
  static const String sNOTEPATHOPEN = 'E0';
  static const String sCHANNELDISABLE = 'B5';
  static const String sINITIALISING = 'B6';
}

enum Pera {
  bente(20.00, "p20"),
  tapwe(50.00, "p50"),
  isangdaan(100.00, "p100"),
  dalawangdaan(200.00, "p200"),
  limangdaan(500.00, "p500"),
  isanglibo(1000.00, "p1000");

  final double halaga;
  final String value;

  const Pera(this.halaga, this.value);
}



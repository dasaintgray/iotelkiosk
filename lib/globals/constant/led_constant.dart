class LedOperation {
  
  LedOperation._();

  // TOP LEFT
  static const String cameraON = 'O(00,01,3)E';
  static const String cameraOFF = 'O(00,01,0)E';

  // TOP RIGHT
  static const String cardON = 'O(00,03,3)E';
  static const String cardOFF = 'O(00,03,0)E';

  // BOTTOM LEFT
  static const String printingON = 'O(00,07,3)E';
  static const String printingOFF = 'O(00,07,0)E';

  // BOTTOM CENTER
  static const String qrcodeON = 'O(00,09,3)E';
  static const String qrcodeOFF = 'O(00,09,0)E';

  // BOTTOM RIGHT
  static const String cashDispenserON = 'O(00,11,3)E';
  static const String cashDispenserOFF = 'O(00,11,0)E';
}

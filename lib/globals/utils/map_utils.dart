import 'dart:math' show cos, sqrt, asin;
import 'package:intl/intl.dart';

double calculateDistance(double lat1, double long1, double lat2, double long2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((long2 - long1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

NumberFormat formatPrice() {
  return NumberFormat('#,###', 'en_US');

  // return formatter.format(number);
}

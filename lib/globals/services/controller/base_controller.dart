import 'package:iotelkiosk/globals/helper/dialog_helper.dart';
import 'package:iotelkiosk/globals/services/exceptions/base_client_exception.dart';

class BaseController {
  void handleError(error) {
    hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      DialogHelper.showErroDialog(description: message);
    } else if (error is FetchDataException) {
      var message = error.message;
      DialogHelper.showErroDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      DialogHelper.showErroDialog(description: 'Oops! It took longer to respond the api, call the developer.');
    }
  }

  void showLoading([String? message]) {
    DialogHelper.showLoading(message);
  }

  void hideLoading() {
    DialogHelper.hideLoading();
  }

  // bool? checkTokenExpiration() {
  //   String? expireTime = HenryStorage.readFromLS(titulo: HenryGlobal.cargoJWTTokenExpire);

  //   var expirationTime = expireTime == null ? int.parse("0") : int.parse(expireTime);

  //   DateTime ngayonOras = DateTime.now();

  //   final ct = (ngayonOras.millisecondsSinceEpoch.abs() ~/ 1000).toInt();
  //   // expirationTime ??= 0;
  //   if (expirationTime <= ct) {
  //     return true;
  //   }
  //   return false;
  // }
}

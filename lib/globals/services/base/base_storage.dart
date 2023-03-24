import 'package:get_storage/get_storage.dart';

class HenryStorage {
  /// use this to [saveToken] to local storage
  static saveToken(String tokenValue) {
    return GetStorage().write("token", tokenValue);
  }

  /// use this to [getToken] from local storage
  static getToken() {
    return GetStorage().read("token");
  }

  /// use this to [deleteToken] from local storage
  deleteToken() {
    return GetStorage().remove("token");
  }

  /// use this to [saveUsername] to local storage
  static saveUsername(String userName) {
    return GetStorage().write('name', userName);
  }

  /// use this to [getUsername] from local storage
  static getUsername() {
    return GetStorage().read('name');
  }

  //GLOBAL Method
  static saveToLS(String tokenValue, {String? titulo = "token"}) {
    return GetStorage().write(titulo!, tokenValue);
  }

  static readFromLS({String? titulo = "token"}) {
    return GetStorage().read(titulo!);
  }

  static deleteFromLS({String? titulo = "token"}) {
    return GetStorage().remove(titulo!);
  }
}

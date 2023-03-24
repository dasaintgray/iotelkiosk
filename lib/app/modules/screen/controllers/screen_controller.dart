import 'package:get/get.dart';

import 'package:iotelkiosk/app/data/models_rest/weather_model.dart';
import 'package:iotelkiosk/app/providers/providers_global.dart';
import 'package:iotelkiosk/globals/services/controller/base_controller.dart';

class ScreenController extends GetxController with BaseController {
  // VARIABLE DECLARTION WITH OBSERVABLE CAPABILITY;
  // BOOLEAN
  final isLoading = false.obs;

  // STRING
  final imgUrl = ''.obs;

  // LIST or OBJECT DATA
  final weatherList = <WeatherModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getWeather();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //   getWeather();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  Future<bool> getWeather() async {
    isLoading.value = true;
    final weatherResponse = await GlobalProvider().fetchWeather(queryParam: 'Angeles City');
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
}

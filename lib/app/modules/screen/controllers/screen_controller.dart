import 'dart:async';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:get/get.dart';
import 'package:iotelkiosk/app/data/models_graphql/settings_model.dart';

import 'package:iotelkiosk/app/data/models_rest/weather_model.dart';
import 'package:iotelkiosk/app/providers/providers_global.dart';
import 'package:iotelkiosk/globals/services/controller/base_controller.dart';

class ScreenController extends GetxController with BaseController {
  // VARIABLE DECLARTION WITH OBSERVABLE CAPABILITY;

  // BOOLEAN
  final isLoading = false.obs;

  // STRING
  final imgUrl = ''.obs;
  final sCity = ''.obs;

  // INTEGER

  // LIST or OBJECT DATA
  final weatherList = <WeatherModel>[].obs;
  final settingsList = <SettingsModel>[].obs;

  final player = Player(
    id: 0,
  );

  @override
  void onInit() async {
    super.onInit();
    await getSettings();
    await getWeather();
    mediaOpen();
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

  void mediaOpen() {
    player.setVolume(0);
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

  Future<bool> getSettings() async {
    isLoading.value = true;
    final settingsResponse = await GlobalProvider().fetchSettings();

    try {
      if (settingsResponse != null) {
        settingsList.add(settingsResponse);

        // GET CITY
        final cityIndex = settingsResponse.data.settings.indexWhere((element) => element.code == "CITY");
        sCity.value = settingsResponse.data.settings[cityIndex].value;

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
}

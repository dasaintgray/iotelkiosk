import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/screen/bindings/screen_binding.dart';
import '../modules/screen/views/screen_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SCREEN,
      page: () => ScreenView(),
      bindings: [
        ScreenBinding(),
        HomeBinding(),
      ],
    ),
  ];
}

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_acrylic/flutter_acrylic.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // VIDEO PLAYER
  DartVLC.initialize();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1080, 1920),
    fullScreen: true,
    center: true,
    alwaysOnTop: false,
    skipTaskbar: false,
    // titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(
    windowOptions,
    () async {
      await windowManager.setFullScreen(true);
      await windowManager.setAlignment(Alignment.center);
      await windowManager.show();
      await windowManager.focus();
    },
  );

  // aero mode
  // if (Platform.isWindows) {
  //   // await Window.setEffect(
  //   //   effect: WindowEffect.acrylic,
  //   //   color: const Color.fromARGB(255, 8, 59, 100).withOpacity(0.6),
  //   // );
  //   // await Window.initialize();
  // }

  runApp(
    GetMaterialApp(
      title: "iOtel Kiosk Application",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      themeMode: ThemeMode.light,
      defaultTransition: Transition.fadeIn,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'ProductSans',
        scaffoldBackgroundColor: const Color.fromARGB(0, 51, 51, 51),
      ),
    ),
  );
}

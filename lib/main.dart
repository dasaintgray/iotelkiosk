// import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_acrylic/flutter_acrylic.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

import 'package:window_manager/window_manager.dart';

void main() async {
  // FOR FLUTTER INITIALIZATION
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // VIDEO PLAYER INITIALIZATION
  // MediaKit.ensureInitialized();

  await windowManager.ensureInitialized();

  // WindowOptions windowOptions = const WindowOptions(
  //   size: Size(1920, 1080),
  //   // size: Size(800, 600),
  //   // fullScreen: true,
  //   center: true,
  //   alwaysOnTop: false,
  //   skipTaskbar: false,
  //   titleBarStyle: TitleBarStyle.normal,
  // );

  // windowManager.waitUntilReadyToShow(
  //   windowOptions,
  //   () async {
  //     await windowManager.setFullScreen(true);
  //     await windowManager.setAlignment(Alignment.center);
  //     await windowManager.isDockable();
  //     await windowManager.focus();
  //     await windowManager.show();
  //   },
  // );

  runApp(
    GetMaterialApp(
      // builder: (context, child) => AccessibilityTools(
      //   checkFontOverflows: true,
      //   checkSemanticLabels: false,
      //   checkMissingInputLabels: false,
      //   minimumTapAreas: MinimumTapAreas.material,
      //   child: child,
      // ),
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

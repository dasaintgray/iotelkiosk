import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/app/modules/home/views/home_view.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:sizer/sizer.dart';

import '../controllers/screen_controller.dart';

class ScreenView extends GetView<ScreenController> {
  ScreenView({Key? key}) : super(key: key);

  // CONTROLLER
  final sc = Get.find<ScreenController>();
  final hc = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    hc.startTimer();
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return GestureDetector(
          onTap: () {
            sc.player.stop();
            Get.to(() => HomeView());
          },
          child: Stack(
            children: [
              // BACKGROUND
              // Positioned(
              //   child: Container(
              //     decoration: const BoxDecoration(
              //       image: DecorationImage(
              //         image: AssetImage('assets/background/main.png'),
              //         fit: BoxFit.fill,
              //         alignment: Alignment.topLeft,
              //       ),
              //     ),
              //   ),
              // ),

              // VIDEOS
              Positioned(
                child: Video(
                  player: sc.player,
                  showControls: false,
                ),
              ),

              // IMAGE CAROUSEL - BANNER ADS
              Positioned(
                bottom: 8.h,
                left: 10.sp,
                right: 10.sp,
                child: Container(
                  color: Colors.white,
                  height: 200,
                  width: 100,
                ),
              ),

              Obx(
                () => Scaffold(
                  body: SizedBox(
                    height: 8.h,
                    width: double.infinity,
                    child: sc.imgUrl.isEmpty
                        ? null
                        : Padding(
                            padding: const EdgeInsets.only(top: 20, right: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.network(
                                      sc.imgUrl.value,
                                      fit: BoxFit.contain,
                                      height: 80,
                                      width: 100,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${sc.weatherList.first.current.tempC.toStringAsFixed(0)}° C',
                                          style: TextStyle(color: HenryColors.puti, fontSize: 5.sp),
                                        ),
                                        Text(
                                          '${sc.weatherList.first.current.tempF.toStringAsFixed(0)}° F',
                                          style: TextStyle(color: HenryColors.puti, fontSize: 5.sp),
                                        ),
                                        Text(sc.weatherList.first.current.condition.text,
                                            style: TextStyle(color: HenryColors.puti, fontSize: 3.sp)),
                                      ],
                                    ),
                                  ],
                                ),
                                Text('${sc.weatherList.first.location.name}, ${sc.weatherList.first.location.country}',
                                    style: TextStyle(color: HenryColors.puti, fontSize: 3.sp))
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

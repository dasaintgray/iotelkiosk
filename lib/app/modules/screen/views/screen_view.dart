import 'package:dart_vlc/dart_vlc.dart';
// import 'package:dart_vlc_ffi/dart_vlc_ffi.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/views/home_view.dart';
import 'package:iotelkiosk/globals/constant/theme_constant.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';

import '../controllers/screen_controller.dart';

class ScreenView extends GetView<ScreenController> {
  ScreenView({Key? key}) : super(key: key);

  // CONTROLLER
  // final sc = Get.find<ScreenController>();
  final sc = Get.put(ScreenController());

  @override
  Widget build(BuildContext context) {
    sc.player.playbackStream.listen(
      (PlaybackState state) {
        if (state.isCompleted) {
          sc.player.play();
        }
      },
    );
    // hc.startTimer();

    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return Obx(
          () => GestureDetector(
            onTap: () {
              if (!sc.isLoading.value) {
                sc.player.stop();
                sc.getMenu(code: 'SLMT', type: 'TITLE');
                Get.to(() => HomeView());
              }
            },
            child: Stack(
              children: [
                // VIDEOS
                sc.isLoading.value
                    ? Positioned(
                        top: 40.h,
                        left: 25.sp,
                        right: 25.sp,
                        bottom: 40.h,
                        child: SizedBox(
                          child: Center(
                            child: Column(
                              children: [
                                const CircularProgressIndicator.adaptive(
                                  backgroundColor: HenryColors.puti,
                                ),
                                DefaultTextStyle(
                                  style: TextStyle(color: HenryColors.puti, fontSize: 15.sp),
                                  child: const Text('Loading video, please wait...'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Positioned(
                        child: Video(
                          fit: BoxFit.fill,
                          player: sc.player,
                          showControls: false,
                          filterQuality: FilterQuality.high,
                        ),
                      ),

                // IOTEL LOGO
                Positioned(
                  top: 20.sp,
                  left: 10.sp,
                  child: Container(
                    height: 20.h,
                    width: 20.w,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/png/iotellogo.png'),
                        fit: BoxFit.contain,
                        alignment: Alignment.topLeft,
                      ),
                    ),
                  ),
                ),

                // CM LGO
                Positioned(
                  top: 95.h,
                  left: 40.w,
                  // bottom: 10.h,
                  right: 40.w,
                  child: Container(
                    height: 5.h,
                    width: 5.w,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/png/cmlogo.png'),
                        fit: BoxFit.contain,
                        alignment: Alignment.topLeft,
                      ),
                    ),
                  ),
                ),

                // IMAGE CAROUSEL - BANNER ADS
                Positioned(
                  bottom: 8.h,
                  left: 10.sp,
                  right: 10.sp,
                  child: Container(
                    color: Colors.transparent,
                    height: 200,
                    width: 100,
                    child: DefaultTextStyle(
                      style: TextStyle(fontSize: 25.sp, color: HenryColors.puti),
                      textAlign: TextAlign.center,
                      child: Center(
                        child: sc.isLoading.value
                            ? const CircularProgressIndicator.adaptive()
                            : Marquee(
                                text: '${sc.availRoomList.length} Available Rooms as of today ${sc.dtNow}',
                                // HenryGlobal.longText,
                                // style: const TextStyle(color: HenryColors.puti),
                                scrollAxis: Axis.vertical,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                blankSpace: 20.0,
                                velocity: 100.0,
                                pauseAfterRound: const Duration(seconds: 2),
                                startPadding: 10.0,
                                accelerationDuration: const Duration(seconds: 2),
                                accelerationCurve: Curves.linear,
                                decelerationDuration: const Duration(milliseconds: 500),
                                decelerationCurve: Curves.elasticIn,
                              ),
                      ),
                    ),
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
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(sc.weatherList.first.current.condition.text,
                                      style: TextStyle(color: HenryColors.puti, fontSize: 3.sp)),
                                  Text(
                                      '${sc.weatherList.first.location.name}, ${sc.weatherList.first.location.country}',
                                      style: TextStyle(color: HenryColors.puti, fontSize: 3.sp))
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

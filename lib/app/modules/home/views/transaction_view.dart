// import 'package:flutter/material.dart';
// import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
// import 'package:iotelkiosk/app/modules/screen/controllers/screen_controller.dart';
// import 'package:iotelkiosk/globals/constant/theme_constant.dart';
// import 'package:iotelkiosk/globals/widgets/henryclock_widget.dart';
// import 'package:sizer/sizer.dart';

// class TransactionView extends GetView {
//   TransactionView({Key? key}) : super(key: key);

//   final hc = Get.find<HomeController>();
//   final sc = Get.find<ScreenController>();

//   // final DateTime dtLocalTime = DateTime.now();

//   @override
//   Widget build(BuildContext context) {
//     return Sizer(
//       builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
//         return GestureDetector(
//           onTap: () {
//             hc.resetTimer();
//             hc.initTimezone();
//           },
//           child: Stack(
//             children: [
//               Positioned(
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/background/bck.png'),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: orientation == Orientation.portrait ? 25.h : 5.h,
//                 bottom: orientation == Orientation.portrait ? 65.h : 45.h,
//                 left: orientation == Orientation.portrait ? 40.w : 45.w,
//                 right: orientation == Orientation.portrait ? 40.w : 45.w,
//                 child: SizedBox(
//                   child: Image.asset('assets/png/iotellogo.png', fit: BoxFit.contain),
//                 ),
//               ),
//               Obx(
//                 () => Scaffold(
//                   body: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         clockAndWeather(),
//                         SizedBox(
//                           height: orientation == Orientation.portrait ? 15.h : 1.h,
//                           width: double.infinity,
//                         ),
//                         menuTitle(),
//                         menuTransactionTitle(orientation),
//                         SizedBox(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               InkWell(
//                                 onTap: () {
//                                   hc.getMenu(languageID: 0, code: 'SLMT', type: 'TITLE');
//                                   Get.back();
//                                 },
//                                 child: Image.asset(
//                                   'assets/menus/back-arrow.png',
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 50,
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   // hc.getMenu(languageID: 0, code: 'SLMT', type: 'TITLE');
//                                   // Get.back();
//                                 },
//                                 child: Image.asset(
//                                   'assets/menus/forward-arrow.png',
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget menuTransactionTitle(Orientation orientation) {
//     return SizedBox(
//       height: orientation == Orientation.portrait ? 45.h : 25.h,
//       width: 70.w,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(25.0),
//         itemCount: hc.pageTrans.length,
//         itemBuilder: (BuildContext context, int index) {
//           return SizedBox(
//             height: 10.h,
//             child: Stack(
//               children: [
//                 Positioned(
//                   left: 25.w,
//                   top: 35,
//                   right: 10.w,
//                   child: SizedBox(
//                     width: 10.w,
//                     child: Text(
//                       hc.pageTrans[index].translationText,
//                       style: TextStyle(
//                         color: HenryColors.darkGreen,
//                         fontSize: 12.sp,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: 8.w,
//                   right: 8.w,
//                   child: InkWell(
//                     onTap: () {
//                       // var response = hc.getMenu(
//                       //     languageID: hc.languageList.first.data.languages[index].id,
//                       //     code: 'ST${hc.languageList.first.data.languages[index].code}',
//                       //     type: 'TITLE');
//                       // if (response != 0) {
//                       //   // Get.to(() => TransactionView());
//                       // }
//                     },
//                     child: Hero(
//                       tag: hc.pageTrans[index].code + index.toString(),
//                       child: SizedBox(
//                         height: 7.h,
//                         child: Image.asset(hc.pageTrans[index].images!, fit: BoxFit.contain),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget clockAndWeather() {
//     return SizedBox(
//       height: 23.h,
//       width: double.infinity,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: SizedBox(
//                     // width: 10.w,
//                     child: Obx(
//                       () => Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             DateFormat("EEEE").format(hc.localTime.value),
//                             style: TextStyle(color: HenryColors.puti, fontSize: 4.sp),
//                           ),
//                           Text(
//                             DateFormat("MMMM, dd, y").format(hc.localTime.value),
//                             style: TextStyle(color: HenryColors.puti, fontSize: 4.sp),
//                           ),
//                           const Divider(
//                             color: HenryColors.puti,
//                             thickness: 2,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 12),
//                             child: HenryClock(
//                               locationOfTime: 'Philippines',
//                               locationStyle: const TextStyle(color: HenryColors.puti, fontSize: 15),
//                               dateTime: hc.localTime.value,
//                               isLive: true,
//                               useClockSkin: false,
//                               showSeconds: false,
//                               textScaleFactor: 1,
//                               digitalClockTextColor: HenryColors.darkGreen,
//                               // decoration: const BoxDecoration(
//                               //   shape: BoxShape.rectangle,
//                               //   borderRadius: BorderRadius.all(Radius.zero),
//                               // ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 65.w,
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: SizedBox(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Image.network(
//                               sc.imgUrl.value,
//                               fit: BoxFit.cover,
//                               height: 80,
//                               width: 100,
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '${sc.weatherList.first.current.tempC.toStringAsFixed(0)}° C',
//                                   style: TextStyle(color: HenryColors.puti, fontSize: 5.sp),
//                                 ),
//                                 Text(
//                                   '${sc.weatherList.first.current.tempF.toStringAsFixed(0)}° F',
//                                   style: TextStyle(color: HenryColors.puti, fontSize: 5.sp),
//                                 ),
//                                 Text(sc.weatherList.first.current.condition.text,
//                                     style: TextStyle(color: HenryColors.puti, fontSize: 3.sp)),
//                               ],
//                             ),
//                           ],
//                         ),
//                         const Divider(
//                           color: HenryColors.puti,
//                           thickness: 3,
//                         ),
//                         Text('${sc.weatherList.first.location.name}, ${sc.weatherList.first.location.country}',
//                             style: TextStyle(color: HenryColors.puti, fontSize: 3.sp))
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               HenryClock(
//                 locationOfTime: 'Japan',
//                 locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
//                 dateTime: hc.japanNow,
//                 isLive: true,
//                 showSeconds: false,
//                 use24Hour: true,
//                 useClockSkin: true,
//                 textScaleFactor: 2,
//                 digitalClockTextColor: Colors.black,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.all(Radius.zero),
//                 ),
//               ),
//               HenryClock(
//                 locationOfTime: 'New York',
//                 locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
//                 dateTime: hc.newyorkNow,
//                 isLive: true,
//                 showSeconds: false,
//                 use24Hour: true,
//                 useClockSkin: true,
//                 textScaleFactor: 2,
//                 digitalClockTextColor: Colors.black,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.all(Radius.zero),
//                 ),
//               ),
//               HenryClock(
//                 locationOfTime: 'Seoul',
//                 locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
//                 dateTime: hc.seoulNow,
//                 isLive: true,
//                 showSeconds: false,
//                 use24Hour: true,
//                 useClockSkin: true,
//                 textScaleFactor: 2,
//                 digitalClockTextColor: Colors.black,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.all(Radius.zero),
//                 ),
//               ),
//               HenryClock(
//                 locationOfTime: 'Sydney',
//                 locationStyle: TextStyle(color: HenryColors.puti, fontSize: 8.sp),
//                 dateTime: hc.sydneyNow,
//                 isLive: true,
//                 showSeconds: false,
//                 use24Hour: true,
//                 useClockSkin: true,
//                 textScaleFactor: 2,
//                 digitalClockTextColor: Colors.black,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.all(Radius.zero),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget menuTitle() {
//     return SizedBox(
//       height: 5.h,
//       width: 50.w,
//       child: FlutterCarousel.builder(
//         itemCount: hc.titleTrans.length,
//         itemBuilder: (BuildContext context, int index, int realIndex) {
//           return SizedBox(
//             height: 10.h,
//             width: double.infinity,
//             child: Center(
//               child: Text(hc.titleTrans[index].translationText,
//                   style: TextStyle(color: HenryColors.darkGreen, fontSize: 13.sp)),
//             ),
//           );
//         },
//         options: CarouselOptions(autoPlay: true, showIndicator: false, reverse: true),
//       ),
//     );
//   }
// }

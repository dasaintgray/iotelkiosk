import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iotelkiosk/app/modules/home/controllers/home_controller.dart';
import 'package:iotelkiosk/globals/widgets/kioskbi_widget.dart';
import 'package:iotelkiosk/globals/widgets/companylogo_widget.dart';
import 'package:iotelkiosk/globals/widgets/kioskheader_widget.dart';
import 'package:sizer/sizer.dart';

class CheckoutView extends GetView<HomeController> {
  CheckoutView({Key? key}) : super(key: key);

  final hc = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return Stack(
          children: [
            const KioskBackgroundImage(),
            orientation == Orientation.portrait
                ? CompanyLogo(top: 15.h, bottom: 65.h, left: 35.w, right: 35.w)
                : CompanyLogo(top: 5.h, bottom: 45.h, left: 45.w, right: 45.w),
            Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(
                    () => KioskHeader(
                      isLive: hc.clockLiveUpdate.value,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 5.h,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

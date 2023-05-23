import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:iotelkiosk/app/data/models_graphql/transaction_model.dart';
import 'package:sizer/sizer.dart';

class CarouselTitle extends StatelessWidget {
  final List<Conversion> titleTrans;
  final TextStyle textStyle;
  const CarouselTitle({super.key, required this.titleTrans, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return FlutterCarousel.builder(
      itemCount: titleTrans.length,
      itemBuilder: (BuildContext context, int ctr, int realIndex) {
        return SizedBox(
          height: 10.h,
          width: double.infinity,
          child: Center(
            child: Text(
              titleTrans.length == 1 ? titleTrans.first.translationText : titleTrans[ctr].translationText,
              style: textStyle,
            ),
          ),
        );
      },
      options: CarouselOptions(
          autoPlay: titleTrans.length == 1 ? false : true,
          showIndicator: false,
          reverse: true,
          scrollDirection: Axis.vertical),
    );
  }
}

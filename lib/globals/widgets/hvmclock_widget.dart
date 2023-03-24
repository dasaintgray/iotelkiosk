import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

/// Create the custom Clock Widget
/// Author: Henry V. Mempin
/// Date: 14 March, 2023
/// email: henrymempin@gmail.com

class HVMClock extends StatelessWidget {
  final DateTime? datetime;
  final String? location;
  // final Widget? child;
  final TextStyle? locationStyle;
  final TextStyle? clockStyle;
  final Color? clockColor;
  final bool? defaultStyleAndColor = true;

  const HVMClock({
    super.key,
    required this.datetime,
    required this.location,
    required this.locationStyle,
    this.clockStyle,
    this.clockColor,
    // this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return SafeArea(
          // minimum: const EdgeInsets.all(10),
          child: SizedBox(
            width: 100,
            height: 70,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform(
                      transform: Matrix4.skewX(-0.2),
                      child: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.white),
                        child: Text(
                          DateFormat('HH').format(datetime!),
                          textAlign: TextAlign.justify,
                          style: defaultStyleAndColor!
                              ? const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)
                              : TextStyle(color: clockColor!, fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.skewX(-0.1),
                      child: Image.asset(
                        'assets/png/dot.png',
                        fit: BoxFit.cover,
                        height: 18,
                        width: 4,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.skewX(-0.2),
                      child: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.white),
                        child: Text(
                          DateFormat('mm').format(datetime!),
                          textAlign: TextAlign.justify,
                          style: defaultStyleAndColor!
                              ? const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)
                              : TextStyle(color: clockColor!, fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(
                //   height: 2,
                // ),
                SizedBox(
                  child: Text(
                    location!,
                    style: locationStyle!,
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

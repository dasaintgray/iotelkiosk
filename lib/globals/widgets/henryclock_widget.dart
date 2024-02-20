import 'package:flutter/material.dart';
import 'dart:async';

import 'package:intl/intl.dart' as intl;

/// Create the custom Clock Widget
/// Author: Henry V. Mempin
/// Date: 15 March, 2023
/// email: henrymempin@gmail.com

class HenryClock extends StatefulWidget {
  final DateTime? dateTime;

  final bool showSeconds;
  final bool use24Hour;
  final BoxDecoration? decoration;
  final Color digitalClockTextColor;
  final EdgeInsets? padding;
  final bool isLive;
  final bool useClockSkin;
  final double textScaleFactor;
  final String? locationOfTime;
  final TextStyle? locationStyle;

  // const HenryClock({super.key, this.location, this.clockColor});
  const HenryClock(
      {this.dateTime,
      this.showSeconds = true,
      this.use24Hour = false,
      this.useClockSkin = false,
      this.decoration,
      this.padding,
      this.digitalClockTextColor = Colors.black,
      this.textScaleFactor = 1.0,
      required this.locationOfTime,
      required this.locationStyle,
      isLive,
      super.key})
      : isLive = isLive ?? (dateTime == null);

  @override
  // ignore: no_logic_in_create_state
  State<HenryClock> createState() => _HenryClockState(dateTime);
  // @override
  // _HenryClockState createState() => _HenryClockState(dateTime);
}

class _HenryClockState extends State<HenryClock> {
  DateTime initialDatetime; // to keep track of time changes
  DateTime datetime;

  Duration updateDuration = const Duration(seconds: 1); // repaint frequency
  _HenryClockState(datetime)
      : datetime = datetime ?? DateTime.now(),
        initialDatetime = datetime ?? DateTime.now();

  @override
  initState() {
    super.initState();
    // don't repaint the clock every second if second hand is not shown
    updateDuration = widget.showSeconds ? const Duration(seconds: 1) : const Duration(minutes: 1);

    if (widget.isLive) {
      // update clock every second or minute based on second hand's visibility.
      Timer.periodic(updateDuration, update);
    }
  }

  update(Timer timer) {
    if (mounted) {
      // update is only called on live clocks. So, it's safe to update datetime.
      datetime = initialDatetime.add(updateDuration * timer.tick);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.decoration,
      padding: widget.padding,
      child: Container(
          constraints: BoxConstraints(
              minWidth: widget.showSeconds ? 110 * widget.textScaleFactor : 60.0 * widget.textScaleFactor,
              minHeight: 20.0 * widget.textScaleFactor),
          child: widget.useClockSkin
              ? SizedBox(
                  width: 200,
                  height: 150,
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
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                              child: Text(
                                intl.DateFormat('HH').format(datetime),
                                textAlign: TextAlign.justify,
                                style: const TextStyle(color: Colors.black, fontSize: 50, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.skewX(-0.2),
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
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                              child: Text(
                                intl.DateFormat('mm').format(datetime),
                                textAlign: TextAlign.justify,
                                style: const TextStyle(color: Colors.black, fontSize: 50, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        child: Text(
                          widget.locationOfTime!,
                          style: widget.locationStyle!,
                        ),
                      ),
                    ],
                  ),
                )
              : CustomPaint(
                  painter: DigitalClockPainter(
                      showSeconds: widget.showSeconds,
                      use24Hour: widget.use24Hour,
                      datetime: datetime,
                      digitalClockTextColor: widget.digitalClockTextColor,
                      textScaleFactor: widget.textScaleFactor),
                )),
    );
  }

  @override
  void didUpdateWidget(HenryClock oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.isLive && widget.dateTime != oldWidget.dateTime) {
      datetime = widget.dateTime ?? DateTime.now();
    } else if (widget.isLive && widget.dateTime != oldWidget.dateTime) {
      initialDatetime = widget.dateTime ?? DateTime.now();
    }
  }
}

class DigitalClockPainter extends CustomPainter {
  DateTime datetime;

  final Color digitalClockTextColor;
  final double textScaleFactor;
  final TextStyle? textStyle;
  //digital clock
  final bool showSeconds;
  final bool use24Hour;

  DigitalClockPainter({
    required this.datetime,
    this.textStyle,
    this.showSeconds = true,
    this.use24Hour = false,
    this.digitalClockTextColor = Colors.black,
    this.textScaleFactor = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double scaleFactor = 1;

    _paintDigitalClock(canvas, size, scaleFactor);
  }

  @override
  bool shouldRepaint(DigitalClockPainter oldDelegate) {
    return oldDelegate.datetime.isBefore(datetime);
  }

  void _paintDigitalClock(Canvas canvas, Size size, double scaleFactor) {
    String textToBeDisplayed = showSeconds
        ? use24Hour
            ? intl.DateFormat('HH:mm:ss').format(datetime)
            : intl.DateFormat('hh:mm:ss a').format(datetime)
        : use24Hour
            ? intl.DateFormat('HH:mm').format(datetime)
            : intl.DateFormat('hh:mm a').format(datetime);
    TextSpan digitalClockSpan = TextSpan(
        style: textStyle ??
            TextStyle(
                color: digitalClockTextColor,
                fontSize: 18 * scaleFactor * textScaleFactor,
                fontWeight: FontWeight.bold),
        text: textToBeDisplayed);
    TextPainter digitalClockTP =
        TextPainter(text: digitalClockSpan, textAlign: TextAlign.right, textDirection: TextDirection.ltr);
    digitalClockTP.layout();
    digitalClockTP.paint(canvas, size.center(-digitalClockTP.size.center(const Offset(0.0, 0.0))));
  }
}

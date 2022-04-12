import 'package:flutter/material.dart';

class Meeting {
  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;

  Meeting({
    this.eventName,
    this.from,
    this.to,
    this.background = Colors.blue,
    this.isAllDay = false,
  });
}
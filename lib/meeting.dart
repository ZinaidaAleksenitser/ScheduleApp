import 'package:flutter/material.dart';

class Meeting {
  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;

  Meeting({
    this.eventName = '',
    required this.from,
    required this.to,
    this.background,
    this.isAllDay = false,
  });
}
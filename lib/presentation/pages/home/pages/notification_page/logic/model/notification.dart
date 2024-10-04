import 'package:flutter/foundation.dart';

@immutable
class Notification {
  final DateTime? scheduleTime;
  final String title;
  final String message;

  const Notification(
      {this.scheduleTime, required this.title, required this.message});
  Notification copyWith(
          {DateTime? scheduleTime, String? title, String? message}) =>
      Notification(
          scheduleTime: scheduleTime ?? this.scheduleTime,
          title: title ?? this.title,
          message: message ?? this.message);
}

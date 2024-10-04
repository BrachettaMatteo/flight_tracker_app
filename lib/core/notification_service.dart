import 'dart:async';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  log('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    log('notification action tapped with input: ${notificationResponse.input}');
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            notificationCategories: [
          DarwinNotificationCategory(
            'demoCategory',
            actions: <DarwinNotificationAction>[
              DarwinNotificationAction.plain('id_1', 'Action 1'),
              DarwinNotificationAction.plain(
                'id_2',
                'Action 2',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.destructive,
                },
              ),
              DarwinNotificationAction.plain(
                'id_3',
                'Action 3',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.foreground,
                },
              ),
            ],
            options: <DarwinNotificationCategoryOption>{
              DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
            },
          )
        ],
            onDidReceiveLocalNotification: (first, second, third, fourth) => {
                  log("run in onDidReceiveLocalNotification: $first -> $second -> $third -> $fourth")
                });

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        // ...
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    // AndroidInitializationSettings initializationSettingsAndroid =
    //     const AndroidInitializationSettings('background.png');
    // var initializationSettingsIOS = DarwinInitializationSettings(
    //     requestAlertPermission: true,
    //     requestBadgePermission: true,
    //     requestSoundPermission: true,
    //     onDidReceiveLocalNotification:
    //         (int id, String? title, String? body, String? payload) async {
    //       log("run onDidReceiveLocalNotification");
    //     });
    // var initializationSettings = InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // await notificationsPlugin.initialize(
    //   initializationSettings,
    //   onDidReceiveNotificationResponse:
    //       (NotificationResponse notificationResponse) async {
    //     log("run onDidReceiveNotificationResponse");
    //   },
    //   onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    // );
  }

  Future sendNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    await notificationsPlugin.show(id, title, body, null);
  }

  Future scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required List<DateTime> listDateNotification}) async {
    if (listDateNotification.isNotEmpty) {
      for (var dateNotification in listDateNotification) {
        if (dateNotification.isAfter(DateTime.now())) {
          log("build date: ${tz.TZDateTime.from(dateNotification.toUtc(), tz.local).toUtc()} -> ${tz.local}");
          return notificationsPlugin.zonedSchedule(
              id,
              title,
              body,
              tz.TZDateTime.from(dateNotification.toUtc(), tz.local),
              const NotificationDetails(
                  iOS: DarwinNotificationDetails(
                      presentBadge: true,
                      interruptionLevel: InterruptionLevel.active),
                  android: AndroidNotificationDetails(
                      'your channel id', 'your channel name',
                      channelDescription: 'your channel description')),
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime);
        }
      }
    }
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

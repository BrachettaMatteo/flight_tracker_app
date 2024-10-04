import 'dart:async';

import 'dart:core';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_tracker/core/notification_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<FetchedNotifications>(_fetchNotification);
    on<AddedInstantNotification>(_addNotification);
    on<AddedScheduleNotification>(_scheduleNotification);
    on<ClearNotifications>(_clearNotifications);
    on<DeletedNotification>(_deleteNotification);
    on<Initialized>(_initNotifications);
  }

  FutureOr<void> _addNotification(
      AddedInstantNotification event, Emitter<NotificationState> emit) async {
    await NotificationService().sendNotification(
        id: event.id,
        title: event.title,
        body: event.body,
        payLoad: event.payLoad);
    emit(NotificationState(
        notifications: await NotificationService()
            .notificationsPlugin
            .getActiveNotifications(),
        notificationToSee: state.notificationToSee + 1));
  }

  FutureOr<void> _scheduleNotification(
      AddedScheduleNotification event, Emitter<NotificationState> emit) async {
    // await NotificationService()
    //     .scheduleNotification(
    //         id: event.id,
    //         title: event.title,
    //         body: event.body,
    //         payLoad: event.payLoad,
    //         listDateNotification: l)
    //     .whenComplete(() async {
    //   log("schedule notification on: ${DateTime.now()}");

    //   emit(NotificationState(
    //       notifications: await NotificationService()
    //           .notificationsPlugin
    //           .getActiveNotifications(),
    //       notificationToSee: state.notificationToSee));
    // });

    /*     .then((r) async {
      log("emit schedule ${r}");
      emit(NotificationState(
          notifications: await NotificationService()
              .notificationsPlugin
              .getActiveNotifications(),
          notificationToSee: state.notificationToSee));
    }); */

    // order in asc
    List<DateTime> l = [
      DateTime.now().add(const Duration(seconds: 2)),
      DateTime.now().add(const Duration(seconds: 30))
    ];

    var re = await NotificationService().scheduleNotification(
        id: event.id,
        title: event.title,
        body: event.body,
        payLoad: event.payLoad,
        listDateNotification: l);
    l.sort();
    log("r:${re.toString()}");
    log(l.toString());
    await for (var date in Stream.fromIterable(l)) {
      log("now:${DateTime.now()} emit in ${date.toLocal()}");
      await Future.delayed(date.difference(DateTime.now()));

      emit(NotificationState(
          notifications: await NotificationService()
              .notificationsPlugin
              .getActiveNotifications(),
          notificationToSee: state.notificationToSee + 1));
    }

    /*      emit.forEach(Stream.fromIterable(l), onData: (date)  {
            log((date.difference(DateTime.now())).toString());
Future.delayed(date.difference(DateTime.now()));return   NotificationState(
          notifications: await _service.notificationsPlugin.getActiveNotifications(), notificationToSee: state.notificationToSee + 1);
      }); */

    //}

    /*  List<ActiveNotification> lNo =
        await _service.notificationsPlugin.getActiveNotifications();
    emit(
      NotificationState(
          notifications: lNo, notificationToSee: state.notificationToSee + 1),
    ); */
  }

  Stream<Notification> _emitNotificationTest(
      ClearNotifications event, Emitter<NotificationState> emit) async* {}
  FutureOr<void> _clearNotifications(
      ClearNotifications event, Emitter<NotificationState> emit) async {
    NotificationService().notificationsPlugin.cancelAll();
    emit(NotificationState(
        notifications: await NotificationService()
            .notificationsPlugin
            .getActiveNotifications(),
        notificationToSee: 0));
  }

  FutureOr<void> _fetchNotification(
      FetchedNotifications event, Emitter<NotificationState> emit) async {
    List<ActiveNotification> notifications = await NotificationService()
        .notificationsPlugin
        .getActiveNotifications();
    emit(NotificationState(
        notifications: notifications,
        notificationToSee:
            (notifications.length - state.notifications.length).abs()));
  }

  FutureOr<void> _deleteNotification(
      DeletedNotification event, Emitter<NotificationState> emit) async {
    NotificationService().notificationsPlugin.cancel(event.idNotification);
    emit(NotificationState(
        notifications: await NotificationService()
            .notificationsPlugin
            .getActiveNotifications()));
  }

  FutureOr<void> _initNotifications(
      Initialized event, Emitter<NotificationState> emit) async {
    NotificationService() = event.service;
    emit(NotificationState(
        notifications: await NotificationService()
            .notificationsPlugin
            .getActiveNotifications()));
  }
}

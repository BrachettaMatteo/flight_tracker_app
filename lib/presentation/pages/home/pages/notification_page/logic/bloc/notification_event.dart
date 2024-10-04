part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends NotificationEvent {
  final NotificationService service;

  const Initialized({required this.service});
}

class AddedInstantNotification extends NotificationEvent {
  final int id;
  final String title;
  final String body;
  final String payLoad;
  const AddedInstantNotification(
      {this.title = "", this.body = "", this.payLoad = "", required this.id});
  @override
  List<Object> get props => [id, title, body, payLoad];
}

class AddedScheduleNotification extends NotificationEvent {
  final int id;
  final String title;
  final String body;
  final String payLoad;
  const AddedScheduleNotification(
      {this.title = "", this.body = "", this.payLoad = "", required this.id});
  @override
  List<Object> get props => [id, title, body, payLoad];
}

class ClearNotifications extends NotificationEvent {}

class FetchedNotifications extends NotificationEvent {}

class DeletedNotification extends NotificationEvent {
  final int idNotification;

  const DeletedNotification({required this.idNotification});
  @override
  List<Object> get props => [idNotification];
}

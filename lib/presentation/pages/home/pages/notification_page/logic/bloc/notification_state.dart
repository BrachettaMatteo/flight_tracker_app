part of 'notification_bloc.dart';

@immutable
class NotificationState extends Equatable {
  const NotificationState(
      {this.notifications = const [], this.notificationToSee = 0});
  final List<ActiveNotification> notifications;
  final int notificationToSee;
  @override
  List<Object> get props => [notifications, notificationToSee];
}

import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flight_tracker/presentation/pages/home/pages/notification_page/logic/bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<NotificationBloc>().add(FetchedNotifications());
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () => context.read<NotificationBloc>().add(
                        AddedInstantNotification(
                            id: Random().nextInt(100000),
                            title: "Test",
                            body:
                                "generated: ${DateTime.now().toIso8601String()}")),
                    child: const Text("add")),
                TextButton(
                    onPressed: () => context.read<NotificationBloc>().add(
                        AddedScheduleNotification(
                            id: Random().nextInt(8909890),
                            title: "schedule notification",
                            body:
                                "generated: ${DateTime.now().toIso8601String()}")),
                    child: const Text("add schedule")),
                TextButton(
                    onPressed: () => context
                        .read<NotificationBloc>()
                        .add(ClearNotifications()),
                    child: const Text("clear"))
              ],
            ),
            Expanded(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  return ListView.builder(
                      itemCount: state.notifications.length,
                      itemBuilder: (context, index) => Dismissible(
                            onDismissed: (_) => context
                                .read<NotificationBloc>()
                                .add(DeletedNotification(
                                    idNotification:
                                        state.notifications[index].id ?? 0)),
                            key: Key(state.notifications[index].id.toString()),
                            child: ListTile(
                              title: Text(state.notifications[index].title ??
                                  "notification"),
                            ),
                          ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

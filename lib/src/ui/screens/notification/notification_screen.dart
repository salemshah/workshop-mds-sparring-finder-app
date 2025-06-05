import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sparring_finder/src/blocs/sparring/sparring_bloc.dart';
import 'package:sparring_finder/src/blocs/sparring/sparring_event.dart';
import '../../../blocs/notification/notification_bloc.dart';
import '../../../blocs/notification/notification_event.dart';
import '../../../blocs/notification/notification_state.dart';
import '../../theme/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger loading of notifications when the widget is built
    context.read<NotificationBloc>().add(const LoadNotifications());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationLoadSuccess) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return const Center(
                child: Text('No notifications yet.',
                    style: TextStyle(color: Colors.white54)),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Slidable(
                    key: ValueKey(item.id),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.45,
                      children: [
                        /// =============== Cancel
                        CustomSlidableAction(
                          onPressed: (_) {
                            String? idStr = item.actionUrl?.split('/').last;
                            int id = int.parse(idStr!);
                            context
                                .read<SparringBloc>()
                                .add(CancelSparring(id: id));
                          },
                          flex: 1,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                            ),
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: const Text(
                              'Decline',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        /// ================= Accept ==============
                        CustomSlidableAction(
                          onPressed: (_) {
                            String? idStr = item.actionUrl?.split('/').last;
                            int id = int.parse(idStr!);
                            context
                                .read<SparringBloc>()
                                .add(ConfirmSparring(id));
                          },
                          // backgroundColor: Colors.green,
                          flex: 1,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green[800],
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                            ),
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: const Text(
                              'Accept',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(item.sender.photoUrl ?? ''),
                            radius: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.sender.firstName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.body,
                                  style: const TextStyle(
                                      color: Colors.white38, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'time ${item.id}',
                            style: const TextStyle(
                                color: Colors.white60, fontSize: 13),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          if (state is NotificationFailure) {
            return Center(
              child: Text(
                'Failed to load notifications:\n${state.error}',
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

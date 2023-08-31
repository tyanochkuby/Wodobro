import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;
import 'package:wodobro/domain/notification_controller.dart';

import '../../application/locator.dart';
import '../widgets/lava.dart';

class IntroPage4 extends StatelessWidget {
  const IntroPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LavaAnimation(
        color: Color.fromRGBO(142, 201, 249, 1),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Padding(
            padding: const EdgeInsets.only(left: 11.0, right: 11.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Expanded(
                  child: Text(
                      'Finally, we need to ask you for permission to send you notifications\n'
                      '\nThis way we can remind you to drink water\n',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: Colors.black38)),
                ),
                const SizedBox(height: 55),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
          child: Row(
            children: [
              //const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: () async {
                  final perm_handler.PermissionStatus status =
                      await perm_handler.Permission.notification.request();
                  if (status.isGranted) {
                    TimeOfDay? selectedTime = null;
                    while (selectedTime == null) {
                      selectedTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                    }
                    Notifications.registerDailyForecastNotifications(
                        time: selectedTime);

                    locator.get<GetStorage>().write('initialLocation', '/home');
                    locator
                        .get<GetStorage>()
                        .write('enableNotifications', 'on');
                    locator
                        .get<GetStorage>()
                        .write('notificationsTimeHour', selectedTime.hour);
                    locator
                        .get<GetStorage>()
                        .write('notificationsTimeMinute', selectedTime.minute);
                    context.go('/home');
                  }
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.37,
                  child: Text(
                    'Yep, ask\nfor permission',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color.fromRGBO(245, 245, 247, 0.9),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  side: const BorderSide(
                    color: Color.fromRGBO(142, 201, 249, 1),
                    width: 2,
                  ),
                  backgroundColor: const Color.fromRGBO(245, 245, 247, 0.9),
                ),
                onPressed: () async {
                  locator.get<GetStorage>().write('initialLocation', '/home');
                  locator.get<GetStorage>().write('enableNotifications', 'off');
                  locator
                      .get<GetStorage>()
                      .write('notificationsTimeHour', null);
                  locator
                      .get<GetStorage>()
                      .write('notificationsTimeMinute', null);
                  context.go('/home');
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.37,
                  child: Text(
                    "No, don't send\nme notifications",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color.fromRGBO(45, 45, 47, 0.9),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              //const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> requestNotificationPermissions() async {
  final perm_handler.PermissionStatus status =
      await perm_handler.Permission.notification.request();
  if (status.isGranted) {
    // Notification permissions granted
  } else if (status.isDenied) {
    // Notification permissions denied
  } else if (status.isPermanentlyDenied) {
    // Notification permissions permanently denied, open app settings
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;
import 'package:wodobro/domain/notification_controller.dart';
import 'package:wodobro/presentation/widgets/big_bottom_button.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24),
          child: ElevatedButton(
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
                  selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                }
                Notifications.registerDailyForecastNotifications(
                    time: selectedTime);

                locator.get<GetStorage>().write('initialLocation', '/home');
                context.go('/home');
              }
            },
            child: Text('Yep, ask for permission',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color.fromRGBO(245, 245, 247, 0.9),
                fontWeight: FontWeight.bold,
              ),),
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



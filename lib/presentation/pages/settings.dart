import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wodobro/domain/notification_controller.dart';
import 'package:wodobro/domain/weight_controller.dart';
import 'package:wodobro/presentation/widgets/wodobro_text_field.dart';

import '../../application/locator.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController weightController = TextEditingController();
  @override
  void initState() async {
    super.initState();
    weightController.text =
        await locator.get<WeightDomainController>().getWeight().toString();
  }

  bool areNotificationsEnabledSwitcher =
      locator.get<GetStorage>().read('enableNotifications');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: WodobroTextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[\d]"))
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  Text(
                    'Daily reminders',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        'Enable daily notifications',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                          value: areNotificationsEnabledSwitcher,
                          onChanged: (bool switcherNewState) {
                            setState(() {
                              areNotificationsEnabledSwitcher =
                                  switcherNewState;
                            });
                            if (areNotificationsEnabledSwitcher == true) {
                              enableNotifications(context);
                            } else {
                              disableNotifications();
                            }
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Pick time'),
                      const Spacer(),
                      Text(
                          "${locator.get<GetStorage>().read('notificationsTime')}"),
                      GestureDetector(
                        child: Icon(Icons.access_time_filled),
                        onTap: () => setState(() {
                          changeNotificationsTime(context);
                        })
                      )
                    ],
                  )
                ],
              )),
        ],
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
          onPressed: () {
            locator
                .get<WeightDomainController>()
                .setWeight(double.parse(weightController.text));
          },
          child: Text(
            'Save',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color.fromRGBO(245, 245, 247, 0.9),
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      )),
    );
  }
}

Future<void> enableNotifications(BuildContext context) async {
  while (Notifications.checkNotificationPermissions() == false) {
    Notifications.requestNotificationPermissions();
  }
  if (locator.get<GetStorage>().read('notificationsTime') == null) {
    TimeOfDay? selectedTime = null;
    while (selectedTime == null) {
      selectedTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
    }
    Notifications.registerDailyForecastNotifications(time: selectedTime);

    locator.get<GetStorage>().write('enableNotifications', true);
    locator.get<GetStorage>().write('notificationsTime', selectedTime);
  } else {
    Notifications.registerDailyForecastNotifications(
        time: locator.get<GetStorage>().read('notificationsTime'));
    locator.get<GetStorage>().write('enableNotifications', true);
  }
}

Future<void> disableNotifications() async {
  Notifications.unsubscribeDailyForecastNotifications();
  locator.get<GetStorage>().write('enableNotifications', false);
}

Future<void> changeNotificationsTime(BuildContext context) async {
  TimeOfDay? selectedTime = null;
  while (selectedTime == null) {
    selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }
  if (locator.get<GetStorage>().read('enableNotifications') == true) {
    Notifications.unsubscribeDailyForecastNotifications();
    Notifications.registerDailyForecastNotifications(time: selectedTime);
  }
  locator.get<GetStorage>().write('notificationsTime', selectedTime);
}

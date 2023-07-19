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
  // @override
  // void initState() async {
  //   super.initState();
  //   weightController.text =
  //       await locator.get<WeightDomainController>().getWeight().toString();
  // }

  bool areNotificationsEnabledSwitcher =
      locator.get<GetStorage>().read('enableNotifications');
  bool _stateInited = false;
  TimeOfDay? selectedTime = locator.get<GetStorage>().read('notificationsTime');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 150),
            _stateInited
                ? TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[\d]"))
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(16),
                    )
            )
                : FutureBuilder<double>(
                    future: locator.get<WeightDomainController>().getWeight(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError)
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 8.0),
                                child: Text('Error: ${snapshot.error}'));
                          else {
                            weightController.text = snapshot.data.toString();
                            _stateInited = true;
                            return WodobroTextField(
                              controller: weightController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[\d]"))
                              ],
                            );
                          }
                      }
                    }),
            const SizedBox(height: 20),
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
                        areNotificationsEnabledSwitcher = switcherNewState;
                      });
                      if (areNotificationsEnabledSwitcher == true) {
                        enableNotifications(context);
                      } else {
                        disableNotifications();
                      }
                    }),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('Pick time',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text(selectedTime == null
                    ? 'Not selected'
                    : '${selectedTime!.hour}:${selectedTime!.minute}'),
                GestureDetector(
                    child: Icon(Icons.access_time_filled),
                    onTap: () async{
                      selectedTime = await changeNotificationsTime(context);
                      setState(() {

                      });
                    })

              ],
            )
          ],
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
          onPressed: () {
            locator
                .get<WeightDomainController>()
                .setWeight(double.parse(weightController.text));
            FocusManager.instance.primaryFocus?.unfocus();
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

Future<TimeOfDay> changeNotificationsTime(BuildContext context) async {
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
  return selectedTime;
}

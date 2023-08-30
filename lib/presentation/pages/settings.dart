import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wodobro/domain/cubit/settings_cubit.dart';
import 'package:wodobro/domain/notification_controller.dart';
import 'package:wodobro/domain/weight_controller.dart';
import 'package:wodobro/presentation/widgets/wodobro_text_field.dart';

import '../../application/locator.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  //const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: BlocConsumer<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) =>
              previous.userWeight != current.userWeight,
          listener: (context, state) {
            weightController.text = state.userWeight.toString();
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 150),
                TextField(
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
                    )),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Enable daily notifications',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                        value: state.notificationsEnabled,
                        onChanged: (bool switcherNewState) {
                          setState(() {
                            BlocProvider.of<SettingsCubit>(context)
                                .setNotificationsEnabled(switcherNewState);
                          });
                          if (state.notificationsEnabled == true) {
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
                    Text(widget.selectedTime == null
                        ? 'Not selected'
                        : '${widget.selectedTime!.hour}:${widget.selectedTime!.minute}'),
                    GestureDetector(
                        child: Icon(Icons.access_time_filled),
                        onTap: () async {
                          widget.selectedTime =
                              await changeNotificationsTime(context);
                          setState(() {});
                        })
                  ],
                )
              ],
            );
          },
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
  if (locator.get<GetStorage>().read('notificationsTimeHour') == null) {
    TimeOfDay? selectedTime = null;
    while (selectedTime == null) {
      selectedTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
    }
    Notifications.registerDailyForecastNotifications(time: selectedTime);

    await locator.get<GetStorage>().write('enableNotifications', 'on');
    await locator.get<GetStorage>().write('notificationsTime', selectedTime);
  } else {
    Notifications.registerDailyForecastNotifications(
        time: TimeOfDay(
            hour: locator.get<GetStorage>().read('notificationsTimeHour'),
            minute: locator.get<GetStorage>().read('notificationsTimeMinute')));
    await locator.get<GetStorage>().write('enableNotifications', 'on');
  }
}

Future<void> disableNotifications() async {
  Notifications.unsubscribeDailyForecastNotifications();
  await locator.get<GetStorage>().write('enableNotifications', 'off');
}

Future<TimeOfDay> changeNotificationsTime(BuildContext context) async {
  TimeOfDay? selectedTime = null;
  while (selectedTime == null) {
    selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }
  if (locator.get<GetStorage>().read('enableNotifications') == 'on') {
    Notifications.unsubscribeDailyForecastNotifications();
    Notifications.registerDailyForecastNotifications(time: selectedTime);
  }
  //int hour = selectedTime.hour;
  await locator
      .get<GetStorage>()
      .write('notificationsTimeHour', selectedTime.hour);
  await locator
      .get<GetStorage>()
      .write('notificationsTimeMinute', selectedTime.minute);
  return selectedTime;
}

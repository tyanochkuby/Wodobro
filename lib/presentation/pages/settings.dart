import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wodobro/domain/notification_controller.dart';
import 'package:wodobro/domain/weight_controller.dart';
import 'package:wodobro/presentation/widgets/wodobro_text_field.dart';

import '../../application/locator.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  //const SettingsPage({super.key});

  bool areNotificationsEnabledSwitcher =
      locator.get<GetStorage>().read('enableNotifications') == 'on'
          ? true
          : false;
  bool _stateInited = false;
  final hour = locator.get<GetStorage>().read('notificationsTimeHour');
  TimeOfDay? selectedTime =
      locator.get<GetStorage>().read('notificationsTimeHour') != null
          ? TimeOfDay(
              hour: locator.get<GetStorage>().read('notificationsTimeHour'),
              minute: locator.get<GetStorage>().read('notificationsTimeMinute'))
          : null;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locator.get<GetStorage>().listenKey('enableNotifications', (value) {
      print('notifications enabled: $value');
    });
    locator.get<GetStorage>().listenKey('notificationsTimeHour', (value) {
      print('notifications hour: $value');
    });
    locator.get<GetStorage>().listenKey('notificationsTimeMinute', (value) {
      print('notifications minute: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 150),
            widget._stateInited
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
                    ))
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
                            widget._stateInited = true;
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
                    value: widget.areNotificationsEnabledSwitcher,
                    onChanged: (bool switcherNewState) {
                      setState(() {
                        widget.areNotificationsEnabledSwitcher =
                            switcherNewState;
                      });
                      if (widget.areNotificationsEnabledSwitcher == true) {
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

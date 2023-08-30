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
                          BlocProvider.of<SettingsCubit>(context)
                              .setNotificationsEnabled(switcherNewState);

                          if (state.notificationsEnabled == true) {
                            if (state.selectedHour == null ||
                                state.selectedMinute == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please select time for notifications')));
                            } else {
                              enableNotifications(
                                  context,
                                  TimeOfDay(
                                      hour: state.selectedHour!,
                                      minute: state.selectedMinute!));
                            }
                          } else {
                            disableNotifications(context);
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
                    Text(state.selectedHour == null
                        ? 'Not selected'
                        : '${state.selectedHour}:${state.selectedMinute}'),
                    GestureDetector(
                        child: Icon(Icons.access_time_filled),
                        onTap: () async {
                          TimeOfDay? selectedTime = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          //change time if selected or enable notifications if not
                          if (selectedTime != null) {
                            BlocProvider.of<SettingsCubit>(context)
                                .setTime(selectedTime);
                            if (state.notificationsEnabled == true)
                              disableNotifications(context);

                            enableNotifications(context, selectedTime);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Time not selected')));
                          }
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
            BlocProvider.of<SettingsCubit>(context).setWeight(int.parse(
                weightController.text.isEmpty ? '0' : weightController.text));
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Text(
            'Save weight',
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

Future<void> enableNotifications(
    BuildContext context, TimeOfDay selectedTime) async {
  while (Notifications.checkNotificationPermissions() == false) {
    Notifications.requestNotificationPermissions();
  }
  Notifications.registerDailyForecastNotifications(time: selectedTime);
  BlocProvider.of<SettingsCubit>(context).setNotificationsEnabled(true);
}

Future<void> disableNotifications(BuildContext context) async {
  Notifications.unsubscribeDailyForecastNotifications();
  BlocProvider.of<SettingsCubit>(context).setNotificationsEnabled(false);
}

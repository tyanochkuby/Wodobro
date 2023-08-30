import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:wodobro/data/weight_repo.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> with HydratedMixin {
  SettingsCubit()
      : super(SettingsState(notificationsEnabled: false, userWeight: 0));

  void updateSettings(bool notificationsenabled, int selectedHour,
      int selectedMinute, int userWeight) {
    emit(SettingsState(
        notificationsEnabled: notificationsenabled,
        selectedHour: selectedHour,
        selectedMinute: selectedMinute,
        userWeight: userWeight));
  }

  void setWeight(int weight) {
    emit(state.copyWith(userWeight: weight));
    WeightRepo.setWeightOnline(weight);
  }

  void setNotificationsEnabled(bool enabled) async {
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  void setTime(TimeOfDay timeOfDay) {
    emit(state.copyWith(
        selectedHour: timeOfDay.hour, selectedMinute: timeOfDay.minute));
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toMap();
  }
}

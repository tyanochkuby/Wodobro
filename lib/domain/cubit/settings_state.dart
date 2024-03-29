// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'settings_cubit.dart';

class SettingsState {
  bool notificationsEnabled;
  int? selectedHour;
  int? selectedMinute;
  int? userWeight;

  SettingsState(
      {required this.notificationsEnabled,
      this.selectedHour,
      this.selectedMinute,
      this.userWeight});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notificationsEnabled': notificationsEnabled,
      'selectedHour': selectedHour,
      'selectedMinute': selectedMinute,
      'userWeight': userWeight,
    };
  }

  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
      notificationsEnabled: map['notificationsEnabled'] as bool,
      selectedHour:
          map['selectedHour'] != null ? map['selectedHour'] as int : null,
      selectedMinute:
          map['selectedMinute'] != null ? map['selectedMinute'] as int : null,
      userWeight: map['userWeight'] != null ? map['userWeight'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingsState.fromJson(String source) =>
      SettingsState.fromMap(json.decode(source) as Map<String, dynamic>);

  SettingsState copyWith({
    bool? notificationsEnabled,
    int? selectedHour,
    int? selectedMinute,
    int? userWeight,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      selectedHour: selectedHour ?? this.selectedHour,
      selectedMinute: selectedMinute ?? this.selectedMinute,
      userWeight: userWeight ?? this.userWeight,
    );
  }
}

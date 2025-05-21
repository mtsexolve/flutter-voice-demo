part of 'settings_bloc.dart';

@immutable
class SettingsState implements Equatable {
  final bool isRingtoneEnabled;
  final bool isDetectLocationEnabled;
  final String? sdkVersionDescriprion;

  const SettingsState({
    required this.isRingtoneEnabled,
    required this.isDetectLocationEnabled,
    this.sdkVersionDescriprion,
  });

  SettingsState.copy({
    required SettingsState copied,
    bool? isRingtoneEnabled,
    bool? isDetectLocationEnabled,
    String? sdkVersionDescriprion,
  }) :
      isRingtoneEnabled = isRingtoneEnabled ?? copied.isRingtoneEnabled,
      isDetectLocationEnabled = isDetectLocationEnabled ?? copied.isDetectLocationEnabled,
      sdkVersionDescriprion = sdkVersionDescriprion ?? copied.sdkVersionDescriprion;

  const SettingsState.initial(
      {
        this.sdkVersionDescriprion = "",
        this.isRingtoneEnabled = false,
        this.isDetectLocationEnabled = true,
      });

  @override
  List<Object?> get props => [
  ];

  @override
  bool? get stringify => true;
}


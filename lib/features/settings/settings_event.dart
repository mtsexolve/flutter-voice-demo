part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class VersionInfoLoadedEvent extends SettingsEvent {
  final String data;
  VersionInfoLoadedEvent({required this.data});
}

class ShareLogsEvent extends SettingsEvent {
  final BuildContext context;
  ShareLogsEvent({required this.context});
}

class SettingsDetectLocationEvent extends SettingsEvent{
  final bool enabled;
  SettingsDetectLocationEvent({required this.enabled});
}

class SettingsRingtoneEvent extends SettingsEvent{
  final bool enabled;
  SettingsRingtoneEvent({required this.enabled});
}

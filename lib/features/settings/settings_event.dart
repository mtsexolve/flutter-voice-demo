part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class ActivateSipAccountEvent extends SettingsEvent{}

class RegistrationReceivedEvent extends SettingsEvent{
  final RegistrationEvent state;
  RegistrationReceivedEvent({required this.state});
}

class RegistrationReceivedState extends SettingsEvent{
  final RegistrationState state;
  RegistrationReceivedState({required this.state});
}

class DeactivateSipAccountEvent extends SettingsEvent {}

class DeactivateAccountEvent extends SettingsEvent {}

class AccountDataIsLoadedEvent extends SettingsEvent {
  final Account data;
  AccountDataIsLoadedEvent({required this.data});
}

class VersionInfoLoadedEvent extends SettingsEvent {
  final String data;
  VersionInfoLoadedEvent({required this.data});
}


class TextFieldChangedEvent extends SettingsEvent {
  final String name;
  final String inputText;
  TextFieldChangedEvent({required this.name, required this.inputText});
}

class ShareLogsEvent extends SettingsEvent {
  final BuildContext context;
  ShareLogsEvent({required this.context});
}

class PushTokenEvent extends SettingsEvent{
  final String pushToken;
  PushTokenEvent({required this.pushToken});
}
